CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE streaks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_timestamp DATETIME NOT NULL,
    end_timestamp DATETIME DEFAULT NULL,
    status ENUM('active', 'relapsed') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE checkins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    checkin_date DATE NOT NULL,
    mood VARCHAR(20),
    trigger_note TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE reflections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    entry_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
