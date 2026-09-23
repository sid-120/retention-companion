<?php
header("Content-Type: application/json");
include_once '../config/db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (
    empty($data['name']) || 
    empty($data['email']) || 
    empty($data['password'])
) {
    echo json_encode(["success" => false, "message" => "Name, email and password are required"]);
    exit;
}

$database = new Database();
$conn = $database->connect();

try {
    // Check if email already exists
    $checkQuery = "SELECT id FROM users WHERE email = :email";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bindParam(":email", $data['email']);
    $checkStmt->execute();

    if ($checkStmt->rowCount() > 0) {
        echo json_encode(["success" => false, "message" => "Email already registered"]);
        exit;
    }

    $password_hash = password_hash($data['password'], PASSWORD_BCRYPT);
    $age = isset($data['age']) ? $data['age'] : null;
    $country = isset($data['country']) ? $data['country'] : null;

    $query = "INSERT INTO users (username, email, password_hash, age, country) 
              VALUES (:username, :email, :password_hash, :age, :country)";

    $stmt = $conn->prepare($query);
    $stmt->bindParam(":username", $data['name']);
    $stmt->bindParam(":email", $data['email']);
    $stmt->bindParam(":password_hash", $password_hash);
    $stmt->bindParam(":age", $age);
    $stmt->bindParam(":country", $country);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Registration successful",
            "user_id" => $conn->lastInsertId()
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Registration failed"]);
    }

} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Database error: " . $e->getMessage()]);
}
?>
