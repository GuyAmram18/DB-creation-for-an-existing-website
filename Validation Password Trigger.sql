

---SUPER Advance Tools - Trigger with a curser

--Functions
CREATE FUNCTION CheckPasswordLen (@password VARCHAR(20)) 
Returns Bit 
AS BEGIN
	DECLARE @ANS Bit = 0 --means valid

-- under 6 chars
	if len( @password) <=5
	BEGIN 
		SET @ANS = 1
	END

return @ANS
END

CREATE FUNCTION CheckPasswordHasLetters (@password VARCHAR(20))
Returns bit 
AS BEGIN
	DECLARE @ANS BIT = 0 --means valid

-- DOENT HAVE LETTERS
	IF @password NOT LIKE '%[A-Z]%'
	BEGIN
		SET @ANS = 1
	END

return @ANS
END

CREATE FUNCTION CheckPasswordHasNumbers (@password VARCHAR(20))
Returns bit 
AS BEGIN
	DECLARE @ANS BIT = 0 --means valid

-- DOENT HAVE NUMBERS
	IF @password NOT LIKE '%[0-9]%'
	BEGIN
		SET @ANS = 1
	END

return @ANS
END

CREATE FUNCTION CheckPasswordHasSymbol (@password VARCHAR(20))
Returns bit 
AS BEGIN
	DECLARE @ANS BIT = 1 --means invalid

-- CONTAINS SYMBOLS
	IF @password LIKE '%!%' OR @password LIKE '%@%' OR @password LIKE '%#%' OR @password LIKE '%^%' OR @password LIKE '%&%' OR @password LIKE '%*%' OR @password LIKE '%~%'
	BEGIN
		SET @ANS = 0
	END

return @ANS
END

CREATE VIEW getRandNum
AS
SELECT FLOOR(RAND()*(9-1+1)) AS Value

CREATE VIEW getRandPlaceToAdd
AS
SELECT FLOOR(RAND()*(6-2+1)+2) AS Value


CREATE VIEW getRandLetter
AS
SELECT substring('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', convert(int, rand()*52), 1)
AS Value --RAND LETTER

CREATE VIEW getRandSymbol
AS
SELECT substring('!@#$^&*~', convert(int, rand()*8), 1)
AS Value --RAND Symbol

CREATE FUNCTION GeneratePassword_AddNumbers (@password VARCHAR(20))
Returns VARCHAR (20)
AS BEGIN
	DECLARE @newPass VARCHAR(20) = @password
	DECLARE @PassLen INT =LEN(@password)
	DECLARE @numToAdd VARCHAR = (SELECT Value FROM getRandNum) --RAND NUM BETWEEN 1-9

	--if password is in the exect size of limit-make it shorter 
	IF(LEN(@password)=20)
		--insert the number into the password instaed 1 char in the beggining
		BEGIN
		SET @newPass =  STUFF(@newPass,1, 1, @numToAdd)
		END

	ELSE
		--insert the number into the password
		BEGIN
		DECLARE @placeToAdd INT = (SELECT Value FROM getRandPlaceToAdd) --RAND PLACE BETWEEN 1-6
		SET @newPass =  STUFF(@newPass,@placeToAdd, 0, @numToAdd)
		END


RETURN @newPass
END


CREATE FUNCTION GeneratePassword_AddLetters (@password VARCHAR(20))
Returns VARCHAR (20)
AS BEGIN
	DECLARE @newPass VARCHAR (20) = @password
	DECLARE @PassLen INT = LEN(@password)
	DECLARE @LetterToAdd VARCHAR = (SELECT Value FROM getRandLetter)

	--if password is in the exect size of limit-make it shorter 
	IF(LEN(@password)=20)
		--insert the Letter into the password instaed 1 char in the middel
		BEGIN
		SET @newPass =  STUFF(@newPass,@PassLen/2, 1, @LetterToAdd)
		END

	ELSE
		--insert the Letter into the password in rand place
		BEGIN
		DECLARE @placeToAdd INT = (SELECT Value FROM getRandPlaceToAdd)
		SET @newPass =  STUFF(@newPass,@placeToAdd, 0, @LetterToAdd)
		END

RETURN @newPass
END


CREATE FUNCTION GeneratePassword_AddSymbols (@password VARCHAR(20))
Returns VARCHAR (20) 
AS BEGIN
	DECLARE @newPass VARCHAR (20) = @password
	DECLARE @PassLen INT = LEN(@password)
	DECLARE @SymbolToAdd VARCHAR = (SELECT Value FROM getRandSymbol)

	--if password is in the exect size of limit-make it shorter 
	IF(LEN(@password)=20)
		--insert the Letter into the password instaed 1 char in the end
		BEGIN
		SET @newPass =  STUFF(@newPass,@PassLen, 1, @SymbolToAdd)
		END

	ELSE
		--insert the Letter into the password in rand place
		BEGIN
		DECLARE @placeToAdd INT = (SELECT Value FROM getRandPlaceToAdd)
		SET @newPass =  STUFF(@newPass,@placeToAdd, 0, @SymbolToAdd)
		END

RETURN @newPass
END

Drop FUNCTION GeneratePassword_AddChars
CREATE FUNCTION GeneratePassword_AddChars (@password VARCHAR(20))
Returns VARCHAR (20)
AS BEGIN
	DECLARE @newPass VARCHAR (20) = @password
	DECLARE @PassLen INT = LEN(@password)
	DECLARE @Letter1ToAdd VARCHAR = (SELECT Value FROM getRandLetter)
	DECLARE @Letter2ToAdd VARCHAR = (SELECT Value FROM getRandLetter)
	DECLARE @num1ToAdd VARCHAR = (SELECT Value FROM getRandNum) --RAND NUM BETWEEN 1-9
	DECLARE @num2ToAdd VARCHAR = (SELECT Value FROM getRandNum) --RAND NUM BETWEEN 1-9
	DECLARE @SymbolToAdd VARCHAR = (SELECT Value FROM getRandSymbol)

		--insert the Letter into the password in rand place
		BEGIN
		DECLARE @placeToAdd INT = 1
		SET @newPass =  STUFF(@newPass,@placeToAdd, 0, @Letter1ToAdd+@num1ToAdd+@Letter2ToAdd+@num2ToAdd+@SymbolToAdd)
		END

RETURN @newPass
END


--Triger
Drop TRIGGER PasswordValidation
CREATE TRIGGER PasswordValidation
	ON 	CUSTOMERS	
	FOR		INSERT

AS


--local variable
DECLARE @CustomerEmail	VARCHAR(30)
DECLARE @password	VARCHAR(20)
DECLARE @NotContainNumbers BIT
DECLARE @NotContainLetters BIT
DECLARE @NotContainSymbols BIT
DECLARE @NotValidLen BIT
DECLARE @NewPass Varchar(20)

DECLARE   Cur CURSOR
FOR	SELECT  Email, Password
		FROM	INSERTED 

BEGIN
open Cur 
fetch next from Cur
into @CustomerEmail, @Password

WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		
		SET @NotValidLen = dbo.CheckPasswordLen(@password) --1 if Shorten then 6 letters
		SET @NotContainNumbers= dbo.CheckPasswordHasNumbers(@password) --1 if not contains
		SET @NotContainLetters= dbo.CheckPasswordHasLetters(@password) --1 if not contains
		SET @NotContainSymbols= dbo.CheckPasswordHasSymbol(@password) --1 if not contains
		SET @NewPass = @password

		if(@NotValidLen =1)
			SET @NewPass =dbo.GeneratePassword_AddChars (@NewPass)

		if (@NotContainNumbers=1)
			SET @NewPass = dbo.GeneratePassword_AddNumbers(@NewPass)
		
		if (@NotContainLetters=1)
			SET @NewPass = dbo.GeneratePassword_AddLetters(@NewPass)

		if (@NotContainSymbols=1)
			SET @NewPass = dbo.GeneratePassword_AddSymbols(@NewPass)
	
		UPDATE CUSTOMERS
		SET Password = @NewPass
		WHERE Email = @CustomerEmail

	fetch next from Cur
	into @CustomerEmail, @password
	END

CLOSE 	Cur

END
