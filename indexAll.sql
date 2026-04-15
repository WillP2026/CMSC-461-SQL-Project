

CREATE INDEX vehicles_by_user
ON vehicles(user_id);

CREATE INDEX tickets_by_vehicle
ON tickets(vehicle_id, date_issued);

CREATE INDEX permit_types_lot
ON parkingSpots(parking_lot_id, occupied);

CREATE INDEX lot_permit_types_vehicle
ON lotPermitTypes(permit_type_id, parking_lot_id);

CREATE INDEX permits_vehicle
ON permits(vehicle_id, permit_type_id);
