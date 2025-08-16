USE SSD_tut2;
DROP PROCEDURE if exists GetWatchHistoryBySubscriber;
DROP PROCEDURE if exists SendWatchTimeReport;
DELIMITER $$
CREATE PROCEDURE GetWatchHistoryBySubscriber()
BEGIN
    DECLARE Sub_Id VARCHAR(100);
    DECLARE Sub_Name VARCHAR(100);
    DECLARE His_id INT;
	DECLARE Show_Title VARCHAR(100);
	DECLARE Watch_time INT;
    DECLARE done INT DEFAULT 0;

    -- Declare cursor and handler after variables
    DECLARE cursor_ptr CURSOR FOR 
        SELECT WatchHistory.SubscriberID,SubscriberName,HistoryID,Title,WatchTime FROM (WatchHistory INNER JOIN Shows
        ON Shows.ShowID=WatchHistory.ShowID) INNER JOIN Subscribers ON WatchHistory.SubscriberID=Subscribers.SubscriberID
        WHERE  WatchHistory.SubscriberID=@curr_subid;
 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_names (SubcriberID INT,SubscriberName VARCHAR(100),HistoryID INT,Title VARCHAR(100),WatchTime INT); 


    OPEN cursor_ptr;
    readLoop: LOOP
        FETCH cursor_ptr INTO Sub_Id,Sub_Name,His_id,Show_Title,Watch_time;
        IF done THEN
            LEAVE readLoop;
        END IF;

        INSERT INTO tmp_names VALUES (Sub_Id,Sub_Name,His_id,Show_Title,Watch_time);
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
        SELECT distinct SubscriberID from WatchHistory;
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
END$$

DELIMITER ;
CALL SendWatchTimeReport();
