USE SSD_tut2;
DROP PROCEDURE IF EXISTS ListAllSubscribers;

DELIMITER $$
CREATE PROCEDURE ListAllSubscribers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE SubName VARCHAR(100);

    DECLARE cursor_subsptr CURSOR FOR 
        SELECT SubscriberName FROM Subscribers;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE tmp_names (name VARCHAR(100));

    OPEN cursor_subsptr;
    read_loop: LOOP
        FETCH cursor_subsptr INTO SubName;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO tmp_names VALUES (SubName);
    END LOOP;
CLOSE cursor_subsptr;

    SELECT * FROM tmp_names;
    DROP TEMPORARY TABLE tmp_names;
END $$
DELIMITER ;

CALL ListAllSubscribers();

