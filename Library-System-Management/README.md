# Library Management System using MYSQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_system_management`

This project demonstrates the implementation of a Library Management System using MYSQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_system_management`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
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

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books VALUES ("978-1-60129-456-2", "To Kill a Mockingbird", "Classic", 6.00, "yes", "Harper Lee", "J.B. Lippincott & Co.");
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = "125 Main St"
WHERE member_id = "C101";
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
where issued_emp_id = 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT issued_emp_id, COUNT(*) AS issued_book_count
FROM issued_status
GROUP BY issued_emp_id
HAVING issued_book_count > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_count
AS
SELECT 
	b.isbn AS isbn,
    b. book_title AS book_name,
    COUNT(issued_id) AS book_issue_count
FROM books b 
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY isbn, book_name;
SELECT * FROM book_issued_count;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = "Children";
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
    b.category,
    SUM(b.rental_price) AS total_rental_income,
    COUNT(*) AS cnt
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;
```

9. **List Members Who Registered in the Last 1 year**:
```sql
SELECT * FROM members
WHERE reg_date >= current_date() - INTERVAL 1 year;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```SELECT 
	e1.*,
    	b.manager_id,
    	e2.emp_name AS manager_name,
    	b.branch_address
FROM employees e1
JOIN
branch b
ON e1.branch_id = b.branch_id
JOIN
employees e2
ON b.manager_id = e2.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
	i.issued_book_isbn,
    	i.issued_book_name
FROM issued_status i
LEFT JOIN
return_status r 
ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
	m.member_id,
    m.member_name,
    b.book_title,
    ist.issued_date,
    curdate() as currentdate,
    datediff(curdate(),ist.issued_date) AS days_overdue
FROM members m
JOIN 
issued_status ist
ON m.member_id = ist.issued_member_id
JOIN 
books b
ON ist.issued_book_isbn = b.isbn
left JOIN
return_status rs
ON ist.issued_id = rs.issued_id
WHERE 
	rs.return_date IS NULL
    AND
    datediff(curdate(),ist.issued_date) > 30
;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

DELIMITER $$  

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10), 
    IN p_issued_id VARCHAR(10), 
    IN p_book_quality VARCHAR(10)
)
BEGIN  
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert into return_status table
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    -- Fetch the book details associated with the issued_id
    SELECT issued_book_isbn, issued_book_name 
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update the books table to mark the book as returned
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Display a thank you message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END $$  

DELIMITER ;


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
-- branch >> employees >> issued_status >> return_status >> book
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM books;

CREATE TABLE branch_reports AS
SELECT 
	b.branch_id,
    COUNT(ist.issued_id) AS no_books_issued,
	COUNT(rs.return_id) AS no_books_returned,
	SUM(bk.rental_price) AS total_revenue
FROM branch b
JOIN employees e
ON b.branch_id = e.branch_id
JOIN issued_status ist
ON e.emp_id = ist.issued_emp_id
LEFT JOIN return_status rs
ON ist.issued_id = rs.issued_id
JOIN books bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id;

SELECT * FROM branch_reports;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE 
	member_id IN 
	(
	SELECT DISTINCT issued_member_id FROM issued_status
	WHERE issued_date >= (CURRENT_DATE - INTERVAL 2 month)
	);

SELECT * FROM active_members;
```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
-- employees >> branch >> issued_status


SELECT 
    e.emp_name,
    COUNT(ist.issued_id) AS books_processed,
    b.*
FROM branch b
JOIN employees e
ON b.branch_id = e.branch_id
JOIN issued_status ist
ON e.emp_id = ist.issued_emp_id
GROUP BY 
    e.emp_name,
    b.branch_id
ORDER BY books_processed DESC LIMIT 3;
```   


**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

DELIMITER $$  

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10), 
    IN p_issued_member_id VARCHAR(30), 
    IN p_issued_book_isbn VARCHAR(30), 
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN  
    DECLARE v_status VARCHAR(10);

    -- Check if the book is available
    SELECT status INTO v_status FROM books WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        -- Insert into issued_status table
        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        -- Update the books table to mark the book as issued
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Display a success message
        SELECT CONCAT('Book records added successfully for book ISBN: ', p_issued_book_isbn) AS message;

    ELSE
        -- Display an unavailable book message
        SELECT CONCAT('Sorry, the book you requested is unavailable. ISBN: ', p_issued_book_isbn) AS message;
    END IF;
END $$  

DELIMITER ;

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8';
```


## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone https://github.com/najirh/Library-System-Management---P2.git
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `analysis_queries.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback feel free to get in touch!

LinkedIn: Connect with me professionally
Email: sivakumar.sathaiyah@gmail.com

Thank you for your support, and I look forward to connecting with you!