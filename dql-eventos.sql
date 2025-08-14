SET GLOBAL event_scheduler = ON;

   -- • ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
CREATE TABLE IF NOT EXISTS ReporteVentas (
    IdReporte INT AUTO_INCREMENT PRIMARY KEY,
    Mes YEAR(4) NOT NULL,
    MesNumero INT NOT NULL,
    TotalVentas DECIMAL(10,2) NOT NULL,
    FechaGeneracion DATETIME NOT NULL
);

DELIMITER $$

CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
BEGIN
    INSERT INTO ReporteVentas (Mes, MesNumero, TotalVentas, FechaGeneracion)
    SELECT 
        YEAR(CURDATE()) AS Anio,
        MONTH(CURDATE()) AS Mes,
        IFNULL(SUM(Total), 0) AS TotalVentas,
        NOW()
    FROM Invoice
    WHERE YEAR(InvoiceDate) = YEAR(CURDATE())
      AND MONTH(InvoiceDate) = MONTH(CURDATE());
END $$

DELIMITER ;

   -- • ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.

ALTER TABLE Customer ADD COLUMN SaldoPendiente DECIMAL(10,2) DEFAULT 0;

DELIMITER $$

CREATE EVENT ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 23:59:59'
DO
BEGIN
    UPDATE Customer c
    SET SaldoPendiente = (
        SELECT IFNULL(SUM(Total), 0)
        FROM Invoice
        WHERE CustomerId = c.CustomerId
          AND BillingState = 'DEUDA'
    );
END $$

DELIMITER ;
   -- • AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.

CREATE TABLE IF NOT EXISTS AlertasAlbum (
    IdAlerta INT AUTO_INCREMENT PRIMARY KEY,
    AlbumId INT,
    Titulo NVARCHAR(160),
    FechaAlerta DATETIME
);

DELIMITER $$

CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
STARTS '2025-12-31 23:59:59'
DO
BEGIN
    INSERT INTO AlertasAlbum (AlbumId, Titulo, FechaAlerta)
    SELECT a.AlbumId, a.Title, NOW()
    FROM Album a
    WHERE a.AlbumId NOT IN (
        SELECT DISTINCT t.AlbumId
        FROM Track t
        JOIN InvoiceLine il ON t.TrackId = il.TrackId
        JOIN Invoice i ON il.InvoiceId = i.InvoiceId
        WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    );
END $$

DELIMITER ;
   -- • LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
DELIMITER $$

CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS '2025-12-31 23:59:59'
DO
BEGIN
    DELETE FROM AuditoriaCliente
    WHERE FechaCambio < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END $$

DELIMITER ;
   -- • ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.

CREATE TABLE IF NOT EXISTS GenerosPopulares (
    IdRegistro INT AUTO_INCREMENT PRIMARY KEY,
    Mes YEAR(4),
    MesNumero INT,
    GenreId INT,
    NombreGenero NVARCHAR(120),
    CancionesVendidas INT,
    FechaRegistro DATETIME
);

DELIMITER $$

CREATE EVENT ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 23:59:59'
DO
BEGIN
    INSERT INTO GenerosPopulares (Mes, MesNumero, GenreId, NombreGenero, CancionesVendidas, FechaRegistro)
    SELECT 
        YEAR(CURDATE()),
        MONTH(CURDATE()),
        g.GenreId,
        g.Name,
        COUNT(il.TrackId) AS Ventas,
        NOW()
    FROM Genre g
    JOIN Track t ON g.GenreId = t.GenreId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE YEAR(i.InvoiceDate) = YEAR(CURDATE())
      AND MONTH(i.InvoiceDate) = MONTH(CURDATE())
    GROUP BY g.GenreId, g.Name
    ORDER BY Ventas DESC;
END $$

DELIMITER ;






