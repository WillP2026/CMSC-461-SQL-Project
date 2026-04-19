INSERT INTO users (name, role, email)
VALUES
('John Doe', 'faculty', 'johndoe@gmail.com'),
('Ben Doe', 'student', 'bendoe@gmail.com'),
('May Doe', 'visitor', 'maydoe@gmail.com'),
('Peter Doe', 'student', 'peterdoe@gmail.com'),
('Frank Doe', 'faculty', 'frankdoe@gmail.com'),
('Owen Doe', 'faculty', 'ownedoe@gmail.com'),
('Nate Doe', 'admin', 'natedoe@gmail.com'),
('Josh Doe', 'student', 'joshdoe@gmail.com'),
('Emily Doe', 'student', 'emilydoe@gmail.com'),
('Tish Doe', 'admin', 'tishdoe@gmail.com');

INSERT INTO permitTypes (permit_name)
VALUES
('A'),
('B'),
('C'),
('D'),
('E'),
('F'),
('G'),
('H'),
('I'),
('J');

INSERT INTO vehicles (user_id, plate_number, vehicle_year, model)
VALUES
('1','ABCDEFG','2025', 'toyota'),
('1','A123456','2023', 'toyota'),
('2','B123456','2013', 'honda'),
('3','B234567','2000', 'honda'),
('4','C123456','1995', 'chevy'),
('5','C234567','2026', 'ford'),
('6','D123456','2026', 'mustang'),
('7','D234567','2014', 'tesla'), -- visitor car
('8','GFEDCBA','2019', 'tesla'), -- visitor car
('9','A234567','2022', 'subaru');-- visitor car

INSERT INTO permits (vehicle_id,permit_type_id,date_issued,expiration_date)
VALUES
('1','1','2025-01-15', '2025-06-03'),
('1','2','2025-02-24', '2025-02-28'),
('2','4','2025-04-10', '2025-04-11'),
('2','4','2025-05-05', '2026-01-20'),
('1','1','2025-07-15', '2025-08-03'),
('3','5','2025-10-13', '2027-10-18'),
('4','1','2025-12-18', '2027-11-02'),
('5','1','2025-12-28', '2027-09-26'),
('6','1','2026-01-28', '2027-05-04'),
('7','2','2026-02-16', '2026-07-15'),
('7','1','2026-04-01', '2028-01-29');

INSERT INTO tickets (vehicle_id, date_issued, amount_owed, status)
VALUES
('1','2025-09-13','40','unpaid'),
('2','2025-08-23','49.30', 'paid'),
('3','2025-02-21','100.29', 'unpaid'),
('4','2025-04-16','200', 'paid'),
('5','2025-07-29','150.32', 'unpaid'),
('6','2025-01-27','10.42', 'unpaid'),
('7','2025-02-16','5.00', 'unpaid'),
('8','2026-05-19','20.00', 'unpaid'),
('9','2026-03-04','25.00', 'paid'),
('10','2026-04-07','50.00', 'unpaid');

INSERT INTO parkingLots (name,location)
VALUES
('Walker Garage', 'Walker Garage'),
('ACC Apartments', 'ACC'),
('Admin Parking Garage', 'Admin'),
('Parking Lot 1', '1000 Hilltop Circle'),
('Parking Lot 2', '1000 Hilltop Circle'),
('Parking Lot 3', '1000 Hilltop Circle'),
('Library Parking', 'UMBC Library'),
('Commons Parking Garage', 'Commons'),
('BWTech Parking Lot', 'BWTech'),
('Dining Hall Parking Lot', 'D Hall');

INSERT INTO parkingSpots (parking_lot_id,parking_spot_number)
VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('1', '4'),
('1', '5'),
('2', '1'),
('2', '2'),
('2', '3'),
('2', '4'),
('2', '5'),
('3', '1'),
('3', '2'),
('3', '3'),
('3', '4'),
('3', '5'),
('4', '1'),
('4', '2'),
('4', '3'),
('4', '4'),
('4', '5'),
('5', '1'),
('5', '2'),
('5', '3'),
('5', '4'),
('5', '5'),
('6', '1'),
('6', '2'),
('6', '3'),
('6', '4'),
('6', '5'),
('7', '1'),
('7', '2'),
('7', '3'),
('7', '4'),
('7', '5'),
('8', '1'),
('8', '2'),
('8', '3'),
('8', '4'),
('8', '5'),
('9', '1'),
('9', '2'),
('9', '3'),
('9', '4'),
('9', '5'),
('10', '1'),
('10', '2'),
('10', '3'),
('10', '4'),
('10', '5');

INSERT INTO lotPermitTypes (permit_type_id,parking_lot_id)
VALUES
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4'),
('5', '5'),
('6', '6'),
('7', '7'),
('8', '8'),
('9', '9'),
('10', '10');

INSERT INTO sensors(parking_spot_id, sensor_type)
VALUES
('1','camera'),
('2','camera'),
('3','camera'),
('4','camera'),
('5','camera'),
('6','camera'),
('7','camera'),
('8','camera'),
('9','camera'),
('10','camera'),
('11','camera'),
('12','camera'),
('13','camera'),
('14','camera'),
('15','camera'),
('16','camera'),
('17','camera'),
('18','camera'),
('19','camera'),
('20','camera'),
('21','motion'),
('22','motion'),
('23','motion'),
('24','motion'),
('25','motion'),
('26','motion'),
('27','motion'),
('28','motion'),
('29','motion'),
('30','motion'),
('31','camera'),
('32','camera'),
('33','camera'),
('34','camera'),
('35','camera'),
('36','camera'),
('37','camera'),
('38','camera'),
('39','camera'),
('40','camera');

INSERT INTO sensorEvents(sensor_id,vehicle_id, event_type, timestamp)
VALUES
('1','1','entry', '2025-01-13 12:00:00'),
('1','1','exit', '2025-02-26 05:00:00'),
('3','2','occupied', '2025-03-04 10:00:00'),
('4','3','entry', '2025-04-26 16:00:00'),
('5','3','occupied', '2025-05-23 14:00:00'),
('6','4','occupied', '2025-06-03 17:00:00'),
('7','5','occupied', '2025-07-06 15:00:00'),
('8','6','none', '2025-08-15 22:00:00'),
('9','7','entry', '2025-09-16 14:00:00'),
('10','8','entry','2025-10-28 21:00:00');

INSERT INTO reservations(vehicle_id, parking_spot_id, start_timestamp, end_timestamp)
VALUES
('8','1','2025-01-15 12:00:00', '2025-01-15 23:00:00'),
('8','2','2025-02-24 12:00:00', '2025-02-24 23:00:00'),
('8','4','2025-04-10 12:00:00', '2025-04-10 23:00:00'),
('8','4','2025-05-05 12:00:00', '2025-05-05 23:00:00'),
('8','1','2025-07-15 12:00:00', '2025-07-15 23:00:00'),
('9','5','2025-10-13 12:00:00', '2025-10-13 23:00:00'),
('9','1','2025-12-18 12:00:00', '2025-12-18 23:00:00'),
('9','1','2025-12-28 12:00:00', '2025-12-28 23:00:00'),
('10','1','2026-01-28 12:00:00', '2026-01-28 23:00:00'),
('10','2','2026-02-16 12:00:00', '2026-02-16 23:00:00'),
('10','1','2026-04-01 12:00:00', '2026-04-01 23:00:00');

-- INSERT INTO users (name, role, email)
-- VALUES
-- ('John Doe', 'visitor', 'johndoe@gmail.com'),
-- ('John Doe', 'faculty', 'johndoe@gmail.com');

-- INSERT INTO vehicles (user_id, plate_number, vehicle_year, model)
-- VALUES
-- ('1','ABCDEFG','2025', '2027-06-03'),
-- ('2','ABCDEFG','2023', '2027-02-14');
