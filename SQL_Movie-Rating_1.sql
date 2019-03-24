/*Q1. Find the titles of all movies directed by Steven Spielberg.*/
Select title from Movie 
where director ='Steven Spielberg';

/*Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/
select year from movie where mID in(select mID from Rating where stars=4 or stars=5) order by year;

/*Q3. Find the titles of all movies that have no ratings.*/
select title
from Movie
where Movie.mID not in (select mid from Rating);

/*Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */
select name from Reviewer where rID in (select rID from Rating where ratingDate is NULL);

/*Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
	Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.*/
select distinct reviewer.name, movie.title, Rating.stars, Rating.ratingDate from movie natural join Reviewer
natural join Rating order by Reviewer.name,movie.title,Rating.stars;

/*Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name
      and the title of the movie. */
select DISTINCT name, title
from Rating R1 natural join Movie natural join Reviewer
where R1.mID in( select mID as counter from Rating R2 where R2.rID = R1.rID group by R2.mID having count(*) = 2) 
and (select stars from Rating R3 where R3.rID = R1.rID and R1.mID = R3.mID order by R3.ratingDate LIMIT 1) < 
(select stars from Rating R3 where R3.rID = R1.rID and R1.mID = R3.mID order by R3.ratingDate DESC LIMIT 1);

/*Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */
select title,max(stars) from Movie M natural join Rating R1 group by title order by title;

/*Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
      Sort by rating spread from highest to lowest, then by movie title. */
select title,max(stars)-min(stars) as spread from Rating Natural join Movie group by Rating.mID
order by spread DESC, title;

/*Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie,
 then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)*/
select downavg-upavg
from (select avg(av) as upavg
    from (select avg(stars) as av
      from Movie natural join Rating
      where year > 1980
      group by mID) as u ) as up,
  (select avg(av) as downavg
    from (select avg(stars) as av
      from Movie natural join Rating
      where year < 1980
      group by mID) as d
) as down;