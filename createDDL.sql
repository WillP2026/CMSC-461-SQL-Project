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

CREATE TABLE permits (
    permit_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    permit_type_id INT NOT NULL,
    date_issued DATE NOT NULL,
    expiration_date DATE NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    
    FOREIGN KEY (permit_type_id) 
        REFERENCES permitTypes(permit_type_id)
            ON DELETE RESTRICT,

    CHECK (expiration_date > date_issued)
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

    FOREIGN KEY (parking_lot_id) REFERENCES parkingLots(parking_lot_id)
        ON DELETE CASCADE,

    UNIQUE(parking_lot_id, parking_spot_number)
);

CREATE TABLE reservation (
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

CREATE TABLE lotPermitType(
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
    event_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,

    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
        ON DELETE CASCADE,
    
    CHECK (event_type IN ('entry', 'exit', 'occupied', 'none'))

);