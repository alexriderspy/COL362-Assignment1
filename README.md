# COL362

sudo su - postgres </br>
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data </br>
/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start </br>
/usr/local/pgsql/bin/psql postgres </br>

</br>
\i /home/sreemanti/Desktop/COL362/data/jmhvhjhj.sql

COPY table_name FROM '/home/......csv'  DELIMITER ',' CSV HEADER;
