CREATE TABLE products (
    id INT, 
    name VARCHAR(50),
    price INT,
    onSALE boolean
);

CREATE TABLE restaurants (
    id INT,
    name VARCHAR(50),
    location VARCHAR(50),
    price_range INT
);

INSERT INTO restaurants (id, name, location, price_range) values (123, 'mcdonalods', 'new yorks', 3);

select * from restaurants; 

CREATE TABLE restaurants (
    id BIGSERIAL NOT NULL,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL, 
    price_range INT NOT NULL check(price_range >= 1 and price_range <= 5)
);

CREATE TABLE restaurants (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL, 
    price_range INT NOT NULL check(price_range >= 1 and price_range <= 5)
);

CREATE TABLE reviews (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    review TEXT NOT NULL,
    rating INT check(rating >= 1 and rating <= 5)
);

\d to show the entity 

INSERT INTO reviews (name, review, rating) values ('carl', 'restaurant was awesome', 5);

How do we specify and review to associate the restaurant that exist in the restaurant table?

We introduce the foreign key 

drop table reviews;

CREATE TABLE reviews (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    restaurant_id BIGINT NOT NULL REFERENCES restaurants(id),
    name VARCHAR(50) NOT NULL,
    review TEXT NOT NULL,
    rating INT NOT NULL check(rating >= 1 and rating <= 5)
);

INSERT INTO reviews (restaurant_id, name, review, rating) values (2, 'carl', 'restaurant was awesome', 5);

select * from reviews where restaurant_id = 1;

INSERT INTO reviews (restaurant_id,  name, review, rating) values (4, 'mark', 'restaurant good', 4);

select count(*) from reviews; 
to show the number of reviews 

select MIN(rating) from reviews;
to show the minimum rating values

select MAX(rating) from reviews;
to show the maximmum rating values 

select AVG(rating) from reviews;
to show the average rating values

select AVG(rating) AS average_review from reviews;
to show the average rating values and also giving out the name 

select name, rating from reviews;
to show both name and rating 

select name as username, rating as restaurant_rating from review;
the column will update the variable name accordingly 

select AVG(rating) from reviews where restaurant_rating where id = 2;
we will get all the average value from the restaruarnt id is 2

select trunk(AVG(rating),2) from reviews where restaurant_id = 2;
average rating will be in 2 decimal places 

How do we count the total rating that the restaurant has?
select count(rating) from reviews where restaurant_id = 2;

GROUPBY feature
we want to count the restaurant from the specific location 
select location, count(location) from restaurants group by location;

count the number of rating from each of the restaurant 
select restaurant_id, count(restaurant_id) from reviews group by restaurant_id;

select * from restaurants inner join reviews on restaurants.id = reviews.restaurant_id;

select * from restaurants left join (select restaurant_id, COUNT(*), TRUNC(AVG(rating),1) as average_rating from reviews group by restaurant_id) reviews on restaurants.id = reviews.restaurant_id ;