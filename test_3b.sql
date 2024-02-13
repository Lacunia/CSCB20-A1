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
ON Catalog1.pid = Catalog2.pid AND Catalog1.cost = Catalog2.cost;

	
	
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
FROM (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal1
JOIN (SELECT sid AS sid1, subid AS sid2 FROM Subsuppliers) AS reciprocal2
ON reciprocal1.sid1 = reciprocal2.sid2 AND reciprocal1.sid2 = reciprocal2.sid1 
-- we get the subsuppliers for reciprocal supplier 2, where the subsuppliers are not the reciprocal supplier 1
-- we exclude subsuppliers that are also subsuppliers of reciprocal supplier 1
JOIN Subsuppliers 
ON Subsuppliers.sid = reciprocal1.sid2 AND Subsuppliers.subid != reciprocal1.sid1
WHERE subid NOT IN (SELECT subid FROM Subsuppliers WHERE Subsuppliers.sid = reciprocal1.sid1 AND Subsuppliers.subid != reciprocal1.sid2)

