-- If you define any views for a question (you are encouraged to), you must drop them
-- after you have populated the answer table for that question.
-- Good Luck!
-- note: make sure to clean the query tables before testing.
-- Query 1b i --------------------------------------------------
INSERT INTO Query1bi 

-- Query 1b ii --------------------------------------------------
INSERT INTO Query1bii

-- Query 1b iii --------------------------------------------------
INSERT INTO Query1biii

-- Query 1b iv  --------------------------------------------------
INSERT INTO Query1biv

-- Query 1b v --------------------------------------------------
INSERT INTO Query1bv

-- Query 1b vi --------------------------------------------------
INSERT INTO Query1bvi

-- Query 1b vii --------------------------------------------------
INSERT INTO Query1bvii

-- Query 1b ix --------------------------------------------------
INSERT INTO Query1bix

-- Query 1b x --------------------------------------------------
INSERT INTO Query1bx


-- Query 1c i --------------------------------------------------
-- For each pair of suppliers that have a “business relationship” (*1) with each other, 
-- find pids they both offer in their catalog, but which we do not have inventory of. 
-- Return the columns as pid, sid1, sid2, cost1, cost2.
INSERT INTO Query1ci
-- since i later renamed pid as pid1 and pid2, I rename here to meet the requirement of the question 
SELECT pid1 AS pid, supplier.sid1, supplier.sid2, cost1, cost2
-- the subquery creates a table supplier with columns from Subsuppliers, where sid as sid1 and subid as sid2
FROM (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS supplier 
-- the subquery renames the columns of Catalog to pid1, sid1, and cost1, renames Catalog to Catalog1, and select only the tuples
-- with product that are not in UTSC inventory.
-- then, join this and the previous table based on sid1
JOIN (SELECT pid AS pid1, sid AS sid1, cost AS cost1 FROM Catalog WHERE pid1 IN (SELECT pid FROM Inventory WHERE quantity = 0)) as Catalog1
ON supplier.sid1 = Catalog1.sid1
-- the subquery renames the columns of Catalog to pid2, sid2, and cost2, renames Catalog to Catalog2, and select only the tuples
-- with product that are not in UTSC inventory.
-- then, join this and the previous tables based on sid2 and based on pid (to make sure the two suppliers sell the same product). 
-- Now there should be 3 tables joined together.
JOIN (SELECT pid AS pid2, sid AS sid2, cost AS cost2 FROM Catalog WHERE pid2 IN (SELECT pid FROM Inventory WHERE quantity = 0)) as Catalog2
ON supplier.sid2 = Catalog2.sid2 AND Catalog1.pid1 = Catalog2.pid2;

	
-- Query 1c ii --------------------------------------------------
-- For each pid, find the suppliers that have products listed in their catalog at the exact same price. 
-- Return the columns as pid, sid, cost. 
INSERT INTO Query1cii 
SELECT Catalog2.pid, Catalog2.sid, Catalog2.cost
FROM Catalog AS Catalog1
JOIN Catalog AS Catalog2 
ON Catalog1.pid = Catalog2.pid AND Catalog1.cost = Catalog2.cost AND Catalog1.sid != Catalog2.sid;

	
-- Query 1c iii --------------------------------------------------
-- Find the pids that have been listed as at least 3 different tags. However, one of the tags must be ‘PPE’, 
-- and one of them must not be ‘Super Tech’. Return columns containing the pid, pname, cost.
INSERT INTO Query1ciii
SELECT pid1 AS pid, pname, cost
-- this table only contain products with tag of 'PPE' to make sure one of the tag is 'PPE'
FROM (SELECT pid AS pid1, tagname AS tagname1 FROM ProductTag WHERE tagname1 = 'PPE') AS Tag1
-- this table make sure there is not 'Super Tech' tag, and that the second tag is different from first tag 
JOIN (SELECT pid AS pid2, tagname AS tagname2 FROM ProductTag WHERE tagname2 != 'Super Tech') AS Tag2 
ON Tag1.pid1 = Tag2.pid2 AND tagname1 != tagname2 
-- this table make sure there is not 'Super Tech' tag, and that the third tag is different from previous two tags
JOIN (SELECT pid AS pid3, tagname AS tagname3 FROM ProductTag WHERE tagname3 != 'Super Tech') AS Tag3
ON Tag1.pid1 = Tag3.pid3 AND tagname3 != tagname1 AND tagname3 != tagname2
-- Join catalog to get the cost
JOIN Catalog
ON Tag1.pid1 = Catalog.pid 
-- Join product to get the pname
JOIN Product 
ON Tag1.pid1 = Product.pid;


-- Query 1c iv  --------------------------------------------------
-- For each pair of “reciprocal subsuppliers”(*2), find all of their “uncommon subsuppliers”(*3). 
-- Every uncommon subsupplier of the pair should have only one row. Return the sid of the reciprocal subsuppliers, 
-- along with the sid, name and address of the uncommon subsupplier.
INSERT INTO Query1civ
SELECT DISTINCT reciprocal1.sid1, reciprocal1.sid2, subid, subname, subaddress
-- First, we find pairs that are reciprocal subsuppliers
FROM (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal1
JOIN (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal2
ON reciprocal1.sid1 = reciprocal2.sid2 AND reciprocal1.sid2 = reciprocal2.sid1 
-- we get the subsuppliers for reciprocal supplier 1, where the subsuppliers are not the reciprocal supplier 2
-- we exclude subsuppliers that are also subsuppliers of reciprocal supplier 2
JOIN Subsuppliers 
ON Subsuppliers.sid = reciprocal1.sid1 AND Subsuppliers.subid != reciprocal1.sid2
WHERE subid NOT IN (SELECT subid FROM Subsuppliers WHERE Subsuppliers.sid = reciprocal1.sid2 AND Subsuppliers.subid != reciprocal1.sid1)

UNION

SELECT DISTINCT reciprocal1.sid1, reciprocal1.sid2, subid, subname, subaddress
FROM (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal16
JOIN (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal2
ON reciprocal1.sid1 = reciprocal2.sid2 AND reciprocal1.sid2 = reciprocal2.sid1 
-- we get the subsuppliers for reciprocal supplier 2, where the subsuppliers are not the reciprocal supplier 1
-- we exclude subsuppliers that are also subsuppliers of reciprocal supplier 1
JOIN Subsuppliers 
ON Subsuppliers.sid = reciprocal1.sid2 AND Subsuppliers.subid != reciprocal1.sid1
WHERE subid NOT IN (SELECT subid FROM Subsuppliers WHERE Subsuppliers.sid = reciprocal1.sid1 AND Subsuppliers.subid != reciprocal1.sid2);


-- note: make sure to clean the query tables before testing.
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
ON Approved.roomid = Occupancy.roomid AND (Occupancy.date BETWEEN 2022-09-01 AND 2022-12-31)
-- joining Room table to find all occurences of when alert level is above the alert threshold level
JOIN Room
ON Approved.roomid = Room.roomid AND Occupancy.alertlevel > Room.alertthreshold;

-- Query 2 vi --------------------------------------------------
INSERT INTO Query2vi
SELECT utorid
FROM (SELECT utorid, roomid FROM Occupancy WHERE Occupancy.data BETWEEN 2021-03-17 AND 2022-12-31) AS Occupied

EXCEPT

(SELECT *
FROM Approved);

-- Query 2 vii --------------------------------------------------
INSERT INTO Query2vii


-- Query 2 viii --------------------------------------------------
INSERT INTO Query2viii
SELECT Member.utorid, Member.email
FROM (((Student
JOIN Member
ON Student.utorid = Member.utorid AND Member.vacstatus = 0)
JOIN Occupancy
ON Student.utorid = Occupancy.utorid AND Member.utorid = Occupancy.utorid)
JOIN Room 
ON Occupancy.roomid = Room.roomid AND Occupancy.alertlevel > Room.alertthreshold);











