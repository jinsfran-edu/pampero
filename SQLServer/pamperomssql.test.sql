USE pampero;

SET NOCOUNT ON;
DECLARE @crc as varchar(max);
DECLARE @crc_fail as bigint;
DECLARE @count_fail as bigint;
DECLARE @tiempoini as datetime;
DECLARE @basecontrol as varchar(50);
DECLARE @uuid as varchar(50);
SET @tiempoini=CURRENT_TIMESTAMP;

DROP TABLE IF EXISTS #valores_esperados, #valores_encontrados;
CREATE TABLE #valores_esperados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_md5 VARCHAR(100) NOT NULL
);

CREATE TABLE #valores_encontrados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_md5 VARCHAR(100) NOT NULL
);

INSERT INTO #valores_esperados VALUES 
('categorias',                   8,'ac36ac06710f486dbc49e306365c4024'),
('proveedores',                 29,'c6c0a43e59a7217b61e02b8424a88676'),
('territorios',                 53,'3d5757c76dbbf0d190c2e7b6f5ddcd16'),
('empleadoterritorios',         49,'b424b1cd2dc85287e623ac7772de62b5'),
('productos',                   77,'12b574fcbe1ad01addcc132b5c4a4123'),
('region',                       4,'ea36373529f9c3cc64e021c3e806a226'),
('detalles pedido',           2155,'a2bfd89c6e0dc43e269553876f1a2e99'),
('empleados',                    9,'d57e46ced0bb0560b109431f8aaffcbf'),
('pedidos',                    830,'9074dc7fc43b45f19235aa986415f972'),
('clientes',                    91,'983f954bb719b52eb2d801e571e1349e'),
('transportistas',               3,'684d81cf94d3977cd7dd8254b417c4da'),
('nums',                    100000,'51f46071a3cc8fa00f638c7f5b089c86');

-- categorias
SET @crc= '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc,IDCategoria,NombreCategoria,Descripcion)),2))
    FROM Categorias ORDER BY IDCategoria;
INSERT INTO #valores_encontrados VALUES ('categorias', (SELECT COUNT(*) FROM Categorias),@crc);

-- proveedores
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDProveedor, NombreEmpresa,NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax, Web)),2))
    FROM Proveedores ORDER BY IDProveedor;
INSERT INTO #valores_encontrados VALUES ('proveedores', (SELECT COUNT(*) FROM Proveedores), @crc);

-- territorios
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTerritorio, RTRIM(DescripcionTerritorio), IDRegion)),2))
    FROM Territorios ORDER BY IDTerritorio;
INSERT INTO #valores_encontrados VALUES ('territorios', (SELECT COUNT(*) FROM Territorios), @crc);

-- empleadoterritorios
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDEmpleado, IDTerritorio)),2))
    FROM EmpleadoTerritorios ORDER BY IDEmpleado, IDTerritorio;
INSERT INTO #valores_encontrados VALUES ('empleadoterritorios', (SELECT COUNT(*) FROM EmpleadoTerritorios), @crc);

-- productos
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDProducto, NombreProducto, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, UnidadesEnStock, UnidadesEnPedidos, NivelNuevoPedido, Discontinuado)),2))
    FROM Productos ORDER BY IDProducto;
INSERT INTO #valores_encontrados VALUES ('productos', (SELECT COUNT(*) FROM Productos), @crc);

-- region
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDRegion, RTRIM(RegionDescripcion))),2))
    FROM Region ORDER BY IDRegion;
INSERT INTO #valores_encontrados VALUES ('region', (SELECT COUNT(*) FROM Region), @crc);

-- detalles pedido
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDPedido, IDProducto, PrecioUnitario, Cantidad, Descuento)),2))
    FROM [Detalles Pedido] ORDER BY IDPedido, IDProducto;
INSERT INTO #valores_encontrados VALUES ('detalles pedido', (SELECT COUNT(*) FROM [Detalles Pedido]), @crc);

-- empleados
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDEmpleado, Apellido, Nombre, Puesto, Saludo, FechaNacimiento, FechaAlta, Direccion, Ciudad, Region, CodigoPostal, Pais, TelefonoCasa, Interno, Notas, JefeID, RutaFoto)),2))
    FROM Empleados ORDER BY IDEmpleado;
INSERT INTO #valores_encontrados VALUES ('empleados', (SELECT COUNT(*) FROM Empleados), @crc);

-- pedidos
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDPedido, IDCliente, IDEmpleado, convert(varchar(25),FechaPedido,120), convert(varchar(25),FechaRequerida,120), convert(varchar(25),FechaEnvio,120), EnvioPor, Flete, NombreEnvio, DireccionEnvio, CiudadEnvio, RegionEnvio, CodigoPostalEnvio, PaisEnvio)),2))
    FROM Pedidos ORDER BY IDPedido;
INSERT INTO #valores_encontrados VALUES ('pedidos', (SELECT COUNT(*) FROM Pedidos), @crc);

-- clientes
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDCliente, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax)),2))
    FROM Clientes ORDER BY IDCliente;
INSERT INTO #valores_encontrados VALUES ('clientes', (SELECT COUNT(*) FROM Clientes), @crc);

-- transportistas
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, IDTransportista, NombreEmpresa, Telefono)),2))
    FROM Transportistas ORDER BY IDTransportista;
INSERT INTO #valores_encontrados VALUES ('transportistas', (SELECT COUNT(*) FROM Transportistas), @crc);

-- nums
SET @crc = '';
    SELECT @crc = LOWER(CONVERT(VARCHAR(32),HashBytes('MD5',CONCAT_WS('#',@crc, n)),2))
    FROM Nums ORDER BY n;
INSERT INTO #valores_encontrados VALUES ('nums', (SELECT COUNT(*) FROM Nums), @crc);

SET @crc_fail=(
SELECT COUNT(*)
FROM #valores_esperados e INNER JOIN #valores_encontrados f ON (e.tabla=f.tabla)
WHERE f.crc_md5 <> e.crc_md5
);
SET @count_fail=(
SELECT COUNT(*)
FROM #valores_esperados e INNER JOIN #valores_encontrados f ON (e.tabla=f.tabla)
WHERE f.regs <> e.regs
);
IF @@version LIKE '%Azure%'
    SET @basecontrol = 'master'
ELSE
    SET @basecontrol = 'msdb'
SELECT @uuid = CAST([service_broker_guid] AS varchar(50))
FROM   sys.databases
WHERE [name] = @basecontrol
DROP TABLE IF EXISTS #resumen;
CREATE TABLE #resumen (Resumen VARCHAR(50), Resultado VARCHAR(100));
INSERT INTO #resumen VALUES
('UUID', @uuid),
('Server Name', @@SERVERNAME),
('Version', CAST(SERVERPROPERTY('productversion') AS varchar(50)) ),
('Edition', CAST(SERVERPROPERTY('edition') AS varchar(50)) ),
('CRC', CASE WHEN @crc_fail = 0 THEN 'OK' ELSE 'Error' END),
('Cantidad', CASE WHEN @count_fail = 0 THEN 'OK' ELSE 'Error' END),
('Tiempo', CAST(DATEDIFF(MILLISECOND,@tiempoini,CURRENT_TIMESTAMP) AS varchar(50)));
SELECT tabla, regs AS registros_esperados, crc_md5 AS crc_esperado 
FROM #valores_esperados;
SELECT tabla, regs AS registros_encontrados, crc_md5 AS crc_encontrado
FROM #valores_encontrados;
SELECT  
    e.tabla, 
    CASE WHEN e.regs=f.regs THEN 'OK' ELSE 'No OK' END AS coinciden_registros,
    CASE WHEN e.crc_md5=f.crc_md5 THEN 'OK' ELSE 'No OK' END AS coindicen_crc
FROM 
    #valores_esperados e INNER JOIN #valores_encontrados f ON e.tabla=f.tabla;
SELECT Resumen, Resultado FROM #resumen;
