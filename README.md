# ecs-mysql-upgrade
### Testing Overview
All test were run against the following Docker image;
https://hub.docker.com/layers/mysql/library/mysql/5.7/images/sha256-7cc32db144fe6a69f22fe68429d9cc278b9f2f2f8c9380d3ef811cadf693cbaf?context=explore

#### mysqlBootstrap.sql
Bootstrap script used for testing purposes.
Script needs to run as root mysql user against a mysql 5.7 database
#### Creates the below objects
| Object | Name | 
|------|-------------------------------------------|
| Database | testupgrade |
| User | testuser (and grants privileges) |
| Table | versionTable (inserts first record of 0) |
#### Example run
```
mysql --user=root --password=mysql --user=root -Dsys --password < mysqlBootstrap.sql
```
### Upgrade
#### upgradeMysql.sh
Shell script to upgrade the mysql database if there are sql scripts beyond the current version. If no scripts are available no upgrade will occur.
##### NOTE: It is assumed that the executing user has the mysql cli set in their PATH variable
#### Example execution
##### Usage output
```
gaz@LAPTOP2251:~/ecs-mysql-upgrade$ ./upgradeMysql.sh
usage: ./upgradeMysql.sh <script_directory> <db_username> <db_host> <db_name> <db_password>
```
#### Script execution against test database
```
./upgradeMysql.sh sql-scripts testuser localhost testupgrade password
```
##### Example output if upgrade scripts run
```
=================================================
current database version = 0
=================================================

=================================================
latest script version =  049
=================================================

=================================================
running database upgrade
running upgrade script 044createTable.sql
database newdb upgraded to version 044
output from version table
+------+
|   44 |
+------+
=================================================
running upgrade script 045.insert.sql
database newdb upgraded to version 045
output from version table
+------+
|   45 |
+------+
=================================================
running upgrade script 046insert.sql
database newdb upgraded to version 046
output from version table
+------+
|   46 |
+------+
=================================================
running upgrade script 048.insert.sql
database newdb upgraded to version 048
output from version table
+------+
|   48 |
+------+
=================================================
running upgrade script 049insert.sql
database newdb upgraded to version 049
output from version table
+------+
|   49 |
+------+
=================================================
```
##### Example output if database is at latest version
```
=================================================
current database version = 49
=================================================

=================================================
latest script version =  049
=================================================

=================================================
database is at the latest version
output from version table
+------+
| 49   |
+------+
=================================================
```



