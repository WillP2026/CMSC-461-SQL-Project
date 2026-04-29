import psycopg
from psycopg.rows import dict_row

conn = psycopg.connect(
  dbname="postgres",
  user="pgAdmin",
  password="pgAdmin",
  host="localhost",
  port="5040",
)

cursor = conn.cursor(row_factory=dict_row)

def rows():
  return cursor.fetchall()

def give_tickets():
    cursor.execute("""
    CALL give_tickets()
                   """)
    conn.commit()

def add_user():
    name = input("name: ")
    role = input("role (faculty, student,visutor,admin):" )
    email = input("email: ")

    if(role != 'faculty' or role != 'student' or role != 'visitor' or role != 'admin'):
      print("invalid role")
      return

    cursor.execute(f"""
        INSERT INTO users (name, role, email)
        VALUES
        ('{name}', '{role}', '{email}')
        """)
    conn.commit()

def get_user_total_ticket_amount(user: str):
    cursor.execute(f"""
        SELECT sum(t.amount_owed) AS total_cost
        FROM users u
        JOIN vehicles v ON u.user_id = v.user_id
        JOIN tickets t ON v.vehicle_id = t.vehicle_id
        WHERE u.name = '{user}'
        GROUP BY u.user_id
        ;
    """)
    return rows()
 
def delete_user_tickets(user: str):
    cursor.execute(f"""
        DELETE FROM tickets
        WHERE vehicle_id IN (
            SELECT v.vehicle_id    
            FROM vehicles v
            JOIN users u ON v.user_id = u.user_id
            WHERE u.name = '{user}'
        );
    """)

    conn.commit()


def view_user_tickets(user: str):
    cursor.execute(f"""
        SELECT v.plate_number, t.amount_owed, t.date_issued
        FROM tickets t
        JOIN vehicles v
            ON t.vehicle_id = v.vehicle_id
        LEFT JOIN users u
            on v.user_id = u.user_id
        WHERE u.name = '{user}';
    """)
    return rows()

def view_tickets():
    cursor.execute(f"""
        SELECT v.plate_number, t.amount_owed, t.date_issued
        FROM tickets t
        JOIN vehicles v
            ON t.vehicle_id = v.vehicle_id
    """)
    return rows()

def view_user_vehicles(user: str):
    cursor.execute(f"""
        SELECT plate_number, vehicle_year, model
        FROM vehicles v
        JOIN users u
            ON u.user_id = v.user_id
        WHERE u.name = '{user}';
    """)
    return rows()

def view_vehicles():
    cursor.execute(f"""
        SELECT plate_number, vehicle_year, model
        FROM vehicles v
    """)
    return rows()

def view_vehicles_in_wrong_spots():
    cursor.execute(f"""
        SELECT DISTINCT sEvents.vehicle_id,v.plate_number, pLots.parking_lot_id, pLots.name
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
    """)
    return rows()

def view_occupied_spots_count():
    cursor.execute(f"""
        SELECT pLots.parking_lot_id, 
        pLots.name, 
        COUNT(CASE WHEN pSpots.occupied = TRUE THEN 1 END) AS occupied_spot_count
        FROM parkingLots pLots
        LEFT JOIN parkingSpots pSpots
        ON pLots.parking_lot_id = pSpots.parking_lot_id
        GROUP BY pLots.parking_lot_id, pLots.name
        ORDER BY occupied_spot_count DESC;
    """)
    return rows()


  