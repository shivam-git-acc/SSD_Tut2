USE SSD_tut2;
drop procedure if exists AddSubscriberIfNotExists;
drop procedure if exists FindSubscriber;

DELIMITER $$
CREATE PROCEDURE FindSubscriber(In subName varchar(100),OUT FLAG INT)
BEGIN
DECLARE Nameflag INT DEFAULT 0;
DECLARE SubNamelocal VARCHAR(100);
DECLARE done INT DEFAULT 0;

	DECLARE cursor_ptr CURSOR FOR 
	SELECT SubscriberName FROM Subscribers;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
    
SET FLAG=0;    
OPEN cursor_ptr;
readLoop:LOOP
	FETCH cursor_ptr INTO SubNamelocal;
	IF done THEN
		LEAVE readLoop;
	END IF;
    
    IF SubNamelocal=subName THEN
		SET FLAG=1;
		LEAVE readLoop;
	END IF;
END LOOP;

CLOSE cursor_ptr;
END $$

DELIMITER $$
CREATE PROCEDURE AddSubscriberIfNotExists(IN subName VARCHAR(100))
BEGIN
DECLARE ID INT;
DECLARE FLAG INT DEFAULT 0;
DECLARE Todays_date DATE;
SET Todays_date=curdate();
CALL FindSubscriber(subName,FLAG);

	IF FLAG=0 THEN
		SET ID=COALESCE((SELECT MAX(SubscriberID) FROM Subscribers), 0) + 1;
		INSERT INTO Subscribers (SubscriberID, SubscriberName,SubscriptionDate)
		VALUES (ID, subName, Todays_date);
	END IF;
END $$
DELIMITER ;


Call AddSubscriberIfNotExists("Meghan Markle");