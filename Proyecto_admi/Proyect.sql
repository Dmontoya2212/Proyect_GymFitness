CREATE DATABASE GymFitness
ON PRIMARY
(
    NAME = 'GymFitness_Data',
    FILENAME = 'C:\SQLData\GymFitness_Data.mdf',
    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = 'GimnasioFitness_Log',
    FILENAME = 'C:\SQLData\GymFitness_Log.ldf',
    SIZE = 50MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 5MB
);
GO

USE GymFitness;
GO

-- =============================================
-- TABLA: Socio
-- =============================================
CREATE TABLE Socio (
    socio_id INT IDENTITY(1,1) PRIMARY KEY,
    numero_socio VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M','F')),
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    fecha_inscripcion DATE NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo','Inactivo','Suspendido')),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- =============================================
-- TABLA: Membresia
-- =============================================
CREATE TABLE Membresia (
    membresia_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    precio_mensual DECIMAL(10,2) NOT NULL CHECK (precio_mensual >= 0),
    duracion_meses INT NOT NULL CHECK (duracion_meses > 0),
    clases_incluidas INT NOT NULL DEFAULT 0 CHECK (clases_incluidas >= 0),
    acceso_areas_especiales BIT NOT NULL DEFAULT 0,
    estado BIT NOT NULL DEFAULT 1
);
GO

-- =============================================
-- TABLA: Socios_Membresias
-- =============================================
CREATE TABLE Socios_Membresias (
    socio_membresia_id INT IDENTITY(1,1) PRIMARY KEY,
    socio_id INT NOT NULL,
    membresia_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activa' CHECK (estado IN ('Activa','Vencida','Cancelada')),
    precio_pagado DECIMAL(10,2) NOT NULL CHECK (precio_pagado >= 0),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CHK_Fechas_Membresia CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT FK_SocioMembresia_Socio FOREIGN KEY (socio_id)
        REFERENCES Socio(socio_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_SocioMembresia_Membresia FOREIGN KEY (membresia_id)
        REFERENCES Membresia(membresia_id)
        ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

-- =============================================
-- TABLA: Entrenador
-- =============================================
CREATE TABLE Entrenador (
    entrenador_id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_entrenador VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    especialidad VARCHAR(200),
    fecha_contratacion DATE NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo' CHECK (estado IN ('Activo','Inactivo','Vacaciones')),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- =============================================
-- TABLA: Clase
-- =============================================
CREATE TABLE Clase (
    clase_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    duracion_minutos INT NOT NULL CHECK (duracion_minutos > 0),
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('Principiante','Intermedio','Avanzado')),
    capacidad_maxima INT NOT NULL CHECK (capacidad_maxima > 0),
    estado BIT NOT NULL DEFAULT 1
);
GO

-- =============================================
-- TABLA: Horario_Clase
-- =============================================
CREATE TABLE Horario_Clase (
    horario_id INT IDENTITY(1,1) PRIMARY KEY,
    clase_id INT NOT NULL,
    entrenador_id INT NOT NULL,
    dia_semana VARCHAR(10) NOT NULL CHECK (dia_semana IN ('Lunes','Martes','Mi�rcoles','Jueves','Viernes','S�bado','Domingo')),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    salon VARCHAR(50) NOT NULL,
    cupos_disponibles INT NOT NULL CHECK (cupos_disponibles >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'Programada' CHECK (estado IN ('Programada','Cancelada','Completada')),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CHK_Horas_Clase CHECK (hora_fin > hora_inicio),
    CONSTRAINT FK_Horario_Clase FOREIGN KEY (clase_id)
        REFERENCES Clase(clase_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Horario_Entrenador FOREIGN KEY (entrenador_id)
        REFERENCES Entrenador(entrenador_id)
        ON DELETE NO ACTION ON UPDATE CASCADE
);
GO

-- =============================================
-- TABLA: Reserva
-- =============================================
CREATE TABLE Reserva (
    reserva_id INT IDENTITY(1,1) PRIMARY KEY,
    socio_id INT NOT NULL,
    horario_id INT NOT NULL,
    fecha_reserva DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_clase DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Confirmada' CHECK (estado IN ('Confirmada','Cancelada','Asisti�','NoAsisti�')),
    fecha_cancelacion DATETIME,
    observaciones VARCHAR(500),
    CONSTRAINT FK_Reserva_Socio FOREIGN KEY (socio_id)
        REFERENCES Socio(socio_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Reserva_Horario FOREIGN KEY (horario_id)
        REFERENCES Horario_Clase(horario_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- =============================================
-- TABLA: UsuarioSistema
-- =============================================
CREATE TABLE UsuarioSistema (
    usuario_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL CHECK (rol IN ('Administrador','Recepcionista','Entrenador','Socio')),
    email VARCHAR(100) NOT NULL UNIQUE,
    socio_id INT NULL,
    entrenador_id INT NULL,
    activo BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    ultimo_acceso DATETIME,
    CONSTRAINT FK_Usuario_Socio FOREIGN KEY (socio_id)
        REFERENCES Socio(socio_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Usuario_Entrenador FOREIGN KEY (entrenador_id)
        REFERENCES Entrenador(entrenador_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT CHK_Usuario_Tipo CHECK (
        (socio_id IS NOT NULL AND entrenador_id IS NULL AND rol = 'Socio')
        OR (socio_id IS NULL AND entrenador_id IS NOT NULL AND rol = 'Entrenador')
        OR (socio_id IS NULL AND entrenador_id IS NULL AND rol IN ('Administrador','Recepcionista'))
    )
);
GO

-- =============================================
-- TABLA: Asistencia (sin cascadas m�ltiples)
-- =============================================
CREATE TABLE Asistencia (
    asistencia_id INT IDENTITY(1,1) PRIMARY KEY,
    reserva_id INT NOT NULL,
    socio_id INT NOT NULL,
    horario_id INT NOT NULL,
    fecha_clase DATE NOT NULL,
    hora_registro TIME,
    asistio BIT NOT NULL DEFAULT 0,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Asistencia_Reserva FOREIGN KEY (reserva_id)
        REFERENCES Reserva(reserva_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Asistencia_Socio FOREIGN KEY (socio_id)
        REFERENCES Socio(socio_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Asistencia_Horario FOREIGN KEY (horario_id)
        REFERENCES Horario_Clase(horario_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- =============================================
-- TABLA: Pago (sin cascadas m�ltiples)
-- =============================================
CREATE TABLE Pago (
    pago_id INT IDENTITY(1,1) PRIMARY KEY,
    socio_id INT NOT NULL,
    socio_membresia_id INT NULL,
    tipo_pago VARCHAR(50) NOT NULL CHECK (tipo_pago IN ('Membres�a','Clase Adicional','Penalizaci�n','Otro')),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    fecha_pago DATETIME NOT NULL DEFAULT GETDATE(),
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('Efectivo','Tarjeta','Transferencia','Cheque')),
    numero_recibo VARCHAR(50) UNIQUE,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pagado' CHECK (estado IN ('Pagado','Pendiente','Anulado')),
    CONSTRAINT FK_Pago_Socio FOREIGN KEY (socio_id)
        REFERENCES Socio(socio_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Pago_SocioMembresia FOREIGN KEY (socio_membresia_id)
        REFERENCES Socios_Membresias(socio_membresia_id)
        ON DELETE SET NULL ON UPDATE NO ACTION
);
GO