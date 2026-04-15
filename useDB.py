import psycopg
import argparse

def print_rows(cur):
  columns_headers = [des[0] for des in cur.description]
  print(columns_headers)

  rows = cur.fetchall()

  for row in rows:
    print(row)

  print('\n')


def give_tickets(cur,conn):
  print("tickets before calling give_tickets()")
  cur.execute("SELECT * FROM tickets;")
  print_rows(cur)
  cur.execute("CALL give_tickets();")
  conn.commit()

  print("tickets after calling give_tickets()")
  cur.execute("SELECT * FROM tickets;")
  print_rows(cur)

  conn.commit()


def main():
  parser = argparse.ArgumentParser(description="DB Connection parameters")
  parser.add_argument('-d', '--dbname', type=str, required=True)
  parser.add_argument('-p', '--port', type=int, default=5432)
  parser.add_argument('-s', '--hostname', type=str, default="localhost")
  parser.add_argument('-u', '--username', type=str, required=True)
  parser.add_argument('-P', '--password', type=str, default="pgAdmin")
  parser.add_argument('-m', '--mode', type=int, required=True,
         choices = [1],
         help = "1-Give tickets (There is only one choice for now)")
  args = parser.parse_args()

  dbname = args.dbname
  hostname = args.hostname
  port = args.port
  username = args.username
  password = args.password
  mode = args.mode


  if len(password) == 0:
    password = username

  try:
    conn = psycopg.connect(
      dbname=dbname,
      user=username,
      password=password,
      host=hostname,
      port=port,
      connect_timeout=3

    )
    print(mode)
    print(f"Connected to Postgres DB={dbname}, username={username}")
    cursor = conn.cursor()

    if(mode == 1):
      give_tickets(cursor, conn)

    

  except Exception as e:
    print("Error:", e)

  finally:
    cursor.close()
    conn.close()

if __name__ == "__main__":
  main()

