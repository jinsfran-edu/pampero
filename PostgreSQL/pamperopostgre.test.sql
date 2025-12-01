\c pampero;
DO $$
DECLARE 
    v_crc_fail bigint := 0;
    v_count_fail bigint := 0;
    v_tiempoini timestamp := clock_timestamp();
    rec RECORD;
    vcrc_categorias       text := '';
    vcrc_proveedores      text := '';
    vcrc_territorios      text := '';
    vcrc_empleadoterritorios text := '';
    vcrc_productos        text := '';
    vcrc_region           text := '';
    vcrc_detalles         text := '';
    vcrc_empleados        text := '';
    vcrc_pedidos          text := '';
    vcrc_clientes         text := '';
    vcrc_transportistas   text := '';
    vcrc_nums             text := '';
BEGIN
    DROP TABLE IF EXISTS valores_esperados;
    DROP TABLE IF EXISTS valores_encontrados;
    CREATE TEMP TABLE valores_esperados (
        tabla   VARCHAR(30)  PRIMARY KEY,
        regs    INT          NOT NULL,
        crc_md5 VARCHAR(100) NOT NULL
    );

    CREATE TEMP TABLE valores_encontrados (
        tabla   VARCHAR(30)  PRIMARY KEY,
        regs    INT          NOT NULL,
        crc_md5 VARCHAR(100) NOT NULL
    );

    INSERT INTO valores_esperados VALUES 
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
    FOR rec IN
        SELECT CONCAT_WS('#', IDCategoria, NombreCategoria, Descripcion) AS rowdata
        FROM Categorias ORDER BY IDCategoria
    LOOP
        vcrc_categorias := md5(CONCAT_WS('#', vcrc_categorias, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('categorias', (SELECT COUNT(*) FROM Categorias), COALESCE(vcrc_categorias, md5('')));

    -- proveedores
    FOR rec IN
        SELECT CONCAT_WS('#', IDProveedor, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax, Web) AS rowdata
        FROM Proveedores ORDER BY IDProveedor
    LOOP
        vcrc_proveedores := md5(CONCAT_WS('#', vcrc_proveedores, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('proveedores', (SELECT COUNT(*) FROM Proveedores), COALESCE(vcrc_proveedores, md5('')));

    -- territorios
    FOR rec IN
        SELECT CONCAT_WS('#', IDTerritorio, RTRIM(DescripcionTerritorio), IDRegion) AS rowdata
        FROM Territorios ORDER BY IDTerritorio
    LOOP
        vcrc_territorios := md5(CONCAT_WS('#', vcrc_territorios, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('territorios', (SELECT COUNT(*) FROM Territorios), COALESCE(vcrc_territorios, md5('')));

    -- empleadoterritorios
    FOR rec IN
        SELECT CONCAT_WS('#', IDEmpleado, IDTerritorio) AS rowdata
        FROM EmpleadoTerritorios ORDER BY IDEmpleado, IDTerritorio
    LOOP
        vcrc_empleadoterritorios := md5(CONCAT_WS('#', vcrc_empleadoterritorios, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('empleadoterritorios', (SELECT COUNT(*) FROM EmpleadoTerritorios), COALESCE(vcrc_empleadoterritorios, md5('')));

    -- productos
    FOR rec IN
        SELECT CONCAT_WS('#', IDProducto, NombreProducto, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, UnidadesEnStock, UnidadesEnPedidos, NivelNuevoPedido, Discontinuado) AS rowdata
        FROM Productos ORDER BY IDProducto
    LOOP
        vcrc_productos := md5(CONCAT_WS('#', vcrc_productos, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('productos', (SELECT COUNT(*) FROM Productos), COALESCE(vcrc_productos, md5('')));

    -- region
    FOR rec IN
        SELECT CONCAT_WS('#', IDRegion, RTRIM(RegionDescripcion)) AS rowdata
        FROM Region ORDER BY IDRegion
    LOOP
        vcrc_region := md5(CONCAT_WS('#', vcrc_region, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('region', (SELECT COUNT(*) FROM Region), COALESCE(vcrc_region, md5('')));

    -- detalles pedido
    FOR rec IN
        SELECT CONCAT_WS('#', IDPedido, IDProducto, PrecioUnitario, Cantidad, Descuento) AS rowdata
        FROM "Detalles Pedido" ORDER BY IDPedido, IDProducto
    LOOP
        vcrc_detalles := md5(CONCAT_WS('#', vcrc_detalles, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('detalles pedido', (SELECT COUNT(*) FROM "Detalles Pedido"), COALESCE(vcrc_detalles, md5('')));

    -- empleados
    FOR rec IN
        SELECT CONCAT_WS('#', IDEmpleado, Apellido, Nombre, Puesto, Saludo, FechaNacimiento, FechaAlta, Direccion, Ciudad, Region, CodigoPostal, Pais, TelefonoCasa, Interno, Notas, JefeID, RutaFoto) AS rowdata
        FROM Empleados ORDER BY IDEmpleado
    LOOP
        vcrc_empleados := md5(CONCAT_WS('#', vcrc_empleados, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('empleados', (SELECT COUNT(*) FROM Empleados), COALESCE(vcrc_empleados, md5('')));

    -- pedidos
    FOR rec IN
        SELECT CONCAT_WS('#', IDPedido, IDCliente, IDEmpleado, FechaPedido, FechaRequerida, FechaEnvio, EnvioPor, Flete, NombreEnvio, DireccionEnvio, CiudadEnvio, RegionEnvio, CodigoPostalEnvio, PaisEnvio) AS rowdata
        FROM Pedidos ORDER BY IDPedido
    LOOP
        vcrc_pedidos := md5(CONCAT_WS('#', vcrc_pedidos, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('pedidos', (SELECT COUNT(*) FROM Pedidos), COALESCE(vcrc_pedidos, md5('')));

    -- clientes
    FOR rec IN
        SELECT CONCAT_WS('#', IDCliente, NombreEmpresa, NombreContacto, PuestoContacto, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Fax) AS rowdata
        FROM Clientes ORDER BY IDCliente
    LOOP
        vcrc_clientes := md5(CONCAT_WS('#', vcrc_clientes, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('clientes', (SELECT COUNT(*) FROM Clientes), COALESCE(vcrc_clientes, md5('')));

    -- transportistas
    FOR rec IN
        SELECT CONCAT_WS('#', IDTransportista, NombreEmpresa, Telefono) AS rowdata
        FROM Transportistas ORDER BY IDTransportista
    LOOP
        vcrc_transportistas := md5(CONCAT_WS('#', vcrc_transportistas, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('transportistas', (SELECT COUNT(*) FROM Transportistas), COALESCE(vcrc_transportistas, md5('')));

    -- nums
    FOR rec IN
        SELECT n AS rowdata
        FROM Nums ORDER BY n
    LOOP
        vcrc_nums := md5(CONCAT_WS('#', vcrc_nums, rec.rowdata));
    END LOOP;
    INSERT INTO valores_encontrados
    VALUES ('nums', (SELECT COUNT(*) FROM Nums), COALESCE(vcrc_nums, md5('')));

    SELECT COUNT(*) INTO v_crc_fail
    FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla)
    WHERE f.crc_md5 <> e.crc_md5
    ;

    SELECT COUNT(*) INTO v_count_fail
    FROM valores_esperados e INNER JOIN valores_encontrados f ON (e.tabla=f.tabla)
    WHERE f.regs <> e.regs
    ;

    DROP TABLE IF EXISTS resumen;
    CREATE TEMP TABLE resumen (Resumen VARCHAR(50), Resultado VARCHAR(100));
    INSERT INTO resumen VALUES
        ('Server Name', inet_server_addr()),
        ('Version', version()),
        ('CRC', CASE WHEN v_crc_fail = 0 THEN 'OK' ELSE 'Error' END),
        ('Cantidad', CASE WHEN v_count_fail = 0 THEN 'OK' ELSE 'Error' END),
        ('Tiempo', to_char(EXTRACT(EPOCH FROM (clock_timestamp() - v_tiempoini)) * 1000, 'FM999999990.00'));

END $$;
SELECT tabla, regs AS registros_esperados, crc_md5 AS crc_esperado
FROM valores_esperados;
SELECT tabla, regs AS registros_encontrados, crc_md5 AS crc_encontrado
FROM valores_encontrados;
SELECT
    e.tabla,
    CASE WHEN e.regs=f.regs THEN 'OK' ELSE 'No OK' END AS coinciden_registros,
    CASE WHEN e.crc_md5=f.crc_md5 THEN 'OK' ELSE 'No OK' END AS coindicen_crc
FROM
    valores_esperados e INNER JOIN valores_encontrados f ON e.tabla=f.tabla;
SELECT Resumen, Resultado FROM resumen;
