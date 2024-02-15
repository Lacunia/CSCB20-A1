-- Query 2 i --------------------------------------------------
INSERT INTO Query2i
-- Selecting the table containing all the utorid from the Student table
SELECT utorid
FROM Student

-- Subtracting the latter from the entire Student table
EXCEPT

-- Selecting all those utorids that are indeed approved for the room 'IC404'
-- Select all utorid and theta join with the list of approved utorids for the room 'IC404'
(SELECT utorid
FROM Student
-- Selected all the utorids that have access to room 'IC404'
JOIN(SELECT * FROM Room JOIN Approved ON Room.roomid = Approved.roomid WHERE roomname = 'IC404') AS Approved1
ON Student.utorid = Approved1.utorid);

-- Query 2 ii --------------------------------------------------
INSERT INTO Query2ii
-- Getting the rooms that are approved for employees
SELECT utorid
-- copy 1
FROM (SELECT utorid AS utorid1, roomid AS roomid1 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved1 
-- copy 2
JOIN (SELECT utorid AS utorid2, roomid AS roomid2 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved2
-- Making sure there are at least two rooms approved under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved2.roomid2
-- copy 3
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved3
-- Making sure there are at least three rooms approved under the same utorid
ON Approved1.utorid1 = Approved3.utorid3 AND Approved1.roomid1 != Approved3.roomid3 AND Approved.roomid2 != Approved.roomid3;

-- Query 2 iii --------------------------------------------------
INSERT INTO Query2iii
-- The idea is to subtract utorids with access to 4+ rooms from access to 3+ rooms to retain the ones with only access to exactly 3 rooms
-- Getting the utorids with access to 3 or more rooms
SELECT utorid
-- copy 1
FROM (SELECT utorid AS utorid1, roomid AS roomid1 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved1 
-- copy 2
JOIN (SELECT utorid AS utorid2, roomid AS roomid2 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved2
-- Making sure there are at least two rooms approved under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved2.roomid2
-- copy 3
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved3
-- Making sure there are at least three rooms approved under the same utorid
ON Approved1.utorid1 = Approved3.utorid3 AND Approved1.roomid1 != Approved3.roomid3 AND Approved.roomid2 != Approved.roomid3

EXCEPT

-- Getting the utorids with access to 4 or more rooms 
(SELECT utorid
-- copy 1
FROM (SELECT utorid AS utorid1, roomid AS roomid1 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved1 
-- copy 2
JOIN (SELECT utorid AS utorid2, roomid AS roomid2 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved2
-- Making sure there are at least two rooms approved under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved2.roomid2
-- copy 3
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved3
-- Making sure there are at least three rooms approved under the same utorid
ON Approved1.utorid1 = Approved3.utorid3 AND Approved1.roomid1 != Approved3.roomid3 AND Approved.roomid2 != Approved.roomid3
-- copy 4
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved4
-- There are at least 4 different rooms under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved4.roomid4 AND Approved2.roomid2 != Approved4.roomid4 AND Approved3.roomid3 != Approved4.roomid4);

-- Query 2 iv  --------------------------------------------------
INSERT INTO Query2iv
-- The idea is to subtract utorids with access to 4+ rooms from access to all rooms to retain the ones with only access to 3 or less rooms
-- Getting the utorids with access to 3 or more rooms
SELECT utorid
-- copy 1
FROM Employee JOIN Approved ON Employee.utorid = Approved.utorid

EXCEPT

-- Getting the utorids with access to 4 or more rooms 
(SELECT utorid
-- copy 1
FROM (SELECT utorid AS utorid1, roomid AS roomid1 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved1 
-- copy 2
JOIN (SELECT utorid AS utorid2, roomid AS roomid2 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved2
-- Making sure there are at least two rooms approved under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved2.roomid2
-- copy 3
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved3
-- Making sure there are at least three rooms approved under the same utorid
ON Approved1.utorid1 = Approved3.utorid3 AND Approved1.roomid1 != Approved3.roomid3 AND Approved.roomid2 != Approved.roomid3
-- copy 4
JOIN (SELECT utorid AS utorid3, roomid AS roomid3 FROM (Employee JOIN Approved ON Employee.utorid = Approved.utorid)) AS Approved4
-- There are at least 4 different rooms under the same utorid
ON Approved1.utorid1 = Approved2.utorid2 AND Approved1.roomid1 != Approved4.roomid4 AND Approved2.roomid2 != Approved4.roomid4 AND Approved3.roomid3 != Approved4.roomid4);

-- Query 2 v --------------------------------------------------
INSERT INTO Query2v
--In this case, we are accounting for all cases of when the alert level has exceeded the threshold, regardless of whether it was triggered by Oscar Lin or not
-- getting the room id of where alert level has exceeded threshold between 2022-09-01 and 2022-12-31
SELECT Room.roomid
-- Checking Oscar Lin is indeed a student
FROM (SELECT * FROM Student JOIN Member ON Student.utorid = Member.utorid AND Member.name = 'Oscar Lin') AS Student_O_L
-- joining the approved table to find out all the rooms Oscar Lin was approved for
JOIN Approved
ON Student_O_L.utorid = Approved.utorid
-- joining Occupancy table to find out all occurences of these rooms being occupied between 2022-09-01 and 2022-12-31
JOIN Occupancy
ON Approved.roomid = Occupancy.roomid AND (Occupancy.date Between 2022-09-01 AND 2022-12-31)
-- joining Room table to find all occurences of when alert level is above the alert threshold level
JOIN Room
ON Approved.roomid = Room.roomid AND Occupancy.alertlevel > Room.alertthreshold;

-- Query 2 vi --------------------------------------------------
INSERT INTO Query2vi
-- select utorid of occupancy of rooms that are not approved within this time period
SELECT utorid
-- from a table that contains all the occupancy occurences between the desired dates
FROM (SELECT utorid, roomid FROM Occupancy WHERE Occupancy.data Between 2021-03-17 AND 2022-12-31) AS Occupied

EXCEPT

-- only containing approved occupancy of rooms
(SELECT *
FROM Approved);

-- Query 2 vii --------------------------------------------------
INSERT INTO Query2vii
-- using the SUM() function, adding up the salary column in the Employee table
SELECT SUM(salary)
FROM Employee;


-- Query 2 viii --------------------------------------------------
INSERT INTO Query2viii
-- selecting the utorid and email of students with vaxstatus '0' and exceeded any room's alert threshold
SELECT Member.utorid, Member.email
-- finds all students with vacstatus '0'
FROM Student
JOIN Member
ON Student.utorid = Member.utorid AND Member.vacstatus = 0
-- finds all occurences of the students with vacstatus '0' occupying a space
JOIN Occupancy
ON Student.utorid = Occupancy.utorid AND Member.utorid = Occupancy.utorid
-- finds all occurences of the students with vacstatus '0' occupying a space that exceeds the room's alert threshold
JOIN Room 
ON Occupancy.roomid = Room.roomid AND Occupancy.alertlevel > Room.alertthreshold;