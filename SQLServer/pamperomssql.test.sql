USE pampero;

SET NOCOUNT ON;
DECLARE @crc as varchar(max);
DECLARE @crc_fail as bigint;
DECLARE @count_fail as bigint;
DECLARE @tiempoini as datetime;
SET @tiempoini=GETDATE();

DROP TABLE IF EXISTS valores_esperados, valores_encontrados;
CREATE TABLE valores_esperados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_md5 VARCHAR(100) NOT NULL
);

CREATE TABLE valores_encontrados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_md5 VARCHAR(100) NOT NULL
);

INSERT INTO valores_esperados VALUES 
('categorias',                   8,'ac36ac06710f486dbc49e306365c4024'),
('proveedores',                 29,'c6c0a43e59a7217b61e02b8424a88676'),
('territorios',                 53,'3d5757c76dbbf0d190c2e7b6f5ddcd16'),
('empleadoterritorios',         49,'d6d431bf5c8c953832c70723c0841380'),
('productos',                   77,'12b574fcbe1ad01addcc132b5c4a4123'),
('region',                       4,'ea36373529f9c3cc64e021c3e806a226'),
('detalles pedido',           2155,'a2bfd89c6e0dc43e269553876f1a2e99'),
('empleados',                    9,'d57e46ced0bb0560b109431f8aaffcbf'),
('clientedemografia',            0,''),
('pedidos',                    830,'9074dc7fc43b45f19235aa986415f972'),
('clienteclientedemo',           0,''),
('clientes',                    91,'542b1771a6f2f3d43200ebc43d2b9b08'),
('transportistas',               3,'684d81cf94d3977cd7dd8254b417c4da');

SELECT tabla, regs AS registros_esperados, crc_md5 AS crc_esperado FROM valores_esperados;

SET @crc= '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc,IDCategoria,NombreCategoria,Descripcion)),2))
    FROM Categorias ORDER BY IDCategoria;
INSERT INTO valores_encontrados VALUES ('categorias', (SELECT COUNT(*) FROM Categorias),@crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDProveedor, NombreEmpresa,NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax, Web)),2))
    FROM Proveedores ORDER BY IDProveedor;
INSERT INTO valores_encontrados VALUES ('proveedores', (SELECT COUNT(*) FROM Proveedores), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTerritorio, RTRIM(DescripcionTerritorio), IDRegion)),2))
    FROM Territorios ORDER BY IDTerritorio;
INSERT INTO valores_encontrados VALUES ('territorios', (SELECT COUNT(*) FROM Territorios), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTerritorio, IDTerritorio)),2))
    FROM EmpleadoTerritorios ORDER BY IDEmpleado, IDTerritorio;
INSERT INTO valores_encontrados VALUES ('empleadoterritorios', (SELECT COUNT(*) FROM EmpleadoTerritorios), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDProducto, NombreProducto, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, UnidadesEnStock, UnidadesEnPedidos, NivelNuevoPedido, Discontinuado)),2))
    FROM Productos ORDER BY IDProducto;
INSERT INTO valores_encontrados VALUES ('productos', (SELECT COUNT(*) FROM Productos), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDRegion, RTRIM(RegionDescripcion))),2))
    FROM Region ORDER BY IDRegion;
INSERT INTO valores_encontrados VALUES ('region', (SELECT COUNT(*) FROM Region), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDPedido, IDProducto, PrecioUnitario, Cantidad, Descuento)),2))
    FROM [Detalles Pedido] ORDER BY IDPedido, IDProducto;
INSERT INTO valores_encontrados VALUES ('detalles pedido', (SELECT COUNT(*) FROM [Detalles Pedido]), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDEmpleado, Apellido, Nombre, Puesto, Saludo, FechaNacimiento, FechaAlta, Direccion, Ciudad, Region, CodigoPostal, Pais, TelefonoCasa, Interno, Notas, JefeID, RutaFoto)),2))
    FROM Empleados ORDER BY IDEmpleado;
INSERT INTO valores_encontrados VALUES ('empleados', (SELECT COUNT(*) FROM Empleados), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTipoCliente, DescCliente)),2))
    FROM ClienteDemografia ORDER BY IDTipoCliente;
INSERT INTO valores_encontrados VALUES ('clientedemografia', (SELECT COUNT(*) FROM ClienteDemografia), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDPedido, IDCliente, IDEmpleado, convert(varchar(25),FechaPedido,120), convert(varchar(25),FechaRequerida,120), convert(varchar(25),FechaEnvio,120), EnvioPor, Flete, NombreEnvio, DireccionEnvio, CiudadEnvio, RegionEnvio, CodigoPostalEnvio, PaisEnvio)),2))
    FROM Pedidos ORDER BY IDPedido;
INSERT INTO valores_encontrados VALUES ('pedidos', (SELECT COUNT(*) FROM Pedidos), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDCliente, IDTipoCliente)),2))
    FROM ClienteClienteDemo ORDER BY IDCliente, IDTipoCliente;
INSERT INTO valores_encontrados VALUES ('clienteclientedemo', (SELECT COUNT(*) FROM ClienteClienteDemo), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDCliente, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax)),2))
    FROM Clientes ORDER BY IDCliente;
INSERT INTO valores_encontrados VALUES ('clientes', (SELECT COUNT(*) FROM Clientes), @crc);

SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTransportista, NombreEmpresa, Telefono)),2))
    FROM Transportistas ORDER BY IDTransportista;
INSERT INTO valores_encontrados VALUES ('transportistas', (SELECT COUNT(*) FROM Transportistas), @crc);

SELECT tabla, regs AS 'registros_encontrados', crc_md5 AS crc_encontrado FROM valores_encontrados;

SELECT  
    e.tabla, 
    IIF(e.regs=f.regs,'OK', 'No OK') AS coinciden_registros, 
    IIF(e.crc_md5=f.crc_md5,'OK','No OK') AS coindicen_crc 
FROM 
    valores_esperados e INNER JOIN valores_encontrados f ON e.tabla=f.tabla;

SET @crc_fail=(SELECT COUNT(*) FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla) WHERE f.crc_md5 != e.crc_md5);
SET @count_fail=(SELECT COUNT(*) FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla) WHERE f.regs != e.regs);

DROP TABLE valores_esperados,valores_encontrados;

SELECT 'UUID' AS Resumen, CAST([service_broker_guid] AS varchar(50)) AS 'Resultado'
FROM   sys.databases
WHERE [name] = N'msdb'
UNION ALL
SELECT 'Server Name', @@SERVERNAME
UNION ALL
SELECT 'CRC', IIF(@crc_fail = 0, 'OK', 'Error')
UNION ALL
SELECT 'Cantidad', IIF(@count_fail = 0, 'OK', 'Error' )
UNION ALL
SELECT 'Tiempo', CAST(DATEDIFF(MILLISECOND,@tiempoini,GETDATE()) AS varchar(50));
