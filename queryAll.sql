-- I'm going to comment what each SQL query does.

-- List vehicles and their owners
SELECT v.vehicle_id, v.plate_number, u.user_id, u.name
FROM vehicles v
JOIN users u ON v.user_id = u.user_id;

-- Lists Users with no vehicles
SELECT v.vehicle_id, v.plate_number
FROM vehicles v
WHERE v.vehicle_id NOT IN (
    SELECT vehicle_id FROM tickets
);

-- List vehicles within parking lots
SELECT DISTINCT sEvents.vehicle_id
FROM sensorEvents sEvents
WHERE sEvents.event_type IN ('entry', 'occupied') 
AND sEvents.vehicle_id NOT IN (
    SELECT vehicle_id
    FROM sensorEvents
    WHERE event_type in ('exit', 'none')
);

-- List vehicles with tickets
SELECT vehicle_id, COUNT(*) AS ticket_count
FROM tickets
GROUP BY vehicle_id
HAVING COUNT(*) > 0;

-- List users with active permits
SELECT DISTINCT u.user_id, u.name
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM vehicles v
    JOIN CurrentActivePermits caPermits ON v.vehicle_id = caPermits.vehicle_id
    WHERE v.user_id = u.user_id
);


-- List vehicles in the wrong lot
EXPLAIN ANALYZE
SELECT DISTINCT sEvents.vehicle_id,v.plate_number, pLots.parking_lot_id
FROM sensorEvents sEvents
JOIN sensors s ON sEvents.sensor_id = s.sensor_id
JOIN parkingSpots pSpots ON s.parking_spot_id = pSpots.parking_spot_id
JOIN parkingLots pLots ON pSpots.parking_lot_id = pLots.parking_lot_id
JOIN vehicles v ON sEvents.vehicle_id = v.vehicle_id
WHERE pSpots.occupied = TRUE
AND NOT EXISTS(
    SELECT 1 FROM permits p
    JOIN lotPermitTypes lpTypes
        ON p.permit_type_id = lpTypes.permit_type_id
    WHERE p.vehicle_id = v.vehicle_id
        AND lpTypes.parking_lot_id = pLots.parking_lot_id
        AND CURRENT_DATE BETWEEN p.date_issued AND p.expiration_date
);

-- Lists tickets per day
SELECT DATE(date_issued), COUNT(*) AS ticket_count
FROM tickets GROUP BY date_issued
ORDER BY date_issued;

-- Lists spot frequency
SELECT s.parking_spot_id, COUNT(sEvents.event_type) AS spot_frequency
FROM sensors s
JOIN sensorEvents sEvents ON s.sensor_id = sEvents.sensor_id
GROUP BY s.parking_spot_id
ORDER BY spot_frequency DESC;

-- Lists occupied spots within parking lots by order
EXPLAIN ANALYZE
SELECT pLots.parking_lot_id, 
pLots.name, 
COUNT(CASE WHEN pSpots.occupied = TRUE THEN 1 END) AS occupied_spot_count
FROM parkingLots pLots
LEFT JOIN parkingSpots pSpots 
    ON pLots.parking_lot_id = pSpots.parking_lot_id
GROUP BY pLots.parking_lot_id, pLots.name
ORDER BY occupied_spot_count DESC;

-- Lists users with the greatest amount of tickets
EXPLAIN ANALYZE
SELECT u.user_id, u.name, COUNT(t.ticket_id) AS ticket_count
FROM users u
JOIN vehicles v ON u.user_id = v.user_id
JOIN tickets t ON v.vehicle_id = t.vehicle_id
GROUP BY u.user_id, u.name
HAVING COUNT(t.ticket_id) = (
    SELECT MAX(ticket_count)
    FROM (
        SELECT COUNT(*) AS ticket_count
        FROM tickets
        GROUP BY vehicle_id
    ) sQuery
);