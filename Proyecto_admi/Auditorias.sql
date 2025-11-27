USE master;
GO

CREATE SERVER AUDIT Audit_Gym
TO FILE (
    FILEPATH = 'C:\audit_gimnasio\',
    MAXSIZE = 50 MB
)
WITH (
    QUEUE_DELAY = 1000
);
GO

ALTER SERVER AUDIT Audit_Gym
WITH (STATE = ON);
GO
USE GymFitness;
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_Gym_DB
FOR SERVER AUDIT Audit_Gym
ADD (INSERT ON dbo.Socio BY PUBLIC),
ADD (UPDATE ON dbo.Socio BY PUBLIC),
ADD (DELETE ON dbo.Socio BY PUBLIC),

ADD (INSERT ON dbo.Socios_Membresias BY PUBLIC),
ADD (UPDATE ON dbo.Socios_Membresias BY PUBLIC),
ADD (DELETE ON dbo.Socios_Membresias BY PUBLIC),

ADD (INSERT ON dbo.Pago BY PUBLIC),
ADD (UPDATE ON dbo.Pago BY PUBLIC),
ADD (DELETE ON dbo.Pago BY PUBLIC),

ADD (INSERT ON dbo.UsuarioSistema BY PUBLIC),
ADD (UPDATE ON dbo.UsuarioSistema BY PUBLIC),
ADD (DELETE ON dbo.UsuarioSistema BY PUBLIC),

ADD (INSERT ON dbo.Reserva BY PUBLIC),
ADD (UPDATE ON dbo.Reserva BY PUBLIC),
ADD (DELETE ON dbo.Reserva BY PUBLIC)
WITH (STATE = ON);
GO

SELECT *
FROM sys.fn_get_audit_file('C:\audit_gimnasio\*', DEFAULT, DEFAULT);
GO
