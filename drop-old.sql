drop database if exists dahelp;
drop role if exists dhroot;

create database dahelp;

create user dhroot with PASSWORD 'dhroot';
GRANT ALL PRIVILEGES ON database dahelp TO dhroot;
