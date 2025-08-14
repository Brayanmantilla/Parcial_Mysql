USE Chinook;

    -- • Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.

SELECT e.FirstName, e.LastName, COUNT(SupportRepId) as Numero_clientes
FROM Employee e 
INNER JOIN Customer c 
ON e.EmployeeId = c.SupportRepId 
GROUP BY SupportRepId 
ORDER BY Numero_clientes DESC
LIMIT 1;


SELECT *
FROM Invoice i;


SELECT *
FROM Customer c ;

	-- • Lista los cinco artistas con más canciones vendidas en el último año.

SELECT a.Name, COUNT(il.InvoiceLineId) as canciones_vendidas
FROM Artist a  
INNER JOIN Album a2 ON a.ArtistId = a2.ArtistId 
INNER JOIN Track t ON a2.AlbumId = t.AlbumId 
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.Name
ORDER BY canciones_vendidas DESC
LIMIT 5;

    -- • Obtén el total de ventas y la cantidad de canciones vendidas por país.

SELECT c.Country as pais, SUM(i.Total) AS Total_ventas, COUNT(il.TrackId) as Cantidad_canciones
FROM Customer c 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceLineId 
GROUP BY pais
ORDER BY Total_ventas DESC;

    -- • Calcula el número total de clientes que realizaron compras por cada género en un mes específico.

SELECT g.name as genero, COUNT(i.InvoiceId) as numero_clientes
FROM Genre g 
INNER JOIN Track t ON g.GenreId = t.GenreId 
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId 
INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId 
GROUP BY genero;

    -- • Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.

SELECT c.FirstName as nombre, c.LastName as apellido
FROM Customer c 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
INNER JOIN Track t ON il.TrackId = t.TrackId 
INNER JOIN Album a ON t.AlbumId = a.AlbumId

    -- • Lista los tres países con mayores ventas durante el último semestre

SELECT c.Country as pais, SUM(i.Total) AS Total_ventas
FROM Customer c 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceLineId 
WHERE i.InvoiceDate > NOW() - INTERVAL 6 MONTH
GROUP BY pais;

    -- • Muestra los cinco géneros menos vendidos en el último año.

SELECT g.Name, COUNT(il.InvoiceId) AS numero_genero
FROM Genre g 
INNER JOIN Track t on g.GenreId = t.GenreId 
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId 
INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId 
WHERE YEAR(i.InvoiceDate) = '2025'
GROUP BY g.Name
ORDER BY numero_genero ASC
LIMIT 5;

	-- • Calcula el promedio de edad de los clientes al momento de su primera compra.
    -- • Encuentra los cinco empleados que realizaron más ventas de Rock.

SELECT e.FirstName AS Nombre, COUNT(il.Quantity) as cantidad
FROM Employee e
INNER JOIN Customer c on e.EmployeeId = c.SupportRepId 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
INNER JOIN Track t ON il.TrackId = t.TrackId 
INNER JOIN Genre g ON t.GenreId = g.GenreId 
WHERE g.Name = 'Rock'
GROUP BY Nombre
LIMIT 5;

    -- • Genera un informe de los clientes con más compras recurrentes.

SELECT c.FirstName AS Nombre, COUNT(i.CustomerId) as cantidad
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId 
where i.InvoiceDate > NOW() - INTERVAL 1 WEEK
GROUP BY Nombre
ORDER BY cantidad DESC;

    -- • Calcula el precio promedio de venta por género.

SELECT g.name AS Nombre, AVG(i.Total) as Promedio 
FROM Genre g 
INNER JOIN Track t ON g.GenreId = t.GenreId 
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId 
INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY Nombre
ORDER BY Promedio ASC;

    -- • Lista las cinco canciones más largas vendidas en el último año.

SELECT t.Name, t.Milliseconds 
FROM Track t 
INNER JOIN InvoiceLine il ON t.TrackId = il.TrackId 
INNER JOIN Invoice i ON il.InvoiceId = i.InvoiceId 
WHERE i.InvoiceDate > NOW() - INTERVAL 1 YEAR
ORDER BY t.Milliseconds DESC
LIMIT 5;

    -- • Muestra los clientes que compraron más canciones de Jazz.

SELECT c.FirstName AS Nombre, COUNT(i.InvoiceId) AS cantidad
FROM Customer c 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
INNER JOIN Track t ON il.TrackId = t.TrackId 
INNER JOIN Genre g ON t.GenreId = g.GenreId 
WHERE g.Name = 'Jazz'
GROUP BY Nombre
ORDER BY cantidad DESC;

    -- • Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.

SELECT c.FirstName AS Nombre, SUM(t.Milliseconds/60)
FROM Customer c 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
INNER JOIN Track t ON il.TrackId = t.TrackId
WHERE i.InvoiceDate > NOW()- INTERVAL 1 MONTH
GROUP BY Nombre;

    -- • Muestra el número de ventas diarias de canciones en cada mes del último trimestre.

SELECT COUNT(i.InvoiceId) AS Numero_ventas_diarias, i.InvoiceDate AS Fecha
FROM Invoice i 
WHERE i.InvoiceDate > NOW() - INTERVAL 3 MONTH
GROUP BY Fecha;

    -- • Calcula el total de ventas por cada vendedor en el último semestre.}

SELECT e.FirstName AS Nombre, COUNT(i.InvoiceId), sum(i.Total)
FROM Employee e 
INNER JOIN Customer c on e.EmployeeId = c.SupportRepId 
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
where i.InvoiceDate > NOW() - INTERVAL 6 MONTH 
GROUP BY Nombre;

    -- • Encuentra el cliente que ha realizado la compra más cara en el último año.

SELECT 
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS Cliente,
    MAX(i.Total) AS MontoCompra
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.CustomerId, Cliente
ORDER BY MontoCompra DESC
LIMIT 1;

    -- • Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.

SELECT 
    a.AlbumId,
    a.Title AS Album,
    COUNT(il.TrackId) AS CancionesVendidas
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.AlbumId, Album
ORDER BY CancionesVendidas DESC
LIMIT 5;

    -- • Obtén la cantidad de canciones vendidas por cada género en el último mes.

SELECT 
    g.GenreId,
    g.Name AS Genero,
    COUNT(il.TrackId) AS CancionesVendidas
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY g.GenreId, Genero
ORDER BY CancionesVendidas DESC;

    -- • Lista los clientes que no han comprado nada en el último año.

SELECT 
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS Cliente
FROM Customer c
LEFT JOIN Invoice i 
    ON c.CustomerId = i.CustomerId 
    AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE i.InvoiceId IS NULL;