
import psycopg
conn = psycopg.connect(
  dbname="postgres",
  user="pgAdmin",
  password="pgAdmin",
  host="localhost",
  port="5040",
)

cursor = conn.cursor()

def print_rows():
  rows = cursor.fetchall()

  for row in rows:
    print(row)


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
        
def view_tickets():
    cursor.execute("""
    SELECT * FROM tickets
    """)
    print_rows()
  
def view_users():
    cursor.execute("""
    SELECT * FROM users
    """)   
    print_rows()
  
def main():
  while True:
    try:
        print("1. Give tickets")
        print("2. Add User")
        print("3. View tickets")
        print("4. View Users")
        print("5. Exit")

        choice = int(input("Please select a choice (1-5): "))

        match choice:
           case 1:
            give_tickets()
           case 2:
            add_user()
           case 3:
            view_tickets()
           case 4:
            view_users()
           case 5:
            break
           case _:
            print("Please type a valid number")

    except ValueError:
       print("Please type a valid number")
  

  


if __name__ == "__main__":
  main()

