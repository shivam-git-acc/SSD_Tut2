USE SSD_tut2;
drop procedure if exists GetWatchHistoryBySubscriber;
DELIMITER $$
CREATE PROCEDURE GetWatchHistoryBySubscriber(IN sub_id INT)
BEGIN
DECLARE done INT DEFAULT 0;
DECLARE His_id INT;
DECLARE Show_Title VARCHAR(100);
DECLARE Watch_time INT;

	DECLARE cursor_subsptr CURSOR FOR 
        SELECT HistoryID,Title,WatchTime FROM WatchHistory INNER JOIN Shows
        ON Shows.ShowID=WatchHistory.ShowID where WatchHistory.SubscriberID=sub_id;
     

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        CREATE TEMPORARY TABLE tmp_names (HistoryID INT,Title VARCHAR(100),WatchTime INT); 

OPEN cursor_subsptr;
    
    read_loop: LOOP
        FETCH cursor_subsptr INTO His_id,Show_Title,Watch_time;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO tmp_names VALUES (His_id,Show_Title,Watch_time);
    END LOOP;
    
CLOSE cursor_subsptr;
    
SELECT * FROM tmp_names;
DROP TEMPORARY TABLE tmp_names;    
END $$

Delimiter ;
call GetWatchHistoryBySubscriber(1);


