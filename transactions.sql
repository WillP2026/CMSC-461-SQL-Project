-- NOT TO RUN (FOLLOW QUERIES WITHIN PG ADMIN)
-- PLEASE RUN createDDL.sql and loadAll.sql     

-- OVER LAPPING EXAMPLE 
-- IN SESSION 1 RUN THE FOLLOWING
DELETE FROM reservations;

BEGIN;
SELECT * FROM reservations
WHERE parking_spot_id = 2;


-- THEN RUN IN SESSION 2
BEGIN;
SELECT * FROM reservations
WHERE parking_spot_id = 2;

INSERT INTO reservations(vehicle_id, parking_spot_id, start_timestamp, end_timestamp)
VALUES
('10','2','2026-05-01 12:00:00', '2028-05-01 23:00:00');

COMMIT;

-- THEN IN SESSION 1 RUN

INSERT INTO reservations(vehicle_id, parking_spot_id, start_timestamp, end_timestamp)
VALUES
('8','2','2026-05-01 12:00:00', '2028-05-01 23:00:00');

COMMIT;

-- CHECK THE TABLE WHICH SHOULD HAVE A DOUBLE BOOKING
SELECT * FROM reservations;

-- CLEAN TABLE
DELETE FROM reservations;

-- PREVENTATION (ROW LOCKING)

-- IN SESSION 1 RUN

BEGIN;

SELECT * FROM parkingSpots
WHERE parking_spot_id = 2
FOR UPDATE;

INSERT INTO reservations(vehicle_id, parking_spot_id, start_timestamp, end_timestamp)
VALUES
('10','2','2026-05-01 12:00:00', '2028-05-01 23:00:00');

-- IN SESSION 2 RUN
BEGIN;
SELECT * FROM parkingSpots
WHERE parking_spot_id = 2
FOR UPDATE;

-- THEN IN SESSION 1 RUN
COMMIT;

-- THEN IN SESSION 2 RUN
SELECT * FROM reservations
WHERE parking_spot_id = 2
AND '2026-05-01 12:00:00' < end_timestamp
AND '2026-05-01 23:00:00' > start_timestamp;

ROLLBACK;

-- CHECK THAT THERE IS NO DOUBLE BOOKING
SELECT * FROM reservations;