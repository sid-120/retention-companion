<?php
header('Content-Type: application/json');
require_once '../config/db.php';
require_once '../includes/jing_helper.php';

$database = new Database();
$conn = $database->connect();

$data = json_decode(file_get_contents("php://input"), true);
$user_id = $data['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(["success" => false, "message" => "user_id is required"]);
    exit;
}

// Step 1: User की age निकालो
$stmt = $conn->prepare("SELECT age FROM users WHERE id = :user_id");
$stmt->execute(['user_id' => $user_id]);
$userRow = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$userRow) {
    echo json_encode(["success" => false, "message" => "User not found"]);
    exit;
}
$age = $userRow['age'];
$penalty = getPenaltyByAge($age);

// Step 2: Active streak ढूंढो
$stmt2 = $conn->prepare("SELECT id, start_timestamp FROM streaks WHERE user_id = :user_id AND status = 'active' ORDER BY id DESC LIMIT 1");
$stmt2->execute(['user_id' => $user_id]);
$streakRow = $stmt2->fetch(PDO::FETCH_ASSOC);

if (!$streakRow) {
    echo json_encode(["success" => false, "message" => "No active streak found"]);
    exit;
}
$streak_id = $streakRow['id'];

// Step 3: Current streak days calculate करो
$start = new DateTime($streakRow['start_timestamp']);
$now = new DateTime();
$current_streak_days = $now->diff($start)->days;

// Step 4: Penalty logic apply करो
$new_streak_days = $current_streak_days - $penalty;
if ($new_streak_days < 0) {
    $new_streak_days = 0;
}

// Step 5: पुरानी row को 'relapsed' mark करो
$stmt3 = $conn->prepare("UPDATE streaks SET status = 'relapsed', end_timestamp = NOW() WHERE id = :id");
$stmt3->execute(['id' => $streak_id]);

// Step 6: नई row insert करो
$stmt4 = $conn->prepare("INSERT INTO streaks (user_id, start_timestamp, status) VALUES (:user_id, NOW() - INTERVAL :days DAY, 'active')");
$stmt4->execute(['user_id' => $user_id, 'days' => $new_streak_days]);

echo json_encode([
    "success" => true,
    "message" => "Relapse recorded",
    "age" => $age,
    "penalty_applied" => $penalty,
    "old_streak_days" => $current_streak_days,
    "new_streak_days" => $new_streak_days
]);
?>
