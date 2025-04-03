-- create database
CREATE DATABASE library_system_management;

-- select the database
USE library_system_management;

-- view the selected database
SELECT database();

-- creating tables into the database
-- create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
				(
					branch_id VARCHAR(10) PRIMARY KEY,
                    manager_id VARCHAR(10), -- FK
                    branch_address VARCHAR(55),
                    contact_no VARCHAR(10)
				);
ALTER TABLE branch
MODIFY COLUMN contact_no VARCHAR(20);

-- create employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
				(
					emp_id VARCHAR(10) PRIMARY KEY,
                    emp_name VARCHAR(25),
                    position VARCHAR(15),
                    salary INT,
                    branch_id VARCHAR(10)  -- FK
				);

-- create books table
DROP TABLE IF EXISTS books;
CREATE TABLE books
				(
					isbn VARCHAR(25) PRIMARY KEY,
                    book_title VARCHAR(100),
                    category VARCHAR(25),
                    rental_price FLOAT,
                    status VARCHAR(10),
                    author VARCHAR(30),
                    publisher VARCHAR(55)
				);
                
                
-- create members table
DROP TABLE IF EXISTS members;
CREATE TABLE members
				(
					member_id VARCHAR(10) PRIMARY KEY,
                    member_name VARCHAR(20),
                    member_address VARCHAR(25),
                    reg_date DATE
				);

-- create issued_status table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
				(
					issued_id VARCHAR(10) PRIMARY KEY,
                    issued_member_id VARCHAR(10),  -- FK
                    issued_book_name VARCHAR(75),
                    issued_date DATE,
                    issued_book_isbn  VARCHAR(25),  -- FK
                    issued_emp_id VARCHAR(10)  -- FK
				);

-- create return_status table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
				(
					return_id VARCHAR(10) PRIMARY KEY,
                    issued_id VARCHAR(10),  -- FK
                    return_book_name VARCHAR(75),
                    return_date DATE,
                    return_book_isbn  VARCHAR(25)  -- FK
				);

-- modifying foreign key constraints

ALTER TABLE branch
ADD CONSTRAINT fk_manager_id
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_member_id
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_book_isbn
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_book_isbn
FOREIGN KEY (return_book_isbn)
REFERENCES books(isbn);

