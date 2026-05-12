-- ============================================
-- BLOOD BANK DATABASE
-- Version 1 (3NF) - Full Schema + Sample Data
-- 20 Participants | 5 Events | 3 Admins
-- Users with (*) appear as both Donor & Recipient:
--   A1 (Alice), C3 (Carla), F6 (Frank), J10 (Jose), N14 (Noel)
-- Admin users: ADM1, ADM2, ADM3
-- ============================================

-- ----------------------------
-- TABLE CREATION
-- ----------------------------

CREATE TABLE User (
    user_id VARCHAR(10) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE Profile (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(10) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    mname VARCHAR(50),
    birth_date DATE NOT NULL,
    sex CHAR(1) NOT NULL,
    address VARCHAR(255),
    mobile_no VARCHAR(20),
    blood_type VARCHAR(5),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(10) NOT NULL,
    feedback TEXT NOT NULL,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Donor (
    donor_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    role_id INT NOT NULL,
    last_donation_date DATE,
    no_times_donated INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Recipient (
    recipient_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    role_id INT NOT NULL,
    last_request_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Admin (
    admin_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    role_id INT NOT NULL,
    assigned_at DATETIME NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Event (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    event_location VARCHAR(255),
    capacity INT,
    managed_by VARCHAR(10),
    FOREIGN KEY (managed_by) REFERENCES Admin(admin_id)
);

CREATE TABLE Appointment_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id VARCHAR(10) NOT NULL,
    event_id INT NOT NULL,
    appointment_date_time DATETIME NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (status_id) REFERENCES Appointment_Status(status_id)
);

CREATE TABLE Request_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Blood_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    recipient_id VARCHAR(10) NOT NULL,
    blood_type VARCHAR(5) NOT NULL,
    units_requested INT NOT NULL,
    request_location VARCHAR(255),
    request_date DATE NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (recipient_id) REFERENCES Recipient(recipient_id),
    FOREIGN KEY (status_id) REFERENCES Request_Status(status_id)
);

CREATE TABLE Blood_Unit (
    blood_unit_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT NOT NULL,
    blood_type VARCHAR(5) NOT NULL,
    donation_date DATE NOT NULL,
    units_collected INT DEFAULT 1,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Blood_Release (
    blood_release_id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT NOT NULL,
    blood_unit_id INT NOT NULL,
    release_date DATE NOT NULL,
    released_by VARCHAR(10),                     -- FK to Admin.admin_id
    FOREIGN KEY (request_id) REFERENCES Blood_Request(request_id),
    FOREIGN KEY (blood_unit_id) REFERENCES Blood_Unit(blood_unit_id),
    FOREIGN KEY (released_by) REFERENCES Admin(admin_id)
);

CREATE TABLE Event_Registration (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    donor_id VARCHAR(10) NOT NULL,
    registered_date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id)
);


-- ----------------------------
-- SAMPLE DATA
-- ----------------------------

-- ============================================================
-- USER (20 participants + 3 admins)
-- ============================================================
INSERT INTO User (user_id, email, password) VALUES
('A1',   'alice.santos@example.com',    'Hash@123'),
('B2',   'brian.lee@example.com',       'Secure#456'),
('C3',   'carla.reyes@example.com',     'Pass!789'),
('D4',   'daniel.cruz@example.com',     'Lock$321'),
('E5',   'ella.flores@example.com',     'Safe%654'),
('F6',   'frank.garcia@example.com',    'Key^987'),
('G7',   'gina.mendoza@example.com',    'Shield&159'),
('H8',   'hector.ramos@example.com',    'Blade@202'),
('I9',   'iris.villanueva@example.com', 'Coral#331'),
('J10',  'jose.delacruz@example.com',   'Forge%441'),
('K11',  'karen.tan@example.com',       'Winds!551'),
('L12',  'leo.bautista@example.com',    'Torch^661'),
('M13',  'maria.lim@example.com',       'Crest&771'),
('N14',  'noel.aquino@example.com',     'Spark@881'),
('O15',  'ofelia.santos@example.com',   'Blaze#991'),
('P16',  'pedro.gomez@example.com',     'Drift%112'),
('Q17',  'quirino.david@example.com',   'Stone!223'),
('R18',  'rosa.fernandez@example.com',  'Frost^334'),
('S19',  'sergio.martin@example.com',   'Veil&445'),
('T20',  'teresa.ong@example.com',      'Nova@556'),
-- Admins
('ADM1', 'admin.juan@bloodbank.com',    'Admin@001'),
('ADM2', 'admin.rosa@bloodbank.com',    'Admin@002'),
('ADM3', 'admin.pedro@bloodbank.com',   'Admin@003');

-- ============================================================
-- PROFILE (20 rows)
-- ============================================================
INSERT INTO Profile (profile_id, user_id, fname, lname, mname, birth_date, sex, address, mobile_no, blood_type) VALUES
(1,  'A1',  'Alice',   'Santos',    'M', '1995-02-10', 'F', '123 Rizal St',      '+639171111111', 'O+'),
(2,  'B2',  'Brian',   'Lee',       'T', '1992-07-18', 'M', '45 Mabini Ave',     '+639181111112', 'A+'),
(3,  'C3',  'Carla',   'Reyes',     'P', '1998-11-04', 'F', '78 Luna Rd',        '+639191111113', 'B+'),
(4,  'D4',  'Daniel',  'Cruz',      'R', '1990-03-22', 'M', '9 Bonifacio Blvd',  '+639201111114', 'AB+'),
(5,  'E5',  'Ella',    'Flores',    'G', '1996-09-15', 'F', '14 Sampaguita St',  '+639211111115', 'O-'),
(6,  'F6',  'Frank',   'Garcia',    'L', '1991-12-01', 'M', '88 Acacia Ave',     '+639221111116', 'A-'),
(7,  'G7',  'Gina',    'Mendoza',   'C', '1994-05-27', 'F', '32 Narra St',       '+639231111117', 'B-'),
(8,  'H8',  'Hector',  'Ramos',     'D', '1988-08-14', 'M', '55 Kamagong St',    '+639241111118', 'O+'),
(9,  'I9',  'Iris',    'Villanueva','S', '1997-03-30', 'F', '17 Molave Ave',     '+639251111119', 'A+'),
(10, 'J10', 'Jose',    'dela Cruz', 'B', '1993-11-22', 'M', '6 Mahogany Blvd',   '+639261111120', 'B+'),
(11, 'K11', 'Karen',   'Tan',       'V', '1999-01-05', 'F', '23 Lauan St',       '+639271111121', 'AB-'),
(12, 'L12', 'Leo',     'Bautista',  'F', '1985-06-17', 'M', '90 Dao Rd',         '+639281111122', 'O+'),
(13, 'M13', 'Maria',   'Lim',       'A', '2000-09-08', 'F', '12 Yakal St',       '+639291111123', 'A-'),
(14, 'N14', 'Noel',    'Aquino',    'E', '1987-04-19', 'M', '38 Ipil Ave',       '+639301111124', 'B-'),
(15, 'O15', 'Ofelia',  'Santos',    'H', '1995-12-25', 'F', '7 Narra Blvd',      '+639311111125', 'AB+'),
(16, 'P16', 'Pedro',   'Gomez',     'I', '1990-07-03', 'M', '44 Tindalo St',     '+639321111126', 'O+'),
(17, 'Q17', 'Quirino', 'David',     'J', '1983-02-28', 'M', '19 Apitong Rd',     '+639331111127', 'A+'),
(18, 'R18', 'Rosa',    'Fernandez', 'K', '1998-05-11', 'F', '63 Bataan Ave',     '+639341111128', 'B+'),
(19, 'S19', 'Sergio',  'Martin',    'N', '1992-10-14', 'M', '28 Pampanga St',    '+639351111129', 'O-'),
(20, 'T20', 'Teresa',  'Ong',       'O', '2001-03-07', 'F', '5 Cavite Blvd',     '+639361111130', 'A+'),
-- Admins
(21, 'ADM1', 'Juan',   'Dela Vega', 'S', '1985-03-15', 'M', '10 Admin St',       '+639371111131', 'O+'),
(22, 'ADM2', 'Rosa',   'Magtanggol','B', '1990-07-22', 'F', '22 Admin Ave',      '+639381111132', 'A+'),
(23, 'ADM3', 'Pedro',  'Villanueva','C', '1988-11-30', 'M', '33 Admin Blvd',     '+639391111133', 'B+');

-- ============================================================
-- FEEDBACK (15 rows — not all users leave feedback)
-- ============================================================
INSERT INTO Feedback (feedback_id, user_id, feedback) VALUES
(1,  'A1',  'The donation process was smooth and well-organized.'),
(2,  'B2',  'Staff were very helpful and professional throughout.'),
(3,  'C3',  'Waiting time was short and the process was clear.'),
(4,  'E5',  'The screening was thorough and I felt safe donating.'),
(5,  'F6',  'Great overall experience, will definitely return.'),
(6,  'H8',  'The nurses were kind and made me feel at ease.'),
(7,  'J10', 'Quick process with no long lines — very efficient.'),
(8,  'K11', 'Loved the organized flow at the event venue.'),
(9,  'M13', 'The donation area was clean and well-maintained.'),
(10, 'N14', 'I felt well cared for at every step of the process.'),
(11, 'P16', 'The appointment reminders were very helpful.'),
(12, 'R18', 'Staff explained the procedure clearly before we began.'),
(13, 'T20', 'Proud to have donated — the team was truly amazing.'),
(14, 'D4',  'My blood request was processed faster than expected.'),
(15, 'G7',  'Staff kept me informed about my request status throughout.');

-- ============================================================
-- ROLE
-- ============================================================
INSERT INTO Role (role_id, role_name) VALUES
(1, 'donor'),
(2, 'recipient'),
(3, 'admin');

-- ============================================================
-- ADMIN (3 admins)
-- Must be inserted before Event and Blood_Release
-- ============================================================
INSERT INTO Admin (admin_id, user_id, role_id, assigned_at, is_active) VALUES
('ADM1', 'ADM1', 3, '2024-01-01 08:00:00', 1),
('ADM2', 'ADM2', 3, '2024-01-01 08:00:00', 1),
('ADM3', 'ADM3', 3, '2024-06-01 08:00:00', 1);

-- ============================================================
-- DONOR (13 donors)
-- A1, C3, F6, J10, N14 (*) also appear as recipients
-- ============================================================
INSERT INTO Donor (donor_id, user_id, role_id, last_donation_date, no_times_donated) VALUES
('D001', 'A1',  1, '2025-03-10', 4),
('D002', 'B2',  1, '2025-04-05', 6),
('D003', 'C3',  1, '2025-01-22', 2),
('D004', 'E5',  1, '2025-02-14', 3),
('D005', 'F6',  1, '2025-03-28', 8),
('D006', 'H8',  1, '2025-04-18', 5),
('D007', 'J10', 1, '2025-02-05', 1),
('D008', 'K11', 1, '2025-03-01', 3),
('D009', 'M13', 1, '2025-04-22', 2),
('D010', 'N14', 1, '2025-01-15', 7),
('D011', 'P16', 1, '2025-03-19', 4),
('D012', 'R18', 1, '2025-04-30', 2),
('D013', 'T20', 1, '2025-02-28', 1);

-- ============================================================
-- RECIPIENT (12 recipients)
-- A1(*), C3(*), F6(*), J10(*), N14(*) also appear as donors
-- D4, G7, I9, L12, O15, Q17, S19 are recipients only
-- ============================================================
INSERT INTO Recipient (recipient_id, user_id, role_id, last_request_date) VALUES
('R001', 'A1',  2, '2025-04-20'),
('R002', 'C3',  2, '2025-03-15'),
('R003', 'D4',  2, '2025-05-02'),
('R004', 'F6',  2, '2025-04-10'),
('R005', 'G7',  2, '2025-05-07'),
('R006', 'I9',  2, '2025-04-25'),
('R007', 'J10', 2, '2025-03-30'),
('R008', 'L12', 2, '2025-05-01'),
('R009', 'N14', 2, '2025-02-18'),
('R010', 'O15', 2, '2025-04-14'),
('R011', 'Q17', 2, '2025-05-05'),
('R012', 'S19', 2, '2025-03-22');

-- ============================================================
-- EVENT (5 events) — inserted early, referenced by Appointment
-- created_by references Admin who organized the event
-- ============================================================
INSERT INTO Event (event_id, event_name, event_date, event_location, capacity, created_by) VALUES
(1, 'Central Hospital Blood Drive',    '2025-06-10', 'Central Hospital',  80,  'ADM1'),
(2, 'University Donation Camp',        '2025-06-11', 'University Clinic', 100, 'ADM1'),
(3, 'University Blood Drive',          '2025-06-12', 'University Clinic',  60, 'ADM2'),
(4, 'Community Center Mobile Drive',   '2025-06-13', 'Community Center',   40, 'ADM2'),
(5, 'Red Cross Weekend Event',         '2025-06-14', 'Red Cross HQ',      120, 'ADM3');

-- ============================================================
-- APPOINTMENT STATUS
-- ============================================================
INSERT INTO Appointment_Status (status_id, status_name) VALUES
(1, 'Scheduled'),
(2, 'Completed'),
(3, 'Cancelled'),
(4, 'No-show');

-- ============================================================
-- APPOINTMENT (13 rows — all tied to events, location from Event)
-- ============================================================
INSERT INTO Appointment (appointment_id, donor_id, event_id, appointment_date_time, status_id) VALUES
(1,  'D001', 1, '2025-06-10 09:00:00', 2),
(2,  'D002', 2, '2025-06-11 10:30:00', 2),
(3,  'D003', 3, '2025-06-12 08:45:00', 3),
(4,  'D004', 4, '2025-06-13 11:00:00', 2),
(5,  'D005', 5, '2025-06-14 13:15:00', 2),
(6,  'D006', 1, '2025-06-10 15:00:00', 4),
(7,  'D007', 2, '2025-06-11 09:00:00', 2),
(8,  'D008', 3, '2025-06-12 10:00:00', 1),
(9,  'D009', 4, '2025-06-13 11:30:00', 2),
(10, 'D010', 5, '2025-06-14 08:00:00', 2),
(11, 'D011', 1, '2025-06-10 14:00:00', 1),
(12, 'D012', 2, '2025-06-11 09:45:00', 2),
(13, 'D013', 3, '2025-06-12 13:00:00', 3);

-- ============================================================
-- REQUEST STATUS
-- ============================================================
INSERT INTO Request_Status (status_id, status_name) VALUES
(1, 'Pending'),
(2, 'Completed'),
(3, 'Cancelled');

-- ============================================================
-- BLOOD REQUEST (12 rows — one per recipient)
-- ============================================================
INSERT INTO Blood_Request (request_id, recipient_id, blood_type, units_requested, request_location, request_date, status_id) VALUES
(1,  'R001', 'O+',  2, 'Central Hospital',        '2025-04-20', 2),
(2,  'R002', 'B+',  1, 'University Clinic',       '2025-03-15', 2),
(3,  'R003', 'AB+', 3, 'Provincial Hospital',     '2025-05-02', 1),
(4,  'R004', 'A-',  2, 'St. Mary Clinic',         '2025-04-10', 2),
(5,  'R005', 'B-',  1, 'General Hospital',        '2025-05-07', 1),
(6,  'R006', 'A+',  2, 'Westcare Hospital',       '2025-04-25', 2),
(7,  'R007', 'B+',  3, 'Barangay Health Office',  '2025-03-30', 2),
(8,  'R008', 'O+',  1, 'City Medical Center',     '2025-05-01', 1),
(9,  'R009', 'B-',  2, 'Eastside ER',             '2025-02-18', 2),
(10, 'R010', 'AB+', 1, 'Community Health Center', '2025-04-14', 3),
(11, 'R011', 'A+',  2, 'Central Hospital',        '2025-05-05', 1),
(12, 'R012', 'O-',  1, 'Red Cross HQ',            '2025-03-22', 2);

-- ============================================================
-- BLOOD UNIT (from completed appointments: 1,2,4,5,7,9,10,12)
-- ============================================================
INSERT INTO Blood_Unit (blood_unit_id, appointment_id, blood_type, donation_date, units_collected) VALUES
(1, 1,  'O+',  '2025-06-10', 1),
(2, 2,  'A+',  '2025-06-11', 1),
(3, 4,  'O-',  '2025-06-13', 1),
(4, 5,  'A-',  '2025-06-14', 1),
(5, 7,  'B+',  '2025-06-17', 1),
(6, 9,  'A-',  '2025-06-19', 1),
(7, 10, 'B-',  '2025-06-20', 1),
(8, 12, 'B+',  '2025-06-23', 1);

-- ============================================================
-- BLOOD RELEASE (links completed requests to available units)
-- released_by references Admin who approved the release
-- ============================================================
INSERT INTO Blood_Release (blood_release_id, request_id, blood_unit_id, release_date, released_by) VALUES
(1, 1,  1, '2025-06-12', 'ADM1'),
(2, 2,  5, '2025-06-18', 'ADM1'),
(3, 4,  4, '2025-06-15', 'ADM2'),
(4, 6,  2, '2025-06-13', 'ADM2'),
(5, 7,  8, '2025-06-25', 'ADM3'),
(6, 9,  7, '2025-06-22', 'ADM3'),
(7, 12, 3, '2025-06-16', 'ADM1');

-- ============================================================
-- EVENT REGISTRATION
-- Tracks who pre-registered; some donors register for multiple events
-- ============================================================
INSERT INTO Event_Registration (registration_id, event_id, donor_id, registered_date_time) VALUES
-- Event 1: Central Hospital Blood Drive
(1,  1, 'D001', '2025-06-03 08:15:00'),
(2,  1, 'D006', '2025-06-03 09:30:00'),
(3,  1, 'D011', '2025-06-04 10:00:00'),
-- Event 2: University Donation Camp
(4,  2, 'D002', '2025-06-05 09:20:00'),
(5,  2, 'D007', '2025-06-05 10:10:00'),
(6,  2, 'D012', '2025-06-06 13:30:00'),
-- Event 3: University Blood Drive
(7,  3, 'D003', '2025-06-07 08:00:00'),
(8,  3, 'D008', '2025-06-07 09:00:00'),
(9,  3, 'D013', '2025-06-08 10:30:00'),
(10, 3, 'D001', '2025-06-08 11:00:00'),  -- D001 registers again
-- Event 4: Community Center Mobile Drive
(11, 4, 'D004', '2025-06-09 08:30:00'),
(12, 4, 'D009', '2025-06-09 09:15:00'),
(13, 4, 'D002', '2025-06-09 10:00:00'),  -- D002 registers again
-- Event 5: Red Cross Weekend Event
(14, 5, 'D005', '2025-06-10 08:00:00'),
(15, 5, 'D010', '2025-06-10 09:30:00'),
(16, 5, 'D007', '2025-06-10 10:15:00'),  -- D007 registers again
(17, 5, 'D011', '2025-06-10 11:00:00'),  -- D011 registers again
(18, 5, 'D012', '2025-06-10 13:00:00');  -- D012 registers again
