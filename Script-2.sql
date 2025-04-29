CREATE TABLE Employees (
    empid INT PRIMARY KEY,
    lastname VARCHAR(20),
    firstname VARCHAR(10),
    title VARCHAR(30),
    titleofcourtesy VARCHAR(25),
    birthdate DATE,
    mgrid INT,
    CONSTRAINT CHK_Birthdate CHECK (birthdate <= (CURRENT_DATE - INTERVAL '21 years'))
);


ALTER TABLE Employees
ADD COLUMN address VARCHAR(100) NOT NULL,
ADD COLUMN salary DECIMAL(10,2),
ADD CONSTRAINT fk_mgrid_empid FOREIGN KEY (mgrid) REFERENCES public.Employees(empid);


select firstname from Employees;

SELECT *
FROM Employees
WHERE lastname ~* 'c.*c';



