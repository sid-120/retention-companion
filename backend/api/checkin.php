<?php
header('Content-Type: application/json');
require_once '../config/db.php';

$database = new Database();
$conn = $database->connect();

$data = json_decode(file_get_contents("php://input"), true);
$user_id = $data['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(["success" => false, "message" => "user_id is required"]);
    exit;
}

// क्या पहले से कोई active streak है?
$stmt = $conn->prepare("SELECT id, start_timestamp FROM streaks WHERE user_id = :user_id AND status = 'active' ORDER BY id DESC LIMIT 1");
$stmt->execute(['user_id' => $user_id]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if ($row) {
    // पहले से active streak है
    $start = new DateTime($row['start_timestamp']);
    $now = new DateTime();
    $current_streak_days = $now->diff($start)->days;

    echo json_encode([
        "success" => true,
        "message" => "Streak already active",
        "current_streak_days" => $current_streak_days,
        "start_timestamp" => $row['start_timestamp']
    ]);
} else {
    // नई streak शुरू करो
    $stmt2 = $conn->prepare("INSERT INTO streaks (user_id, start_timestamp, status) VALUES (:user_id, NOW(), 'active')");
    $stmt2->execute(['user_id' => $user_id]);

    echo json_encode([
        "success" => true,
        "message" => "New streak started",
        "current_streak_days" => 0
    ]);
}
?>
