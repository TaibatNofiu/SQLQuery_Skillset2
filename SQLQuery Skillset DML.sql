USE DataBenders

-- NEW SKILLSETS ASSIGNMENT
CREATE DATABASE SQL_DML;

CREATE TABLE Department(
					Num_S INT PRIMARY KEY NOT NULL,
					Label VARCHAR(25) NOT NULL,
					Manager_Name VARCHAR (25) NOT NULL
);

CREATE TABLE Employee(
					Num_E INT PRIMARY KEY,
					Name VARCHAR (50) NOT NULL,
					Position VARCHAR (25) NOT NULL,
					Salary DECIMAL (10,2) NOT NULL,
					Department_Num_S INT FOREIGN KEY REFERENCES Department (Num_S)
);

CREATE TABLE Project (
					Num_P INT PRIMARY KEY,
					Title VARCHAR (50),
					Start_Date DATE,
					End_Date DATE,
					Department_Num_S INT FOREIGN KEY REFERENCES Department (Num_S)
);

CREATE TABLE Employee_Project (
							Employee_Num_E INT FOREIGN KEY REFERENCES Employee (Num_E),
							Project_Num_P INT FOREIGN KEY REFERENCES Project (Num_P),
							Role VARCHAR (50)
);

-- INSERT DATA INTO THE TABLES (DML)
INSERT INTO Department VALUES 
						(1, 'IT', 'Alice Johnson'),
						(2, 'HR', 'Bob Smith'),
						(3, 'Marketing', 'Clara Benneth')
;

INSERT INTO Employee VALUES
						(101, 'John Doe', 'Developer', 60000, 1),
						(102, 'Jane Smith', 'Analyst', 55000, 2),
						(103, 'Mike Brown', 'Designer', 50000, 3),
						(104, 'Sarah Johnson', 'Data Scientist', 70000, 1),
						(105, 'Emma Wilson', 'HR Specialist', 52000, 2);

INSERT INTO Project VALUES
						(201, 'Website Redesign', '2024-01-15', '2024-06-30', 1),
						(202, 'Employee Onboarding', '2024-03-01', '2024-09-01', 2),
						(203, 'Market Research', '2024-02-01', '2024-07-31', 3),
						(204, 'IT Infrastructure Set Up', '2024-04-01', '2024-12-31', 1)
;

INSERT INTO Employee_Project VALUES
						(101, 201, 'Frontend Developer'),
						(104, 201, 'Backend Developer'),
						(102, 202, 'Trainer'),
						(105, 202, 'Coordinator'),
						(103, 203, 'Research Lead'),
						(101, 204, 'Network Specialist')
;


-- UPDATE THE RECORD

UPDATE Employee_Project SET Role = 'Full Stack Developer' WHERE Employee_Num_E = 101

SELECT * FROM Employee_Project

-- DELETE RECORD FROM EMPLOYEE_PROJECT TABLE

DELETE FROM Employee_Project WHERE Employee_Num_E = 103;
DELETE FROM Employee WHERE Num_E = 103;

SELECT * FROM Employee