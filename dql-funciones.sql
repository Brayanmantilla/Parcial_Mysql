   -- • TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.
   
   DELIMITER $$

CREATE FUNCTION TotalGastoCliente(p_ClienteID INT, p_Anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT IFNULL(SUM(Total), 0)
    INTO total
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND YEAR(InvoiceDate) = p_Anio;

    RETURN total;
END $$

DELIMITER ;

SELECT TotalGastoCliente(5, 2009);

   
   -- • PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.

DELIMITER $$

CREATE FUNCTION PromedioPrecioPorAlbum(p_AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT IFNULL(AVG(UnitPrice), 0)
    INTO promedio
    FROM Track
    WHERE AlbumId = p_AlbumID;

    RETURN promedio;
END $$

DELIMITER ;

SELECT PromedioPrecioPorAlbum(1);

   -- • DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.

DELIMITER $$

CREATE FUNCTION DuracionTotalPorGenero(p_GeneroID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE duracionTotal INT;

    SELECT IFNULL(SUM(t.Milliseconds), 0)
    INTO duracionTotal
    FROM Track t
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    WHERE t.GenreId = p_GeneroID;

    RETURN duracionTotal;
END $$

DELIMITER ;

SELECT DuracionTotalPorGenero(1); -- Devuelve en milisegundos

   -- • DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.

DELIMITER $$

CREATE FUNCTION DescuentoPorFrecuencia(p_ClienteID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE compras INT;
    DECLARE descuento DECIMAL(5,2);

    SELECT COUNT(*) 
    INTO compras
    FROM Invoice
    WHERE CustomerId = p_ClienteID;

    IF compras >= 20 THEN
        SET descuento = 0.10; -- 10%
    ELSEIF compras >= 10 THEN
        SET descuento = 0.05; -- 5%
    ELSE
        SET descuento = 0.00; -- 0%
    END IF;

    RETURN descuento;
END $$

DELIMITER ;

SELECT DescuentoPorFrecuencia(5);

   -- • VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.

DELIMITER $$

CREATE FUNCTION VerificarClienteVIP(p_ClienteID INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE gastoAnual DECIMAL(10,2);

    SELECT SUM(Total)
    INTO gastoAnual
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND YEAR(InvoiceDate) = YEAR(CURDATE());

    IF gastoAnual >= 100 THEN
        RETURN 'VIP';
    ELSE
        RETURN 'NO VIP';
    END IF;
END $$

DELIMITER ;

SELECT VerificarClienteVIP(5);
















