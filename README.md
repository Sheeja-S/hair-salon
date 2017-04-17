Hair Salon App

Description:

The program allows user to list out hair stylists and also to add clients to each stylist.


Relationship : one stylist, many clients

In PSQL:

Production Database: hair_salon

CREATE TABLE clients (id serial PRIMARY KEY, name varchar, stylist_id int);

CREATE TABLE stylists(id serial PRIMARY KEY, name varchar);

Development Database: hair_salon_test
