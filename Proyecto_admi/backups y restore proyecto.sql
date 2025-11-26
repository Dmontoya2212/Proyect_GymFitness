
--------------------------------------------------SCRIPTS DE BACKUP----------------------------------------------------
--formato de los backups
--ejemplo: GymFitness_LOG_20251115_1500.trn
--GymFitness_LOG = nombre
--_20251115 = fecha en formato AAAA/MM/DD
--_1500 = hora en formato HH/MM

----------------------------------------FULL-----------------------------------------------
DECLARE @fecha NVARCHAR(20) = CONVERT(VARCHAR(20), GETDATE(), 112);
DECLARE @ruta NVARCHAR(200) = 'C:\backups\GymFitness_FULL_' + @fecha + '.bak';

BACKUP DATABASE [GymFitness]
TO DISK = @ruta
WITH INIT, COMPRESSION,
     NAME = 'GymFitness Full Backup',
     STATS = 5;

----------------------------------------DIFF-----------------------------------------------
DECLARE @fecha NVARCHAR(20) = CONVERT(VARCHAR(20), GETDATE(), 112);
DECLARE @ruta NVARCHAR(200) = 'C:\backups\GymFitness_DIFF_' + @fecha + '.bak';

BACKUP DATABASE [GymFitness]
TO DISK = @ruta
WITH DIFFERENTIAL, INIT, COMPRESSION,
     NAME = 'GymFitness Differential Backup',
     STATS = 5;

----------------------------------------LOG-------------------------------------------------
DECLARE @fecha NVARCHAR(20) = FORMAT(GETDATE(), 'yyyyMMdd_HHmm');
DECLARE @ruta NVARCHAR(200) = 'C:\backups\GymFitness_LOG_' + @fecha + '.trn';

BACKUP LOG [GymFitness]
TO DISK = @ruta
WITH INIT, COMPRESSION,
     NAME = 'GymFitness Log Backup',
     STATS = 5;


--------------------------------------------------------SCRIPTS DE RESTORE---------------------------------------------------
--verificar el contenido del backup
RESTORE FILELISTONLY 
FROM DISK = 'C:\backups\GymFitness_FULL_20251117.bak';

--verificar la integridad del backup
RESTORE VERIFYONLY 
FROM DISK = 'C:\backups\GymFitness_FULL_20251117.bak';

--restaurar la base de datos
--full
USE master;
GO
ALTER DATABASE GymFitness SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE GymFitness
FROM DISK = 'C:\backups\GymFitness_FULL_20251115.bak'
WITH REPLACE, RECOVERY, STATS = 5;
GO

ALTER DATABASE pubs SET MULTI_USER;


--full + diferencial
USE master;
ALTER DATABASE GymFitness SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE GymFitness
FROM DISK = 'C:\backups\GymFitness_FULL_20251115.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE GymFitness
FROM DISK = 'C:\backups\GymFitness_DIFF_20251115.bak'
WITH RECOVERY, STATS = 5;

ALTER DATABASE GymFitness SET MULTI_USER;
GO

--full + diferencial + log 
USE master;
ALTER DATABASE GymFitness SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE GymFitness
FROM DISK = 'C:\backups\GymFitness_FULL_20251117.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE LOG GymFitness
FROM DISK = 'C:\backups\GymFitness_LOG_20251117_1500.trn'
WITH NORECOVERY, STATS = 5;

RESTORE LOG GymFitness
FROM DISK = 'C:\backups\GymFitness_LOG_20251117_1530.trn'
WITH NORECOVERY, STATS = 5;

RESTORE LOG GymFitness
FROM DISK = 'C:\backups\GymFitness_LOG_20251117_1600.trn'
WITH RECOVERY, STATS = 5;  --el ultimo restore log debe estar en WITH RECOVERY

ALTER DATABASE GymFitness SET MULTI_USER;
GO

-- Ejecuta este comando en caso de que de error (si no falla ignoralo)
RESTORE DATABASE GymFitness WITH RECOVERY;