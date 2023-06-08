# COL362 - Database management system - Assignment 1

We had to write 30 queries in sql and we had only 1 week time. So it was kind of speed run for all of us.

Instructions to set up postgresql on Linux machines:

sudo su - postgres </br>
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data </br>
/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start </br>
/usr/local/pgsql/bin/psql postgres </br>

</br>
\i /home/sreemanti/Desktop/COL362/data/jmhvhjhj.sql

COPY table_name FROM '/home/......csv'  DELIMITER ',' CSV HEADER;

check foreign key constraint for uploading csv files
