/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. 

Answer:
name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court
*/

SELECT name
FROM Facilities
WHERE `membercost` > 0


/* Q2: How many facilities do not charge a fee to members? Answer: 4 */
SELECT COUNT( * )
FROM Facilities
WHERE `membercost` = 0


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. 
Answer:
facid	name	membercost	
0	Tennis Court 1	5.0
1	Tennis Court 2	5.0
4	Massage Room 1	9.9
5	Massage Room 2	9.9
6	Squash Court	3.5
*/

SELECT facid, name, membercost
FROM `Facilities`
WHERE `membercost` >0
AND `membercost` / `monthlymaintenance` < 0.2



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. 
Answer:
facid	name	        membercost	guestcost	initialoutlay	monthlymaintenance	
1	    Tennis Court 2	    5.0	    25.0	    8000	        200
5	    Massage Room 2	    9.9	    80.0	    4000	        3000
*/
SELECT *
FROM `Facilities`
WHERE `facid`
IN ( 1, 5 )




/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. 

Answer:
name	monthlymaintenance	maintenance_cost	
Tennis Court 1	200	Expensive
Tennis Court 2	200	Expensive
Badminton Court	50	Cheap
Table Tennis	10	Cheap
Massage Room 1	3000	Expensive
Massage Room 2	3000	Expensive
Squash Court	80	Cheap
Snooker Table	15	Cheap
Pool Table	15	Cheap
*/

SELECT `name` , `monthlymaintenance` , 
(CASE WHEN `monthlymaintenance` >100
THEN "Expensive"
ELSE "Cheap"
END) AS "maintenance_cost"
FROM `Facilities`


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. 
Answer:
firstname	surname	
Darren	Smith
*/

SELECT firstname, surname
FROM Members
WHERE memid = (
SELECT MAX( memid ) AS id
FROM Members )

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. 

Answer:
Name	Facility_Name	
Tracy Smith	Tennis Court 1
GUEST GUEST	Tennis Court 2
GUEST GUEST	Tennis Court 1
Tim Rownam	Tennis Court 2
Tim Rownam	Tennis Court 1
Darren Smith	Tennis Court 2
Janice Joplette	Tennis Court 1
Gerald Butters	Tennis Court 1
Janice Joplette	Tennis Court 2
Tracy Smith	Tennis Court 2
Gerald Butters	Tennis Court 2
Tim Boothe	Tennis Court 2
Burton Tracy	Tennis Court 2
Burton Tracy	Tennis Court 1
Nancy Dare	Tennis Court 2
Nancy Dare	Tennis Court 1
Tim Boothe	Tennis Court 1
Ponder Stibbons	Tennis Court 2
Charles Owen	Tennis Court 1
Charles Owen	Tennis Court 2
Anne Baker	Tennis Court 1
David Jones	Tennis Court 2
Jack Smith	Tennis Court 1
Anne Baker	Tennis Court 2
David Jones	Tennis Court 1
Timothy Baker	Tennis Court 2
Florence Bader	Tennis Court 2
Timothy Baker	Tennis Court 1
David Pinker	Tennis Court 1
Jemima Farrell	Tennis Court 2
Ponder Stibbons	Tennis Court 1
Ramnaresh Sarwin	Tennis Court 2
Joan Coplin	Tennis Court 1
Douglas Jones	Tennis Court 1
Ramnaresh Sarwin	Tennis Court 1
Jack Smith	Tennis Court 2
Jemima Farrell	Tennis Court 1
David Farrell	Tennis Court 1
Millicent Purview	Tennis Court 2
Henrietta Rumney	Tennis Court 2
Florence Bader	Tennis Court 1
John Hunt	Tennis Court 1
John Hunt	Tennis Court 2
David Farrell	Tennis Court 2
Matthew Genting	Tennis Court 1
Erica Crumpet	Tennis Court 1


*/

SELECT DISTINCT CONCAT( m.firstname, ' ', m.surname ) AS Name, f.name AS Facility_Name
FROM Members AS m
INNER JOIN Bookings AS b ON m.memid = b.memid
INNER JOIN Facilities AS f ON b.facid = f.facid
WHERE b.facid
IN (
SELECT facid
FROM Facilities
WHERE name LIKE 'Tennis Court%'
)

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. 

Answer:
Member	Facility	cost	
GUEST	Massage Room 2	320.0
GUEST	Massage Room 1	160.0
GUEST	Massage Room 1	160.0
GUEST	Massage Room 1	160.0
GUEST	Tennis Court 2	150.0
GUEST	Tennis Court 2	75.0
GUEST	Tennis Court 1	75.0
GUEST	Tennis Court 1	75.0
GUEST	Squash Court	70.0
Farrell	Massage Room 1	39.6
GUEST	Squash Court	35.0
GUEST	Squash Court	35.0

Tried these but none of them works:



SELECT f.name as Facility, CONCAT( m.firstname, ' ', m.surname ) AS Name,
CASE WHEN memid
FROM `Facilities` as f WHERE starttime = '2012-09-14'

SELECT f.name as Facility, CONCAT( m.firstname, ' ', m.surname ) AS Name,
(CASE WHEN b.memid = 0 then f.guestcost*b.slots
	 ELSE f.membercost*b.slots END) as Cost
FROM `Facilities` as f
WHERE starttime like '2012-09-14%';



SELECT f.name as Facility, CONCAT( m.firstname, ' ', m.surname ) AS Name,
(CASE WHEN b.memid = 0 then f.guestcost*b.slots
	 ELSE f.membercost*b.slots END) as Cost
FROM Bookings as b
INNER JOIN Members as m
INNER JOIN Facilities as f
WHERE starttime like '2012-09-14%';




WITH 
	cost_list as (SELECT f.name AS Facility, CONCAT( m.firstname, ' ', m.surname ) AS Name, 
    (CASE WHEN b.memid = 0
	THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
	END) AS Cost
	FROM Bookings AS b
	INNER JOIN Members AS m
	INNER JOIN Facilities AS f
	WHERE starttime LIKE '2012-09-14%')
select Facility, Name, Cost from cost_list where Cost > 30;


WITH
  cte1 AS (SELECT name, facid FROM Facilities),
  cte2 AS (SELECT starttime, facid FROM Bookings)
SELECT 
	name, starttime FROM cte1 INNER JOIN cte2
	WHERE cte1.facid = cte2.facid;

*/

SELECT surname AS Member, name AS Facility,
CASE
    WHEN Members.memid =0
    THEN Bookings.slots * Facilities.guestcost
    ELSE Bookings.slots * Facilities.membercost
END AS cost
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
    WHERE Bookings.starttime >= '2012-09-14'
    AND Bookings.starttime < '2012-09-15'
    AND ((Members.memid =0
    AND Bookings.slots * Facilities.guestcost >30)
OR (Members.memid !=0
    AND Bookings.slots * Facilities.membercost >30))
ORDER BY cost DESC




/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT surname AS Member, name AS Facility,
CASE
    WHEN Members.memid =0
    THEN Bookings.slots * Facilities.guestcost
    ELSE Bookings.slots * Facilities.membercost
END AS cost
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
    WHERE Bookings.starttime IN (select starttime from Bookings where starttime like '2012-09-14%')
    AND ((Members.memid =0
    AND Bookings.slots * Facilities.guestcost >30)
OR (Members.memid !=0
    AND Bookings.slots * Facilities.membercost >30))
ORDER BY cost DESC

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

