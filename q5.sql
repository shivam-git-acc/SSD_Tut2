USE SSD_tut2;
DROP PROCEDURE if exists GetWatchHistoryBySubscriber;
DROP PROCEDURE if exists SendWatchTimeReport;
DELIMITER $$
CREATE PROCEDURE GetWatchHistoryBySubscriber()
BEGIN
    DECLARE Sub_Id VARCHAR(100);
    DECLARE Sub_Name VARCHAR(100);
    DECLARE Show_id INT;
    DECLARE His_id INT;
	DECLARE Show_Title VARCHAR(100);
	DECLARE Watch_time INT;
    DECLARE done INT DEFAULT 0;

    -- Declare cursor and handler after variables
    DECLARE cursor_ptr CURSOR FOR 
        SELECT Subscribers.SubscriberID,Subscribers.SubscriberName,WatchHistory.ShowID,HistoryID,Title,WatchTime FROM (WatchHistory RIGHT JOIN Subscribers
        ON WatchHistory.SubscriberID=Subscribers.SubscriberID) LEFT JOIN Shows ON Shows.ShowID=WatchHistory.ShowID
        WHERE  Subscribers.SubscriberID=@curr_subid;
 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_names (SubscriberID INT,SubscriberName VARCHAR(100),ShowID INT,HistoryID INT,Title VARCHAR(100),WatchTime INT); 


    OPEN cursor_ptr;
    readLoop: LOOP
        FETCH cursor_ptr INTO Sub_Id,Sub_Name,Show_id,His_id,Show_Title,Watch_time;
        IF done THEN
            LEAVE readLoop;
        END IF;

        INSERT INTO tmp_names VALUES (Sub_Id,Sub_Name,Show_id,His_id,Show_Title,Watch_time);
    END LOOP;
CLOSE cursor_ptr;
SELECT * FROM tmp_names;

   
END$$


-- Inserts if not exists
DELIMITER $$
CREATE PROCEDURE SendWatchTimeReport()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE Sub_id INT DEFAULT 0;
    	DECLARE cursor_ptr CURSOR FOR 
        SELECT SubscriberID from Subscribers;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1; 
OPEN cursor_ptr;
readLoop:LOOP
	FETCH cursor_ptr INTO Sub_id;
    IF done THEN
    LEAVE readLoop;
	END iF;
    
    SET @curr_subid=Sub_id;
    CALL GetWatchHistoryBySubscriber();
    END LOOP;
    
CLOSE cursor_ptr;
DROP TEMPORARY TABLE tmp_names;  
END$$

DELIMITER ;
CALL SendWatchTimeReport();
