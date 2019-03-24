/*Q1. Find the names of all reviewers who rated Gone with the Wind. */
select Reviewer.name from Reviewer where rID in
(select rID from Rating where mID in (select mID from Movie where title='Gone with the Wind'));

/*Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
select R1.name,M.title,R1.stars from Movie M,
(select mID, Re.name, Ra.stars from Reviewer Re,
Rating Ra on Re.rID=Ra.rID) R1 on M.mID=R1.mID
where R1.name = M.director;

/*Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name
      of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)  */
select name from Reviewer R  
Union
Select title from Movie
order by R.name;

/*Q4. Find the titles of all movies not reviewed by Chris Jackson. */
select title from Movie where mID not in(select mID from Rating where rID in(select rID from Reviewer where name='Chris Jackson'));

/*Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, 
      don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.  */
select Re.name,M.title,Ra.stars from Rating Ra,Reviewer Re,Movie M where Ra.rId=Re.rID and M.mID=Ra.mID
and stars in (select min(stars) from Rating);

/*Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.  */
select R1.name,M.title,R1.stars from Movie M,
(select mID, Re.name, Ra.stars from Reviewer Re,
Rating Ra on Re.rID=Ra.rID) R1 on M.mID=R1.mID
where R1.stars = (select min(stars) from Rating);
        
/*Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them 
	in alphabetical order.  */
select M.title, R1.stars from Movie M,(select Rating.mID,avg(stars) as stars
from Rating group by Rating.mID) R1 on M.mID= R1.mID 
order by R1.stars DESC,M.title;

/*Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or
      without COUNT.) */
select name from Reviewer
where Reviewer.rID IN 
(Select rID from Rating group by rID having count(Rating.rID)>=3);

/*Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director
      name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)  */
select title,director from Movie where director in 
(select director from Movie group by director having count(director)>1) order by director, title;

/*Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to 
	   write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that 
       average rating.) */
select M.title,R1.avg_stars from Movie M,(select R.mID,avg(R.stars) as avg_stars from Rating R group by R.mID) R1 
on M.mID= R1.mID 
order by R1.avg_stars DESC LIMIT 1;

/*Q11. Find the movies with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write
 in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */
select M.title,R1.avg_stars 
from Movie M,
(select R.rID,R.mID,avg(R.stars) as avg_stars from Rating R group by R.mID order by avg_stars) R1 
on M.mID=R1.mID order by avg_stars LIMIT ;

/*Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among
 all of their movies, and the value of that rating. Ignore movies whose director is NULL.  */
select M.director,M.title,max(R.stars) from Rating R,Movie M
where M.mID=R.mID and director is not NULL group by M.director;