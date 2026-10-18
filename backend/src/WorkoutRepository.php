<?php
final class WorkoutRepository
{
    public static function all(PDO $pdo): array
    {
        $workouts = $pdo->query('SELECT * FROM workouts ORDER BY sort_order, id')->fetchAll();
        return array_map(fn(array $w) => self::hydrate($pdo, $w), $workouts);
    }

    public static function find(PDO $pdo, int $id): ?array
    {
        $stmt = $pdo->prepare('SELECT * FROM workouts WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        $workout = $stmt->fetch();
        return $workout ? self::hydrate($pdo, $workout) : null;
    }

    private static function hydrate(PDO $pdo, array $w): array
    {
        $ex = $pdo->prepare('SELECT name, reps, seconds, cue FROM exercises WHERE workout_id = ? ORDER BY sort_order, id');
        $ex->execute([$w['id']]);
        $exercises = array_map(static function (array $e): array {
            return [
                'name' => $e['name'],
                'reps' => $e['reps'] !== null ? (int)$e['reps'] : null,
                'seconds' => $e['seconds'] !== null ? (int)$e['seconds'] : null,
                'cue' => $e['cue'],
            ];
        }, $ex->fetchAll());

        $cat = $pdo->prepare(
            'SELECT c.name FROM categories c INNER JOIN category_workout cw ON cw.category_id = c.id WHERE cw.workout_id = ? ORDER BY c.id'
        );
        $cat->execute([$w['id']]);
        $categories = array_column($cat->fetchAll(), 'name');

        return [
            'id' => $w['code'],
            'db_id' => (int)$w['id'],
            'title' => $w['title'],
            'level' => $w['level'],
            'equipment' => $w['equipment'],
            'focus' => $w['focus'],
            'minutes' => (int)$w['minutes'],
            'image' => $w['image'],
            'description' => $w['description'],
            'is_new' => (bool)$w['is_new'],
            'categories' => $categories,
            'exercises' => $exercises,
        ];
    }
}
