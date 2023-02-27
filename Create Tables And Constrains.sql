create table Customers(
Email Varchar(30) NOT NULL,
Name Varchar(20),
Password Varchar(20),
CONSTRAINT PK_Customer PRIMARY KEY(Email),
)

create table Addresses(
Email Varchar(30) NOT NULL,
Number Integer NOT NULL,
[Zip code] Integer,
State Varchar(20),
City Varchar(20),
Street Varchar(20),
Building Integer,
Apartment Integer,
CONSTRAINT PK_Addresses PRIMARY KEY(Email,Number),
CONSTRAINT FK_Email foreign key(Email) references Customers(Email),
)

create table ShippingPrices(
State Varchar(20) NOT NULL,
[Delivery Method] Varchar(20) NOT NULL,
[Shipping Price] Money,
CONSTRAINT PK_ShippingPrices PRIMARY KEY(State,[Delivery Method])
)

create table CreditCards(
[CC – Account]  Integer NOT NULL,
[CC – Type] Varchar(20),
[CC – Number] BigInt,
[CC – CVC]  Integer,
[CC – Expiration] Date,
CONSTRAINT PK_CreditCard PRIMARY KEY([CC – Account])
)


create table Orders(
[Order-ID] Integer NOT NULL,
Name Varchar(20),
DT DateTime,
Email Varchar(30),
[Phone Number] Integer,
State Varchar(20),
[Delivery Method] Varchar(20),
[Zip Code] Integer,
City Varchar(20),
Street Varchar(20),
Building Integer,
Apartment Integer,
[Customer Email] Varchar(30),
Number Integer,
[CC – Account] Integer,
CONSTRAINT PK_Orders PRIMARY KEY([Order-ID]),
CONSTRAINT FK_Addresses foreign key([Customer Email],Number) references Addresses(Email,Number),
CONSTRAINT FK_Customer foreign key([Customer Email]) references Customers(Email),
CONSTRAINT FK_State foreign key(State,[Delivery Method]) references ShippingPrices(State,[Delivery Method]),
CONSTRAINT FK_CreditCard foreign key([CC – Account]) references CreditCards([CC – Account]),
)


create table Products(
[Item Number] Integer NOT NULL,
Name Varchar(50),
Price Money,
Description Varchar(100),
Vendor Varchar(20),
CONSTRAINT PK_Products PRIMARY KEY([Item Number])
)

create table Questions(
[Item Number] Integer NOT NULL,
DT Date NOT NULL,
Name Varchar(20),
Content Varchar(50),
Answer Varchar(50),
CONSTRAINT PK_Questions PRIMARY KEY([Item Number],DT),
CONSTRAINT FK_QuestionsProducts foreign key([Item Number]) references Products([Item Number])
)

create table Reviews(
[Item Number] Integer NOT NULL,
DT Date NOT NULL,
Title Varchar(20),
Rate Integer,
CONSTRAINT PK_ReviewsQuestions PRIMARY KEY([Item Number],DT),
CONSTRAINT FK_QuestionsReviews foreign key([Item Number],DT) references Questions([Item Number], DT)
)  

CREATE TABLE ProductsColors(
[Item Number] Integer NOT NULL,
Color  Varchar(20) NOT NULL,
CONSTRAINT PK_ProductsColors PRIMARY KEY([Item Number],Color)
 )

 CREATE TABLE ProductsSizes(
[Item Number] Integer NOT NULL,
Size  Varchar(20) NOT NULL,
CONSTRAINT PK_ProductsSizes PRIMARY KEY([Item Number],Size)
 )

CREATE TABLE Searches(
[IP Address]  Varchar(15) NOT NULL,
[Search DT]  Date NOT NULL,
Text  Varchar(30),
Category Varchar(20),
Email  Varchar(30),
[Price Filter] Varchar(10),
[Color Filter] Varchar(20),
[Size Filter] Varchar(20),
[Gender Filter] Varchar(20),
CONSTRAINT PK_Searches PRIMARY KEY([IP Address],[Search DT]),
CONSTRAINT FK_SearchesCustomers foreign key(Email) references Customers(Email)
 )

create table Related(
[Item Number1] Integer NOT NULL,
[Item Number2] Integer NOT NULL,
CONSTRAINT PK_Related PRIMARY KEY([Item Number1],[Item Number2]),
CONSTRAINT FK1_Related foreign key([Item Number1]) references Products ([Item Number]),
CONSTRAINT FK2_Related foreign key([Item Number2]) references Products ([Item Number])
)

create table Retrieves(
[IP Address] Varchar(15) NOT NULL,
DT DATE NOT NULL,
[Item Number] Integer NOT NULL, 
CONSTRAINT PK_Retrieves PRIMARY KEY([IP Address], DT, [Item Number]),
CONSTRAINT FK1_Retrieves foreign key([IP Address], DT) references Searches ([IP Address], [Search DT]),
CONSTRAINT FK2_Retrieves foreign key([Item Number]) references Products ([Item Number])
)

 Create Table Includes (
[Item Number] Integer NOT NULL,
[Order ID] Integer NOT NULL,
Color  Varchar(20),
Size  Varchar(20),
Quantity  Integer,
CONSTRAINT PK_Includes PRIMARY KEY([Item Number],[Order ID]),
CONSTRAINT FK_IncludesProducts1 foreign key([Item Number]) references Products([Item Number]),
CONSTRAINT FK_IncludesProducts2 foreign key([Order ID]) references Orders([Order-ID])
 )

 Create Table WrittenBy (
Email Varchar(30) NOT NULL,
[Item Number] Integer NOT NULL,
DT  Date NOT NULL,
CONSTRAINT PK_WrittenBy PRIMARY KEY(Email,[Item Number],DT),
CONSTRAINT FK_WrittenByCustomer foreign key(Email) references Customers(Email),
CONSTRAINT FK_WrittenByQUestion foreign key([Item Number],DT) references Questions([Item Number],DT)
 )

ALTER TABLE Customers ADD CONSTRAINT CustomerEmail CHECK (Email LIKE '%@%.%')
ALTER TABLE Orders ADD CONSTRAINT OrderEmail CHECK (Email LIKE '%@%.%')
ALTER TABLE Addresses ADD CONSTRAINT CheckPositiveAddress CHECK (Number>=0 AND [Zip code]>=0 AND Building>=0 AND Apartment>=0)
ALTER TABLE Orders ADD CONSTRAINT CheckPositiveAddressInOrder CHECK ([Zip code]>=0 AND Building>=0 AND Apartment>=0)
ALTER TABLE Orders ADD CONSTRAINT CheckPositiveOrderID CHECK ([Order-ID]>=0)
ALTER TABLE CreditCards ADD CONSTRAINT checkpositiveCreditCardDetails CHECK ([CC – Account] >=0 AND [CC – Number]>=0)
ALTER TABLE CreditCards ADD CONSTRAINT CVCFormat CHECK ([CC – CVC] >=100 AND [CC – CVC] < 1000)
ALTER TABLE Reviews ADD CONSTRAINT RatePossibleNumbers CHECK (Rate BETWEEN 0 AND 5)
ALTER TABLE Includes ADD CONSTRAINT CheckPositiveQuantity CHECK (Quantity>=0)
ALTER TABLE Products ADD CONSTRAINT CheckPositiveNumberANDPrice CHECK ([Item Number] >=0 AND Price>=0)

CREATE TABLE Colors (
Color Varchar(20) NOT NULL PRIMARY KEY )
INSERT INTO  Colors (Color) Values ('Red')
INSERT INTO  Colors (Color) Values ('Blue')
INSERT INTO  Colors (Color) Values ('Black')
INSERT INTO  Colors (Color) Values ('Pink')
INSERT INTO  Colors (Color) Values ('White')
INSERT INTO  Colors (Color) Values ('Yellow')
INSERT INTO  Colors (Color) Values ('Green')

ALTER TABLE ProductsColors
ADD CONSTRAINT FK_Colors
FOREIGN KEY (Color) REFERENCES Colors (Color)

ALTER TABLE Searches
ADD CONSTRAINT FK_SearchesColors
FOREIGN KEY ([Color Filter]) REFERENCES Colors (color)

ALTER TABLE Includes
ADD CONSTRAINT FK_IncludesColors
FOREIGN KEY (Color) REFERENCES Colors (Color)

CREATE TABLE Sizes (
Size Varchar(20) NOT NULL PRIMARY KEY )

INSERT INTO  Sizes (Size) Values ('7j')
INSERT INTO  Sizes (Size) Values ('8y')
INSERT INTO  Sizes (Size) Values ('9j')
INSERT INTO  Sizes (Size) Values ('10j')
INSERT INTO  Sizes (Size) Values ('11y')
INSERT INTO  Sizes (Size) Values ('12y')
INSERT INTO  Sizes (Size) Values ('13y')
INSERT INTO  Sizes (Size) Values ('14j')

ALTER TABLE ProductsSizes
ADD CONSTRAINT FK_Sizes
FOREIGN KEY (Size) REFERENCES Sizes (Size)

ALTER TABLE Searches
ADD CONSTRAINT FK_SearchesSizes
FOREIGN KEY ([Size Filter]) REFERENCES Sizes (Size)

ALTER TABLE Includes
ADD CONSTRAINT FK_IncludesSizes
FOREIGN KEY (Size) REFERENCES Sizes (Size)

CREATE TABLE Genders (
Gender Varchar(20) NOT NULL PRIMARY KEY )
INSERT INTO  Genders (Gender) Values ('Women')
INSERT INTO  Genders (Gender) Values ('Men')
INSERT INTO  Genders (Gender) Values ('Boys')
INSERT INTO  Genders (Gender) Values ('Girls')

ALTER TABLE Searches
ADD CONSTRAINT FK_SearchesGenders
FOREIGN KEY ([Gender Filter]) REFERENCES Genders (Gender)

CREATE TABLE Prices (
Price Varchar(10) NOT NULL PRIMARY KEY )
INSERT INTO  Prices (Price) Values ('0-50')
INSERT INTO  Prices (Price) Values ('50-100')
INSERT INTO  Prices (Price) Values ('100-150')
INSERT INTO  Prices (Price) Values ('150-200')
INSERT INTO  Prices (Price) Values ('200-250')
INSERT INTO  Prices (Price) Values ('250-300')

ALTER TABLE Searches
ADD CONSTRAINT FK_SearchesPrices
FOREIGN KEY ([Price Filter]) REFERENCES Prices (Price)
