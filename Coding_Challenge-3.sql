SHOW DATABASES;
CREATE DATABASE CarRentalSystem;
USE CarRentalSystem;

CREATE TABLE VEHICLE(vehicleID INT PRIMARY KEY, make VARCHAR(20), model VARCHAR(20),year INT,
dailyRate DECIMAL(4,2),status VARCHAR(15),passengerCapacity INT,engineCapacity INT);
DESC VEHICLE;

CREATE TABLE Customer(customerID INT PRIMARY KEY,firstName VARCHAR(30),lastName VARCHAR(30),email VARCHAR(50),
phoneNumber CHAR(15));
DESC CUSTOMER;

CREATE TABLE Lease(leaseID INT PRIMARY KEY,vehicleID INT,FOREIGN KEY (vehicleID) REFERENCES VEHICLE(vehicleID)
ON DELETE CASCADE, customerID INT,FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE,
startDate DATE, endDate DATE,leaseType VARCHAR(20));
DESC LEASE;

CREATE TABLE Payment(paymentID INT PRIMARY KEY,leaseID INT,FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) 
ON DELETE CASCADE,paymentDate DATE,amount FLOAT);
DESC payment;

INSERT INTO VEHICLE VALUES (1, 'Toyota', 'Camry', 2022, 50.00, 'Available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'Available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'Not Available', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'Available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'Available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'Not Available', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'Available', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'Available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'Not Available', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'Available', 4, 2500);
SELECT * FROM VEHICLE;

INSERT INTO Customer VALUES (1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555');
INSERT INTO Customer VALUES (2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567');
INSERT INTO Customer VALUES (3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234');
INSERT INTO Customer VALUES (4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890');
INSERT INTO Customer VALUES (5, 'David', 'Lee', 'david@example.com', '555-987-6543');
INSERT INTO Customer VALUES (6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678');
INSERT INTO Customer VALUES (7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432');
INSERT INTO Customer VALUES (8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098');
INSERT INTO Customer VALUES (9, 'William', 'Taylor', 'william@example.com', '555-321-6547');
INSERT INTO Customer VALUES (10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');
SELECT * FROM CUSTOMER;

INSERT INTO Lease VALUES (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');
SELECT * FROM Lease;

INSERT INTO Payment VALUES (1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-08', 70.00),
(7, 7, '2023-07-09', 80.00),
(8, 8, '2023-08-10', 90.00),
(9, 9, '2023-09-11', 110.00),
(10,10,'2023-10-12', 160.00);
SELECT * FROM Payment;
/*1*/
UPDATE VEHICLE SET dailyRate = 68 WHERE make = 'Mercedes';
/*2*/
DELETE FROM Customer WHERE customerID = 3;
SELECT * FROM CUSTOMER;
/*3*/
USE CarRentalSystem;
ALTER TABLE Payment
CHANGE COLUMN paymentDate transactionDate DATE;
select * from payment;

/*4*/
SELECT *FROM Customer WHERE email = 'janesmith@example.com';

/*5*/
SELECT * FROM Customer as c JOIN Lease as l ON l.customerID = c.customerID WHERE c.customerID = 10;
/*6*/
SELECT Payment.* FROM Payment, Lease, Customer WHERE Payment.leaseID = Lease.leaseID
AND Lease.customerID = Customer.customerID AND Customer.phoneNumber = '555-555-5555';
/*7*/
SELECT AVG(dailyRate) AS AverageDailyRate FROM VEHICLE;
/*8*/
SELECT * FROM VEHICLE WHERE dailyRate = (SELECT MAX(dailyRate) FROM VEHICLE);
/*9*/
SELECT * FROM Vehicle WHERE vehicleID IN (SELECT vehicleID FROM Lease WHERE customerID = 1);
/*10*/
SELECT TOP  .*, v.make, v.model FROM VEHICLE v, Lease l WHERE l.vehicleID = v.vehicleID 
ORDER BY l.startDate DESC;
/*11*/
SELECT * FROM Payment WHERE YEAR(paymentDate) = 2023;
/*12*/
SELECT c.customerID, c.firstName, c.lastName
FROM Customer c
LEFT JOIN Payment p ON c.customerID = p.leaseID
WHERE p.paymentID IS NULL;
/*13*/
SELECT v.vehicleID, v.make, v.model, v.year,SUM(p.amount) AS totalPayments
FROM VEHICLE v
JOIN LEASE l ON v.vehicleID = l.vehicleID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.year;

/*14*/
SELECT c.customerID, c.firstName, c.lastName, 
       COALESCE(SUM(p.amount), 0) AS totalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

/*15*/
SELECT l.leaseID, v.vehicleID, v.make, v.model, v.year
FROM Lease l
JOIN VEHICLE v ON l.vehicleID = v.vehicleID;

/*16*/
SELECT l.leaseID, c.customerID, c.firstName, c.lastName,
       v.vehicleID, v.make, v.model, v.year,
       l.startDate, l.endDate, l.leaseType
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN VEHICLE v ON l.vehicleID = v.vehicleID
WHERE l.endDate >= CURDATE(); 

/*17*/
SELECT c.customerID, c.firstName, c.lastName,
       COALESCE(SUM(p.amount), 0) AS totalSpent
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName
ORDER BY totalSpent DESC
LIMIT 1;

/*18*/
SELECT v.vehicleID, v.make, v.model, v.year,
       COALESCE(l.leaseID, 'Not leased') AS leaseID,
       COALESCE(l.startDate, 'N/A') AS startDate,
       COALESCE(l.endDate, 'N/A') AS endDate,
       COALESCE(l.leaseType, 'N/A') AS leaseType
FROM VEHICLE v
LEFT JOIN (
    SELECT l.vehicleID, l.leaseID, l.startDate, l.endDate, l.leaseType
    FROM LEASE l
    JOIN (SELECT vehicleID, MAX(startDate) AS maxStartDate
        FROM LEASE
        WHERE endDate >= CURDATE() OR endDate IS NULL
        GROUP BY vehicleID) latestLease ON l.vehicleID = latestLease.vehicleID AND l.startDate = latestLease.maxStartDate) l ON v.vehicleID = l.vehicleID;









