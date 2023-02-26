# DB creation for an existing website

The objective of this project is to develop a prototype database for an existing website and demonstrate its functionality. 

The project comprises several stages:

**Analysis:** Conducting a comprehensive analysis of the website to comprehend the business concept and the structure of the underlying database.

**Entity Relationship Diagram (ERD):** Creating a diagram of the entities within the database, including their attributes and relationships.

**Database Implementation:** Establishing the database by employing SQL SERVER and loading test data from an Excel file.

**Querying:** Developing intricate queries to examine the data and derive insights.

**Advanced SQL Tools:** Utilizing advanced SQL tools like stored procedures (SP) and triggers to simulate functionality and illustrate the benefits of the database.

**Reports and Dashboards:** Generating reports and CEO dashboards using POWER BI.

<ins>Step 1 - ERD:</ins>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221418333-9ccfed41-e2a9-4f80-beae-6da033e8d6a0.png" width="700" height="700" />
</p>

<ins>Step 2 - The Relational Database:</ins>

When converting the ERD diagram to a Relational Database, each entity depicted in the ERD diagram will be mapped to a distinct table in the database. The relationships between these entities is established by defining the foreign keys.
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221418520-63e13717-ae90-48d8-821a-c68f3ddbe7b2.png" width="600" height="600" />
</p>
At this stage, I have created all of the required tables in SQL SERVER using the CREATE function and by defining the relevant fields and constraints, including primary keys, foreign keys, and data format constraints. 

<sub>You can see all of the above in the "create tables and constrains" SQL file.</sub>

<ins>Step 3 - generate synthetic data and load it into SQL SERVER:</ins>

<sub>You can see the added Excle file named "Data". Each table from the tables indicated above is on a different sheet.</sub>

<ins>Step 4 - Developing intricate queries to examine the data and derive insights:</ins>

At this stage, I have create a range of SQL queries that gradually increase in complexity.

Beginning with simple SELECT queries, such as - "find all registered customers whose total order amount exceeds 1000". 

<sub>In this case the query and the results will be:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221422093-3b68efa3-852d-4558-84f9-891695a2bcb5.png" width="450" height="250" />
</p>



And progressing to more advanced queries that use update statment and nested queries, such as - "For the 3 most popular countries in the order - update the shipping fees with a 10% discount".

<sub>In this case the query and the results will be:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221422420-2b8dc217-aa08-4331-b04d-18c92ed767ad.png" width="450" height="250" />
</p>

<ins>Step 5 - Utilizing advanced SQL tools:</ins>




