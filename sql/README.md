# Introduction
This project is a hands-on learning exercise focused on relational database design and practical SQL querying using PostgreSQL, built around a simple club management system with members, facilities, and bookings. It helps users progress from basic SQL operations such as creating tables and inserting, updating, and deleting data to more advanced concepts including joins, subqueries, aggregations, filtering, and window functions like row_number() and rank(). The project also emphasizes good database design practices, such as primary and foreign keys, referential integrity, and normalization. It is intended for beginners and junior developers who want to strengthen both their SQL skills and their understanding of how real-world data models are structured.
# SQL Queries

###### Table Setup (DDL)
```sql
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
```
```sql
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
```
```sql
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
```

###### Question 1:
```sql
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    values (9, 'Spa', 20, 30, 100000, 800);       
```

###### Question 2:
```sql
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```

###### Question 3:
```sql
update cd.facilities
    set initialoutlay = 10000
    where facid = 1; 
```

###### Question 4:
```sql
update cd.facilities facs
    set
        membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
        guestcost = (select guestcost * 1.1 from cd.facilities where facid = 0)
    where facs.facid = 1; 
```

###### Question 5:
```sql
delete from cd.bookings; 
```

###### Question 6:
```sql
delete from cd.members where memid = 37;     
```

###### Question 7:
```sql
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

```

###### Question 8:
```sql
Select 
  * 
from 
  cd.facilities 
Where 
  name LIKE '%Tennis%';

```

###### Question 9:
```sql
Select 
  * 
from 
  cd.facilities 
Where 
  facid in (1, 5);

```

###### Question 10:
```sql
Select 
  memid, 
  surname, 
  firstname, 
  joindate 
from 
  cd.members 
where 
  joindate >= '2012-09-01';
```

###### Question 11:
```sql
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

```

###### Question 12:
```sql
Select 
  b.starttime 
from 
  cd.bookings as b 
  INNER JOIN cd.members as m ON b.memid = m.memid 
Where 
  m.firstname = 'David' 
  and m.surname = 'Farrell';

```

###### Question 13:
```sql
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

```
###### Question 14:
```sql
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
  mem.firstname
```

###### Question 15:
```sql
Select 
  distinct mem.firstname, 
  mem.surname 
from 
  cd.members as mem 
  inner join cd.members as rec on rec.recommendedby = mem.memid 
order by 
  surname, 
  firstname;
```

###### Question 16:
```sql
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
  mem_name
```

###### Question 17:
```sql
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
  recommendedby

```

###### Question 18:
```sql
select 
  facid, 
  sum(slots) as totalslots 
from 
  cd.bookings 
group by 
  facid 
order by 
  facid

```

###### Question 19:
```sql
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
  total_slots

```

###### Question 20:
```sql
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
  month
```

###### Question 21:
```sql
select 
  count(
    distinct(mem.memid)
  ) 
from 
  cd.members as mem 
  inner join cd.bookings as book on mem.memid = book.memid

```

###### Question 22:
```sql
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
  mem.memid
```

###### Question 23:
```sql
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
  joindate
```

###### Question 24:
```sql
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
  joindate

```

###### Question 25:
```sql
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
  rank = 1

```

###### Question 26:
```sql
Select 
  surname || ', ' || firstname as name 
from 
  cd.members

```

###### Question 27:
```sql
select 
  memid, 
  telephone 
from 
  cd.members 
where 
  telephone ~ '[()]'
```

###### Question 28:
```sql
select 
  substr (mem.surname, 1, 1) as letter, 
  count(*) as count 
from 
  cd.members as mem 
group by 
  letter 
order by 
  letter
```



