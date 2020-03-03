-- create database
CREATE DATABASE testupgrade;
-- switch to database
USE testupgrade;
-- create testuser
CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'password';
-- assign privileges
GRANT ALL PRIVILEGES ON testupgrade.* TO 'testuser'@'localhost';
-- create versionTable
CREATE TABLE versionTable (version int);
-- insert record into versionTable
INSERT INTO versionTable VALUES (0);

