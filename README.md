# CMSC-461-SQL-Project

<h3>About</h3>
The objective of this project is to create a database using Postgres SQL. The purpose of the database is to be a used as a parking management system.

<h3> How To Run Project</h3>
<ul>
<li>
Follow the official Docker <a href="https://docs.docker.com/engine/">documentation</a> to run the docker engine
</li>
<li>
Within the project directory run the following command
<br> - docker compose up
</li>
<l1>
To remove containers and volumes run
<br> - docker compose down -v
</li>
<li>
Postgres will now be ran on port 5040 and pgAdmin is hosted on 
<a href="http://localhost:5050">http://localhost:5050</a>
<br>
If these ports don't work change them within the docker-compose.yml file
</li>
</ul>

<h3>Connect Database to pgAdmin</h3>
<ul>
<li>
Login into pgAdmin with the following credentials:
<br>
Username: pgAdmin@pgAdmin.pgAdmin
Password: pgAdmin
</li>
<li>
Within Object Explorer right click "servers" and hover "Register" then select "Server..."
</li>
<li>
In the general tab the name should be "db"
</li>
<li>
Select the connection tab and fill the information with the following information
<br>
<br>

Host name/address - postgres
<br>
Port - 5432
<br>
Username - pgAdmin
<br>
Password - pgAdmin
</li>
</ul>
<h3>Test Data Base</h3>
<ul>
<li>
    Using command line and postgres directly (example)<br>
    - "docker compose exec postgres psql -U pgAdmin -d postgres -f ./smoke_test.sql"
</li>
<l1>
Check pgAdmin if the db has changed within the db schema and tables section.
</li>
</ul>

<h3>Running sql files and sql through command line</h3>
Run file - docker compose exec postgres psql -U pgAdmin -d postgres -f ./(file_name)

Run SQL - docker compose exec postgres psql -U pgAdmin -d postgres

<h3>Scripts to Run</h3>
<div>
useDB.py (Run off of container within system)

Make sure to have python installed. No external libraries should be needed.
ARGS
-d (database name)
-u (username)
-fc (file choice)

To test DB run
python3 useDB.py -d postgres -u pgAdmin  -fc 0 (smoke_test.sql)

Executable commands in order (without parentheses)
<ul>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 1 (createDDL.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 2 (createMethods.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 3 (loadAll.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 4 (indexAll.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 5 (queryAll.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 6 (dropMethods.sql)</li>
<li>python3 useDB.py -d postgres -u pgAdmin  -fc 7 (dropDDL.sql)</li>
</ul>
</div>

Before running any inserts or deletes I recommend calling createDDL.sql and loadAll.sql.

actions.py
requires the python library psycopg

To adjust parameters change them within the file.

This is suppose to replicate a short view of what an admin should see when they work alongside this database.

CMD - python3 actions.py


<h3>Running GUI</h3>
create a Virtual environment

python -m venv .venv 
<br>
<br>
Depending on OS use the following command<br>
(mac or linux) - source .venv/bin/activate
(windows) - .venv\Scripts\activate

Then download the requirements after entering your venv

pip install -r requirements.txt

Before starting the program make sure to start the docker server and load your data using createDDL.sql and loadAll.sql.

To start the GUI run - 
python gui.py

Here are the list of availible users by username and password

             'John Doe': 'john123',
             'Ben Doe': 'ben123',
             'May Doe': 'may123',
            'Peter Doe': 'peter123',
            'Frank Doe': 'frank123',
            'Owen Doe': 'owen123',
            'Nate Doe': 'nate123',
            'Josh Doe': 'josh123',
            'Emily Doe': 'emily123',
            'Tish Doe': 'tish123'