show databases;
create database CareerHub;
show databases;
use careerhub;

create table companies(CompanyID int Primary key,CompanyName varchar(20),Location varchar(20));
desc companies;

create table Jobs(JobID int Primary Key,companyID int,Jobtitle varchar(20),JobDescription text,
JobLocation varchar(20), Salary decimal(10,2), foreign key(companyID) references companies(companyID),
jobtype varchar(20), PostedDate datetime);
desc jobs;

create table Applicants(ApplicantID int primary key,FirstName varchar(20),LastName varchar(20),
email varchar(20),phone varchar(20), resume text);
desc applicants;

create table applications(applicatoinID int primary key,JobID int,ApplicantID int,ApplicationDate datetime,
Coverletter text,foreign key(jobID) references jobs(jobID), foreign key(applicantID) references 
Applicants(applicantID));
desc applications;

insert into companies values(1,"Hexaware","Chennai"),(2,"Sony","Okinawa"),(3,"Google","California"),
(4,"Amazon","Chennai"),(5,"Microsoft","hyderabad");
select * from companies;

INSERT INTO jobs VALUES
(1, 1, 'Software Engineer', 'Description for Software Engineer position', 'Chennai', 80000.00, 'Full-time', '2023-01-10 08:00:00'),
(2, 1, 'Data Analyst', 'Description for Data Analyst position', 'Chennai', 65000.00, 'Full-time', '2023-01-15 09:30:00'),
(3, 2, 'Marketing Manager', 'Description for Marketing Manager position', 'Okinawa', 75000.00, 'Full-time', '2023-01-20 10:45:00'),
(4, 3, 'Sales Representative', 'Description for Sales Representative position', 'California', 70000.00, 'Full-time', '2023-01-25 11:15:00'),
(5, 4, 'Accountant', 'Description for Accountant position', 'Chennai', 60000.00, 'Full-time', '2023-02-01 12:00:00'),
(6, 5, 'HR Coordinator', 'Description for HR Coordinator position', 'Hyderabad', 55000.00, 'Full-time', '2023-02-05 13:30:00'),
(7, 1, 'Graphic Designer', 'Description for Graphic Designer position', 'Chennai', 65000.00, 'Full-time', '2023-02-10 14:45:00'),
(8, 2, 'Customer Service Rep', 'Description for CSR position', 'Okinawa', 50000.00, 'Full-time', '2023-02-15 15:00:00'),
(9, 3, 'Project Manager', 'Description for Project Manager position', 'California', 90000.00, 'Full-time', '2023-02-20 16:00:00'),
(10, 4, 'Data Scientist', 'Description for Data Scientist position', 'Chennai', 85000.00, 'Full-time', '2023-02-25 17:30:00');
select * from jobs;

INSERT INTO applicants VALUES
(1, 'John', 'Doe', 'john@example.com', '123-456-7890', 'Resume for John Doe'),
(2, 'Jane', 'Smith', 'jane@example.com', '987-654-3210', 'Resume for Jane Smith'),
(3, 'Alice', 'Johnson', 'alice@example.com', '111-222-3333', 'Resume for Alice Johnson'),
(4, 'Michael', 'Brown', 'michael@example.com', '444-555-6666', 'Resume for Michael Brown'),
(5, 'Emily', 'Davis', 'emily@example.com', '777-888-9999', 'Resume for Emily Davis'),
(6, 'David', 'Garcia', 'david@example.com', '666-333-2222', 'Resume for David Garcia'),
(7, 'Olivia', 'Martinez', 'olivia@example.com', '999-000-1111', 'Resume for Olivia Martinez'),
(8, 'Sophia', 'Lopez', 'sophia@example.com', '222-777-4444', 'Resume for Sophia Lopez'),
(9, 'Daniel', 'Gonzalez', 'daniel@example.com', '888-111-5555', 'Resume for Daniel Gonzalez'),
(10, 'Isabella', 'Rodriguez', 'isabella@example.com', '555-999-8888', 'Resume for Isabella Rodriguez');
select * from applicants;

INSERT INTO applications VALUES
(1, 1, 1, '2023-01-11 13:00:00', 'Cover letter for Job 1 by John Doe'),
(2, 2, 2, '2023-01-16 14:30:00', 'Cover letter for Job 2 by Jane Smith'),
(3, 3, 3, '2023-01-21 15:45:00', 'Cover letter for Job 3 by Alice Johnson'),
(4, 4, 1, '2023-01-26 16:15:00', 'Cover letter for Job 4 by John Doe'),
(5, 5, 4, '2023-02-02 17:00:00', 'Cover letter for Job 5 by Michael Brown'),
(6, 6, 5, '2023-02-06 18:30:00', 'Cover letter for Job 6 by Emily Davis'),
(7, 7, 6, '2023-02-11 19:45:00', 'Cover letter for Job 7 by David Garcia'),
(8, 8, 7, '2023-02-16 20:00:00', 'Cover letter for Job 8 by Olivia Martinez'),
(9, 9, 8, '2023-02-21 21:00:00', 'Cover letter for Job 9 by Sophia Lopez'),
(10, 10, 9, '2023-02-26 22:30:00', 'Cover letter for Job 10 by Daniel Gonzalez');
select * from applicants;


/*5*/
SELECT j.JobID, j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM jobs j
LEFT JOIN applications a ON j.JobID = a.JobID
GROUP BY j.JobID, j.JobTitle
ORDER BY j.JobID;

/*6*/
select * from jobs where (salary between 60000 and 80000);

/* 7 */
SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM applications a
JOIN jobs j ON a.JobID = j.JobID
JOIN companies c ON j.companyID = c.CompanyID
WHERE a.ApplicantID = 6;

/*8*/
SELECT AVG(Salary) AS AverageSalary
FROM jobs;

/*9*/
SELECT CompanyName, COUNT(*) AS JobListingsCount
FROM jobs j
JOIN companies c ON j.companyID = c.CompanyID
GROUP BY c.CompanyID, c.CompanyName
HAVING COUNT(*) = (
    SELECT MAX(JobCount)
    FROM (
        SELECT COUNT(*) AS JobCount
        FROM jobs
        GROUP BY companyID
    ) AS Counts);


/*10*/
SELECT DISTINCT a.FirstName, a.LastName
FROM applicants a
JOIN applications app ON a.ApplicantID = app.ApplicantID
JOIN jobs j ON app.JobID = j.JobID
JOIN companies c ON j.companyID = c.CompanyID
JOIN applicationDate e ON a.ApplicantID = e.ApplicantID
WHERE c.Location = "Chennai"
AND (DATEDIFF(CURDATE(), e.StartDate) / 365) >= 3;


/*11*/
SELECT DISTINCT JobTitle
FROM jobs
WHERE Salary BETWEEN 60000 AND 80000;

/*12*/
SELECT * FROM jobs WHERE JobID NOT IN (
    SELECT DISTINCT JobID
    FROM applications);


/*13*/
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM applicants a
JOIN applications app ON a.ApplicantID = app.ApplicantID
JOIN jobs j ON app.JobID = j.JobID
JOIN companies c ON j.companyID = c.CompanyID;

/*14*/
SELECT c.CompanyName, COUNT(j.JobID) AS JobsPosted
FROM companies c
LEFT JOIN jobs j ON c.CompanyID = j.companyID
GROUP BY c.CompanyName;

/*15*/
SELECT a.FirstName, a.LastName, COALESCE(c.CompanyName, 'Not Applied') AS CompanyName, COALESCE(j.JobTitle, 'Not Applied') AS JobTitle
FROM applicants a
LEFT JOIN applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN jobs j ON app.JobID = j.JobID
LEFT JOIN companies c ON j.companyID = c.CompanyID;

/*16*/
SELECT DISTINCT c.CompanyName
FROM companies c
JOIN jobs j ON c.CompanyID = j.companyID
WHERE j.Salary > (
    SELECT AVG(Salary)
    FROM jobs);
    
/*17*/
SELECT CONCAT(j.FirstName, ' ', j.LastName) AS FullName, j.jobLocation AS CityState
FROM jobs j;
    
/*18*/
SELECT * FROM jobs
WHERE JobTitle LIKE '%developer%' OR JobTitle LIKE '%engineer%';

/*19*/
SELECT a.FirstName, a.LastName, COALESCE(c.CompanyName, 'No Job Applied') AS CompanyName, COALESCE(j.JobTitle, 'No Job Applied') AS JobTitle
FROM applicants a
LEFT JOIN applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN jobs j ON app.JobID = j.JobID
LEFT JOIN companies c ON j.companyID = c.CompanyID;

/*20*/
SELECT a.FirstName, a.LastName, c.CompanyName
FROM applicants a
JOIN experience e ON a.ApplicantID = e.ApplicantID
JOIN companies c ON e.Location = c.Location
WHERE e.StartDate <= DATE_SUB(NOW(), INTERVAL 2 YEAR) 
AND c.Location = 'Chennai';












