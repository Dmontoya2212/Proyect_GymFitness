-- OPTIMIZACI�N Y CONSULTAS AVANZADAS � GYMFITNESS

-- CREACI�N DE �NDICES
CREATE INDEX IX_Socio_Estado_Email ON Socio (estado, email);
CREATE INDEX IX_Reserva_Socio_Fecha ON Reserva (socio_id, fecha_clase);
CREATE INDEX IX_Pago_Tipo_Fecha ON Pago (tipo_pago, fecha_pago);
CREATE INDEX IX_Horario_Dia_Entrenador ON Horario_Clase (dia_semana, entrenador_id);

-- CONSULTAS AVANZADAS CON FUNCIONES VENTANA

-- 1. Ranking de socios con m�s reservas
SELECT 
    s.socio_id,
    s.nombres,
    s.apellidos,
    COUNT(r.reserva_id) AS total_reservas,
    RANK() OVER (ORDER BY COUNT(r.reserva_id) DESC) AS posicion
FROM Socio s
JOIN Reserva r ON s.socio_id = r.socio_id
GROUP BY s.socio_id, s.nombres, s.apellidos;

-- 2. Pagos acumulados por socio
SELECT 
    p.socio_id,
    s.nombres,
    s.apellidos,
    p.fecha_pago,
    SUM(p.monto) OVER (PARTITION BY p.socio_id ORDER BY p.fecha_pago) AS monto_acumulado
FROM Pago p
JOIN Socio s ON s.socio_id = p.socio_id;

-- 3. Promedio de asistencia por socio
SELECT 
    a.socio_id,
    s.nombres,
    COUNT(CASE WHEN a.asistio = 1 THEN 1 END) AS clases_asistidas,
    COUNT(a.asistencia_id) AS total_reservas,
    ROUND(100.0 * COUNT(CASE WHEN a.asistio = 1 THEN 1 END) / COUNT(a.asistencia_id), 2) AS porcentaje_asistencia,
    AVG(COUNT(CASE WHEN a.asistio = 1 THEN 1 END)) OVER () AS promedio_general
FROM Asistencia a
JOIN Socio s ON s.socio_id = a.socio_id
GROUP BY a.socio_id, s.nombres;

-- 4. Ingresos mensuales del gimnasio
SELECT 
    FORMAT(fecha_pago, 'yyyy-MM') AS mes,
    SUM(monto) AS total_mensual,
    SUM(SUM(monto)) OVER (
        ORDER BY YEAR(fecha_pago), MONTH(fecha_pago)
        ROWS UNBOUNDED PRECEDING
    ) AS acumulado_anual
FROM Pago
GROUP BY YEAR(fecha_pago), MONTH(fecha_pago), FORMAT(fecha_pago, 'yyyy-MM')
ORDER BY mes;