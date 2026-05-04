USE Pampero;

SET @tiempoini=CURRENT_TIMESTAMP();

DROP TEMPORARY TABLE IF EXISTS valores_esperados, valores_encontrados;
CREATE TEMPORARY TABLE valores_esperados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_sha2 VARCHAR(100) NOT NULL
);

CREATE TEMPORARY TABLE valores_encontrados (
    tabla   VARCHAR(30)  NOT NULL PRIMARY KEY,
    regs    INT          NOT NULL,
    crc_sha2 VARCHAR(100) NOT NULL
);

INSERT INTO valores_esperados VALUES 
('categorias',                   8,'d7816575d95edec6af0a9388b886f649a460d5f41e1d24ce050c79b8a484047c'),
('proveedores',                 29,'9d9d5762431e24b093c4562313a2d799bcece9dbdbe1c847accab64804e16884'),
('territorios',                 53,'b5e76abf3c49d160dac16ef3f7e0d0cf76a9e6b04f163ed0e54f5f1d4c33b0cc'),
('empleadoterritorios',         49,'9e3d0121166906017df5cb08816d02d422765c202f5d616620f7b3ac6a7e0620'),
('productos',                   77,'2c3d263637e7061367653b58ce5fd4c9c3419b23d5ece12e5fb3168697198e6b'),
('region',                       4,'a0444f26cd6f8b1942011ec522cea0c3d0cce4a71a005fc1d0ea0e87d2c61f86'),
('detalles pedido',           2155,'d71deff2a766734ab91fc11f0b1c3ea91d148204a417fa4909b3be11de272edd'),
('empleados',                    9,'a303789cf08673efbc4f9e374df8b44c738805fec90da26d74a1d56e948cfc43'),
('pedidos',                    830,'e764944a65a7378ce4e6e5c1cff8b130775769159c4193b7a165c8c4950e352d'),
('clientes',                    91,'89a80a544f1217d3e79b47c22cd0647879e7c2dce40881f51e628eff4b1b0fc6'),
('transportistas',               3,'6b32e4362662d0a3de439f63024e3dfe15cd649a2bce45e7f56ee02c281a84cb'),
('nums',                    100000,'8421968c7bc1aeda071a9f799d18a31f2b8484ca8f5cd7c8ae8cb7869edef691');

-- categorias
SET @crc= '';
DROP TEMPORARY TABLE IF EXISTS tchecksum;
CREATE TEMPORARY TABLE tchecksum (chk char(100));
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc,IDCategoria,NombreCategoria,Descripcion),256)
    FROM Categorias ORDER BY IDCategoria;
INSERT INTO valores_encontrados VALUES ('categorias', (SELECT COUNT(*) FROM Categorias),@crc);

-- proveedores
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDProveedor, NombreEmpresa,NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax, Web),256)
    FROM Proveedores ORDER BY IDProveedor;
INSERT INTO valores_encontrados VALUES ('proveedores', (SELECT COUNT(*) FROM Proveedores), @crc);

-- territorios
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDTerritorio, RTRIM(DescripcionTerritorio), IDRegion),256)
    FROM Territorios ORDER BY IDTerritorio;
INSERT INTO valores_encontrados VALUES ('territorios', (SELECT COUNT(*) FROM Territorios), @crc);

-- empleadoterritorios
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDEmpleado, IDTerritorio),256)
    FROM EmpleadoTerritorios ORDER BY IDEmpleado, IDTerritorio;
INSERT INTO valores_encontrados VALUES ('empleadoterritorios', (SELECT COUNT(*) FROM EmpleadoTerritorios), @crc);

-- productos
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDProducto, NombreProducto, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, UnidadesEnStock, UnidadesEnPedidos, NivelNuevoPedido, Discontinuado),256)
    FROM Productos ORDER BY IDProducto;
INSERT INTO valores_encontrados VALUES ('productos', (SELECT COUNT(*) FROM Productos), @crc);

-- region
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDRegion, RTRIM(RegionDescripcion)),256)
    FROM Region ORDER BY IDRegion;
INSERT INTO valores_encontrados VALUES ('region', (SELECT COUNT(*) FROM Region), @crc);

-- detalles pedido
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDPedido, IDProducto, PrecioUnitario, Cantidad, Descuento),256)
    FROM `Detalles Pedido` ORDER BY IDPedido, IDProducto;
INSERT INTO valores_encontrados VALUES ('detalles pedido', (SELECT COUNT(*) FROM `Detalles Pedido`), @crc);

-- empleados
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDEmpleado, Apellido, Nombre, Puesto, Saludo, FechaNacimiento, FechaAlta, Direccion, Ciudad, Region, CodigoPostal, Pais, TelefonoCasa, Interno, Notas, JefeID, RutaFoto),256)
    FROM Empleados ORDER BY IDEmpleado;
INSERT INTO valores_encontrados VALUES ('empleados', (SELECT COUNT(*) FROM Empleados), @crc);

-- pedidos
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDPedido, IDCliente, IDEmpleado, FechaPedido, FechaRequerida, FechaEnvio, EnvioPor, Flete, NombreEnvio, DireccionEnvio, CiudadEnvio, RegionEnvio, CodigoPostalEnvio, PaisEnvio),256)
    FROM Pedidos ORDER BY IDPedido;
INSERT INTO valores_encontrados VALUES ('pedidos', (SELECT COUNT(*) FROM Pedidos), @crc);

-- clientes
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDCliente, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax),256)
    FROM Clientes ORDER BY IDCliente;
INSERT INTO valores_encontrados VALUES ('clientes', (SELECT COUNT(*) FROM Clientes), @crc);

-- transportistas
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, IDTransportista, NombreEmpresa, Telefono),256)
    FROM Transportistas ORDER BY IDTransportista;
INSERT INTO valores_encontrados VALUES ('transportistas', (SELECT COUNT(*) FROM Transportistas), @crc);

-- nums
SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := SHA2(CONCAT_WS('#',@crc, n),256)
    FROM Nums ORDER BY n;
INSERT INTO valores_encontrados VALUES ('nums', (SELECT COUNT(*) FROM Nums), @crc);

DROP TEMPORARY TABLE IF EXISTS tchecksum;
SET @crc_fail=(
SELECT COUNT(*) 
FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla)
WHERE f.crc_sha2 <> e.crc_sha2
);
SET @count_fail=(
SELECT COUNT(*) 
FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla)
WHERE f.regs <> e.regs
);
DROP TEMPORARY TABLE IF EXISTS resumen;
CREATE TEMPORARY TABLE resumen (Resumen VARCHAR(50), Resultado VARCHAR(100));
INSERT INTO resumen VALUES
('UUID', @@server_uuid),
('Server Name', @@hostname),
('Version', @@version),
('Version Compile', @@version_compile_os),
('CRC', CASE WHEN @crc_fail = 0 THEN 'OK' ELSE 'Error' END),
('Cantidad', CASE WHEN @count_fail = 0 THEN 'OK' ELSE 'Error' END),
('Tiempo', TIMESTAMPDIFF(MICROSECOND,@tiempoini,CURRENT_TIMESTAMP()));
SELECT tabla, regs AS registros_esperados, crc_sha2 AS crc_esperado
FROM valores_esperados;
SELECT tabla, regs AS registros_encontrados, crc_sha2 AS crc_encontrado
FROM valores_encontrados;
SELECT
    e.tabla, 
    CASE WHEN e.regs=f.regs THEN 'OK' ELSE 'No OK' END AS coinciden_registros,
    CASE WHEN e.crc_sha2=f.crc_sha2 THEN 'OK' ELSE 'No OK' END AS coindicen_crc
FROM 
    valores_esperados e INNER JOIN valores_encontrados f ON e.tabla=f.tabla;
SELECT Resumen, Resultado FROM resumen;
