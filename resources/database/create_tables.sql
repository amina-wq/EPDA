CREATE DATABASE IF NOT EXISTS crs_db;
USE crs_db;

CREATE TABLE IF NOT EXISTS user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS student (
    id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    program VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    is_eligible BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS course (
    id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    description TEXT
);

CREATE TABLE IF NOT EXISTS enrollment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(20) NOT NULL,
    course_id VARCHAR(20) NOT NULL,
    semester VARCHAR(50) NOT NULL,
    grade FLOAT,
    attempt_number INT DEFAULT 1 CHECK (attempt_number BETWEEN 1 AND 3),
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_attempt (student_id, course_id, semester, attempt_number)
);

CREATE TABLE IF NOT EXISTS failed_component (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id BIGINT NOT NULL,
    component_type VARCHAR(50) NOT NULL,
    component_name VARCHAR(100) NOT NULL,
    score FLOAT NOT NULL,
    passing_score FLOAT NOT NULL,
    
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recovery_plan (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(20) NOT NULL,
    course_id VARCHAR(20) NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recovery_milestone (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    recovery_plan_id BIGINT NOT NULL,
    week_range VARCHAR(50) NOT NULL,
    task TEXT NOT NULL,
    deadline DATE,
    status VARCHAR(20) DEFAULT 'PENDING',
    grade FLOAT,
    comments TEXT,
    
    FOREIGN KEY (recovery_plan_id) REFERENCES recovery_plan(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    recipient_id VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMP NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);