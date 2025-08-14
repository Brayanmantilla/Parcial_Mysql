    -- • ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
    
    ALTER TABLE Employee ADD COLUMN TotalVentas DECIMAL(10,2) DEFAULT 0;

DELIMITER $$

CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
    UPDATE Employee
    SET TotalVentas = TotalVentas + NEW.Total
    WHERE EmployeeId = (
        SELECT SupportRepId
        FROM Customer
        WHERE CustomerId = NEW.CustomerId
    );
END $$

DELIMITER ;
    
    -- • AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.

ALTER TABLE Customer 
ADD COLUMN UltimaModificacion DATETIME,
ADD COLUMN UltimoCambio VARCHAR(255);

DELIMITER $$

CREATE TRIGGER AuditarActualizacionCliente
BEFORE UPDATE ON Customer
FOR EACH ROW
BEGIN
    SET NEW.UltimaModificacion = NOW();
    SET NEW.UltimoCambio = CONCAT(
        'Cambio en cliente: ', OLD.FirstName, ' ', OLD.LastName,
        ' -> ', NEW.FirstName, ' ', NEW.LastName
    );
END $$

DELIMITER ;

    -- • RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.

ALTER TABLE Track 
ADD COLUMN PrecioAnterior DECIMAL(10,2),
ADD COLUMN FechaCambioPrecio DATETIME;

DELIMITER $$

CREATE TRIGGER RegistrarHistorialPrecioCancion
BEFORE UPDATE ON Track
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        SET NEW.PrecioAnterior = OLD.UnitPrice;
        SET NEW.FechaCambioPrecio = NOW();
    END IF;
END $$

DELIMITER ;

    -- • NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.

ALTER TABLE Invoice ADD COLUMN MensajeCancelacion VARCHAR(255);

DELIMITER $$

CREATE TRIGGER NotificarCancelacionVenta
BEFORE DELETE ON Invoice
FOR EACH ROW
BEGIN
    SET OLD.MensajeCancelacion = CONCAT('Venta ', OLD.InvoiceId, ' cancelada en ', NOW());
END $$

DELIMITER ;

    -- • RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.

DELIMITER $$

CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE deudas INT;

    SELECT COUNT(*) INTO deudas
    FROM Invoice
    WHERE CustomerId = NEW.CustomerId
      AND BillingState = 'DEUDA';

    IF deudas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Compra rechazada: cliente con saldo deudor';
    END IF;
END $$

DELIMITER ;


