BEGIN TRANSACTION;

COPY People FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/People.csv' WITH CSV HEADER DELIMITER AS ',';
COPY TeamsFranchises FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/TeamsFranchises.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Teams FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Teams.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Batting FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Batting.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Fielding FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Fielding.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Pitching FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Pitching.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AllstarFull FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/AllstarFull.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Appearances FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Appearances.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsManagers FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/AwardsManagers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsPlayers FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/AwardsPlayers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsShareManagers FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/AwardsShareManagers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY AwardsSharePlayers FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/AwardsSharePlayers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY HallOfFame FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/HallOfFame.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Managers FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Managers.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Salaries FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Salaries.csv' WITH CSV HEADER DELIMITER AS ',';
COPY Schools FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/Schools.csv' WITH CSV HEADER DELIMITER AS ',';
COPY CollegePlaying FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/CollegePlaying.csv' WITH CSV HEADER DELIMITER AS ',';
COPY SeriesPost FROM '/home/sreemanti/Desktop/COL362/A1_dataset/database/SeriesPost.csv' WITH CSV HEADER DELIMITER AS ',';

END TRANSACTION;

