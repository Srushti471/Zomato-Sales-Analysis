create database zomato_analysis;
use zomato_analysis;

-- KPI 1
-- CREATE A COUNTRY MAP TABLE

create table country (
                      CountryCode int,
                      CountryName varchar(50));
insert into country values (1,"India"),
						(14,"Australia"),
                        (30,"Brazil"),
                        (37,"Canada"),
                        (94,"Indonesia"),
                        (148,"New Zealand"),
                        (162,"Philippines"),
                        (166,"Qatar"),
                        (184,"Singapore"),
                        (189,"Sounth Africa"),
                        (191,"Sri Lanka"),
                        (208,"Turkey"),
                        (214,"United Arab Emirates"),
                        (215,"united Kingdom"),
                        (216,"United States"),
                        (14,"Australia");
SELECT * FROM COUNTRY;

-- KPI 2 
-- CREATE A CALENDER TABLE

create table calender (
             Datekey_Opening date primary key );

alter table calender drop primary key;
insert into calender (Datekey_Opening) 
select Datekey_Opening from zomato;

select * from calender;


-- ADD OTHER COLUMNS TO THE CALENDER TABLE

alter table calender
			add Year int,
            add MonthNO int,
            add MonthName varchar(20),
            add Quarter varchar(10),
            add YearMonth Varchar(20),
            add WeekdayNo int,
            add WeekdayName varchar(50),
            add FinancialMonth varchar(5),
            add FinancialQuarter varchar(5);
-- UPDATE YEAR
update calender
set year = year(Datekey_Opening);
-- UPDATE MONTH
update calender 
set MonthNo = month(Datekey_Opening);
-- UPDATE MONTHNAME
update calender
set MonthName = date_format(Datekey_Opening,'%M');
-- UPDATE QUARTER
update calender
set Quarter = concat('Q',
Quarter(Datekey_Opening));
-- UPDATE YEAR-MONTH
update calender
set YearMonth = date_format(Datekey_Opening,'%Y-%b');
-- UPDATE WEEKDAY NO WEEKDAY NAME
update calender
set WeekdayNo = weekday(Datekey_Opening)+1;
update calender
set WeekdayName = date_format(Datekey_Opening,'%W');
-- UPDATE FINANCIAL MONTH
update calender
set FinancialMonth = case
     when month(Datekey_Opening) = 4 then 'FM1'
     when month(Datekey_Opening) = 5 then 'FM2'
     when month(Datekey_Opening) = 6 THEN 'FM3'
     when month(Datekey_Opening) = 7 THEN 'FM4'
     when month(Datekey_Opening) = 8 THEN 'FM5'
     when month(Datekey_Opening) = 9 THEN 'FM6'
     when month(Datekey_Opening) = 10 THEN 'FM7'
     when month(Datekey_Opening) = 11 THEN 'FM8'
     when month(Datekey_Opening) = 12 THEN 'FM9'
     when month(Datekey_Opening) = 1 THEN 'FM10'
     when month(Datekey_Opening) = 2 THEN 'FM11'
     when month(Datekey_Opening) = 3 THEN 'FM12'
END;
-- UPDATE FINANCIAL QUARTER
update calender 
set FinancialQuarter = case
    when month(Datekey_Opening) in (4,5,6) then 'FQ1'
    when month(Datekey_Opening) in (7,8,9) then 'FQ2'
    when month(Datekey_Opening) in (10,11,12) then 'FQ3'
    when month(Datekey_Opening) in (1,2,3) then 'FQ4'
END;


-- KPI 3
-- Find the Numbers of Resturants based on City and Country.

select z.city, c.CountryName , count(*) as "No_of_Restaurants"
from zomato z 
join country c 
on z.CountryCode = c.CountryCode
group by z.city , c.CountryName
order by c.CountryName, z.city;


-- KPI 4
-- Numbers of Resturants opening based on Year , Quarter , Month

select
     Year(Datekey_Opening) as "Year",
     Quarter(Datekey_Opening) as "Quarter",
     MonthName(Datekey_Opening) as "Month",
     count(*) as "No_of_Restaurants"
from zomato
group by
	  Year(Datekey_Opening),
     Quarter(Datekey_Opening), 
     MonthName(Datekey_Opening)
order by 
year,quarter,month;


-- KPI 5
-- Count of Resturants based on Average Ratings

select 
     case
        when Rating between 0 and 1 then '0-1'
        when Rating between 1 and 2 then '1-2'
        when Rating between 2 and 3 then '2-3'
        when Rating between 3 and 4 then '3-4'
        when Rating between 4 and 5 then '4-5'
     end as "Rating_Range",
     count(*) as "No_of_Restaurants"
from zomato
group by Rating_Range
order by Rating_Range;

select 
    round(avg(Rating),1) as "Average_Rating",
    count(*) as "No_of_Restaurants"
from zomato;


-- KPI 6
-- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

select Average_Cost_for_two /2 as "Average_Cost"
from zomato;
select 
    case
       when Average_Cost_for_two between 0 and 250 then '0-250'
       when Average_Cost_for_two between 251 and 500 then '251-500'
       when Average_Cost_for_two between 501 and 750 then '501-750' 
       when Average_Cost_for_two between 751 and 1000 then '751-1000'
       when Average_Cost_for_two between 1001 and 1500 then '1001-1500'
       when Average_Cost_for_two between 1501 and 2000 then '1501-2000'
       when Average_Cost_for_two > 2000 then '2000+'
	end as "Bucket_Price",
    count(*) as "No_of_Restaurants"
from zomato
group by Bucket_Price
order by Bucket_Price;

-- KPI 7
-- Percentage of Resturants based on "Has_Table_booking"

select 
     Has_Table_booking,
     count(*) as 'No_of_Restaurants',
     round((count(*) * 100.0 / (select count(*)
from zomato)), 2) as percentage
from
    zomato
group by 
        Has_Table_booking
order by
       percentage desc;

-- KPI 8
-- Percentage of Resturants based on "Has_Online_delivery"

select 
     Has_Online_delivery,
     count(*) as 'No_of_Restaurants',
     round((count(*) * 100.0 / (select count(*)
from zomato)), 2) as percentage
from
    zomato
group by 
        Has_Online_delivery
order by
       percentage desc;
       
-- KPI 9
-- Develop Charts based on Cusines, City, Ratings
select
     City,
     Cuisines,
     Rating,
     count(*) as 'No_of_Restaurants'
from
   zomato
group by
   City,
   Cuisines,
   Rating
Order by
    City,Cuisines,Rating desc;







