create database airline;
select *from maindata;
alter table maindata rename column `%Airline ID` to `Airline_id`;
alter table maindata rename column `%Carrier Group ID` to `Carrier_group_ID`;
alter table maindata rename column `%Region Code` to `Region_code`;
alter table maindata rename column `%Unique Carrier Code` to `Unique_Carrier_Code`;
alter table maindata rename column `%Origin Airport ID` to `Origin_Airport_ID`;
alter table maindata rename column `# Departures Scheduled` to `Departures_scheduled`;
alter table maindata rename column `# Departures Performed` to `Departures_performed`;
alter table maindata rename column `# Payload` to `Payload`;
alter table maindata rename column `# Available Seats` to `Available_seats`;
alter table maindata rename column `# Transported Passengers` to `Transported_passengers`;
alter table maindata rename column `# Transported Freight` to `Transported_Freight`;
alter table maindata rename column `# Transported Mail` to `Transported_Mail`;
alter table maindata rename column `# Air Time` to `Air_Time`;
alter table maindata rename column `Unique Carrier` to `Unique_Carrier`;
alter table maindata rename column `Carrier Code` to `Carrier_code`;
alter table maindata rename column `Carrier Name` to `Carrier_Name`;
alter table maindata rename column `Origin Airport Code` to `Origin_Airport_Code`;
alter table maindata rename column `Origin City` to `Origin_city`;
alter table maindata rename column `Origin Country` to `Origin_country`;
alter table maindata rename column `Origin State` to `Origin_State`;
alter table maindata rename column `Destination Airport Code` to `Destination_Airport_Code`;
alter table maindata rename column `Destination City` to `Destination_City`;
alter table maindata rename column `Destination Country` to `Destination_country`;
alter table maindata rename column `Destination State` to `Destination_state`;
alter table maindata rename column `From - To City` to `From_to_city`;
alter table maindata
add column fulldate date;
update maindata
set fulldate = str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d');
select (concat_WS(Year,'-',Month,'-',Day),'%Y-%m-%d') as fulldate from maindata;

-- Q1
create view kpi1 as
select Year,Month as monthno,monthname(str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d')) as Monthname,
concat('Q',Quarter(str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d'))) as Quarter,
date_format(str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d'),'%Y-%m') as Yearmonth,
weekday(str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d')) + 1 as Weekno,
dayname(str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d')) as Weekdayname,
case
when Month >=4 then Month-3
else Month + 9
end as Financialmonth,
case
when Month between 4 and 6 then 'Q1'
when Month between 7 and 9 then 'Q2'
when Month between 10 and 12 then 'Q3'
else 'Q4'
end as Financialquarter,
str_to_date(concat_WS('-',Year,Month,Day), '%Y-%m-%d') as fulldate from maindata;
select * from kpi1;


-- Q2(Transported passengers/available seats
create view kpi2 as
select year,
Month,case
when Month between 4 and 6 then 'Q1'
when Month between 7 and 9 then 'Q2'
when Month between 10 and 12 then 'Q3'
else 'Q4'
end as Quarter, sum(Transported_passengers) / sum(Available_seats) * 100 as Load_factor_percentage from maindata
group by Year,Month,case
when Month between 4 and 6 then 'Q1'
when Month between 7 and 9 then 'Q2'
when Month between 10 and 12 then 'Q3'
else 'Q4'
end;
select * from kpi2;
drop view kpi2

-- Q3
create view kpi3 as
select Carrier_name,sum(Transported_passengers) / sum(Available_seats) * 100 as Load_factor_percentage from maindata
group by Carrier_name
order by Load_factor_percentage desc;
select*from kpi3

-- Q4
create view kpi4 as
select Carrier_name,sum(Transported_passengers) as Total_passengers from maindata
group by Carrier_name
order by Total_passengers desc
limit 10;
select * from kpi4;

-- Q5
drop view kpi5
create view kpi5 as
select From_to_city,count(*) as Number_of_flights from maindata
group by From_to_city
order by Number_of_flights desc
limit 10;
select * from kpi5

-- Q6
create view kpi6 as
select 
case
when Dayofweek(fulldate) in (1,7) then 'Weekend'
else 'Weekday'
end as Daytype,sum(Transported_passengers) as Total_passengers,
sum(Available_seats) as Total_seats,
round(sum(Transported_passengers)/sum(Available_seats) * 100,2) as Load_factor_percentage from maindata
group by Daytype;
select * from kpi6;

-- Q7
create view kpi7 as
select Distance,count(*) as Number_of_flights from maindata
group by Distance
order by Distance;
select*from kpi7;






