USE crs_db;

INSERT INTO user (username, password, email, role, active) VALUES
('admin', 'admin123', 'admin@university.edu', 'ADMIN', TRUE),
('jdoe', 'password123', 'john.doe@university.edu', 'OFFICER', TRUE),
('asmith', 'password123', 'alice.smith@university.edu', 'OFFICER', TRUE),
('bwilson', 'password123', 'bob.wilson@university.edu', 'OFFICER', TRUE),
('ctaylor', 'password123', 'carol.taylor@university.edu', 'OFFICER', FALSE);

INSERT INTO student (id, name, program, email, is_eligible) VALUES
('2025A1234', 'Alex Tan', 'Bachelor of Computer Science', 'alex.tan@student.edu', FALSE),
('2025B5678', 'Maria Garcia', 'Bachelor of Computer Science', 'maria.garcia@student.edu', TRUE),
('2025C9012', 'John Smith', 'Bachelor of Information Technology', 'john.smith@student.edu', FALSE),
('2025D3456', 'Sarah Johnson', 'Bachelor of Computer Science', 'sarah.johnson@student.edu', FALSE),
('2025E7890', 'Mike Brown', 'Bachelor of Information Technology', 'mike.brown@student.edu', TRUE),
('2025F1122', 'Emily Davis', 'Bachelor of Data Science', 'emily.davis@student.edu', TRUE),
('2025G3344', 'David Lee', 'Bachelor of Computer Science', 'david.lee@student.edu', FALSE),
('2025H5566', 'Lisa Wong', 'Bachelor of Information Technology', 'lisa.wong@student.edu', TRUE),
('2025I7788', 'James Wilson', 'Bachelor of Data Science', 'james.wilson@student.edu', FALSE),
('2025J9900', 'Anna Kim', 'Bachelor of Computer Science', 'anna.kim@student.edu', TRUE);

INSERT INTO course (id, title, credits, description) VALUES
('CS201', 'Data Structures', 3, 'Introduction to data structures and algorithms including arrays, linked lists, trees, and graphs'),
('CS205', 'Database Systems', 3, 'Fundamentals of database design, SQL, normalization, and transaction management'),
('CS210', 'Software Engineering I', 3, 'Software development lifecycle, requirements analysis, and design patterns'),
('MA202', 'Discrete Mathematics', 4, 'Mathematical foundations for computer science including logic, sets, and combinatorics'),
('EN201', 'Academic Writing', 2, 'Technical writing skills, research papers, and academic communication'),
('CS301', 'Operating Systems', 3, 'Concepts of operating systems including process management, memory management, and file systems'),
('CS305', 'Computer Networks', 3, 'Network protocols, OSI model, TCP/IP, and network security'),
('CS310', 'Web Development', 3, 'Frontend and backend web development technologies'),
('MA301', 'Linear Algebra', 3, 'Matrices, vector spaces, eigenvalues, and applications in computing'),
('IT201', 'Introduction to Programming', 3, 'Fundamentals of programming using Python'),
('IT205', 'Object-Oriented Programming', 3, 'Object-oriented concepts using Java'),
('DS201', 'Introduction to Data Science', 3, 'Basic concepts of data science and analytics');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025A1234', 'CS201', 'Semester 1, 2025', 4.0, 1, 'PASSED'),
('2025A1234', 'CS205', 'Semester 1, 2025', 3.3, 1, 'PASSED'),
('2025A1234', 'CS210', 'Semester 1, 2025', 3.0, 1, 'PASSED'),
('2025A1234', 'MA202', 'Semester 1, 2025', 2.3, 1, 'PASSED'),
('2025A1234', 'EN201', 'Semester 1, 2025', 3.7, 1, 'PASSED'),
('2025A1234', 'CS301', 'Semester 2, 2025', 3.0, 1, 'PASSED'),
('2025A1234', 'CS305', 'Semester 2, 2025', 3.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025B5678', 'CS201', 'Semester 1, 2025', 4.0, 1, 'PASSED'),
('2025B5678', 'CS205', 'Semester 1, 2025', 4.0, 1, 'PASSED'),
('2025B5678', 'MA202', 'Semester 1, 2025', 3.7, 1, 'PASSED'),
('2025B5678', 'EN201', 'Semester 1, 2025', 4.0, 1, 'PASSED'),
('2025B5678', 'CS210', 'Semester 2, 2025', 3.7, 1, 'PASSED'),
('2025B5678', 'CS301', 'Semester 2, 2025', 3.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025C9012', 'CS201', 'Semester 1, 2025', 2.0, 1, 'PASSED'),
('2025C9012', 'MA202', 'Semester 1, 2025', 1.0, 1, 'FAILED'),
('2025C9012', 'MA202', 'Semester 2, 2025', 1.3, 2, 'FAILED'),
('2025C9012', 'CS205', 'Semester 1, 2025', 1.7, 1, 'FAILED'),
('2025C9012', 'EN201', 'Semester 1, 2025', 2.0, 1, 'PASSED'),
('2025C9012', 'CS210', 'Semester 2, 2025', 1.3, 1, 'FAILED'),
('2025C9012', 'IT201', 'Semester 2, 2025', 2.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025D3456', 'CS201', 'Semester 1, 2025', 2.3, 1, 'PASSED'),
('2025D3456', 'CS205', 'Semester 1, 2025', 2.0, 1, 'PASSED'),
('2025D3456', 'MA202', 'Semester 1, 2025', 1.3, 1, 'FAILED'),
('2025D3456', 'CS210', 'Semester 2, 2025', 2.0, 1, 'PASSED'),
('2025D3456', 'EN201', 'Semester 2, 2025', 1.7, 1, 'FAILED'),
('2025D3456', 'IT201', 'Semester 2, 2025', 1.0, 1, 'FAILED'),
('2025D3456', 'IT201', 'Semester 3, 2025', 2.3, 2, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025E7890', 'IT201', 'Semester 1, 2025', 3.3, 1, 'PASSED'),
('2025E7890', 'IT205', 'Semester 1, 2025', 3.0, 1, 'PASSED'),
('2025E7890', 'CS201', 'Semester 2, 2025', 3.7, 1, 'PASSED'),
('2025E7890', 'CS205', 'Semester 2, 2025', 3.0, 1, 'PASSED'),
('2025E7890', 'EN201', 'Semester 2, 2025', 3.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025F1122', 'DS201', 'Semester 1, 2025', 4.0, 1, 'PASSED'),
('2025F1122', 'CS201', 'Semester 1, 2025', 3.7, 1, 'PASSED'),
('2025F1122', 'MA301', 'Semester 1, 2025', 3.3, 1, 'PASSED'),
('2025F1122', 'CS205', 'Semester 2, 2025', 4.0, 1, 'PASSED'),
('2025F1122', 'CS310', 'Semester 2, 2025', 3.7, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025G3344', 'CS201', 'Semester 1, 2025', 2.7, 1, 'PASSED'),
('2025G3344', 'MA202', 'Semester 1, 2025', 1.0, 1, 'FAILED'),
('2025G3344', 'MA202', 'Semester 2, 2025', 1.3, 2, 'FAILED'),
('2025G3344', 'MA301', 'Semester 2, 2025', 1.0, 1, 'FAILED'),
('2025G3344', 'CS205', 'Semester 2, 2025', 2.0, 1, 'PASSED'),
('2025G3344', 'EN201', 'Semester 2, 2025', 2.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025H5566', 'IT201', 'Semester 1, 2025', 3.7, 1, 'PASSED'),
('2025H5566', 'IT205', 'Semester 1, 2025', 3.3, 1, 'PASSED'),
('2025H5566', 'CS201', 'Semester 2, 2025', 3.0, 1, 'PASSED'),
('2025H5566', 'CS305', 'Semester 2, 2025', 3.3, 1, 'PASSED'),
('2025H5566', 'EN201', 'Semester 2, 2025', 4.0, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025I7788', 'DS201', 'Semester 1, 2025', 1.3, 1, 'FAILED'),
('2025I7788', 'CS201', 'Semester 1, 2025', 1.7, 1, 'FAILED'),
('2025I7788', 'MA301', 'Semester 1, 2025', 1.0, 1, 'FAILED'),
('2025I7788', 'DS201', 'Semester 2, 2025', 1.7, 2, 'FAILED'),
('2025I7788', 'CS201', 'Semester 2, 2025', 2.0, 2, 'PASSED'),
('2025I7788', 'EN201', 'Semester 2, 2025', 2.3, 1, 'PASSED');

INSERT INTO enrollment (student_id, course_id, semester, grade, attempt_number, status) VALUES
('2025J9900', 'CS201', 'Semester 1, 2025', 3.3, 1, 'PASSED'),
('2025J9900', 'CS205', 'Semester 1, 2025', 3.7, 1, 'PASSED'),
('2025J9900', 'MA202', 'Semester 1, 2025', 3.0, 1, 'PASSED'),
('2025J9900', 'CS210', 'Semester 2, 2025', 3.3, 1, 'PASSED'),
('2025J9900', 'CS301', 'Semester 2, 2025', 3.0, 1, 'PASSED'),
('2025J9900', 'EN201', 'Semester 2, 2025', 3.7, 1, 'PASSED');

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Final Exam', 45, 60
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'MA202' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'ASSIGNMENT', 'Assignment 3 - Logic Problems', 55, 70
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'MA202' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'QUIZ', 'Quiz 2 - Set Theory', 40, 60
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'MA202' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Recovery Exam', 52, 60
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'MA202' AND e.attempt_number = 2;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Midterm Exam', 38, 60
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'CS205' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'PROJECT', 'Database Design Project', 50, 70
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'CS205' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Final Exam', 42, 60
FROM enrollment e
WHERE e.student_id = '2025C9012' AND e.course_id = 'CS210' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Discrete Math Exam', 48, 60
FROM enrollment e
WHERE e.student_id = '2025D3456' AND e.course_id = 'MA202' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'ASSIGNMENT', 'Academic Essay', 55, 70
FROM enrollment e
WHERE e.student_id = '2025D3456' AND e.course_id = 'EN201' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Python Programming Exam', 35, 60
FROM enrollment e
WHERE e.student_id = '2025D3456' AND e.course_id = 'IT201' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Discrete Math Exam', 42, 60
FROM enrollment e
WHERE e.student_id = '2025G3344' AND e.course_id = 'MA202' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Linear Algebra Exam', 38, 60
FROM enrollment e
WHERE e.student_id = '2025G3344' AND e.course_id = 'MA301' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Data Science Exam', 40, 60
FROM enrollment e
WHERE e.student_id = '2025I7788' AND e.course_id = 'DS201' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'PROJECT', 'Data Analysis Project', 45, 70
FROM enrollment e
WHERE e.student_id = '2025I7788' AND e.course_id = 'DS201' AND e.attempt_number = 1;

INSERT INTO failed_component (enrollment_id, component_type, component_name, score, passing_score)
SELECT e.id, 'EXAM', 'Data Structures Exam', 47, 60
FROM enrollment e
WHERE e.student_id = '2025I7788' AND e.course_id = 'CS201' AND e.attempt_number = 1;

INSERT INTO recovery_plan (student_id, course_id, start_date, end_date, status) VALUES
('2025C9012', 'MA202', '2025-09-01', '2025-10-30', 'ACTIVE'),
('2025C9012', 'CS205', '2025-09-01', '2025-10-30', 'ACTIVE'),
('2025C9012', 'CS210', '2025-09-15', '2025-11-15', 'ACTIVE');

INSERT INTO recovery_plan (student_id, course_id, start_date, end_date, status) VALUES
('2025D3456', 'MA202', '2025-09-15', '2025-11-15', 'ACTIVE'),
('2025D3456', 'EN201', '2025-09-15', '2025-10-30', 'ACTIVE'),
('2025D3456', 'IT201', '2025-10-01', '2025-11-30', 'ACTIVE');

INSERT INTO recovery_plan (student_id, course_id, start_date, end_date, status) VALUES
('2025G3344', 'MA202', '2025-09-01', '2025-10-30', 'ACTIVE'),
('2025G3344', 'MA301', '2025-09-01', '2025-10-30', 'ACTIVE');

INSERT INTO recovery_plan (student_id, course_id, start_date, end_date, status) VALUES
('2025I7788', 'DS201', '2025-09-01', '2025-10-30', 'ACTIVE'),
('2025I7788', 'CS201', '2025-09-01', '2025-10-30', 'COMPLETED');

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(1, 'Week 1-2', 'Review all lecture topics for Discrete Mathematics', '2025-09-15', 'IN_PROGRESS', 'Focus on set theory and logic'),
(1, 'Week 3', 'Meeting with module lecturer to discuss weak areas', '2025-09-22', 'PENDING', 'Prepare questions about combinatorics'),
(1, 'Week 4', 'Take recovery exam for Discrete Mathematics', '2025-09-29', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(2, 'Week 1-2', 'Review database normalization and SQL', '2025-09-15', 'PENDING', NULL),
(2, 'Week 3', 'Complete practice exercises on complex queries', '2025-09-22', 'PENDING', NULL),
(2, 'Week 4', 'Take recovery exam for Database Systems', '2025-09-29', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(3, 'Week 1-3', 'Complete online tutorial for Software Engineering', '2025-10-06', 'PENDING', 'Use provided online resources'),
(3, 'Week 4-5', 'Work on practice project', '2025-10-20', 'PENDING', NULL),
(3, 'Week 6', 'Take recovery exam', '2025-10-27', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(4, 'Week 1-2', 'Review set theory and logic', '2025-09-29', 'PENDING', NULL),
(4, 'Week 3-4', 'Practice combinatorics problems', '2025-10-13', 'PENDING', NULL),
(4, 'Week 5', 'Take recovery exam', '2025-10-20', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(5, 'Week 1-2', 'Rewrite academic essay', '2025-09-29', 'PENDING', 'Focus on structure and citations'),
(5, 'Week 3', 'Submit for review', '2025-10-06', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, comments) VALUES
(7, 'Week 1-3', 'Complete math tutorial', '2025-09-22', 'IN_PROGRESS', 'Focus on problem areas'),
(7, 'Week 4', 'Take recovery exam', '2025-09-29', 'PENDING', NULL);

INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, grade, comments) VALUES
(9, 'Week 1-2', 'Review data science fundamentals', '2025-09-15', 'COMPLETED', 3.0, 'Good progress'),
(9, 'Week 3-4', 'Complete practice project', '2025-09-29', 'COMPLETED', 2.7, 'Needs improvement in data visualization'),
(9, 'Week 5', 'Take recovery exam', '2025-10-06', 'COMPLETED', 3.3, 'Passed');

INSERT INTO notification (recipient_id, type, subject, content, sent_at, status) VALUES
('2025C9012', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - MA202', 'A recovery plan for Discrete Mathematics has been created. Please check your milestones and deadlines.', '2025-09-01 10:30:00', 'SENT'),
('2025C9012', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - CS205', 'A recovery plan for Database Systems has been created. Please check your milestones and deadlines.', '2025-09-01 10:31:00', 'SENT'),
('2025C9012', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - CS210', 'A recovery plan for Software Engineering I has been created. Please check your milestones and deadlines.', '2025-09-15 09:00:00', 'SENT'),
('2025D3456', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - MA202', 'A recovery plan for Discrete Mathematics has been created. Please check your milestones and deadlines.', '2025-09-15 11:00:00', 'SENT'),
('2025D3456', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - EN201', 'A recovery plan for Academic Writing has been created. Please check your milestones and deadlines.', '2025-09-15 11:05:00', 'SENT'),
('2025D3456', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - IT201', 'A recovery plan for Introduction to Programming has been created. Please check your milestones and deadlines.', '2025-10-01 14:00:00', 'PENDING'),
('2025G3344', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - MA202', 'A recovery plan for Discrete Mathematics has been created. Please check your milestones and deadlines.', '2025-09-01 09:15:00', 'SENT'),
('2025G3344', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - MA301', 'A recovery plan for Linear Algebra has been created. Please check your milestones and deadlines.', '2025-09-01 09:20:00', 'SENT'),
('2025I7788', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - DS201', 'A recovery plan for Introduction to Data Science has been created. Please check your milestones and deadlines.', '2025-09-01 10:00:00', 'SENT'),
('2025I7788', 'RECOVERY_PLAN_CREATED', 'Recovery Plan Created - CS201', 'A recovery plan for Data Structures has been created. Please check your milestones and deadlines.', '2025-09-01 10:05:00', 'SENT'),
('2025I7788', 'RECOVERY_PLAN_COMPLETED', 'Recovery Plan Completed - CS201', 'Congratulations! Your recovery plan for Data Structures has been completed successfully.', '2025-10-07 15:30:00', 'SENT'),
('admin', 'REPORT_READY', 'Weekly Eligibility Report', 'The weekly eligibility report is ready for review. 5 students are currently not eligible for progression.', '2025-10-15 08:00:00', 'SENT'),
('1', 'ACCOUNT_CREATED', 'Welcome to CRS', 'Your administrator account has been created. Please login to access the system.', '2025-01-01 09:00:00', 'SENT'),
('2', 'PASSWORD_RESET', 'Password Reset Request', 'Your password has been reset. Please use the temporary password to login.', '2025-02-15 14:30:00', 'SENT');