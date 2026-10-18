<?php
final class Auth
{
    public static function user(PDO $pdo): array
    {
        $header = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
        if (!preg_match('/^Bearer\s+(.+)$/i', $header, $match)) {
            JsonResponse::send(['message' => 'Token autentikasi tidak ditemukan.'], 401);
        }

        $stmt = $pdo->prepare('SELECT * FROM users WHERE api_token = ? LIMIT 1');
        $stmt->execute([$match[1]]);
        $user = $stmt->fetch();
        if (!$user) {
            JsonResponse::send(['message' => 'Token tidak valid atau sudah kedaluwarsa.'], 401);
        }
        return $user;
    }

    public static function publicUser(array $user): array
    {
        return [
            'id' => (int)$user['id'],
            'email' => $user['email'],
            'first_name' => $user['first_name'],
            'last_name' => $user['last_name'],
            'birth_date' => $user['birth_date'],
            'marketing_opt_in' => (bool)$user['marketing_opt_in'],
            'gender' => $user['gender'],
            'weekly_frequency' => $user['weekly_frequency'],
            'joined_at' => $user['created_at'],
        ];
    }

    public static function newToken(): string
    {
        return bin2hex(random_bytes(32));
    }
}
