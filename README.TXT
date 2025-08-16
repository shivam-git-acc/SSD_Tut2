CS6.302 - Software System Development
Lab - 2: SQL - Stored Procedures and Cursors
Student: 2025202030

===============================================
EXECUTION STEPS:
===============================================

Prerequisites:
- MySQL Workbench installed
- MySQL Server running
- Create a database named 'SSD_tut2' (or modify the USE statement in scripts accordingly)

Database Setup:
1. Open MySQL Workbench
2. Connect to your MySQL server
3. Create database: CREATE DATABASE SSD_tut2;
4. Execute the table creation and data insertion statements provided in the assignment PDF

Script Execution Order:
Execute the scripts in the following sequence:

1. q1.sql - ListAllSubscribers() Procedure
   - Creates a stored procedure that uses cursor to iterate through all subscribers
   - Prints subscriber names using temporary table
   - Automatically calls the procedure to demonstrate functionality

2. q2.sql - GetWatchHistoryBySubscriber() Procedure
   - Creates procedure that takes subscriber ID as parameter
   - Returns watch history for specified subscriber with show titles and watch times
   - Uses cursor with INNER JOIN to fetch relevant data
   - Demonstrates with subscriber ID = 1

3. q3.sql - AddSubscriberIfNotExists() Procedure
   - Creates helper procedure FindSubscriber() to check if subscriber exists
   - Creates main procedure to add subscriber only if name doesn't exist
   - Uses cursor to iterate through existing subscribers for duplicate check
   - Demonstrates by adding "DoeSMith" as new subscriber

4. q4.sql - SendWatchTimeReport() Procedure
   - Creates modified GetWatchHistoryBySubscriber() without parameters
   - Creates SendWatchTimeReport() that calls GetWatchHistoryBySubscriber() 
     for all subscribers who have watched something
   - Uses DISTINCT to get only subscribers with watch history
   - Uses session variable @curr_subid to pass subscriber ID between procedures

5. q5.sql - Another version of SendWatchTimeReport() Procedure
   - Creates comprehensive version that loops through ALL subscribers
   - Uses RIGHT JOIN to include subscribers even without watch history
   - Shows complete watch history report for all subscribers
   - Handles subscribers with no watch history gracefully

Execution Notes:
- Each script contains DROP PROCEDURE statements to clean up after execution
- Scripts use temporary tables where appropriate for result display
- All procedures use proper cursor handling with CONTINUE HANDLER for NOT FOUND
- Session variables (@curr_subid) are used for inter-procedure communication

Expected Output:
- q1.sql: List of all subscriber names
- q2.sql: Watch history for subscriber ID 1 (Emily Clark)
- q3.sql: Updated subscribers table with new subscriber "Meghan Markle"
- q4.sql: Watch history report for subscribers who have watched content
- q5.sql: Complete watch history report for ALL subscribers

==================================================================
GIT REPOSITORY LINK:https://github.com/shivam-git-acc/SSD_Tut2.git
==================================================================

Repository contains:
- All 5 SQL script files (q1.sql, q2.sql, q3.sql, q4.sql, q5.sql)
- This README.txt file

===============================================
ADDITIONAL NOTES:
===============================================

- All procedures properly implement cursor-based iteration as required
- Error handling implemented using CONTINUE HANDLER for NOT FOUND
- Temporary tables used for displaying results where appropriate
- Procedures follow MySQL stored procedure best practices
- Each script is self-contained and can be executed independently after database setup

For any issues during execution, ensure:
1. Database 'SSD_tut2' exists and is selected
2. Sample data is properly loaded using the INSERT statements from assignment
3. MySQL Workbench has sufficient privileges for CREATE PROCEDURE operations
