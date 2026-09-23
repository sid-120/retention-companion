<?php
header("Content-Type: application/json");
include_once '../config/db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (empty($data['email']) || empty($data['password'])) {
    echo json_encode(["success" => false, "message" => "Email and password are required"]);
    exit;
}

$database = new Database();
$conn = $database->connect();

try {
    $query = "SELECT id, username, email, password_hash, age, country, is_anonymous, created_at 
              FROM users WHERE email = :email";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(":email", $data['email']);
    $stmt->execute();

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($data['password'], $user['password_hash'])) {
        unset($user['password_hash']); // password hash कभी response में नहीं भेजना चाहिए

        echo json_encode([
            "success" => true,
            "message" => "Login successful",
            "user" => $user
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid email or password"]);
    }
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
}
