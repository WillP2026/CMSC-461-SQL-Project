# CMSC-461-SQL-Project
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
