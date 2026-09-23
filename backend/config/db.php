<?php

class Database
{
    // अपनी database की details यहाँ डालो
    private $host = "localhost";
    private $db_name = "retention_companion";   // ✅ Corrected
    private $username = "root";       // XAMPP/WAMP का default username
    private $password = "";           // XAMPP/WAMP में default password खाली होता है

    private $conn;

    // Connection बनाने वाला function
    public function connect()
    {
        $this->conn = null;

        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4",
                $this->username,
                $this->password
            );
            // Errors को exception की तरह throw करो (debugging आसान होगी)
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            echo json_encode(["success" => false, "message" => "Connection error: " . $e->getMessage()]);
            exit;
        }

        return $this->conn;
    }
}
