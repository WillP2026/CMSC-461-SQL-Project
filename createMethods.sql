CREATE PROCEDURE pay_ticket(
    payment DECIMAL,
    t_plate VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
DECLARE 
    total_amount DECIMAL;
    t_vehicle_id INT;
BEGIN
    SELECT vehicle_id
    INTO t_vehicle_id
    FROM vehicles
    WHERE plate_number = t_plate;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Plate not found';
    END IF;

    SELECT COALESCE(SUM(amount_owed), 0)
    INTO total_amount
    FROM tickets
        WHERE vehicle_id = t_vehicle_id
            AND status = 'unpaid';
    IF total_amount = 0 THEN
        RAISE EXCEPTION 'Not unpaided tickets found';
    END IF;

    IF payment < total_amount THEN
        RAISE EXCEPTION 'Please insert more funds to pay for ticket. Amount owed: %', amount_owed;
    END IF;

    UPDATE tickets
    SET status = 'paid'
    WHERE vehicle_id = t_vehicle_id
        AND status = 'unpaid';
END;
$$;