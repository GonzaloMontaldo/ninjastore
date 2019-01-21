/* 
-----------------------------------------------

DEFINITIVO!!!! ULTIMO UPDATE: 14/10/2018  
-----------------------------------------------
*/

/* 
-----------------------------------------------

DROPS

-----------------------------------------------
*/

DROP TABLE IF EXISTS HIJO;
DROP TABLE IF EXISTS CONTIENE;
DROP TABLE IF EXISTS CREA;
DROP TABLE IF EXISTS REALIZA;
DROP TABLE IF EXISTS GESTIONA;
DROP TABLE IF EXISTS PERMUTA;
/*DROP TABLE IF EXISTS COMUNICA;*/
DROP TABLE IF EXISTS PREGUNTA;
DROP TABLE IF EXISTS FACTURA;
DROP TABLE IF EXISTS COMPRA;
DROP TABLE IF EXISTS FAVORITO;
DROP TABLE IF EXISTS USUARIOTEL;
DROP TABLE IF EXISTS PUBLICACIONIMG;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS PUBLICACION;
DROP TABLE IF EXISTS CATEGORIA;
DROP TABLE IF EXISTS DENUNCIA;
DROP TABLE IF EXISTS HISTORIAL;

/* 
-----------------------------------------------

CREATE TABLES

-----------------------------------------------
*/

CREATE TABLE USUARIO(
	ID 				SERIAL 			NOT NULL,
	CEDULA			VARCHAR(10)		NOT NULL,
	USUARIO			VARCHAR(20)		NOT NULL,
	PASSWORD		VARCHAR(50)		NOT NULL,
	PASSWORD		VARCHAR(50)		NOT NULL,
	PNOMBRE			VARCHAR(20)		NOT NULL,
	SNOMBRE			VARCHAR(20),
	PAPELLIDO		VARCHAR(20)		NOT NULL,
	SAPELLIDO		VARCHAR(20),
	FNACIMIENTO		DATETIME		NOT NULL,
	EMAIL			VARCHAR(50)		NOT NULL,
	CALLE			VARCHAR(50),
	NUMERO			INT,
	ESQUINA			VARCHAR(50),
	CPOSTAL			INT				DEFAULT 0,
	LOCALIDAD		VARCHAR(50),
	DEPARTAMENTO	VARCHAR(50),
	GEOX			VARCHAR(15),		
	GEOY			VARCHAR(15),
	TIPO			VARCHAR(10)		DEFAULT 'COMUN',
	ESTADO			VARCHAR(50)		DEFAULT 'CONFIRMAR EMAIL',
	ACTIVACION		VARCHAR(100)	DEFAULT 1,
	ROL				VARCHAR(50)		DEFAULT 'CLIENTE',
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	UNIQUE			(CEDULA),
	UNIQUE			(USUARIO),
	UNIQUE			(EMAIL),
	INDEX			(CEDULA),
	INDEX			(USUARIO),
	CHECK			(TIPO='COMUN' AND TIPO='VIP'),
	CHECK			(ESTADO='CONFIRMAR EMAIL' AND ESTADO='ACTIVADO' AND ESTADO='BANEADO' AND ESTADO='BLOQUEADO' AND ESTADO='DESHABILITADO' AND ESTADO='MANTENIMIENTO'),
	CHECK			(ROL='CLIENTE' AND ROL='ADMINISTRADOR' AND ROL='MODERADOR')
);
CREATE TABLE USUARIOTEL(
	ID 				BIGINT(20)		UNSIGNED NOT NULL,
	TELEFONO		VARCHAR(10)		NOT NULL,
	PRIMARY KEY		(ID,TELEFONO),
	FOREIGN KEY		(ID) REFERENCES USUARIO(ID),
	UNIQUE			(TELEFONO)
);
CREATE TABLE CATEGORIA(
	ID 				SERIAL 			NOT NULL,
	TITULO 			VARCHAR(50) 	NOT NULL,
	PADRE			BIGINT(20)		UNSIGNED NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	FOREIGN key (PADRE) REFERENCES CATEGORIA(ID),
	UNIQUE			(TITULO)
);
CREATE TABLE PUBLICACION(
	ID 				SERIAL 			NOT NULL,
	IDCATEGORIA		BIGINT(20)		UNSIGNED NOT NULL,
	TITULO			VARCHAR(50) 	NOT NULL,
	DESCRIPCION 	TEXT 			NOT NULL,
	IMGDEFAULT 		VARCHAR(50)		DEFAULT 'noimage',
	PRECIO			DOUBLE(10,2) 	DEFAULT 1,
	OFERTA			BOOLEAN 		DEFAULT 0,
	DESCUENTO		INT 			DEFAULT 0,
	FOFERTA			DATETIME,
	ESTADOP 		VARCHAR(10) 	DEFAULT 'PUBLICADA',
	ESTADOA 		VARCHAR(10) 	DEFAULT 'NUEVO',
	CANTIDAD		INT 			NOT NULL,
	VISTO 			INT 			DEFAULT 0,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	INDEX			(TITULO),
	FOREIGN KEY		(IDCATEGORIA) REFERENCES CATEGORIA(ID),
	CHECK			(ESTADOP='PUBLICADA' AND ESTADOP='BORRADOR' AND ESTADOP='CANCELADA' AND ESTADOP='BANEADA'),
	CHECK			(ESTADOA='NUEVO' AND ESTADOA='USADO')
);
CREATE TABLE PUBLICACIONIMG(
	ID 				BIGINT(20)		UNSIGNED NOT NULL,
	IMAGENES		VARCHAR(50)		DEFAULT 'DEFAULT.JPG',
	PRIMARY KEY		(ID,IMAGENES),
	FOREIGN KEY		(ID) REFERENCES PUBLICACION(ID)
);
CREATE TABLE DENUNCIA(
	ID 				SERIAL 			NOT NULL,
	FECHA			DATETIME 		NOT NULL,
	TIPO			VARCHAR(15) 	NOT NULL,
	IDOBJETO		BIGINT(20)		UNSIGNED NOT NULL,
	COMENTARIO 		VARCHAR(150),
	ESTADO 			VARCHAR(10) 	DEFAULT 'ACTIVA',
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	INDEX			(IDOBJETO),
	CHECK			(TIPO='PUBLICACION' AND TIPO='COMENTARIO' AND TIPO='COMPRA' AND TIPO='CATEGORIAS' AND TIPO='USUARIO'),
	CHECK			(ESTADO='ACTIVA' AND ESTADO='CERRADA' AND ESTADO='EN PROCESO')
);
CREATE TABLE HISTORIAL(
	ID 				SERIAL 			NOT NULL,
	USUARIO 		VARCHAR(15) 	NOT NULL,
	ACCION			VARCHAR(15) 	NOT NULL,
	DESCRIPCCION	TEXT			NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	INDEX			(USUARIO)
);
CREATE TABLE FAVORITO(
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDPUBLICACION 	BIGINT(20)		UNSIGNED NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(IDUSUARIO,IDPUBLICACION),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID)
);
CREATE TABLE COMPRA(
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDPUBLICACION 	BIGINT(20)		UNSIGNED NOT NULL,
	FECHACOMPRA 	TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONCRETADO 		BOOLEAN			DEFAULT 0,
	FECHACONCRETADO DATETIME,
	CANTIDAD 		INT 			DEFAULT 1,
	TOTAL 			DOUBLE(10,2)	NOT NULL,
	COMISION 		DOUBLE(10,2)	NOT NULL,
	CALIFICACION 	INT,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(IDUSUARIO,IDPUBLICACION,FECHACOMPRA),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID),
	CHECK			(CALIFICACION=1 AND CALIFICACION=2 AND CALIFICACION=3 AND CALIFICACION=5 AND CALIFICACION=5)
);
CREATE TABLE FACTURA(
	ID 				SERIAL 			NOT NULL,
	IDCOMPRA		BIGINT(20)		UNSIGNED NOT NULL,
	FECHAC 			DATETIME 		NOT NULL,
	FECHAV 			DATETIME 		NOT NULL,
	ESTADO 			VARCHAR(15) 	NOT NULL,
	SUBTOTAL 		DOUBLE(10,2) 	NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID),
	CHECK			(ESTADO='PENDIENTE' AND ESTADO='PAGA' AND ESTADO='VENCIDA')
);
CREATE TABLE PREGUNTA(
	ID 				SERIAL			NOT NULL,
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDPUBLICACION 	BIGINT(20)		UNSIGNED NOT NULL,
	MENSAJE 		VARCHAR(150) 	NOT NULL,
	FECHAM 			TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP,
	RESPUESTA 		VARCHAR(150),
	FECHAR 			DATETIME,
	ESTADO			VARCHAR(15) 	DEFAULT 'ACTIVO',
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID,IDUSUARIO,IDPUBLICACION),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID),
	CHECK			(ESTADO='ACTIVO' AND ESTADO='BANEADO')
);
CREATE TABLE PERMUTA(
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDPUBLICACION 	BIGINT(20)		UNSIGNED NOT NULL,
	ESTADO 			VARCHAR(15) 	DEFAULT 'ACTIVA',
	FECHAP 			DATETIME 		NOT NULL,
	ACEPTADA 		BOOLEAN			DEFAULT 0,
	FECHAC 			DATETIME,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(IDUSUARIO,IDPUBLICACION),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID),
	CHECK			(ESTADO='ACTIVA' AND ESTADO='CERRADA')
);
CREATE TABLE GESTIONA(
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDDENUNCIA 		BIGINT(20)		UNSIGNED NOT NULL,
	FECHA 			DATETIME 		NOT NULL,
	DESCRIPCION 	TEXT,
	HTML 			TEXT,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(IDUSUARIO,IDDENUNCIA),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDDENUNCIA) REFERENCES DENUNCIA(ID)
);
CREATE TABLE REALIZA (
	IDDENUNCIA 		BIGINT(20)		UNSIGNED NOT NULL,
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(IDDENUNCIA,IDUSUARIO),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDDENUNCIA) REFERENCES DENUNCIA(ID)
);
CREATE TABLE CREA (
	ID 				SERIAL 			NOT NULL,
	IDUSUARIO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDPUBLICACION	BIGINT(20)		UNSIGNED NOT NULL,
	FECHA 			DATETIME 		NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID,IDUSUARIO,IDPUBLICACION),
	FOREIGN KEY		(IDUSUARIO) REFERENCES USUARIO(ID),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID)
);
CREATE TABLE CONTIENE (
	ID 				SERIAL 			NOT NULL,
	IDPUBLICACION	BIGINT(20)		UNSIGNED NOT NULL,
	IDCATEGORIA 	BIGINT(20)		UNSIGNED NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID,IDPUBLICACION,IDCATEGORIA),
	FOREIGN KEY		(IDPUBLICACION) REFERENCES PUBLICACION(ID),
	FOREIGN KEY		(IDCATEGORIA) REFERENCES CATEGORIA(ID)
);
CREATE TABLE HIJO (
	ID 				SERIAL 			NOT NULL,
	IDCATHIJO 		BIGINT(20)		UNSIGNED NOT NULL,
	IDCATPADRE 		BIGINT(20)		UNSIGNED NOT NULL,
	BAJA			BOOLEAN			DEFAULT 0,
	PRIMARY KEY		(ID,IDCATHIJO,IDCATPADRE),
	FOREIGN KEY		(IDCATHIJO) REFERENCES CATEGORIA(ID),
	FOREIGN KEY		(IDCATPADRE) REFERENCES CATEGORIA(ID)
);

/* 
-----------------------------------------------

VISTAS

-----------------------------------------------
*/

CREATE VIEW DATOS_PERSONA_AUX01 AS 
SELECT U.ID,SUM(CO.CANTIDAD) AS VENTAS
FROM USUARIO U
LEFT JOIN COMPRA CO ON U.ID=CO.IDUSUARIO
GROUP BY U.ID;

CREATE VIEW DATOS_PERSONA_AUX02 AS
SELECT CR.IDUSUARIO,ROUND(AVG(CO.CALIFICACION)) AS NOTA,COUNT(CO.CALIFICACION) AS CALIFICACION
FROM CREA CR, COMPRA CO
WHERE CR.IDPUBLICACION=CO.IDPUBLICACION
GROUP BY CR.IDUSUARIO;

CREATE VIEW DATOS_PERSONA_AUX03 AS
SELECT U.ID,CALIFICACION,NOTA
FROM USUARIO U
LEFT JOIN DATOS_PERSONA_AUX02 TT ON U.ID=TT.IDUSUARIO
GROUP BY U.ID;

CREATE VIEW DATOS_PERSONA AS
SELECT U.ID,COUNT(CR.IDPUBLICACION) AS PUBLICACIONES,VENTAS,CALIFICACION,NOTA
FROM USUARIO U
	LEFT JOIN CREA CR ON U.ID=CR.IDUSUARIO
	LEFT JOIN DATOS_PERSONA_AUX01 TT ON U.ID=TT.ID
	LEFT JOIN DATOS_PERSONA_AUX03 TT2 ON U.ID=TT2.ID
GROUP BY U.ID;


CREATE VIEW DATOS_PRODUCTO_AUX01 AS
SELECT IDPUBLICACION,COUNT(ID) as PREGUNTAS 
FROM PREGUNTA 
GROUP BY IDPUBLICACION;


CREATE VIEW DATOS_PRODUCTO AS
SELECT P.ID,P.VISTO,SUM(CO.CANTIDAD) AS VENTAS,CM.PREGUNTAS
FROM PUBLICACION P
	LEFT JOIN COMPRA CO ON P.ID=CO.IDPUBLICACION
    LEFT JOIN DATOS_PRODUCTO_AUX01 CM ON P.ID=CM.IDPUBLICACION
GROUP BY P.ID;

CREATE VIEW DATOS_PRODUCTO_VIP AS
SELECT U.ID AS USUARIO,P.* 
FROM USUARIO U, CREA C, PUBLICACION P
WHERE U.ID=C.IDUSUARIO
AND C.IDPUBLICACION=P.ID
AND U.TIPO="VIP";

CREATE VIEW DATOS_PRODUCTO_OFERTA AS
SELECT P.ID,P.IMGDEFAULT,P.PRECIO,P.TITULO,C.FECHA
FROM CREA C, PUBLICACION P
WHERE P.OFERTA="1"
AND C.IDPUBLICACION=P.ID
ORDER BY RAND()
LIMIT 8;

CREATE VIEW DATOS_PRODUCTO_INDEX AS 
SELECT U.ID AS USUARIO,P.ID,U.TIPO,P.IMGDEFAULT,P.PRECIO,P.TITULO,C.FECHA
FROM USUARIO U, CREA C, PUBLICACION P
WHERE U.ID=C.IDUSUARIO
AND C.IDPUBLICACION=P.ID
ORDER BY U.TIPO DESC, RAND();
/* 
-----------------------------------------------

TRIGGERS

-----------------------------------------------
*/

/* 
-----------------------------------------------

PROCEDIMIENTOS ALMACENADOS

-----------------------------------------------
*/

/* 
-----------------------------------------------

INSERTS DE PRUEBAS

10 USUARIOS - 5 COMUNES 2 VIP 2 MODERADORES 1 ADMINISTRADOR
25 CATEGORIAS - 5 CATEGORIAS - 5 HIJO X PADRE
125 PRODUCTOS - 5 X CATEGORIA - 3 NUEVOS - 2 USADOS
-----------------------------------------------
*/
INSERT INTO USUARIO(ID, CEDULA, USUARIO, PASSWORD, PASSWORDADM, PNOMBRE, SNOMBRE, PAPELLIDO, SAPELLIDO, FNACIMIENTO, EMAIL, CALLE, NUMERO, ESQUINA, CPOSTAL, LOCALIDAD, DEPARTAMENTO, TIPO, ESTADO, ACTIVACION, ROL, BAJA) VALUES 
(6, '51652357', 'gabobuceo', '4e4800c9e622ec10c62c4bf2ca9aa88136d88bdf', NULL, 'Gabriel', NULL, 'Fernandez', NULL, '1990-11-28 00:00:00', 'emgabo@gmail.com', NULL, NULL, NULL, 0, NULL, NULL, 'COMUN', 'RECUPERAR', '37c55379bdf99df28c82e96e6ba62d49d0644680', 'CLIENTE', 0),

INSERT INTO USUARIO(CEDULA,PNOMBRE,PAPELLIDO,EMAIL,FNACIMIENTO,CALLE, NUMERO, ESQUINA,CPOSTAL, LOCALIDAD, DEPARTAMENTO, GEOX, GEOY, USUARIO, PASSWORD, PASSWORDADM,TIPO, ESTADO, ACTIVACION, ROL)VALUES 
("53373886","Rinah","Mathis","erat.eget.tincidunt@feugiat.org","1997-07-08","Magariños Cervantes","1930","Florencio Varela","11600","Parque Batlle","Montevideo","-34.890201","-56.140479","rmathis","f7c3bc1d808e04732adf679965ccc34ca7ae3441","f7c3bc1d808e04732adf679965ccc34ca7ae3441","COMUN","ACTIVADO",0,"MODERADOR"),
("53367920","Hope","Goodman","velit.Quisque.varius@luctussit.ca","1994-07-22","Guadalupe","1798","José L. Terra","11800","Goes","Montevideo","-34.879479","-56.180132","hgoodman","f7c3bc1d808e04732adf679965ccc34ca7ae3441","f7c3bc1d808e04732adf679965ccc34ca7ae3441","VIP","ACTIVADO",0,"MODERADOR"),
("52789056","Idola","Ford","nec.leo@CurabiturdictumPhasellus.com","1997-03-06","Paraguay","1104","Durazno","11100","Barrio Sur","Montevideo","-34.910560","-56.191877","iford","f7c3bc1d808e04732adf679965ccc34ca7ae3441","f7c3bc1d808e04732adf679965ccc34ca7ae3441","VIP","ACTIVADO",0,"ADMINISTRADOR"),
("52651081","Tanisha","Sexton","felis.purus@tellus.net","1992-06-04","Charcas","2752","Costa de Marfil","12800","Casabó","Montevideo","-34.886466","-56.271236","tsexton","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"COMUN","ACTIVADO",0,"CLIENTE"),
("52562268","Dillon","Church","eget.lacus@placerat.org","1994-03-06","Dr Adolfo Pedralbes","2351","Dr Luis Arcos Ferrand","11400","Malvin Alto","Montevideo","-34.874336","-56.112215","dchurch","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"COMUN","ACTIVADO",0,"CLIENTE"),
("52393922","Blair","Brady","magna.Nam@Nullamvitaediam.ca","1996-05-19","Río de Janeiro","4032","Calle Las Canoas","12800","Ciudad de la Costa","Departamento de Canelones","-34.837539","-55.984290","bbrady","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"COMUN","ACTIVADO",0,"CLIENTE"),
("52152922","Howard","Summers","elit.facilisi@nullaCras.net","1990-05-07","Calle 2","20","Calle 3","80500","Ciudad del Plata","Departamento de San José","-34.752014","-56.423861","hsummers","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"COMUN","ACTIVADO",0,"CLIENTE"),
("51860497","Tanya","Hubbard","sapien@loremtristique.com","1990-10-18","Av. Capitán Leal de Ibarra","5545","Capitán Pedro de Mesa y Castro","12800","Pajas Blancas","Montevideo","-34.866848","-56.335528","thubbard","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"COMUN","ACTIVADO",0,"CLIENTE"),
("51716911","Harriet","Gibbs","vitae.dolor@dolornonummy.co.uk","1992-07-07","Juan Russi","331","Javier de Viana","15900","La Paz","Departamento de Canelones","-34.760102","-56.235463","hgibbs","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"VIP","ACTIVADO",0,"CLIENTE"),
("51712727","Scarlet","Knox","Nunc@euaccumsan.net","1996-02-07","Pasaje F","1425","Pasaje E","12400","Asentamiento 21 de Enero","Montevideo","-34.799185","-56.171684","sknox","f7c3bc1d808e04732adf679965ccc34ca7ae3441",NULL,"VIP","ACTIVADO",0,"CLIENTE");

/* 
-----------------------------------------------

CONSULTAS SQL GENERICAS

-----------------------------------------------
*/

INSERT INTO USUARIO(ID, CEDULA, USUARIO, PASSWORD, PASSWORDADM, PNOMBRE, SNOMBRE, PAPELLIDO, SAPELLIDO, FNACIMIENTO, EMAIL, CALLE, NUMERO, ESQUINA, CPOSTAL, LOCALIDAD, DEPARTAMENTO, TIPO, ESTADO, ACTIVACION, ROL, BAJA) VALUES ()
UPDATE USUARIO SET ID=,CEDULA=,USUARIO=,PASSWORD=,PASSWORDADM=,PNOMBRE=,SNOMBRE=,PAPELLIDO=,SAPELLIDO=,FNACIMIENTO=,EMAIL=,CALLE=,NUMERO=,ESQUINA=,CPOSTAL=,LOCALIDAD=,DEPARTAMENTO=,TIPO=,ESTADO=,ACTIVACION=,ROL=,BAJA= WHERE 1