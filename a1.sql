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
-- For each pid, find the suppliers that have products listed in their catalog at the exact same price. 
-- Return the columns as pid, sid, cost. ???????????
INSERT INTO Query1cii
SELECT Catalog1.pid, Catalog1.sid, Catalog1.cost
FROM Catalog AS Catalog1
JOIN Catalog AS Catalog2 
ON Catalog1.pid = Catalog2.pid AND  Catalog1.sid = Catalog2.sid 

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
ON Tag1.pid1 = Tag2.pid3 AND tagname3 != tagname1 AND tagname3 != tagname2
-- Join catalog to get the cost
JOIN Catalog
ON Tag1.pid1 = Catalog.pid 
-- Join product to get the pname
JOIN Product 
ON Tag1.pid1 = Product.pid

-- Query 1c iv  --------------------------------------------------
-- For each pair of “reciprocal subsuppliers”(*2), find all of their “uncommon subsuppliers”(*3). 
-- Every uncommon subsupplier of the pair should have only one row. Return the sid of the reciprocal subsuppliers, 
-- along with the sid, name and address of the uncommon subsupplier.
INSERT INTO Query1civ
SELECT DISTINCT reciprocal1.sid1, reciprocal1.sid2, uncommon.subsid, uncommon.subname, uncommon.subaddress
-- First, we find pairs that are reciprocal subsuppliers
FROM (SELECT sid AS sid1, subid As sid2 FROM Subsuppliers) AS reciprocal1
JOIN (SELECT sid AS sid1, subid As sid2 FROM Subsuppliers) AS reciprocal2
ON reciprocal1.sid1 = reciprocal2.sid2 AND reciprocal1.sid2 = reciprocal2.sid1 
      -- we get the subsuppliers for reciprocal supplier 1, where the subsuppliers are not the reciprocal supplier 2
      -- we exclude subsuppliers that are also subsuppliers of reciprocal supplier 2
JOIN (SELECT sid, subid, subname, subaddress FROM Subsuppliers 
      WHERE Subsuppliers.sid = reciprocal1.sid1 AND Subsuppliers.subid != reciprocal1.sid2 AND
      subid NOT IN (SELECT subid FROM Subsuppliers WHERE Subsuppliers.sid = reciprocal1.sid2 AND Subsuppliers.subid != reciprocal.sid1)
      UNION
      -- we get the subsuppliers for reciprocal supplier 2, where the subsuppliers are not the reciprocal supplier 1
      -- we exclude subsuppliers that are also subsuppliers of reciprocal supplier 1
      SELECT sid, subid, subname, subaddress FROM Subsuppliers 
      WHERE Subsuppliers.sid = reciprocal1.sid2 AND Subsuppliers.subid != reciprocal1.sid1 AND
      subid NOT IN (SELECT subid FROM Subsuppliers WHERE Subsuppliers.sid = reciprocal1.sid1 AND Subsuppliers.subid != reciprocal.sid2)
     ) AS uncommon
ON reciprocal1.sid1 = uncommon.sid OR reciprocal1.sid2 = uncommon.sid
-- The above query joins all uncommon suppliers to the reciprocal suppliers based on reciprocal suppliers' id



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











