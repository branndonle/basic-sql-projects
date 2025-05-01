SELECT * FROM books;
SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

-- Project Tasks
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oat St'
WHERE member_id = 'C103'

SELECT * 
FROM members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121'
SELECT * 
FROM issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E101'

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_member_id, COUNT(*) AS books_issued
FROM issued_status
GROUP BY issued_member_id 
HAVING COUNT(*) > 1

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE books_issued_cnt AS 
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist JOIN books AS b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;



-- Addressing Specific Questions/Findings
-- Task 7. Retrieve All Books in a Specific Category:
SELECT book_title, category
FROM books
WHERE category = 'Horror'

-- Task 8: Find Total Rental Income by Category:
SELECT b.category, SUM(b.rental_price) AS total_rental_income
FROM issued_status as isstatus JOIN books as b ON isstatus.issued_book_isbn = b.isbn
GROUP BY category

-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name AS manager
FROM employee AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id JOIN employee AS e2 ON e2.emp_id = b.manager_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE book_rental_prices AS 
SELECT *
FROM books
WHERE rental_price >= 6.50

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * 
FROM issued_status as Istatus LEFT JOIN return_status as ret
ON ret.issued_id = Istatus.issued_id
WHERE ret.return_id IS NULL;

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.
SELECT member_id, member_name, book_title, issued_date, CURRENT_DATE - iStatus.issued_date AS DAYS_OVERDUE
FROM issued_status AS iStatus
JOIN members AS m ON iStatus.issued_member_id = m.member_id 
JOIN books as bk ON iStatus.issued_book_isbn = bk.isbn
LEFT JOIN return_status AS ret ON ret.issued_id = iStatus.issued_id
WHERE ret.return_id IS NULL AND ((CURRENT_DATE - iStatus.issued_date) > 30);

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
SELECT e.emp_name, e.branch_id, COUNT(iStatus.issued_id) AS num_books_issued
FROM employee AS e 
JOIN branch AS b ON e.branch_id = b.branch_id
JOIN issued_status AS iStatus ON e.emp_id = iStatus.issued_emp_id
GROUP BY e.emp_name, e.branch_id;



