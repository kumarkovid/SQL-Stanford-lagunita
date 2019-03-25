/*Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. */
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2, Highschooler H3
where L1.ID2 = L2.ID1
and L2.ID2 <> L1.ID1
and L1.ID1 = H1.ID and L1.ID2 = H2.ID and L2.ID2 = H3.ID;

/*Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. */
select H1.name, H1.grade, H2.name, H2.grade
from Likesselect name, grade
from Highschooler, (
  select ID1 from Friend
  except
  /* students have friends with same grade*/
  select distinct Friend.ID1
  from Friend, Highschooler H1, Highschooler H2
  where Friend.ID1 = H1.ID and Friend.ID2 = H2.ID
  and H1.grade = H2.grade
) as Sample
where Highschooler.ID = Sample.ID1
; L1 join Likes L2 join Highschooler H1 join Highschooler H2
on L1.ID2 = L2.ID1 and L2.ID2 = L1.ID1 and L1.ID1 = H1.ID and L1.ID2 = H2.ID
where H1.name < H2.name;

/*Q3. What is the average number of friends per student? (Your result should be just one number.) */
select avg(count)from (select count(ID2) as count from Friend group by ID1)

/*Q4. Find the number of students who are either friends with Cassandra or are friends of friends of 
      Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */
select count(id2) from friend where id1 in (
  select id2 from friend where id1 in (select id from highschooler where name='Cassandra')
)
and id1 not in (select id from highschooler where name='Cassandra');

/*Q5. Find the name and grade of the student(s) with the greatest number of friends. */
select h.name, h.grade from highschooler h, friend f where
h.id = f.id1 group by f.id1 having count(f.id2) = (
select max(r.c) from
(select count(id2) as c from friend group by id1) as r);