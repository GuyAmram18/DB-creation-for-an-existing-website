# DB creation for an existing website

The objective of this project is to develop a prototype database for an existing website and demonstrate its functionality.

The project is based on the website - www.skates.com 

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

At this stage, I have created a range of SQL queries that gradually increase in complexity.

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

At this stage,  I have created multiple functions, Triggers and Stored Procedure that are designed for broader application and served to facilitate frequent operations.

**Functions**

For example - a function that takes a start and end date range as input and returns a table. The function retrieves all orders that fall within the specified date range. The information for each order will be the order ID, the date, the number of items, and the total amount paid.

<sub>In this case the function will be:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221435773-f7479142-fe84-4ba0-a528-2fa8d2eaf98b.png" width="450" height="150" />
</p>

<sub>An example of using it will return the following result:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221435871-2840abf7-ef5a-4417-b72a-948d7414d248.png" width="450" height="350" />
</p>

**Trigger**

In order to create this trigger, we created a calculated field that holds for each product the total number of units ordered from it.
The trigger updates this field whenever there is any change in the INCLUDES table (ie for any addition of a product to the order, deletion of a product from the order or change in quantity)

<sub>In this case the Trigger will be:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221436063-4c5631e2-6f12-4c46-9bb0-4373ac0023a5.png" width="450" height="250" />
</p>

<sub>After using an INSERT INTO Statement, the INCLUDES table will change as the following:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221436275-e511b0d6-5a3a-46db-a6f6-78047657bd1d.png" width="450" height="250" />
</p>

**Trigger which uses Cursor**



**Stored Procedure**

This procedure is designed to run once a week through all products and update their popularity ranking based on the number of orders received. It accepts the number of products to be classified as 'popular' as input and updates the corresponding RANK field accordingly.

<sub>In this case the Stored Procedure will be:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221437294-b744eb86-62d1-49bb-b408-f4cd9b8f51ff.png" width="450" height="200" />
</p>

<sub>An example of using it will return the following result:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221437416-91f8b42f-3c76-4a8e-9ccc-783ee999d95a.png" width="450" height="250" />
</p>

<ins>Step 6 - Reports and Dashboards:</ins>

<sub>In order to create the report and the dashbord, I created a large number of VIEWS. You can find all of them in the "CREATE VIEW" SQL file.</sub>

**Sales Report**

The Sales Report aims to showcase the sales performance of different sections. It displays the overall revenue and the top ten most profitable products (which can be filtered by date using the time slider). Additionally, the report presents the revenue generated by each product category and supplier.

<sub>The final Sales Report:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221438415-718da7cf-4c1b-48a5-9426-5080f1213ddb.png" width="800" height="450" />
</p>

**CEO Dashboard**

The CEO dashboard serves the purpose of presenting long-term view of the company's data related to the company's products and customers, with the aim of identifying trends and setting policies and goals for the organization. Additionally, it allows managers to investigate phenomena and trends in greater detail by drilling down into the data.

<sub>The CEO Dashboard:</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221438932-e4b2d009-f5c2-44b9-96a5-2ce20a9596f9.png" width="800" height="450" />
</p>

<sub>Drill Down - segmentation by states (for example - Utah):</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221439147-b585055b-47fd-481b-9ce8-ebc1080b8a31.png" width="800" height="450" />
</p>

<sub>Drill Down - segmentation by vendor (for example - Reebook):</sub>
<p align="center">
<img src="https://user-images.githubusercontent.com/105520248/221439202-f7b7a94b-12ea-4612-87e3-b60857f26421.png" width="800" height="450" />
</p>
