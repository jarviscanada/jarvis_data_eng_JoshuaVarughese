
--[Modifying Data]--
-- 1.
INSERT INTO cd.facilities VALUES (9, 'Spa', 20, 30, 100000, 800);

-- 2.
--INSERT (Columns) SELECT(SELECT key) + 1, ....;
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
Select (select max(facid) from cd.facilities) + 1, 'Spa', 20, 30, 100000, 800;

--3.
Update cd.facilities
set initialoutlay = 10000
Where facid = 1;

--4.
Update cd.facilities
set membercost = (select membercost*1.10 from cd.facilities where facid=0),
	guestcost = (select guestcost*1.10 from cd.facilities where facid=0)
Where facid = 1;

--5.
Delete from cd.bookings;

--6.
delete from cd.members where memid = 37;

--[Basics]--

--1.