DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE MODELO CASCADE CONSTRAINTS;
DROP TABLE PREMIUM CASCADE CONSTRAINTS;
DROP TABLE ESTANDAR CASCADE CONSTRAINTS;
DROP TABLE MECANICO CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE SERVICIO CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS;


--CREACIÓN DE TABLAS

CREATE TABLE SERVICIO(
    id_servicio NUMBER(3) CONSTRAINT servicio_pk PRIMARY KEY,
    descripcion VARCHAR2(100) NOT NULL,
    costo NUMBER(7) NOT NULL
);


CREATE TABLE PAIS(
    --clave primaria de la tabla que se inicia con el n°9 y se autoincrementa en 3.
    id_pais NUMBER(3) GENERATED ALWAYS AS IDENTITY START WITH 9 INCREMENT BY 3 CONSTRAINT pais_pk PRIMARY KEY,
    nom_pais VARCHAR2(30) NOT NULL
);


CREATE TABLE CIUDAD(
    id_ciudad NUMBER(3) CONSTRAINT ciudad_pk PRIMARY KEY,
    nom_ciudad VARCHAR2(30) NOT NULL,
    cod_pais NUMBER(3) NOT NULL,
    CONSTRAINT fk_ciudad_pais FOREIGN KEY (cod_pais) REFERENCES PAIS(id_pais)
);


CREATE TABLE SUCURSAL(
    id_sucursal CHAR(3) CONSTRAINT sucursal_pk PRIMARY KEY,
    nom_sucursal VARCHAR2(20) NOT NULL,
    calle VARCHAR2(20) NOT NULL,
    num_calle NUMBER(4) NOT NULL,
    cod_ciudad NUMBER(3) NOT NULL,
    --Clave foránea cod_ciudad hace referencia a la columna id_ciudad de la tabla CIUDAD
    CONSTRAINT fk_sucursal_ciudad FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD(id_ciudad)
);


CREATE TABLE MECANICO(
    --clave primaria de la tabla que se inicia con el n°460 y se autoincrementa en 7.
    cod_mecanico NUMBER(5) GENERATED ALWAYS AS IDENTITY START WITH 460 INCREMENT BY 7 CONSTRAINT mecanico_pk PRIMARY KEY,
    pnombre VARCHAR2(20) NOT NULL,
    snombre VARCHAR2(20) NOT NULL,
    apaterno VARCHAR2(20) NOT NULL,
    amaterno VARCHAR2(20) NOT NULL,
    bono_jefatura NUMBER(10),
    sueldo NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor NUMBER(5),
    --clave foránea autorreferenciada
    CONSTRAINT fk_mecanico_mecanico FOREIGN KEY (cod_supervisor) REFERENCES MECANICO(cod_mecanico)
);


CREATE TABLE CLIENTE(
    rut NUMBER(8) CONSTRAINT cliente_pk PRIMARY KEY,
    dv_cliente CHAR(1) NOT NULL,
    pnombre VARCHAR2(20) NOT NULL,
    snombre VARCHAR2(20),
    apaterno VARCHAR2(20) NOT NULL,
    amaterno VARCHAR2(20) NOT NULL,
    telefono VARCHAR2(12),
    email VARCHAR2(40),
    tipo_cli CHAR(1) NOT NULL
);

--Un cliente puede ser estándar
CREATE TABLE ESTANDAR(
    cl_rut NUMBER(8) CONSTRAINT normal_pk PRIMARY KEY,
    puntaje_fidelidad NUMBER(10) NOT NULL,
    --Clave foránea cl_rut hace referencia a la columna rut de la tabla CLIENTE
    CONSTRAINT fk_normal_cliente FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);

--Un cliente puede ser premium
CREATE TABLE PREMIUM(
    cl_rut NUMBER(8) CONSTRAINT premium_pk PRIMARY KEY,
    pesos_clientes NUMBER(10) NOT NULL,
    monto_credito NUMBER(10),
    --Clave foránea cl_rut hace referencia a la columna rut de la tabla CLIENTE
    CONSTRAINT fk_premium_cliente FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);


CREATE TABLE MARCA(
    id_marca NUMBER(2) CONSTRAINT marca_pk PRIMARY KEY,
    descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE MODELO(
    id_modelo NUMBER(5) NOT NULL,
    marca_id NUMBER(2) NOT NULL,
    --Clave primaria compuesta por id_modelo y marca_id
    CONSTRAINT modelo_pk PRIMARY KEY (id_modelo, marca_id), 
    --Clave foránea marca_id hace referencia a la columna id_marca de la tabla MARCA
    CONSTRAINT fk_modelo_marca FOREIGN KEY (marca_id) REFERENCES MARCA(id_marca)
);


CREATE TABLE TIPO_AUTOMOVIL(
    id_tipo CHAR(3) CONSTRAINT tipo_automovil_pk PRIMARY KEY,
    descripcion VARCHAR2(20) NOT NULL
);


CREATE TABLE AUTOMOVIL(
    patente CHAR(8) CONSTRAINT automovil_pk PRIMARY KEY,
    annio NUMBER(4) NOT NULL,
    cant_puertas NUMBER(1) NOT NULL,
    km NUMBER(6) NOT NULL,
    color VARCHAR2(30) NOT NULL,
    cod_tipo_auto CHAR(3) NOT NULL,
    cod_modelo NUMBER(5) NOT NULL,
    cod_marca NUMBER(2) NOT NULL,
    cl_rut NUMBER(8) NOT NULL,
    --Clave foránea cod_tipo_auto hace referencia a la columna id_tipo de la tabla TIPO_AUTOMOVIL
    CONSTRAINT fk_automovil_tipo FOREIGN KEY (cod_tipo_auto) REFERENCES TIPO_AUTOMOVIL(id_tipo),
    --Claves foráneas cod_model y cod_marca hacen referencia a las columnas id_modelo y marca_id de la tabla MODELO
    CONSTRAINT fk_automovil_modelo FOREIGN KEY (cod_modelo, cod_marca) REFERENCES MODELO(id_modelo, marca_id),
    --Clave foránea cl_rut hace referencia a la columna rut de la tabla CLIENTE
    CONSTRAINT fk_automovil_cliente FOREIGN KEY (cl_rut) REFERENCES CLIENTE(rut)
);


CREATE TABLE MANTENCION(
    num_mantencion NUMBER(4) CONSTRAINT mantencion_pk PRIMARY KEY,
    cod_sucursal CHAR(3) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE,
    patente_auto CHAR(8),
    cod_mecanico NUMBER(5) NOT NULL,
    costo_total NUMBER(7) NOT NULL,
    estado VARCHAR2(15),
    --Clave foránea cod_sucursal hace referencia a la columna id_sucursal de la tabla SUCURSAL
    CONSTRAINT fk_mant_sucursal FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL(id_sucursal),
    --Clave foránea patente_auto hace referencia a la columna patente de la tabla AUTOMOVIL
    CONSTRAINT fk_mant_automovil FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL(patente),
    --Clave foránea cod_mecanico hace referencia a la columna cod_mecanico de la tabla MECANICO
    CONSTRAINT fk_mant_mecanico FOREIGN KEY (cod_mecanico) REFERENCES MECANICO(cod_mecanico)
);


CREATE TABLE DETALLE_SERVICIO(
    mantencion_num NUMBER(4) NOT NULL,
    cod_servicio NUMBER(3) NOT NULL,
    descuento_serv NUMBER(4,3) NOT NULL,
    cantidad NUMBER(3) NOT NULL,
    --Clave primaria compuesta por mantencion_num y cod_servicio
    CONSTRAINT detalle_servicio_pk PRIMARY KEY (mantencion_num, cod_servicio),
    --Clave foránea mantencion_num hace referencia a la columna num_mantencion de la tabla MANTENCION
    CONSTRAINT fk_det_serv_mantencion FOREIGN KEY (mantencion_num) REFERENCES MANTENCION(num_mantencion),
    --Clave foránea cod_servicio hace referencia a la columna id_servicio de la tabla SERVICIO
    CONSTRAINT fk_det_serv_servicio FOREIGN KEY (cod_servicio) REFERENCES SERVICIO(id_servicio)
);


--ALTERACIÓN DE TABLAS

--Elimina la columna costo_total de la tabla MANTENCION
ALTER TABLE MANTENCION DROP COLUMN costo_total; 

--Se elimina la restriccion fk_det_serv_mantencion de la tabla DETALLE_SERVICIO
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT fk_det_serv_mantencion;

--Se elimina la restriccion mantencion_pk PRIMARY KEY de la tabla MANTENCION
ALTER TABLE MANTENCION DROP CONSTRAINT mantencion_pk; 

--Se agrega una clave primaria compuesta por num_mantencion y cod_sucursal a la tabla MANTENCION
ALTER TABLE MANTENCION ADD CONSTRAINT mantencion_pk PRIMARY KEY (num_mantencion, cod_sucursal);

--Se agrega cod_sucursal a la tabla DETALLE_SERVICIO
ALTER TABLE DETALLE_SERVICIO ADD cod_sucursal CHAR(3) NOT NULL;

--Se agregan las claves foráneas mantencion_num y cod_sucursal que hacen referencia a la columna
--num_mantencion y cod_sucursal de la tabla MANTENCION
ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT fk_det_serv_mantencion FOREIGN KEY (mantencion_num, cod_sucursal)
REFERENCES MANTENCION(num_mantencion, cod_sucursal);

--Se agrega una restriccion a la tabla CLIENTE agregando una condicion para los valores del dv_cliente
ALTER TABLE CLIENTE ADD CONSTRAINT 
ck_dv_cliente CHECK (dv_cliente IN ('0','1','2','3','4','5','6','7','8','9','K')); 

--Se agrega una restriccion a la tabla MECANICO
--agregando una condicion que impone como mínimo un valor de 510000 para el sueldo
ALTER TABLE MECANICO ADD CONSTRAINT ck_sueldo_mecanico CHECK (sueldo>=510000);

--Se agrega una restriccion a la tabla MANTENCION que impone qué valores puede tener un "estado"
ALTER TABLE MANTENCION ADD CONSTRAINT ck_estado_mantencion
CHECK (estado IN ('Reserva', 'Ingresado', 'Entregado', 'Anulado'));


--SECUENCIAS

--Secuencia para la tabla SERVICIO, que comienza en 400 y se incrementa en 2
CREATE SEQUENCE seq_servicio START WITH 400 INCREMENT BY 2;

--Secuencia para la tabla CIUDAD, que comienza en 165 y se incrementa en 5
CREATE SEQUENCE seq_ciudad START WITH 165 INCREMENT BY 5;


--INSERCIÓN DE DATOS EN TABLAS

INSERT INTO SERVICIO(id_servicio, descripcion, costo)VALUES(seq_servicio.nextval, 'Cambio luces', 45000);
INSERT INTO SERVICIO(id_servicio, descripcion, costo)VALUES(seq_servicio.nextval, 'Desabolladura', 67000);
INSERT INTO SERVICIO(id_servicio, descripcion, costo)VALUES(seq_servicio.nextval, 'Revisión frenos', 30000);
INSERT INTO SERVICIO(id_servicio, descripcion, costo)VALUES(seq_servicio.nextval, 'Cambio puerta trasera', 50000);


INSERT INTO PAIS(nom_pais)VALUES('Chile');
INSERT INTO PAIS(nom_pais)VALUES('Perú');
INSERT INTO PAIS(nom_pais)VALUES('Colombia');

INSERT INTO CIUDAD(id_ciudad, nom_ciudad, cod_pais)VALUES(seq_ciudad.nextval, 'Santiago', 9);
INSERT INTO CIUDAD(id_ciudad, nom_ciudad, cod_pais)VALUES(seq_ciudad.nextval, 'Lima', 12);
INSERT INTO CIUDAD(id_ciudad, nom_ciudad, cod_pais)VALUES(seq_ciudad.nextval, 'Bogotá', 15);


INSERT INTO SUCURSAL(id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES('S01', 'Providencia', 'Av. A. Varas', 234, 165);
INSERT INTO SUCURSAL(id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);
INSERT INTO SUCURSAL(id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES('S03', 'El cafetero', 'Av. El faro', 900, 175);


INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos)
VALUES('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580);
INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, sueldo, monto_impuestos)
VALUES('Pedro', 'Jose', 'Manriquez', 'Corral', 759000, 23980);
INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);
INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, sueldo, monto_impuestos, cod_supervisor)
VALUES('Felipe', 'M.', 'Vidal', 'A.', 759000, 23580, 460);
INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, sueldo, monto_impuestos, cod_supervisor)
VALUES('Jose', 'Miguel', 'Troncoso', 'B.', 659000, 44580, 474);
INSERT INTO MECANICO(pnombre, snombre, apaterno, amaterno, sueldo, monto_impuestos, cod_supervisor)
VALUES('Juan', 'Pablo', 'Sanchez', 'R.', 859000, 23380, 474);


INSERT INTO MARCA(id_marca, descripcion)VALUES(1, 'Mazda');
INSERT INTO MARCA(id_marca, descripcion)VALUES(2, 'Chevrolet');
INSERT INTO MARCA(id_marca, descripcion)VALUES(3, 'Toyota');


INSERT INTO MODELO(id_modelo, marca_id)VALUES(40, 1);
INSERT INTO MODELO(id_modelo, marca_id)VALUES(97, 2);
INSERT INTO MODELO(id_modelo, marca_id)VALUES(103, 3);

INSERT INTO TIPO_AUTOMOVIL(id_tipo, descripcion)VALUES(1, 'Sedan');
INSERT INTO TIPO_AUTOMOVIL(id_tipo, descripcion)VALUES(2, 'Pick-up');
INSERT INTO TIPO_AUTOMOVIL(id_tipo, descripcion)VALUES(3, 'Minivan');
INSERT INTO TIPO_AUTOMOVIL(id_tipo, descripcion)VALUES(4, 'SUV');


INSERT INTO CLIENTE(rut, dv_cliente, pnombre, apaterno, amaterno, telefono, tipo_cli)
VALUES(11323456, '7', 'Hector', 'Morales', 'Lopez', '923456103', 'P');
INSERT INTO CLIENTE(rut, dv_cliente, pnombre, apaterno, amaterno, telefono, tipo_cli)
VALUES(14432903, '2', 'Fernanda', 'Dominguez', 'Suarez', '910224594', 'E');
INSERT INTO CLIENTE(rut, dv_cliente, pnombre, apaterno, amaterno, telefono, tipo_cli)
VALUES(15405220, '3', 'Felipe', 'Rivera', 'Martinez', '903449123', 'E');


INSERT INTO AUTOMOVIL(patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES('ABCD-12', 2012, 4, 221000, 'Rojo', 1, 40, 1, 11323456);
INSERT INTO AUTOMOVIL(patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES('BFGH-34', 2020, 4, 45000, 'Rojo', 4, 97, 2, 14432903);
INSERT INTO AUTOMOVIL(patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut)
VALUES('CJKL-56', 2022, 4, 11500, 'Gris', 2, 103, 3, 15405220);


INSERT INTO MANTENCION(num_mantencion, cod_sucursal, fecha_ingreso, cod_mecanico, estado)
VALUES(101, 'S01', '12-04-2023', 460, 'Reserva');
INSERT INTO MANTENCION(num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, cod_mecanico, estado)
VALUES(102, 'S02', '21-02-2023', '21-02-2023', 467, 'Entregado');
INSERT INTO MANTENCION(num_mantencion, cod_sucursal, fecha_ingreso, cod_mecanico, estado)
VALUES(103, 'S02', '09-10-2023', 474, 'Anulado');
INSERT INTO MANTENCION(num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, cod_mecanico, estado)
VALUES(104, 'S03', '11-08-2023', '18-08-2023', 481, 'Entregado');


--RECUPERACIÓN DE DATOS

SELECT 
    cod_mecanico AS "ID MECANICO",
    pnombre || ' ' || snombre || ' ' || apaterno || ' ' || amaterno AS "NOMBRE MECANICO",
    sueldo AS "SALARIO",
    monto_impuestos AS "IMPUESTO ACTUAL",
    monto_impuestos * 0.8 AS "IMPUESTO REBAJADO",
    sueldo - (monto_impuestos * 0.80) AS "SUELDO CON REBAJA IMPUESTOS"
FROM MECANICO
WHERE bono_jefatura IS NULL AND monto_impuestos < 40000  
ORDER BY 4 DESC, apaterno ASC;

SELECT 
    cod_mecanico AS "IDENTIFICADOR",
    pnombre || ' ' || snombre || ' ' || apaterno || ' ' || amaterno AS "MECANICO",
    sueldo AS "SALARIO ACTUAL",
    sueldo*0.05 AS "AJUSTE",
    sueldo + (sueldo*0.05) AS "SUELDO_REAJUSTADO"
FROM MECANICO
WHERE sueldo BETWEEN 600000 AND 900000 OR cod_supervisor IS NULL   
ORDER BY 3 ASC, 2 DESC;

