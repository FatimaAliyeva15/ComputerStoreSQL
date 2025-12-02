create database StoreDB

create table Categories(
Id int primary key identity,
[Name] nvarchar(60) not null
)

create table Brands(
Id int primary key identity,
[Name] nvarchar(60) not null
)

create table Models(
Id int primary key identity,
[Name] nvarchar(60) not null,
BrandId int foreign key references Brands(Id)
)

create table Products(
Id int primary key identity,
[Name] nvarchar(60) not null,
Price decimal(10,2),
StockCount int,
CategoryId int foreign key references Categories(Id),
ModelId int foreign key references Models(Id)
)

create table Branches(
Id int primary key identity,
[Name] nvarchar(60) not null,
[Location] nvarchar(60) not null
)

create table Employees(
Id int primary key identity,
[Name] nvarchar(60) not null,
Surname nvarchar(60) not null,
Age int,
Salary decimal(10,2),
BranchId int foreign key references Branches(Id)
)

create table Sales(
Id int primary key identity,
SaleDate datetime2,
Quantity int,
ProductId int foreign key references Products(Id),
BranchId int foreign key references Branches(Id),
TotalAmount decimal(10,2),
EmployeeId int foreign key references Employees(Id)
)

insert into Categories([Name]) values
('Electronics'),
('Home Appliances'),
('Computers'),
('Smartphones'),
('Accessories');


insert into Brands([Name]) values
('Samsung'),
('Apple'),
('Xiaomi'),
('LG'),
('HP');

insert into Models([Name], BrandId) values
('Galaxy S Series', 1),
('Galaxy A Series', 1),
('iPhone 14', 2),
('iPhone 13', 2),
('Redmi Note', 3),
('Mi Series', 3),
('UltraGear', 4),
('Pavilion', 5);


insert into Products([Name], Price, StockCount, CategoryId, ModelId) values
('Samsung Galaxy S22', 1500.00, 20, 4, 1),
('Samsung Galaxy A54', 800.00, 50, 4, 2),
('iPhone 14 Pro', 2400.00, 15, 4, 3),
('iPhone 13', 1900.00, 25, 4, 4),
('Xiaomi Redmi Note 11', 600.00, 40, 4, 5),
('Xiaomi Mi 11', 900.00, 30, 4, 6),
('LG UltraGear Monitor', 700.00, 10, 1, 7),
('HP Pavilion Laptop', 1400.00, 12, 3, 8);

insert into Branches([Name], [Location]) values
('Nizami Branch', 'Nizami street'),
('28 May Branch', '28 May street'),
('Ganjlik Branch', 'Ganjlik mall');

insert into Employees([Name], Surname, Age, Salary, BranchId) values
('Aysel', 'Aliyeva', 28, 1200.00, 1),
('Nurlan', 'Huseynov', 32, 1500.00, 1),
('Elvin', 'Mammadov', 26, 1100.00, 2),
('Sevinc', 'Ismayilova', 30, 1300.00, 2),
('Ramil', 'Asadov', 35, 1600.00, 3);


insert into Sales(SaleDate, Quantity, ProductId, BranchId, TotalAmount, EmployeeId) values
('2025-01-10', 1, 1, 1, 1500.00, 1),
('2025-01-11', 2, 2, 1, 1600.00, 2),
('2025-01-15', 1, 3, 2, 2400.00, 3),
('2025-01-20', 3, 5, 3, 1800.00, 5),
('2025-01-25', 1, 8, 2, 1400.00, 4);

Select * From Products

Select * From Employees


Select p.Name, c.Name
From Products p
Join Categories c On p.CategoryId = c.Id

Select * 
From Employees
Where Employees.Name = 'Nurlan'

Select * 
From Employees
Where Employees.Age < 30

Select m.Name as Model, count(p.Id) as ProductCount
From Models m
Left join Products p On p.ModelId = m.Id
Group by m.Name


Select b.Name as Brand, m.Name as Model, Count(p.Id) as ProductCount
From Brands b
Join Models m On m.BrandId = b.Id
Left join Products p on p.ModelId = m.Id
group by b.Name, m.Name


select b.Name as Branch, sum(s.TotalAmount) as MonthlyAmount
From Sales s
Join Branches b On s.BranchId = b.Id 
where month(s.SaleDate) = '01'
group by b.Name

Select Top 1 m.Name as Model, sum(s.Quantity) as TotalSold
From Sales s
Join Products p On s.ProductId = p.Id
Join Models m On p.ModelId = m.Id
where month(s.SaleDate) = '01'
group by m.Name
Order by TotalSold desc




Select Top 1 e.Name as Employee, sum(s.TotalAmount) as TotalSales
From Sales s
Join Employees e On s.EmployeeId = e.Id
where month(s.SaleDate) = '01'
group by e.Name
Order by TotalSales asc


Select e.Name as Employee, sum(s.TotalAmount) as TotalSales
From Employees e
join Sales s on e.Id = s.EmployeeId
where month(s.SaleDate) = '01'
group by e.Name, e.Surname
having sum(s.TotalAmount) > 1500

Select [Name] + ' ' + Surname as Fullname
From Employees 

Select [Name], Len(Name) as NameLength
From Products

Select Top 1 *
From Products
Order by Price desc

select * from Products
where Price = (select max(Price) from Products)
   or Price = (select min(Price) from Products)

select Name,Price,
case
when Price < 1000 then 'Appropriate'
when Price between 1000 and 2500 then 'Average price'
when Price > 2500 then 'Expensive'
end as PriceCategory
from Products


select sum(TotalAmount) as MonthlyTotal
from Sales
where month(SaleDate) = month(getdate())


select top 1 e.Id, e.Name, e.Surname, sum(s.TotalAmount) as TotalSales
from Employees e
join Sales s on e.Id = s.EmployeeId
where month(s.SaleDate) = month(getdate())
group by e.Id, e.Name, e.Surname
order by TotalSales desc


select top 1 e.Id, e.Name, e.Surname, sum(s.TotalAmount) as Amount
from Employees e
join Sales s on e.Id = s.EmployeeId
where month(s.SaleDate) = month(getdate())
group by e.Id, e.Name, e.Surname
order by Amount desc

update Employees
set Salary = Salary * 1.5
where Id = (
    select top 1 EmployeeId
    from Sales
    where month(SaleDate) = month(getdate())
    group by EmployeeId
    order by sum(TotalAmount) desc
)
