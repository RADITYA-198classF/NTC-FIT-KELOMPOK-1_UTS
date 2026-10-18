<?php
require_once __DIR__ . '/../src/Database.php';
require_once __DIR__ . '/../src/JsonResponse.php';
require_once __DIR__ . '/../src/Auth.php';
require_once __DIR__ . '/../src/WorkoutRepository.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$config = require __DIR__ . '/../config.php';
$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/';
$path = rtrim($path, '/') ?: '/';

try {
    $pdo = Database::connection($config);

    if ($method === 'GET' && $path === '/api/health') {
        $pdo->query('SELECT 1');
        JsonResponse::send(['status' => 'ok', 'database' => 'connected', 'app' => 'NTC Fit API']);
    }

    if ($method === 'POST' && $path === '/api/auth/request-code') {
        $body = JsonResponse::body();
        $email = strtolower(trim((string)($body['email'] ?? '')));
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            JsonResponse::send(['message' => 'Email tidak valid.'], 422);
        }

        $existsStmt = $pdo->prepare('SELECT COUNT(*) FROM users WHERE email = ?');
        $existsStmt->execute([$email]);
        $exists = (int)$existsStmt->fetchColumn() > 0;
        $code = $config['app']['demo_otp'];

        $stmt = $pdo->prepare(
            'INSERT INTO verification_codes(email, code, expires_at) VALUES(?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))
             ON DUPLICATE KEY UPDATE code = VALUES(code), expires_at = VALUES(expires_at), updated_at = NOW()'
        );
        $stmt->execute([$email, $code]);

        $payload = [
            'message' => 'Kode verifikasi dibuat.',
            'exists' => $exists,
        ];
        if ($config['app']['debug']) {
            $payload['demo_code'] = $code;
        }
        JsonResponse::send($payload);
    }

    if ($method === 'POST' && $path === '/api/auth/register') {
        $body = JsonResponse::body();
        $email = strtolower(trim((string)($body['email'] ?? '')));
        $code = trim((string)($body['code'] ?? ''));
        $firstName = trim((string)($body['first_name'] ?? ''));
        $lastName = trim((string)($body['last_name'] ?? ''));
        $birthDate = trim((string)($body['birth_date'] ?? ''));
        $marketing = !empty($body['marketing_opt_in']) ? 1 : 0;

        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $firstName === '' || $birthDate === '') {
            JsonResponse::send(['message' => 'Data pendaftaran belum lengkap.'], 422);
        }
        selfVerifyCode($pdo, $email, $code);

        $check = $pdo->prepare('SELECT id FROM users WHERE email = ?');
        $check->execute([$email]);
        if ($check->fetch()) {
            JsonResponse::send(['message' => 'Email sudah terdaftar. Silakan masuk.'], 409);
        }

        $token = Auth::newToken();
        $stmt = $pdo->prepare(
            'INSERT INTO users(email, first_name, last_name, birth_date, marketing_opt_in, api_token) VALUES(?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([$email, $firstName, $lastName, $birthDate, $marketing, $token]);
        $userId = (int)$pdo->lastInsertId();
        $pdo->prepare('DELETE FROM verification_codes WHERE email = ?')->execute([$email]);

        $userStmt = $pdo->prepare('SELECT * FROM users WHERE id = ?');
        $userStmt->execute([$userId]);
        JsonResponse::send([
            'message' => 'Registrasi berhasil.',
            'token' => $token,
            'user' => Auth::publicUser($userStmt->fetch()),
        ], 201);
    }

    if ($method === 'POST' && $path === '/api/auth/login') {
        $body = JsonResponse::body();
        $email = strtolower(trim((string)($body['email'] ?? '')));
        $code = trim((string)($body['code'] ?? ''));
        selfVerifyCode($pdo, $email, $code);

        $stmt = $pdo->prepare('SELECT * FROM users WHERE email = ? LIMIT 1');
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        if (!$user) {
            JsonResponse::send(['message' => 'Akun belum terdaftar.'], 404);
        }

        $token = Auth::newToken();
        $pdo->prepare('UPDATE users SET api_token = ?, updated_at = NOW() WHERE id = ?')->execute([$token, $user['id']]);
        $pdo->prepare('DELETE FROM verification_codes WHERE email = ?')->execute([$email]);
        $user['api_token'] = $token;

        JsonResponse::send([
            'message' => 'Login berhasil.',
            'token' => $token,
            'user' => Auth::publicUser($user),
        ]);
    }

    if ($method === 'POST' && $path === '/api/logout') {
        $user = Auth::user($pdo);
        $pdo->prepare('UPDATE users SET api_token = NULL, updated_at = NOW() WHERE id = ?')->execute([$user['id']]);
        JsonResponse::send(['message' => 'Logout berhasil.']);
    }

    if ($method === 'GET' && $path === '/api/me') {
        $user = Auth::user($pdo);
        JsonResponse::send(['user' => Auth::publicUser($user)]);
    }

    if ($method === 'PUT' && $path === '/api/me/preferences') {
        $user = Auth::user($pdo);
        $body = JsonResponse::body();
        $gender = $body['gender'] ?? $user['gender'];
        $frequency = $body['weekly_frequency'] ?? $user['weekly_frequency'];
        if ($gender !== null && !in_array($gender, ['female', 'male'], true)) {
            JsonResponse::send(['message' => 'Pilihan gender tidak valid.'], 422);
        }
        if ($frequency !== null && !in_array($frequency, ['low', 'medium', 'high'], true)) {
            JsonResponse::send(['message' => 'Frekuensi latihan tidak valid.'], 422);
        }
        $stmt = $pdo->prepare('UPDATE users SET gender = ?, weekly_frequency = ?, updated_at = NOW() WHERE id = ?');
        $stmt->execute([$gender, $frequency, $user['id']]);
        $fresh = $pdo->prepare('SELECT * FROM users WHERE id = ?');
        $fresh->execute([$user['id']]);
        JsonResponse::send(['message' => 'Preferensi tersimpan.', 'user' => Auth::publicUser($fresh->fetch())]);
    }

    if ($method === 'DELETE' && $path === '/api/me') {
        $user = Auth::user($pdo);
        $pdo->prepare('DELETE FROM users WHERE id = ?')->execute([$user['id']]);
        JsonResponse::send(['message' => 'Akun berhasil dihapus.']);
    }

    if ($method === 'GET' && $path === '/api/workouts') {
        JsonResponse::send(['data' => WorkoutRepository::all($pdo)]);
    }

    if ($method === 'GET' && preg_match('#^/api/workouts/(\d+)$#', $path, $m)) {
        $workout = WorkoutRepository::find($pdo, (int)$m[1]);
        if (!$workout) {
            JsonResponse::send(['message' => 'Latihan tidak ditemukan.'], 404);
        }
        JsonResponse::send(['data' => $workout]);
    }

    if ($method === 'GET' && $path === '/api/saved') {
        $user = Auth::user($pdo);
        $stmt = $pdo->prepare(
            'SELECT w.code FROM saved_workouts s INNER JOIN workouts w ON w.id = s.workout_id WHERE s.user_id = ? ORDER BY s.created_at DESC'
        );
        $stmt->execute([$user['id']]);
        JsonResponse::send(['data' => array_column($stmt->fetchAll(), 'code')]);
    }

    if (preg_match('#^/api/saved/(w\d+)$#', $path, $m) && in_array($method, ['POST', 'DELETE'], true)) {
        $user = Auth::user($pdo);
        $w = $pdo->prepare('SELECT id FROM workouts WHERE code = ?');
        $w->execute([$m[1]]);
        $workoutId = $w->fetchColumn();
        if (!$workoutId) {
            JsonResponse::send(['message' => 'Latihan tidak ditemukan.'], 404);
        }
        if ($method === 'POST') {
            $stmt = $pdo->prepare('INSERT IGNORE INTO saved_workouts(user_id, workout_id) VALUES(?, ?)');
            $stmt->execute([$user['id'], $workoutId]);
            JsonResponse::send(['message' => 'Latihan disimpan.'], 201);
        }
        $stmt = $pdo->prepare('DELETE FROM saved_workouts WHERE user_id = ? AND workout_id = ?');
        $stmt->execute([$user['id'], $workoutId]);
        JsonResponse::send(['message' => 'Latihan dihapus dari simpanan.']);
    }

    if ($method === 'GET' && $path === '/api/history') {
        $user = Auth::user($pdo);
        $stmt = $pdo->prepare(
            'SELECT h.id, w.code AS workout_id, w.title, h.completed_at, h.duration_seconds AS seconds, h.exercise_count
             FROM workout_history h INNER JOIN workouts w ON w.id = h.workout_id
             WHERE h.user_id = ? ORDER BY h.completed_at DESC'
        );
        $stmt->execute([$user['id']]);
        $rows = array_map(static function (array $r): array {
            $r['id'] = (int)$r['id'];
            $r['seconds'] = (int)$r['seconds'];
            $r['exercise_count'] = (int)$r['exercise_count'];
            return $r;
        }, $stmt->fetchAll());
        JsonResponse::send(['data' => $rows]);
    }

    if ($method === 'POST' && $path === '/api/history') {
        $user = Auth::user($pdo);
        $body = JsonResponse::body();
        $code = trim((string)($body['workout_id'] ?? ''));
        $seconds = max(0, (int)($body['seconds'] ?? 0));
        $exerciseCount = max(0, (int)($body['exercise_count'] ?? 0));
        $completedAt = trim((string)($body['completed_at'] ?? date('Y-m-d H:i:s')));
        $w = $pdo->prepare('SELECT id FROM workouts WHERE code = ?');
        $w->execute([$code]);
        $workoutId = $w->fetchColumn();
        if (!$workoutId) {
            JsonResponse::send(['message' => 'Latihan tidak ditemukan.'], 404);
        }
        $stmt = $pdo->prepare(
            'INSERT INTO workout_history(user_id, workout_id, duration_seconds, exercise_count, completed_at) VALUES(?, ?, ?, ?, ?)'
        );
        $stmt->execute([$user['id'], $workoutId, $seconds, $exerciseCount, $completedAt]);
        JsonResponse::send(['message' => 'Riwayat latihan tersimpan.', 'id' => (int)$pdo->lastInsertId()], 201);
    }

    JsonResponse::send(['message' => 'Endpoint tidak ditemukan.', 'path' => $path], 404);
} catch (PDOException $e) {
    $message = $config['app']['debug'] ? $e->getMessage() : 'Kesalahan database.';
    JsonResponse::send(['message' => $message], 500);
} catch (Throwable $e) {
    $message = $config['app']['debug'] ? $e->getMessage() : 'Kesalahan server.';
    JsonResponse::send(['message' => $message], 500);
}

function selfVerifyCode(PDO $pdo, string $email, string $code): void
{
    if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $code === '') {
        JsonResponse::send(['message' => 'Email dan kode wajib diisi.'], 422);
    }
    $stmt = $pdo->prepare('SELECT code, expires_at FROM verification_codes WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $verification = $stmt->fetch();
    if (!$verification || !hash_equals((string)$verification['code'], $code)) {
        JsonResponse::send(['message' => 'Kode verifikasi salah.'], 422);
    }
    if (strtotime($verification['expires_at']) < time()) {
        JsonResponse::send(['message' => 'Kode verifikasi sudah kedaluwarsa.'], 422);
    }
}
