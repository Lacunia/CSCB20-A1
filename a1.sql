-- If you define any views for a question (you are encouraged to), you must drop them
-- after you have populated the answer table for that question.
-- Good Luck!

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
SELECT pid1 AS pid, sid1, sid2, cost1, cost2
-- the subquery creates a table supplier with columns from Subsuppliers, where sid as sid1 and subid as sid2
FROM (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS supplier 
-- the subquery renames the columns of Catalog to pid1, sid1, and cost1, renames Catalog to Catalog1, and select only the tuples
-- with product that are not in UTSC inventory.
-- then, join this and the previous table based on sid1
JOIN (SELECT pid1, sid1, cost1 FROM Catalog as Catalog1 WHERE pid1 IN (SELECT pid FROM Inventory WHERE quantity = 0))
ON supplier.sid1 = Catalog1.sid1
-- the subquery renames the columns of Catalog to pid2, sid2, and cost2, renames Catalog to Catalog2, and select only the tuples
-- with product that are not in UTSC inventory.
-- then, join this and the previous tables based on sid2 and based on pid (to make sure the two suppliers sell the same product). 
-- Now there should be 3 tables joined together.
JOIN (SELECT pid2, sid2, cost2 FROM Catalog as Catalog2 WHERE pid2 IN (SELECT pid FROM Inventory WHERE quantity = 0))
ON supplier.sid2 = Catalog2.sid2 AND Catalog1.pid1 = Catalog2.pid2

-- Query 1c ii --------------------------------------------------
INSERT INTO Query1cii

-- Query 1c iii --------------------------------------------------
INSERT INTO Query1ciii

-- Query 1c iv  --------------------------------------------------
INSERT INTO Query1civ

-- Query 2 i --------------------------------------------------
INSERT INTO Query2i

-- Query 2 ii --------------------------------------------------
INSERT INTO Query2ii

-- Query 2 iii --------------------------------------------------
INSERT INTO Query2iii

-- Query 2 iv  --------------------------------------------------
INSERT INTO Query2iv

-- Query 2 v --------------------------------------------------
INSERT INTO Query2v

-- Query 2 vi --------------------------------------------------
INSERT INTO Query2vi

-- Query 2 vii --------------------------------------------------
INSERT INTO Query2vii

-- Query 2 viii --------------------------------------------------
INSERT INTO Query2viii











