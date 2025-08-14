# 📄 Proyecto SQL – Consultas, Triggers y Eventos

Este proyecto contiene ejemplos de **consultas SQL avanzadas**, **triggers** y **eventos programados** implementados sobre una base de datos de ventas musicales. El objetivo es cubrir casos de negocio comunes como auditorías, actualizaciones automáticas, reportes y validaciones.

---

## 📊 Consultas SQL

1. **Cliente con la compra más cara en el último año**  
   Consulta para obtener el cliente que ha realizado la compra de mayor valor en el último año.

2. **Cinco álbumes con más canciones vendidas en los últimos tres meses**  
   Consulta para listar los 5 álbumes con mayor número de canciones vendidas en el último trimestre.

3. **Cantidad de canciones vendidas por cada género en el último mes**  
   Consulta para mostrar el total de canciones vendidas agrupadas por género musical en el último mes.

4. **Clientes que no han comprado en el último año**  
   Consulta que identifica a los clientes inactivos en el último año.

---

## ⚙️ Triggers SQL

1. **ActualizarTotalVentasEmpleado**  
   Actualiza automáticamente el total de ventas acumuladas por un empleado al registrarse una nueva venta.

2. **AuditarActualizacionCliente**  
   Registra automáticamente cada modificación realizada sobre un cliente en una tabla de auditoría.

3. **RegistrarHistorialPrecioCancion**  
   Guarda un registro histórico de los cambios de precio en las canciones.

4. **NotificarCancelacionVenta**  
   Inserta una notificación cuando se elimina una venta.

5. **RestringirCompraConSaldoDeudor**  
   Impide que un cliente con saldo deudor realice nuevas compras.

> **Nota:** Estos triggers se implementaron sin usar tablas auxiliares adicionales.

---

## ⏳ Eventos SQL

1. **ReporteVentasMensual**  
   Genera automáticamente un reporte mensual de ventas y lo almacena.

2. **ActualizarSaldosCliente**  
   Actualiza los saldos de cuenta de los clientes al final de cada mes.

3. **AlertaAlbumNoVendidoAnual**  
   Envía una alerta cuando un álbum no registra ventas en los últimos 12 meses.

4. **LimpiarAuditoriaCada6Meses**  
   Borra registros antiguos de auditoría cada 6 meses para optimizar el almacenamiento.

5. **ActualizarListaDeGenerosPopulares**  
   Actualiza la lista de géneros musicales más vendidos al final de cada mes.

---

## 🛠️ Requisitos

- **Motor de base de datos:** MySQL 8.0 o superior  
- **Base de datos** con tablas relacionadas a clientes, ventas, canciones, géneros, álbumes y empleados.  
- **Permisos** para crear y administrar eventos (`EVENT`), y para crear triggers.

---

## 🚀 Ejecución

1. Asegúrate de habilitar el programador de eventos en MySQL:
   ```sql
   SET GLOBAL event_scheduler = ON;