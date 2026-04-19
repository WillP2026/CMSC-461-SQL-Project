import argparse
import subprocess

def execute_sql_file(file_name: str,
  dbname: str,
  username: str,
  ):
     subprocess.run([
          'docker', 
          'compose', 
          'exec', 
          'postgres', 
          'psql',
          '-U', 
          username, 
          '-d', 
          dbname, 
          '-f', 
          f'./{file_name}'
        ])

def main():
  parser = argparse.ArgumentParser(description="DB Connection parameters")
  parser.add_argument('-d', '--dbname', type=str, required=True)
  parser.add_argument('-u', '--username', type=str, required=True)
  parser.add_argument('-fc', '--fileChoice', type=int, required=True,
         choices = [0,1,2,3,4,5,6,7,8],
         help = "Choices are --")
  args = parser.parse_args()

  dbname = args.dbname
  username = args.username
  fc = args.fileChoice

  try:
    print(f"Connected to Postgres DB={dbname}, username={username}")

    match(fc):
      case 1:
        execute_sql_file(   
          'createDDL.sql',   
          dbname,
          username,
        )
      case 2:
        execute_sql_file(  
          'createMethods.sql',    
          dbname,
          username,
        )
      case 3:
        execute_sql_file(  
          'loadAll.sql',        
          dbname,
          username,
        )
      case 4:
        execute_sql_file(    
          'indexAll.sql',
          dbname,
          username,
        )
      case 5:
        execute_sql_file(  
          'queryAll.sql',        
          dbname,
          username,
        )
      case 6: 
        execute_sql_file(
          'dropMethods.sql',
          dbname,
          username,
        )
      case 7: 
        execute_sql_file(
          'dropDDL.sql',
          dbname,
          username,
        )
      case _:
        print("Mode not found")

  except Exception as e:
    print("Error:", e)


if __name__ == "__main__":
  main()

