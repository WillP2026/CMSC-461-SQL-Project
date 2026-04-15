CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,

    CHECK (role IN ('faculty','student','visitor', 'admin'))
);

CREATE TABLE permitTypes (
    permit_type_id SERIAL PRIMARY KEY,
    permit_name VARCHAR(1) NOT NULL UNIQUE
);

CREATE TABLE vehicles(
    vehicle_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    plate_number VARCHAR(10) NOT NULL UNIQUE,
    vehicle_year VARCHAR(4) NOT NULL,
    model VARCHAR(50) NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE permits (
    permit_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL,
    permit_type_id INT NOT NULL,
    date_issued DATE NOT NULL,
    expiration_date DATE NOT NULL,
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
        ON DELETE CASCADE,
    
    FOREIGN KEY (permit_type_id) 
        REFERENCES permitTypes(permit_type_id)
            ON DELETE RESTRICT,

    CHECK (expiration_date > date_issued)
);

CREATE TABLE tickets(
    ticket_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL,
    date_issued DATE NOT NULL,
    amount_owed DECIMAL(6,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'unpaid',

    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
        ON DELETE CASCADE,
    
    CHECK (status IN ('unpaid','paid'))
);

CREATE TABLE parkingLots(
    parking_lot_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(200) NOT NULL
);

CREATE TABLE parkingSpots (
    parking_spot_id SERIAL PRIMARY KEY,
    parking_lot_id INT NOT NULL,
    parking_spot_number INT NOT NULL,
    occupied BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (parking_lot_id) REFERENCES parkingLots(parking_lot_id)
        ON DELETE CASCADE,

    UNIQUE(parking_lot_id, parking_spot_number)
);

CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL,
    parking_spot_id INT NOT NULL,
    start_timestamp TIMESTAMP NOT NULL,
    end_timestamp TIMESTAMP NOT NULL,
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
        ON DELETE CASCADE,
    
    FOREIGN KEY (parking_spot_id) REFERENCES parkingSpots(parking_spot_id)
        ON DELETE CASCADE,

    CHECK (end_timestamp > start_timestamp)

);

CREATE TABLE lotPermitTypes(
    lot_permit_type_id SERIAL PRIMARY KEY,
    permit_type_id INT NOT NULL,
    parking_lot_id INT NOT NULL,
    
    FOREIGN KEY (permit_type_id) REFERENCES permitTypes(permit_type_id)
        ON DELETE RESTRICT,

    FOREIGN KEY (parking_lot_id) REFERENCES parkingLots(parking_lot_id)
        ON DELETE RESTRICT
);

CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    parking_spot_id INT NOT NULL,
    sensor_type VARCHAR(50) NOT NULL,

    CHECK (sensor_type IN ('camera', 'motion'))
);

CREATE TABLE sensorEvents (
    sensor_event_id SERIAL PRIMARY KEY,
    sensor_id INT NOT NULL,
    vehicle_id INT,
    event_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    processed BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
        ON DELETE CASCADE,
    
    CHECK (event_type IN ('entry', 'exit', 'occupied', 'none'))

);

CREATE FUNCTION give_permit(
    user_id_gp INT,
    vehicle_id_gp INT,
    permit_type_id_gp INT,
    parking_lot_id_gp INT,
    date_issued_gp DATE,
    expiration_date_gp DATE
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS(
        SELECT 1 FROM vehicles
        WHERE vehicle_id = vehicle_id_gp
        AND user_id = user_id_gp
    ) THEN
        RAISE EXCEPTION 'User does not own vehicle or vehicle not found';
    END IF;

    IF date_issued_gp >= expiration_date_gp THEN
        RAISE EXCEPTION 'Invalid dates please make sure start date is lower than the end date';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM lotPermitTypes
        WHERE permit_type_id = permit_type_id_gp
        AND parking_lot_id = parking_lot_id_gp
    ) THEN
        RAISE EXCEPTION 'permit type is not valid or parking lot does not exist';
    END IF;

    IF EXISTS (
        SELECT 1 FROM permits
        WHERE vehicle_id = vehicle_id_gp
        AND (
            (date_issued BETWEEN date_issued_gp AND expiration_date_gp)
            OR
            (date_issued_gp BETWEEN date_issued AND expiration_date)
            OR
            (expiration_date_gp BETWEEN date_issued AND expiration_date)
        )
    )
    THEN
        RAISE EXCEPTION 'Permit already exists within the date range.';
    END IF;
    INSERT INTO permits(
        vehicle_id,
        permit_type_id,
        date_issued,
        expiration_date  
    )
    VALUES(
        vehicle_id_gp,
        permit_type_id_gp,
        date_issued_gp,
        expiration_date_gp
    );
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION update_spot()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE parkingSpots
    SET occupied = 
        CASE
            WHEN NEW.event_type = 'entry' THEN TRUE
            WHEN NEW.event_type = 'occupied' THEN TRUE
            WHEN NEW.event_type = 'exit' THEN FALSE
            ELSE FALSE
        END
    WHERE parking_spot_id = 
        (
            SELECT parking_spot_id
            FROM sensors
            WHERE sensor_id = NEW.sensor_id
        );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 CREATE TRIGGER watch_spot
 AFTER INSERT ON sensorEvents
 FOR EACH ROW
 EXECUTE FUNCTION update_spot();

-- add reservation
CREATE PROCEDURE give_tickets()
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO tickets(
        vehicle_id,
        date_issued,
        amount_owed,
        status
    )
    SELECT sEvents.vehicle_id,
        NOW(), 50.00, 'unpaid'
    FROM sensorEvents sEvents
    JOIN sensors s 
        ON sEvents.sensor_id = s.sensor_id
    JOIN parkingSpots pSpots 
        ON s.parking_spot_id = pSpots.parking_spot_id

    WHERE 
        pSpots.occupied = TRUE
        AND sEvents.vehicle_id IS NOT NULL
        AND sEvents.processed = FALSE

        AND NOT EXISTS (
            SELECT 1
            FROM permits p
            JOIN lotPermitTypes lpt
                on p.permit_type_id = lpt.permit_type_id
            WHERE p.vehicle_id = sEvents.vehicle_id
                AND lpt.parking_lot_id = pSpots.parking_lot_id
                AND CURRENT_DATE BETWEEN p.date_issued AND p.expiration_date
        )

        AND NOT EXISTS(
            SELECT 1
            FROM reservations r
            WHERE 
                r.vehicle_id = sEvents.vehicle_id
                AND r.parking_spot_id = pSpots.parking_spot_id
                AND CURRENT_TIMESTAMP BETWEEN r.start_timestamp AND r.end_timestamp
        )

        AND NOT EXISTS (
            SELECT 1
            FROM tickets t
            WHERE 
                t.vehicle_id = sEvents.vehicle_id
                AND DATE(t.date_issued) = CURRENT_DATE
        );
    UPDATE sensorEvents
    SET processed = TRUE
    WHERE processed = FALSE;
END;
$$;

CREATE VIEW CurrentActivePermits AS
SELECT
    p.permit_id,
    p.vehicle_id,
    p.permit_type_id,
    p.date_issued,
    p.expiration_date
FROM permits p
WHERE CURRENT_DATE BETWEEN p.date_issued AND p.expiration_date;

CREATE VIEW CurrentLotAvailability AS SELECT
    pLots.parking_lot_id,
    pLots.name AS parking_lot_name,
    COUNT(pSpots.parking_spot_id) AS all_spots,
    SUM(CASE WHEN pSpots.occupied = TRUE THEN 1 ELSE 0 END) AS occupied_spot_count,
    SUM(CASE WHEN pSpots.occupied = FALSE THEN 1 ELSE 0 END) AS
    available_spot_count
FROM parkingLots pLots
JOIN parkingSpots pSpots ON pLots.parking_lot_id = pSpots.parking_lot_id
GROUP BY pLots.parking_lot_id, pLots.name;
