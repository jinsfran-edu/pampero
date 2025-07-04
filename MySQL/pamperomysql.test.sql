USE Pampero;

SET @tiempoini=CURRENT_TIMESTAMP();

DROP TEMPORARY TABLE IF EXISTS valores_esperados, valores_encontrados;
CREATE TEMPORARY TABLE valores_esperados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_md5 VARCHAR(100) NOT NULL
);

CREATE TEMPORARY TABLE valores_encontrados (
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
('pedidos',                    830,'9074dc7fc43b45f19235aa986415f972'),
('clientes',                    91,'542b1771a6f2f3d43200ebc43d2b9b08'),
('transportistas',               3,'684d81cf94d3977cd7dd8254b417c4da'),
('nums',                    100000,'51f46071a3cc8fa00f638c7f5b089c86');

SELECT tabla, regs AS registros_esperados, crc_md5 AS crc_esperado FROM valores_esperados;

SET @crc= '';
DROP TEMPORARY TABLE IF EXISTS tchecksum;
CREATE TEMPORARY TABLE tchecksum (chk char(100));
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc,IDCategoria,NombreCategoria,Descripcion))
    FROM Categorias ORDER BY IDCategoria;
INSERT INTO valores_encontrados VALUES ('categorias', (SELECT COUNT(*) FROM Categorias),@crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDProveedor, NombreEmpresa,NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax, Web))
    FROM Proveedores ORDER BY IDProveedor;
INSERT INTO valores_encontrados VALUES ('proveedores', (SELECT COUNT(*) FROM Proveedores), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDTerritorio, RTRIM(DescripcionTerritorio), IDRegion))
    FROM Territorios ORDER BY IDTerritorio;
INSERT INTO valores_encontrados VALUES ('territorios', (SELECT COUNT(*) FROM Territorios), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDTerritorio, IDTerritorio))
    FROM EmpleadoTerritorios ORDER BY IDEmpleado, IDTerritorio;
INSERT INTO valores_encontrados VALUES ('empleadoterritorios', (SELECT COUNT(*) FROM EmpleadoTerritorios), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDProducto, NombreProducto, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, UnidadesEnStock, UnidadesEnPedidos, NivelNuevoPedido, Discontinuado))
    FROM Productos ORDER BY IDProducto;
INSERT INTO valores_encontrados VALUES ('productos', (SELECT COUNT(*) FROM Productos), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDRegion, RTRIM(RegionDescripcion)))
    FROM Region ORDER BY IDRegion;
INSERT INTO valores_encontrados VALUES ('region', (SELECT COUNT(*) FROM Region), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDPedido, IDProducto, PrecioUnitario, Cantidad, Descuento))
    FROM `Detalles Pedido` ORDER BY IDPedido, IDProducto;
INSERT INTO valores_encontrados VALUES ('detalles pedido', (SELECT COUNT(*) FROM `Detalles Pedido`), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDEmpleado, Apellido, Nombre, Puesto, Saludo, FechaNacimiento, FechaAlta, Direccion, Ciudad, Region, CodigoPostal, Pais, TelefonoCasa, Interno, Notas, JefeID, RutaFoto))
    FROM Empleados ORDER BY IDEmpleado;
INSERT INTO valores_encontrados VALUES ('empleados', (SELECT COUNT(*) FROM Empleados), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDPedido, IDCliente, IDEmpleado, FechaPedido, FechaRequerida, FechaEnvio, EnvioPor, Flete, NombreEnvio, DireccionEnvio, CiudadEnvio, RegionEnvio, CodigoPostalEnvio, PaisEnvio))
    FROM Pedidos ORDER BY IDPedido;
INSERT INTO valores_encontrados VALUES ('pedidos', (SELECT COUNT(*) FROM Pedidos), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDCliente, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax))
    FROM Clientes ORDER BY IDCliente;
INSERT INTO valores_encontrados VALUES ('clientes', (SELECT COUNT(*) FROM Clientes), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, IDTransportista, NombreEmpresa, Telefono))
    FROM Transportistas ORDER BY IDTransportista;
INSERT INTO valores_encontrados VALUES ('transportistas', (SELECT COUNT(*) FROM Transportistas), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, n))
    FROM Nums ORDER BY n;
INSERT INTO valores_encontrados VALUES ('nums', (SELECT COUNT(*) FROM Nums), @crc);

DROP TEMPORARY TABLE IF EXISTS tchecksum;

SELECT tabla, regs AS 'registros_encontrados', crc_md5 AS crc_encontrado FROM valores_encontrados;

SELECT  
    e.tabla, 
    IF(e.regs=f.regs,'OK', 'No OK') AS coinciden_registros, 
    IF(e.crc_md5=f.crc_md5,'OK','No OK') AS coindicen_crc 
FROM 
    valores_esperados e INNER JOIN valores_encontrados f ON e.tabla=f.tabla;

SET @crc_fail=(SELECT COUNT(*) FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla) WHERE f.crc_md5 != e.crc_md5);
SET @count_fail=(SELECT COUNT(*) FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla) WHERE f.regs != e.regs);

DROP TEMPORARY TABLE valores_esperados,valores_encontrados;

SELECT 'UUID' AS Resumen, @@server_uuid AS Resultado
UNION ALL
SELECT 'Server Name', @@hostname
UNION ALL
SELECT 'Version', @@version
UNION ALL
SELECT 'Version Compile', @@version_compile_os
UNION ALL
SELECT 'CRC', IF(@crc_fail = 0, 'OK', 'Error')
UNION ALL
SELECT 'Cantidad', IF(@count_fail = 0, 'OK', 'Error' )
UNION ALL
SELECT 'Tiempo', TIMESTAMPDIFF(MICROSECOND,@tiempoini,CURRENT_TIMESTAMP())/1000;
