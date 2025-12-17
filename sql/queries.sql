-- Table Setup (DDL)
CREATE TABLE cd.members
    (
       memid integer NOT NULL,
       surname character varying(200) NOT NULL,
       firstname character varying(200) NOT NULL,
       address character varying(300) NOT NULL,
       zipcode integer NOT NULL,
       telephone character varying(20) NOT NULL,
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    );

CREATE TABLE cd.facilities
    (
       facid integer NOT NULL,
       name character varying(100) NOT NULL,
       membercost numeric NOT NULL,
       guestcost numeric NOT NULL,
       initialoutlay numeric NOT NULL,
       monthlymaintenance numeric NOT NULL,
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );

CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL,
       facid integer NOT NULL,
       memid integer NOT NULL,
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    );

-- Question 1
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    values (9, 'Spa', 20, 30, 100000, 800);

-- Question 2
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

-- Question 3
update cd.facilities
    set initialoutlay = 10000
    where facid = 1;

-- Question 4
update cd.facilities facs
    set
        membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
        guestcost = (select guestcost * 1.1 from cd.facilities where facid = 0)
    where facs.facid = 1;

-- Question 5
delete from cd.bookings;

-- Question 6
delete from cd.members where memid = 37;

-- Question 7
Select
  facid,
  name,
  membercost,
  monthlymaintenance
from
  cd.facilities
Where
  membercost > 0
  and membercost < monthlymaintenance / 50;

-- Question 8
Select
  *
from
  cd.facilities
Where
  name LIKE '%Tennis%';

-- Question 9
Select
  *
from
  cd.facilities
Where
  facid in (1, 5);

-- Question 10
Select
  memid,
  surname,
  firstname,
  joindate
from
  cd.members
where
  joindate >= '2012-09-01';

-- Question 11
(
  select
    surname
  from
    cd.members
)
union
  (
    select
      name
    from
      cd.facilities
  );

-- Question 12
Select
  b.starttime
from
  cd.bookings as b
  INNER JOIN cd.members as m ON b.memid = m.memid
Where
  m.firstname = 'David'
  and m.surname = 'Farrell';

-- Question 13
select
  b.starttime,
  f.name
from
  cd.bookings as b
  Inner Join cd.facilities as f On b.facid = f.facid
Where
  f.name LIKE '%Tennis Court%'
  and Date(b.starttime) = '2012-09-21'
Order by
  b.starttime ASC;

-- Question 14
select
  mem.firstname,
  mem.surname,
  rec.firstname,
  rec.surname
from
  cd.members as mem
  left join cd.members as rec on mem.recommendedby = rec.memid
order by
  mem.surname,
  mem.firstname;

-- Question 15
Select
  distinct mem.firstname,
  mem.surname
from
  cd.members as mem
  inner join cd.members as rec on rec.recommendedby = mem.memid
order by
  surname,
  firstname;

-- Question 16
select
  distinct (firstname || ' ' || surname) as mem_name,
  (
    select
      (firstname || ' ' || surname)
    from
      cd.members as rec
    Where
      rec.memid = mem.recommendedby
  )
from
  cd.members as mem
order by
  mem_name;

-- Question 17
Select
  recommendedby,
  count(*)
from
  cd.members
Where
  recommendedby is not null
group by
  recommendedby
order by
  recommendedby;

-- Question 18
select
  facid,
  sum(slots) as totalslots
from
  cd.bookings
group by
  facid
order by
  facid;

-- Question 19
select
  facid,
  sum(slots) as total_slots
from
  cd.bookings
where
  date(starttime) >= '2012-09-01'
  and date(starttime) < '2012-10-01'
group by
  facid
order by
  total_slots;

-- Question 20
select
  facid,
  extract(
    MONTH
    from
      starttime
  ) AS month,
  sum(slots) as total_slots
from
  cd.bookings
where
  date(starttime) >= '2012-01-01'
  and date(starttime) < '2013-01-01'
group by
  facid,
  month
order by
  facid,
  month;

-- Question 21
select
  count(
    distinct(mem.memid)
  )
from
  cd.members as mem
  inner join cd.bookings as book on mem.memid = book.memid;

-- Question 22
select
  mem.surname,
  mem.firstname,
  mem.memid,
  min(book.starttime)
from
  cd.members as mem
  inner join cd.bookings as book on mem.memid = book.memid
where
  date(book.starttime) >= '2012-09-01'
group by
  mem.surname,
  mem.firstname,
  mem.memid
order by
  mem.memid;

-- Question 23
select
  (
    select
      count(*)
    from
      cd.members
  ),
  firstname,
  surname
from
  cd.members
order by
  joindate;

-- Question 24
select
  row_number() over(
    order by
      joindate
  ),
  firstname,
  surname
from
  cd.members
order by
  joindate;

-- Question 25
select
  facid,
  total
from
  (
    select
      facid,
      sum(slots) total,
      rank() over (
        order by
          sum(slots) desc
      ) rank
    from
      cd.bookings
    group by
      facid
  ) as ranked
where
  rank = 1;

-- Question 26
Select
  surname || ', ' || firstname as name
from
  cd.members;

-- Question 27
select
  memid,
  telephone
from
  cd.members
where
  telephone ~ '[()]';

-- Question 28
select
  substr (mem.surname, 1, 1) as letter,
  count(*) as count
from
  cd.members as mem
group by
  letter
order by
  letter;
