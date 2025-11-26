---------------------------------------------------------------------------
--Logins:

USE master;

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'GymAdmin')
BEGIN
  CREATE LOGIN GymAdmin
    WITH PASSWORD = 'Admin@2103',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = ON,
         DEFAULT_DATABASE = GymFitness;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Entrenador')
BEGIN
  CREATE LOGIN Entrenador
    WITH PASSWORD = 'NoPainNoGain#1',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = ON,
         DEFAULT_DATABASE = GymFitness;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Recepcionista')
BEGIN
  CREATE LOGIN Recepcionista
    WITH PASSWORD = 'Password@123',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = ON,
         DEFAULT_DATABASE = GymFitness;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Socio')
BEGIN
  CREATE LOGIN Socio
    WITH PASSWORD = 'Password@321',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = ON,
         DEFAULT_DATABASE = GymFitness;
END
GO

---------------------------------------------------------------------------
--Usuarios:

USE GymFitness;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'GymAdmin')
  CREATE USER GymAdmin FOR LOGIN GymAdmin;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Entrenador')
  CREATE USER Entrenador FOR LOGIN Entrenador;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Recepcionista')
  CREATE USER Recepcionista FOR LOGIN Recepcionista;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Socio')
  CREATE USER Socio FOR LOGIN Socio;
GO

-------------------------------------------------------------------------
--Roles:

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_admin')
  CREATE ROLE role_admin;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_recepcionista')
  CREATE ROLE role_recepcionista;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_entrenador')
  CREATE ROLE role_entrenador;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_socio')
  CREATE ROLE role_socio;
GO

----------------------------------------------------------------------------
--Asignando roles:

EXEC sp_addrolemember 'role_admin', 'GymAdmin';
EXEC sp_addrolemember 'role_recepcionista', 'Recepcionista';
EXEC sp_addrolemember 'role_entrenador', 'Entrenador';
EXEC sp_addrolemember 'role_socio', 'Socio';
GO

----------------------------------------------------------------------------
--Asignando permisos:

-- === ADMIN ===

EXEC sp_addrolemember 'db_owner', 'role_admin';


-- === RECEPCIONISTA ===

IF OBJECT_ID('dbo.Socio','U') IS NOT NULL
  GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Socio TO role_recepcionista;
IF OBJECT_ID('dbo.Socios_Membresias','U') IS NOT NULL
  GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Socios_Membresias TO role_recepcionista;
IF OBJECT_ID('dbo.Reserva','U') IS NOT NULL
  GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Reserva TO role_recepcionista;
IF OBJECT_ID('dbo.Pago','U') IS NOT NULL
  GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Pago TO role_recepcionista;

--Solo lectura
IF OBJECT_ID('dbo.Membresia','U') IS NOT NULL
  GRANT SELECT ON dbo.Membresia TO role_recepcionista;
IF OBJECT_ID('dbo.Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Clase TO role_recepcionista;
IF OBJECT_ID('dbo.Horario_Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Horario_Clase TO role_recepcionista;
IF OBJECT_ID('dbo.Entrenador','U') IS NOT NULL
  GRANT SELECT ON dbo.Entrenador TO role_recepcionista;

-- Asistencia: Recepción también puede marcar (Insert/Update) y consultar
IF OBJECT_ID('dbo.Asistencia','U') IS NOT NULL
BEGIN
  GRANT SELECT ON dbo.Asistencia TO role_recepcionista;
  GRANT INSERT, UPDATE ON dbo.Asistencia TO role_recepcionista;
END

-- UsuarioSistema: permitir SELECT, pero ocultar password_hash si existe
IF OBJECT_ID('dbo.UsuarioSistema','U') IS NOT NULL
BEGIN
  GRANT SELECT ON dbo.UsuarioSistema TO role_recepcionista;
  IF COL_LENGTH('dbo.UsuarioSistema','password_hash') IS NOT NULL
    DENY SELECT ON OBJECT::dbo.UsuarioSistema (password_hash) TO role_recepcionista;
END


-- === ENTRENADOR ===

-- Lectura de catálogos y planificación
IF OBJECT_ID('dbo.Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Clase TO role_entrenador;
IF OBJECT_ID('dbo.Horario_Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Horario_Clase TO role_entrenador;

-- Lectura de reservas y asistencias
IF OBJECT_ID('dbo.Reserva','U') IS NOT NULL
  GRANT SELECT ON dbo.Reserva TO role_entrenador;
IF OBJECT_ID('dbo.Asistencia','U') IS NOT NULL
BEGIN
  GRANT SELECT ON dbo.Asistencia TO role_entrenador;
  GRANT INSERT, UPDATE ON dbo.Asistencia TO role_entrenador;
END

-- Lectura limitada de datos de socio (columnas comunes)
IF OBJECT_ID('dbo.Socio','U') IS NOT NULL
BEGIN
  GRANT SELECT ON dbo.Socio TO role_entrenador;
  GRANT SELECT (socio_id, numero_socio, nombres, apellidos, fecha_nacimiento, sexo)
    ON dbo.Socio TO role_entrenador;
END


-- === SOCIO ===

-- Catálogos en lectura
IF OBJECT_ID('dbo.Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Clase TO role_socio;
IF OBJECT_ID('dbo.Horario_Clase','U') IS NOT NULL
  GRANT SELECT ON dbo.Horario_Clase TO role_socio;
IF OBJECT_ID('dbo.Membresia','U') IS NOT NULL
  GRANT SELECT ON dbo.Membresia TO role_socio;

----------------------------------------------------------------------------
--Denegando que los demas puedan ver la contraseña hasheada:

IF OBJECT_ID('dbo.UsuarioSistema','U') IS NOT NULL
BEGIN
  IF COL_LENGTH('dbo.UsuarioSistema','password_hash') IS NOT NULL
  BEGIN
    DENY SELECT ON OBJECT::dbo.UsuarioSistema (password_hash) TO role_entrenador;
    DENY SELECT ON OBJECT::dbo.UsuarioSistema (password_hash) TO role_socio;
  END
END