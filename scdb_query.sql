-- Find the total amount of donations each Chicago board member received this year
SELECT d.Chicago_ID AS board_member, m.First_Name AS first_name, m.Last_Name2 AS last_name, SUM(d.Amount) AS donations_received
FROM donations AS d
JOIN members AS m
	ON d.Chicago_ID = m.Member_ID
GROUP BY d.Chicago_ID
ORDER BY d.Chicago_ID;

-- Find the total amount of donations each Chicago member has given to the organization
SELECT d.Member_ID AS member_ID, m.First_Name AS first_name, m.Last_Name2 AS last_name, SUM(d.Amount) AS total_donation
FROM donations AS d
JOIN members AS m
	ON d.Member_ID = m.Member_ID
GROUP BY d.Member_ID
ORDER BY d.Member_ID;

-- Total amount of money received per event
SELECT d.Event AS event, SUM(d.Amount) AS funds
FROM donations AS d
GROUP BY d.Event;

-- Make sure the total amount of money received per event is equal to the total amount of money received
SELECT SUM(d.Amount) AS total
FROM donations AS d;

-- COUNT the # of members in each location
SELECT m.Location_ID, l.Location, COUNT(m.Member_ID) AS Total_Members
FROM members AS m
JOIN location AS l
	ON m.Location_ID = l.Location_ID
GROUP BY m.Location_ID, l.Location
ORDER BY m.Location_ID;

-- OR just do this without the join
SELECT m.Location_ID, COUNT(m.Member_ID) AS Total_Members
FROM members AS m
GROUP BY m.Location_ID
ORDER BY m.Location_ID;

-- Give the SUM of the donations by the Dimaculangan family
SELECT m.Last_Name2 AS family, SUM(d.Amount) as donations
FROM members AS m
JOIN donations AS d
	ON m.Member_ID = d.Member_ID
GROUP BY m.Last_Name2
HAVING m.Last_Name2 = 'Dimaculangan';

-- Now give the SUM of donations per family
SELECT m.Last_Name2 AS family, SUM(d.Amount) as donations
FROM members AS m
JOIN donations AS d
	ON m.Member_ID = d.Member_ID
GROUP BY m.Last_Name2
ORDER BY m.Last_Name2;

-- Give the names of the board members
-- that fundraised more than the AVG amount of donations given at a time
-- (Divide the total amount by the amount of donations made)
SELECT d.Chicago_ID AS board_member, m.First_Name AS first_name, m.Last_Name2 AS last_name, SUM(d.Amount) AS donations
FROM donations AS d
JOIN members AS m
	ON d.Chicago_ID = m.Member_ID
GROUP BY d.Chicago_ID
HAVING SUM(d.Amount) >= (SELECT AVG(Amount)
							FROM donations);

-- Give the names of the board members
-- that fundraised more than the AVG that each board member raised
-- (This is different because you aggregate the amounts that each member raised, and then get the AVG)
SELECT d.Chicago_ID AS board_member, m.First_Name AS first_name, m.Last_Name2 AS last_name, SUM(d.Amount) AS donations_per_member
FROM donations AS d
JOIN members AS m
	ON d.Chicago_ID = m.Member_ID
GROUP BY d.Chicago_ID
HAVING SUM(d.Amount) >= (SELECT AVG(d2.d3amount)
							FROM (SELECT d3.Chicago_ID, SUM(d3.Amount) AS d3amount
									FROM donations AS d3
                                    GROUP BY d3.Chicago_ID) AS d2);