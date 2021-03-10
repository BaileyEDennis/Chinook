--1 Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, LastName, CustomerId 
FROM Customer WHERE Country != 'USA'

--2 Provide a query only showing the Customers from Brazil.
SELECT FirstName, LastName, CustomerId
FROM Customer where Country = 'Brazil'

/*3 Provide a query showing the Invoices of customers who are from Brazil. 
The resultant table should show the customer's full name, Invoice ID, 
Date of the invoice and billing country. */
SELECT c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
FROM Customer c
	join Invoice i
		on i.CustomerId = c.CustomerId 
where c.Country = 'Brazil'

-- 4 Provide a query showing only the Employees who are Sales Agents.
SELECT FirstName, LastName, Title
	FROM Employee e
	where e.Title like 'Sales %'

--5 Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT distinct BillingCountry From Invoice

/* 6 Provide a query that shows the invoices associated with each sales agent. 
The resultant table should include the Sales Agent's full name. */
SELECT i.*, e.FirstName, e.LastName
from Invoice i
join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
	order by e.EmployeeId

-- 7 Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total, c.FirstName as CustomerFirstName, C.LastName as CustomerLastName, c.Country, e.FirstName as AgentFirstName, e.LastName as AgentLastName
FROM Invoice i
join Customer c
	on i.CustomerId = c.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
order by c.CustomerId

-- 8 How many Invoices were there in 2009 and 2011?
SELECT year(i.invoiceDate) as 'YEAR', count(*)
from invoice i
where year(i.InvoiceDate) = '2009' OR year(i.InvoiceDate) = '2011'
group by year(i.invoiceDate)

--9 What are the respective total sales for each of those years?
SELECT year(i.InvoiceDate) as 'YEAR', sum(i.Total) as totalSales
FROM invoice i
where year(i.InvoiceDate) = '2009' OR year(i.InvoiceDate) = '2011'
GROUP BY year(i.InvoiceDate)

--10 Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT sum(i.InvoiceId) as LineItems
FROM InvoiceLine i
WHERE InvoiceId = '37'

--11 Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT il.InvoiceId, count(*) as LineItems
FROM InvoiceLine il
GROUP BY il.InvoiceId

--12 Provide a query that includes the purchased track name with each invoice line item.
SELECT il.*, t.Name
FROM InvoiceLine il
join Track t
	ON il.TrackId = t.TrackId
	ORDER BY il.InvoiceId

--13 Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT il.*, t.[Name] as TrackName, ar.[Name] as ArtistName
FROM InvoiceLine il --trackId
JOIN Track t
	on il.TrackId = t.TrackId
	JOIN Album a
	on t.AlbumId = a.AlbumId
	JOIN Artist ar
	on a.ArtistId = ar.ArtistId
	ORDER BY il.InvoiceId

--14  Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT i.BillingCountry as Country, count(*) as NumberOfInvoices
FROM Invoice i
GROUP BY i.BillingCountry

--15 Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
SELECT p.Name ,count(*) as NumberOfTracks
FROM Playlist p
JOIN PlaylistTrack pt
ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name

--16 Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT t.name as TrackName, a.Title as AlbumTitle, m.Name as MediaType, g.Name as Genre
FROM Track t
JOIN Album a
	ON t.AlbumId = a.AlbumId
	JOIN MediaType m
	ON t.MediaTypeId = m.MediaTypeId
	JOIN Genre g
	ON t.GenreId = g.GenreId
ORDER BY t.TrackId

--17 Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT * 
FROM Invoice i
	join (
	select invoiceId, count(*) as numberoflineitems
	from InvoiceLine
	group by InvoiceId
	) linecount
	on linecount.InvoiceId = i.invoiceId

--18 Provide a query that shows total sales made by each sales agent
SELECT e.FirstName, e.LastName, sum(i.Total) as TotalSales
from Invoice i
JOIN Customer c
	ON i.CustomerId = c.CustomerId
	JOIN Employee e
	ON c.SupportRepId = e.EmployeeId
	GROUP BY e.LastName, e.FirstName
	ORDER BY TotalSales DESC

--19 Which sales agent made the most in sales in 2009? HINT: TOP
SELECT TOP 1 e.FirstName, e.LastName, sum(i.Total) as TOTAL
FROM Invoice i
	JOIN Customer c
	ON i.CustomerId = c.CustomerId
	JOIN Employee e
	ON c.SupportRepId = e.EmployeeId
	WHERE year(i.InvoiceDate) = '2009'
	GROUP BY e.LastName, e.FirstName

--20 Which sales agent made the most in sales over all?
SELECT TOP 1 e.LastName, e.FirstName
FROM InvoiceLine il
	join Invoice i
		ON il.InvoiceId = i.InvoiceId
	join Customer C
		ON c.CustomerId = i.CustomerId
	Join Employee e
		ON e.EmployeeId = c.SupportRepId
GROUP BY e.LastName, e.FirstName

--21 Provide a query that shows the count of customers assigned to each sales agent.
SELECT e.FirstName, e.LastName, count(*) as TotalCustomers
FROM Customer c
	JOIN Employee e
	ON c.SupportRepId = e.EmployeeId
	GROUP BY e.FirstName, e.LastName
	ORDER BY TotalCustomers DESC

--22 Provide a query that shows the total sales per country.
SELECT i.BillingCountry, sum(i.Total) as TotalSales
FROM Invoice i
GROUP BY i.BillingCountry
ORDER BY TotalSales DESC
	
--23 Which country's customers spent the most?
SELECT TOP 1 i.BillingCountry, sum(i.Total) as TotalSales
FROM Invoice i
GROUP BY i.BillingCountry
ORDER BY TotalSales DESC

--24 Provide a query that shows the most purchased track of 2013.
SELECT t.Name, COUNT(il.TrackId) AS NumberOfSales
FROM Track t
Join InvoiceLine il on t.TrackId = il.TrackId
join Invoice i on il.InvoiceId = i.InvoiceId
Where year(i.InvoiceDate) = 2013
Group by t.name
HAVING count(*) = (SELECT top 1 COUNT(il.trackID)
FROM Track t
Join InvoiceLine il on t.TrackId = il.TrackId
join Invoice i on il.InvoiceId = i.InvoiceId
Where year(i.InvoiceDate) = 2013
Group By t.name
ORDER BY 1 DESC)

--25 Provide a query that shows the top 5 most purchased songs.
SELECT TOP 5 t.name, count(il.Quantity) as Sold
FROM InvoiceLine il
	JOIN Invoice i
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	GROUP BY t.name
	ORDER BY Sold

--26 Provide a query that shows the top 3 best selling artists.
SELECT TOP 3 a.Name, count(il.Quantity) as Sold
FROM InvoiceLine il
	JOIN Invoice i
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN Album al
	ON t.AlbumId = al.AlbumId
	Join Artist a
	ON al.ArtistId = a.ArtistId
	GROUP BY a.Name
	ORDER BY Sold DESC

--27 Provide a query that shows the most purchased Media Type.
SELECT TOP 1 m.Name, count(il.Quantity) as PurchasedAmount
FROM Invoice i
	JOIN InvoiceLine il
	ON i.InvoiceId = il.InvoiceId
	JOIN Track t
	ON il.TrackId = t.TrackId
	JOIN MediaType m
	ON t.MediaTypeId = m.MediaTypeId
	GROUP BY m.Name
	ORDER BY PurchasedAmount DESC

