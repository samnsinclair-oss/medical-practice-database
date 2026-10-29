# Medical Practice Database

A relational MySQL/MariaDB database designed to support the daily operations of a medical practice, including patient records, doctor schedules, appointments, diagnoses, prescriptions, insurance, billing, and payments.

## Project Overview

This project demonstrates relational database design and SQL development using a realistic medical-practice scenario. The database contains 15 connected tables with primary keys, foreign keys, one-to-many relationships, and a many-to-many relationship between doctors and appointments.

The project was completed collaboratively as part of my Data Science and Machine Learning studies at RRC Polytech. I contributed throughout the project, including database design, data preparation, query development, testing, and documentation.

## Technologies

- MySQL / MariaDB
- SQL
- Relational database design
- Visual Studio Code
- Git and GitHub

## Database Features

- Patient and doctor management
- Doctor schedules and appointment history
- Diagnoses and diagnostic codes
- Medication and prescription tracking
- Insurance policies and providers
- Billing records and payment tracking
- Data validation through primary and foreign keys
- Sample data for testing and analysis

## SQL Concepts Demonstrated

- Table creation and database constraints
- Primary and foreign keys
- One-to-many and many-to-many relationships
- `INNER JOIN` and `LEFT JOIN`
- Aggregate functions including `COUNT`, `SUM`, and `AVG`
- `GROUP BY`, `HAVING`, and sorting
- Common table expressions (CTEs)
- Window functions using `ROW_NUMBER()`
- Date and time calculations
- Null handling with `COALESCE`
- Business-focused reporting queries

## Example Business Questions

The SQL queries answer questions such as:

- Which doctors worked outside their scheduled hours?
- Which appointment had the highest total cost?
- Which patients have outstanding balances of at least $500?
- Which medications are prescribed most often for a particular diagnosis?
- What was each patient’s first diagnosis, and which doctor provided it?
- Which appointment type had the highest average duration?
- Which day had the most completed appointments?

## How to Run the Project

1. Download or clone this repository.
2. Open `medical_practice_database.sql` in MySQL Workbench, MariaDB, or another compatible SQL client.
3. Run the script from top to bottom.
4. The script will create the database, tables, relationships, and sample records.
5. Run the business-analysis queries near the end of the file to explore the data.

## Repository Contents

- `medical_practice_database.sql` – database schema, sample data, and analysis queries
- `README.md` – project documentation

## Author

Sam Sinclair  
Data Science and Machine Learning student  
Red River College Polytechnic
