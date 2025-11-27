-- inserts para los datos
USE GymFitness;
GO

-- 1 TABLA: Membresia
INSERT INTO Membresia (nombre, descripcion, precio_mensual, duracion_meses, clases_incluidas, acceso_areas_especiales, estado)
VALUES
('Básica', 'Acceso al gimnasio general, sin áreas especiales.', 25.00, 1, 4, 0, 1),
('Premium', 'Acceso total a gimnasio, clases grupales y áreas especiales.', 40.00, 1, 8, 1, 1),
('VIP', 'Acceso ilimitado, clases personalizadas y área exclusiva.', 60.00, 1, 12, 1, 1);
GO

-- 2 TABLA: Socio
INSERT INTO Socio (numero_socio, nombres, apellidos, fecha_nacimiento, sexo, telefono, email, estado)
VALUES
('S001', 'Diego', 'Montoya', '2002-03-10', 'M', '78901234', 'diego.montoya@gymfit.com', 'Activo'),
('S002', 'Ander', 'Rivas', '2001-11-15', 'M', '70011223', 'ander.rivas@gymfit.com', 'Activo'),
('S003', 'Fernando', 'Cruz', '1999-08-05', 'M', '76004567', 'fernando.cruz@gymfit.com', 'Activo'),
('S004', 'Alejandro', 'López', '2003-02-18', 'M', '71008945', 'alejandro.lopez@gymfit.com', 'Activo'),
('S005', 'Evan', 'Martínez', '2000-05-22', 'M', '71504321', 'evan.martinez@gymfit.com', 'Activo'),
('S006', 'Laura', 'Gómez', '2001-07-14', 'F', '78123456', 'laura.gomez@gymfit.com', 'Activo'),
('S007', 'Sofía', 'Alfaro', '2004-01-09', 'F', '70045678', 'sofia.alfaro@gymfit.com', 'Activo'),
('S008', 'Carlos', 'Vásquez', '1998-12-25', 'M', '71239876', 'carlos.vasquez@gymfit.com', 'Activo');
GO

-- 3 TABLA: Entrenador
INSERT INTO Entrenador (codigo_entrenador, nombres, apellidos, fecha_nacimiento, telefono, email, especialidad)
VALUES
('E001', 'María', 'Torres', '1988-04-05', '70001234', 'maria.torres@gymfit.com', 'Cardio y Fitness'),
('E002', 'Luis', 'Pérez', '1990-07-22', '72004567', 'luis.perez@gymfit.com', 'Levantamiento de pesas'),
('E003', 'Ana', 'Rojas', '1992-11-30', '73123456', 'ana.rojas@gymfit.com', 'Yoga y Pilates'),
('E004', 'Pedro', 'Jiménez', '1985-09-10', '74005678', 'pedro.jimenez@gymfit.com', 'Entrenamiento funcional');
GO

-- 4 TABLA: Clase
INSERT INTO Clase (nombre, descripcion, duracion_minutos, nivel, capacidad_maxima)
VALUES
('Zumba', 'Clase grupal de baile y acondicionamiento físico.', 60, 'Intermedio', 20),
('Yoga', 'Ejercicios de estiramiento y respiración.', 50, 'Principiante', 15),
('Crossfit', 'Entrenamiento de alta intensidad con peso corporal.', 45, 'Avanzado', 10),
('Spinning', 'Clase de ciclismo en interiores con música.', 50, 'Intermedio', 20),
('FullBody', 'Entrenamiento general de todo el cuerpo.', 55, 'Intermedio', 15);
GO

-- 5 TABLA: Horario_Clase
INSERT INTO Horario_Clase (clase_id, entrenador_id, dia_semana, hora_inicio, hora_fin, salon, cupos_disponibles)
VALUES
(1, 1, 'Lunes', '08:00', '09:00', 'Salón A', 20),
(1, 1, 'Miércoles', '08:00', '09:00', 'Salón A', 20),
(2, 3, 'Martes', '07:00', '07:50', 'Salón Zen', 15),
(3, 2, 'Viernes', '18:00', '18:45', 'Zona Pesas', 10),
(4, 4, 'Sábado', '09:00', '09:50', 'Spinning Room', 20),
(5, 4, 'Jueves', '17:00', '17:55', 'Área Funcional', 15);
GO

-- 6 TABLA: Socios_Membresias
INSERT INTO Socios_Membresias (socio_id, membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado)
VALUES
(1, 3, '2025-01-01', '2025-02-01', 'Activa', 60.00),
(2, 2, '2025-01-15', '2025-02-15', 'Activa', 40.00),
(3, 1, '2025-02-01', '2025-03-01', 'Activa', 25.00),
(4, 2, '2025-01-10', '2025-02-10', 'Activa', 40.00),
(5, 3, '2025-01-20', '2025-02-20', 'Activa', 60.00);
(1, 3, '2025-02-01', '2025-03-01', 'Activa', 60.00),  
(2, 2, '2025-02-15', '2025-03-15', 'Activa', 40.00),  -
(6, 2, '2025-02-10', '2025-03-10', 'Activa', 40.00),  
(7, 1, '2025-02-12', '2025-03-12', 'Activa', 25.00);
(3, 1, '2025-03-01', '2025-04-01', 'Activa', 25.00),  
(4, 2, '2025-03-05', '2025-04-05', 'Activa', 40.00),  
(8, 3, '2025-03-10', '2025-04-10', 'Activa', 60.00),  
(2, 3, '2025-03-20', '2025-04-20', 'Activa', 60.00);
GO

-- 7 TABLA: Reserva
INSERT INTO Reserva (socio_id, horario_id, fecha_clase, estado)
VALUES
(1, 1, '2025-01-06', 'Asistió'),
(2, 2, '2025-01-08', 'Asistió'),
(3, 3, '2025-01-09', 'Confirmada'),
(4, 4, '2025-01-10', 'Asistió'),
(5, 5, '2025-01-11', 'Cancelada'),
(6, 6, '2025-01-13', 'Confirmada');
GO

-- 8 TABLA: Asistencia
INSERT INTO Asistencia (reserva_id, socio_id, horario_id, fecha_clase, hora_registro, asistio)
VALUES
(2, 1, 1, '2025-01-06', '08:00', 1),
(3, 2, 2, '2025-01-08', '08:00', 1),
(4, 3, 3, '2025-01-09', '07:00', 0),
(5, 4, 4, '2025-01-10', '18:00', 1),
(6, 5, 5, '2025-01-11', '09:00', 0),
(7, 6, 6, '2025-01-13', '17:00', 1),
(8, 1, 1, '2025-01-06', '08:00', 1),
(9, 2, 2, '2025-01-08', '08:00', 1),
(10, 3, 3, '2025-01-09', '07:00', 0),
(11, 4, 4, '2025-01-10', '18:00', 1),
(12, 5, 5, '2025-01-11', '09:00', 0),
(13, 6, 6, '2025-01-13', '17:00', 1);
GO

-- 9 TABLA: Pago
INSERT INTO Pago (socio_id, socio_membresia_id, tipo_pago, monto, fecha_pago, metodo_pago, numero_recibo, estado)
VALUES
(1, 2, 'Membresía', 60.00, '2025-01-01', 'Tarjeta', 'R001', 'Pagado'),
(2, 3, 'Membresía', 40.00, '2025-01-15', 'Efectivo', 'R002', 'Pagado'),
(3, 4, 'Membresía', 25.00, '2025-02-01', 'Tarjeta', 'R003', 'Pagado'),
(4, 5, 'Membresía', 40.00, '2025-01-10', 'Transferencia', 'R004', 'Pagado'),
(5, 6, 'Membresía', 60.00, '2025-01-20', 'Tarjeta', 'R005', 'Pagado'),
(1, 2, 'Clase Adicional', 10.00, '2025-01-07', 'Efectivo', 'R006', 'Pagado'),
(2, 3, 'Clase Adicional', 8.00, '2025-01-09', 'Efectivo', 'R007', 'Pagado');
(1, 2, 'Clase Adicional', 8.00,  '2025-01-12', 'Efectivo',     'R010', 'Pagado'),
(2, 3, 'Clase Adicional', 12.00, '2025-01-18', 'Tarjeta',      'R011', 'Pagado'),
(3, 4, 'Clase Adicional', 10.00, '2025-01-22', 'Transferencia','R012', 'Pagado'),
(4, 5, 'Clase Adicional', 15.00, '2025-01-25', 'Tarjeta',      'R013', 'Pagado'),
(5, 6, 'Penalización',    5.00,  '2025-01-28', 'Efectivo',     'R014', 'Pagado'),
(1, 2, 'Penalización',    7.00,  '2025-01-30', 'Transferencia','R015', 'Pagado');
(1, 7, 'Membresía', 60.00, '2025-02-01', 'Tarjeta',      'R020', 'Pagado'),
(2, 8, 'Membresía', 40.00, '2025-02-15', 'Transferencia','R021', 'Pagado'),
(6, 9, 'Membresía', 40.00, '2025-02-10', 'Efectivo',     'R022', 'Pagado'),
(7,10, 'Membresía', 25.00, '2025-02-12', 'Tarjeta',      'R023', 'Pagado');
(1, 7,  'Clase Adicional', 10.00, '2025-02-05', 'Efectivo',     'R024', 'Pagado'),
(2, 8,  'Clase Adicional',  8.00, '2025-02-18', 'Tarjeta',      'R025', 'Pagado'),
(6, 9,  'Clase Adicional', 12.00, '2025-02-20', 'Transferencia','R026', 'Pagado'),
(7,10,  'Clase Adicional',  6.00, '2025-02-25', 'Efectivo',     'R027', 'Pagado'),
(6, 9,  'Penalización',     5.00, '2025-02-28', 'Efectivo',     'R028', 'Pagado');
(3,11, 'Membresía', 25.00, '2025-03-01', 'Tarjeta',      'R030', 'Pagado'),
(4,12, 'Membresía', 40.00, '2025-03-05', 'Transferencia','R031', 'Pagado'),
(8,13, 'Membresía', 60.00, '2025-03-10', 'Tarjeta',      'R032', 'Pagado'),
(2,14, 'Membresía', 60.00, '2025-03-20', 'Efectivo',     'R033', 'Pagado');
(3,11, 'Clase Adicional',  9.00, '2025-03-08', 'Efectivo',     'R034', 'Pagado'),
(4,12, 'Clase Adicional', 11.00, '2025-03-12', 'Tarjeta',      'R035', 'Pagado'),
(8,13, 'Clase Adicional', 15.00, '2025-03-18', 'Transferencia','R036', 'Pagado'),
(2,14, 'Penalización',     7.50, '2025-03-25', 'Efectivo',     'R037', 'Pagado');
GO
