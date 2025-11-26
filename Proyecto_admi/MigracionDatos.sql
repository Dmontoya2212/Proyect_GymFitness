--La forma en que migraremos los datos, es mediante un BULK INSERT a tablas temporales, ya que al insertar a las tablas originales genera error debido a los datos identity
--entonces luego de haberlos insertado en tablas temporales trasladaremos los datos a las tablas reales
CREATE TABLE SocioTemp (
    numero_socio VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    fecha_creacion DATETIME NOT NULL
);
BULK INSERT SocioTemp
FROM 'C:\bulk\socios_500.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001' -- UTF-8
);
INSERT INTO Socio (
    numero_socio,
    nombres,
    apellidos,
    fecha_nacimiento,
    sexo,
    telefono,
    email,
    fecha_inscripcion,
    estado,
    fecha_creacion
)
SELECT
    numero_socio,
    nombres,
    apellidos,
    fecha_nacimiento,
    sexo,
    telefono,
    email,
    fecha_inscripcion,
    estado,
    fecha_creacion
FROM SocioTemp;
SELECT * FROM Socio

CREATE TABLE MembresiaTemp (
    nombre VARCHAR(100),
    descripcion VARCHAR(255),
    precio_mensual DECIMAL(10,2),
    duracion_meses INT,
    clases_incluidas INT,
    acceso_areas_especiales BIT,
    estado BIT
);
SELECT*FROM MembresiaTemp

BULK INSERT MembresiaTemp
FROM 'C:\bulk\membresias_sin_id.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

INSERT INTO Membresia 
(nombre, descripcion, precio_mensual, duracion_meses, clases_incluidas, acceso_areas_especiales, estado)
SELECT 
    nombre, descripcion, precio_mensual, duracion_meses, clases_incluidas, acceso_areas_especiales, estado
FROM MembresiaTemp;

SELECT * FROM Membresia

CREATE TABLE SociosmembreTemp (
     socio_id INT NOT NULL,
    membresia_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activa' CHECK (estado IN ('Activa','Vencida','Cancelada')),
    precio_pagado DECIMAL(10,2) NOT NULL CHECK (precio_pagado >= 0),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE()
);

BULK INSERT SociosmembreTemp
FROM 'C:\bulk\socios_membresias.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001'
);

INSERT INTO Socios_Membresias 
(socio_id, membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, fecha_creacion)
SELECT 
    socio_id, membresia_id, fecha_inicio, fecha_fin, estado, precio_pagado, fecha_creacion
FROM SociosmembreTemp;

SELECT*FROM Socios_Membresias

   CREATE TABLE Pago_Temp (
    socio_id INT NOT NULL,
    socio_membresia_id INT NOT NULL,
    tipo_pago VARCHAR(50) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL,
    numero_recibo VARCHAR(50),
    estado VARCHAR(20) NOT NULL

);

BULK INSERT Pago_Temp
FROM 'C:\temp\pagos_500.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

INSERT INTO Pago (socio_id, socio_membresia_id, tipo_pago, monto, fecha_pago, metodo_pago, numero_recibo, estado)
SELECT socio_id, socio_membresia_id, tipo_pago, monto, fecha_pago, metodo_pago, numero_recibo, estado
FROM Pago_Temp;

SELECT * FROM Pago

CREATE TABLE #EntrenadorTemp (
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

BULK INSERT #EntrenadorTemp
FROM 'C:\bulk\entrenador.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);
INSERT INTO Entrenador(
    codigo_entrenador, nombres, apellidos, fecha_nacimiento,
    telefono, email,  especialidad, fecha_contratacion, estado, fecha_creacion
)
SELECT
    codigo_entrenador, nombres, apellidos, fecha_nacimiento,
    telefono, email,  especialidad, fecha_contratacion, estado, fecha_creacion
FROM #EntrenadorTemp;


-- Crear tabla temporal
CREATE TABLE #ReservaTemp (
    socio_id INT,
    horario_id INT,
    fecha_reserva DATETIME,
    fecha_clase DATE,
    estado VARCHAR(20),
    fecha_cancelacion DATETIME NULL,
    observaciones VARCHAR(500) NULL
);

-- Bulk insert desde el CSV
BULK INSERT #ReservaTemp
FROM 'C:\bulk\reserva.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);

-- Insert hacia la tabla original, dejando que el IDENTITY se genere solo
INSERT INTO Reserva (
    socio_id, horario_id, fecha_reserva, fecha_clase,
    estado, fecha_cancelacion, observaciones
)
SELECT
    socio_id, horario_id, fecha_reserva, fecha_clase,
    estado, fecha_cancelacion, observaciones
FROM #ReservaTemp;

-- Limpiar temporal

CREATE TABLE #ClaseTemp (
 nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500),
    duracion_minutos INT NOT NULL CHECK (duracion_minutos > 0),
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('Principiante','Intermedio','Avanzado')),
    capacidad_maxima INT NOT NULL CHECK (capacidad_maxima > 0),
    estado BIT NOT NULL DEFAULT 1
);

BULK INSERT #ClaseTemp
FROM 'C:\bulk\clase.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);

INSERT INTO Clase(
    nombre, descripcion, duracion_minutos, nivel,
    capacidad_maxima, estado
)
SELECT
    nombre, descripcion, duracion_minutos, nivel,
    capacidad_maxima, estado
FROM #ClaseTemp;

CREATE TABLE #Horario_Clasetemp (
    clase_id INT NOT NULL,
    entrenador_id INT NOT NULL,
    dia_semana VARCHAR(10) NOT NULL CHECK (dia_semana IN ('Lunes','Martes','Mi�rcoles','Jueves','Viernes','S�bado','Domingo')),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    salon VARCHAR(50) NOT NULL,
    cupos_disponibles INT NOT NULL CHECK (cupos_disponibles >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'Programada' CHECK (estado IN ('Programada','Cancelada','Completada')),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE()
	); 
	

	BULK INSERT #Horario_Clasetemp
FROM 'C:\bulk\horario.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);

INSERT INTO Horario_Clase(
    clase_id, entrenador_id, dia_semana, hora_inicio,
    hora_fin, salon, cupos_disponibles, estado, fecha_creacion
)
SELECT
    clase_id, entrenador_id, dia_semana, hora_inicio,
    hora_fin, salon, cupos_disponibles, estado, fecha_creacion
FROM #Horario_Clasetemp;

CREATE TABLE #UsuarioTemp (
nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL CHECK (rol IN ('Administrador','Recepcionista','Entrenador','Socio')),
    email VARCHAR(100) NOT NULL UNIQUE,
    socio_id INT NULL,
    entrenador_id INT NULL,
    activo BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    ultimo_acceso DATETIME
	); 

		BULK INSERT #UsuarioTemp
FROM 'C:\bulk\usuario.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);

INSERT INTO UsuarioSistema(
    nombre_usuario, password_hash, rol, email,
    socio_id, entrenador_id, activo, fecha_creacion, ultimo_acceso
)
SELECT
   nombre_usuario, password_hash, rol, email,
    socio_id, entrenador_id, activo, fecha_creacion, ultimo_acceso
FROM #UsuarioTemp;

CREATE TABLE #AsistenciaTemp(
    reserva_id INT NOT NULL,
    socio_id INT NOT NULL,
    horario_id INT NOT NULL,
    fecha_clase DATE NOT NULL,
    hora_registro TIME,
    asistio BIT NOT NULL DEFAULT 0,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE()
	); 
	

		BULK INSERT #AsistenciaTemp
FROM 'C:\bulk\asistencia.csv'        
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 
);
INSERT INTO Asistencia(
    reserva_id, socio_id, horario_id, fecha_clase,
    hora_registro, asistio,fecha_registro
	)
SELECT
  reserva_id, socio_id, horario_id, fecha_clase,
    hora_registro, asistio,fecha_registro
FROM #AsistenciaTemp;

CREATE TABLE #PagoTemp (
    socio_id INT NOT NULL,
    socio_membresia_id INT NULL,
    tipo_pago VARCHAR(50) NOT NULL CHECK (tipo_pago IN ('Membres�a','Clase Adicional','Penalizaci�n','Otro')),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    fecha_pago DATETIME NOT NULL DEFAULT GETDATE(),
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('Efectivo','Tarjeta','Transferencia','Cheque')),
    numero_recibo VARCHAR(50) UNIQUE,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pagado' CHECK (estado IN ('Pagado','Pendiente','Anulado'))
	) ; 
	
	BULK INSERT #PagoTemp
FROM 'C:\bulk\pago.csv'        --  Cambiar esta ruta
WITH (
    FIELDTERMINATOR = ',',
     ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    CODEPAGE = '65001'                 -- UTF-8
);

INSERT INTO Pago(
    socio_id, socio_membresia_id, tipo_pago, monto,
    fecha_pago, metodo_pago,numero_recibo, estado
	)
SELECT
 socio_id, socio_membresia_id, tipo_pago, monto,
    fecha_pago, metodo_pago,numero_recibo, estado
FROM #PagoTemp;

--Borrando Tablas temporales
DROP TABLE #PagoTemp
DROP TABLE #AsistenciaTemp
DROP TABLE SocioTemp
DROP TABLE MembresiaTemp
DROP TABLE SociosmembreTemp
DROP TABLE #EntrenadorTemp
DROP TABLE #Horario_Clasetemp
DROP TABLE #UsuarioTemp
DROP TABLE #ReservaTemp
DROP TABLE #ClaseTemp; 

SELECT * FROM Socios_Membresias