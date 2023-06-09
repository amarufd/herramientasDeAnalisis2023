-- Creación de una tabla
CREATE TABLE CLIENTES_VIP (
    ID INT AUTO_INCREMENT KEY,
    NOMBRE varchar(25) NOT NULL,
    PAIS varchar(25) DEFAULT 'CHILE',
    CATEGORIA varchar(30),
    NUM_VENTA int
);


-- aqui puedo escribir las querys mas tristes esta noche
-- agregando columna
ALTER TABLE CLIENTES_VIP ADD TELEFONO INT;
ALTER TABLE CLIENTES_VIP ADD COD_TEL INT;
ALTER TABLE CLIENTES_VIP ADD CREACION DATETIME;

-- eliminando columna
ALTER TABLE jarvis.CLIENTES_VIP DROP COLUMN NUM_VENTA;

-- modificando una columna
ALTER TABLE CLIENTES_VIP MODIFY COLUMN COD_TEL VARCHAR(4);

-- eliminar table
DROP TABLE CLIENTES_VIP;

-- Poblar tabla
INSERT INTO CLIENTES_VIP (NOMBRE, CATEGORIA, TELEFONO, COD_TEL, CREACION) VALUES ('AMARU FERNANDEZ','PRIMIUM',23241, '+56', '2023/12/13 21:07:00');
INSERT INTO CLIENTES_VIP (NOMBRE, PAIS, CATEGORIA, TELEFONO, COD_TEL, CREACION) VALUES ('SEBASTIAN ARAVENA','CHILE','SUPER PREMIUM',5555555, '+56', NOW());
INSERT INTO CLIENTES_VIP (NOMBRE, PAIS, CATEGORIA, TELEFONO, COD_TEL, CREACION) VALUES ('ANTONIA APOYO', 'ARGENTINA', 'SUPER PREMIUM', 2222222, '+55', '2023-04-24 21:20:08')

-- ver la información
SELECT * FROM CLIENTES_VIP;

-- ACTUALIZACION DE DATOS
UPDATE CLIENTES_VIP SET CATEGORIA = 'PREMIUM' WHERE ID = 1;

-- USANDO EL LIKE
SELECT * FROM CLIENTES_VIP WHERE NOMBRE LIKE '%na%';

-- USANDO EL =
SELECT * FROM CLIENTES_VIP WHERE CATEGORIA <> 'SUPER PREMIUM';

-- USANDO EL <, >, <=, >=
SELECT * FROM CLIENTES_VIP WHERE CREACION NOT BETWEEN '2023/04/23' AND '2023/04/26';

-- EXPLORANDO
SELECT * FROM CLIENTES WHERE PAIS NOT IN ('Chile','China');
SELECT * FROM CLIENTES WHERE PAIS <> 'Chile' AND PAIS <> 'China';

-- SELECCIONANDO ATRIBUTOS
-- DESC: DESCENDIENTE
-- ASC: ASCENDENTE
SELECT ID, PAIS FROM CLIENTES ORDER BY PAIS ASC, ID ASC;

SELECT * FROM PRODUCTOS ORDER BY TIPO_PRODUCTO_ID;
SELECT * FROM TIPO_PRODUCTO;

-- QUE TIPOS DE PRODUCTOS TENGO Y SUS VALORES
SELECT TP.NOMBRE, P.PRODUCTO, P.PRECIO FROM TIPO_PRODUCTO TP
INNER JOIN PRODUCTOS P ON TP.ID = P.TIPO_PRODUCTO_ID
ORDER BY TP.NOMBRE;


-- PRODUCTOS NO COMPRADOS
SELECT NOMBRE, PRODUCTO, PRECIO FROM TIPO_PRODUCTO TP
INNER JOIN PRODUCTOS P ON TP.ID = P.TIPO_PRODUCTO_ID
LEFT JOIN DETALLE_COMPRAS DC ON P.ID = DC.PRODUCTO_ID
WHERE DC.ID IS NULL
ORDER BY TP.NOMBRE;


-- PRECIO MAXIMO Y MINIMO COMPRADO
EXPLAIN ANALYZE SELECT NOMBRE, PRODUCTO, PRECIO
FROM PRODUCTOS P
INNER JOIN TIPO_PRODUCTO T on P.TIPO_PRODUCTO_ID = T.ID
WHERE P.PRECIO = (SELECT MAX(PRECIO) PRECIO_MAX
    FROM TIPO_PRODUCTO TP
    INNER JOIN PRODUCTOS P ON TP.ID = P.TIPO_PRODUCTO_ID
    INNER JOIN DETALLE_COMPRAS DC ON P.ID = DC.PRODUCTO_ID
    ORDER BY TP.NOMBRE)
OR P.PRECIO = (SELECT MIN(PRECIO) PRECIO_MIN
    FROM TIPO_PRODUCTO TP
    INNER JOIN PRODUCTOS P ON TP.ID = P.TIPO_PRODUCTO_ID
    INNER JOIN DETALLE_COMPRAS DC ON P.ID = DC.PRODUCTO_ID
    ORDER BY TP.NOMBRE);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- ANALIZANDO COSTE DE QUERY

EXPLAIN SELECT NOMBRE, PAIS FROM CLIENTES
WHERE PAIS IN ('CHILE','ALEMANIA')
ORDER BY PAIS;


EXPLAIN ANALYZE SELECT * FROM CLIENTES
WHERE ID BETWEEN 0 AND 10;


EXPLAIN ANALYZE SELECT *
FROM CLIENTES
WHERE ID > 0
AND ID <= 10;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- MOSTRANDO LOS UNICOS CON DISTINCT
SELECT COUNT(*) FROM (
    SELECT NOMBRE
    FROM CLIENTES CLI
    INNER JOIN COMPRAS C on CLI.ID = C.CLIENTE_ID
    GROUP BY NOMBRE
    ) CLIENTES;


SELECT NOMBRE, COUNT(NOMBRE) COMPRAS_TOTALES
FROM CLIENTES CLI
INNER JOIN COMPRAS COM on CLI.ID = COM.CLIENTE_ID
GROUP BY NOMBRE
ORDER BY NOMBRE;

-- CREANDO TABLA A PARTIR DE UNA QUERY
CREATE TABLE AFDTMP AS (
    SELECT C.NOMBRE, P.PRODUCTO, P.PRECIO
    FROM COMPRAS COM
    INNER JOIN DETALLE_COMPRAS DC on COM.ID = DC.COMPRA_ID
    INNER JOIN PRODUCTOS P on DC.PRODUCTO_ID = P.ID
    INNER JOIN CLIENTES C on COM.CLIENTE_ID = C.ID
    ORDER BY NOMBRE, PRECIO
);

DROP TABLE AFDTMP;

-- CREANDO UNA VISTA
CREATE VIEW VIEW_AFD AS (
    SELECT C.NOMBRE, P.PRODUCTO, P.PRECIO
    FROM COMPRAS COM
    INNER JOIN DETALLE_COMPRAS DC on COM.ID = DC.COMPRA_ID
    INNER JOIN PRODUCTOS P on DC.PRODUCTO_ID = P.ID
    INNER JOIN CLIENTES C on COM.CLIENTE_ID = C.ID
    ORDER BY NOMBRE, PRECIO
);

SELECT * FROM VIEW_AFD;

DROP VIEW VIEW_AFD;


-- SUMA
SELECT C.NOMBRE, SUM(P.PRECIO) CONSUMO_TOTAL
FROM COMPRAS COM
INNER JOIN DETALLE_COMPRAS DC on COM.ID = DC.COMPRA_ID
INNER JOIN PRODUCTOS P on DC.PRODUCTO_ID = P.ID
INNER JOIN CLIENTES C on COM.CLIENTE_ID = C.ID
GROUP BY NOMBRE
ORDER BY NOMBRE;

SELECT MAX(CONSUMO_TOTAL) FROM (
    SELECT SUM(P.PRECIO) CONSUMO_TOTAL
    FROM COMPRAS COM
    INNER JOIN DETALLE_COMPRAS DC on COM.ID = DC.COMPRA_ID
    INNER JOIN PRODUCTOS P on DC.PRODUCTO_ID = P.ID
    INNER JOIN CLIENTES C on COM.CLIENTE_ID = C.ID
    GROUP BY NOMBRE
    ORDER BY NOMBRE
) CONSUMO;
