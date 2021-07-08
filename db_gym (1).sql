-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-07-2021 a las 01:08:18
-- Versión del servidor: 10.4.19-MariaDB
-- Versión de PHP: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_gym`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addGimnasio` (IN `_nombre` VARCHAR(45), IN `_telefono` VARCHAR(45), IN `_direccion` VARCHAR(45))  begin
declare checkIdGym int(10);
insert into Gimnasios (nombre, telefono, direccion) values (_nombre, _telefono, _direccion);
set checkIdGym = (select max(id_Gimnasio) from Gimnasios);
insert into Gimnasio_Roles (id_gym, id_rol) VALUES(checkIdGym, 1), (checkIdGym, 2), (checkIdGym, 3);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addRol` (IN `_rol` VARCHAR(45), IN `_gimnasio` INT(10))  begin
declare checkGym int(10);
declare countIdRol int(10);
declare checkRol int(10);
set checkRol = (select id_Rol from roles where rol = _rol);
set checkGym = (select id_Gimnasio from gimnasios where id_Gimnasio = _gimnasio);
if (checkGym is null) then 
select * from gimnasios;
elseif (checkRol is not null) then 
insert into gimnasio_roles (id_gym, id_rol) values (_gimnasio, checkRol);
else 
insert into Roles (rol) values (_rol);
set countIdRol = (select max(id_Rol) from roles);
insert into gimnasio_roles (id_gym, id_rol) values (_gimnasio, countIdRol);
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `formulario_Cliente` (IN `_nombre` VARCHAR(45), IN `_telefono` VARCHAR(45), IN `_huella` VARCHAR(45), IN `_periodo` VARCHAR(45), IN `_gimnasio` INT(10))  begin 
declare countGym int(10);
declare countHuella int(10);
declare checkIdGym int(10);
set checkIdGym = (select id_Suscripcion from pesuscripciones where periodo = _periodo and id_Gimnasio = _gimnasio);
set countGym = (select id_Gimnasio from Gimnasios where id_Gimnasio = _gimnasio);
if (countGym is null) then 
select * from Gimnasios;
elseif (checkIdGym is null) then 
SELECT * from pesuscripciones;
else
insert into Huellas(cod_huella) values (_huella);
set countHuella = (select max(id_Huella) from huellas);
insert into clientes (nombre, telefono, estado, id_Huella, id_Periodo, id_Gimnasio) values (_nombre, _telefono, 1, countHuella, checkIdGym, _gimnasio);
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `formulario_Empleado` (IN `_nombre` VARCHAR(45), IN `_telefono` VARCHAR(45), IN `_direccion` VARCHAR(45), IN `_huella` VARCHAR(45), IN `_rol` INT(10), IN `_turno` INT(10), IN `_documento` VARCHAR(45), IN `_gimnasio` INT(10))  begin
declare checkGym int(10);
declare checkRol int(10);
declare checkhuella int(10);
declare checkEmpleado int(10);
declare checkTurno int(10);
declare checkRolGym int(10);

set checkGym = (select id_Gimnasio from gimnasios where id_Gimnasio = _gimnasio);
set checkRol = (select id_Rol from roles where id_Rol = _rol);
set checkTurno = (select id_Turno from Turnos where id_Turno = _turno);
set checkRolGym = (select id_Rol_Gym from Gimnasio_Roles where id_gym =_gimnasio and id_rol = _rol);
if (checkGym is null || checkRol is null || checkTurno  is null) then 
select * from gimnasios;
select * from roles;
select * from Turnos;
elseif (checkRolGym is null) then 

select * from Gimnasio_Roles;
else 
insert into huellas (cod_huella) values (_huella);
set checkhuella = (select max(id_Huella) from huellas);
insert into datosempleado (nombre, telefono, direccion, estado, id_Rol, id_Turno, id_Huella, id_Gimnasio) values (_nombre, _telefono, _direccion, 1, _rol, _turno, checkhuella, _gimnasio);
set checkEmpleado = (select max(id_Dato) from datosempleado);

case (_rol) 
when (1) then 
insert into recepcion(carrera, id_Empleado) values(_documento, checkEmpleado);
when (2) then 
insert into instructor(certificacion, id_Empleado) values(_documento, checkEmpleado);
when (3) then 
insert into limpieza(solicitud, id_Empleado) values(_documento, checkEmpleado);
else 
insert into documentos_rol(documento, id_empleado, id_rol) values(_documento, checkEmpleado, _rol);
end case;

end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `showTablesEmpleados` ()  begin
SELECT * from Gimnasios;
SELECT * from Roles;
SELECT * from Gimnasio_Roles;
select * from datosEmpleado;
select * from Recepcion;
select * from Instructor;
select * from Limpieza;
select * from Documentos_Rol;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accesocliente`
--

CREATE TABLE `accesocliente` (
  `id_AccCl` int(10) NOT NULL,
  `fecha` datetime NOT NULL,
  `id_Cliente` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `accesocliente`:
--   `id_Cliente`
--       `clientes` -> `id_Cliente`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accesoempleado`
--

CREATE TABLE `accesoempleado` (
  `id_AccEm` int(10) NOT NULL,
  `fecha` date NOT NULL,
  `h_entrada` time NOT NULL,
  `id_Empleado` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `accesoempleado`:
--   `id_Empleado`
--       `datosempleado` -> `id_Dato`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_Cliente` int(10) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `id_Huella` int(10) NOT NULL,
  `id_Periodo` int(10) NOT NULL,
  `id_Gimnasio` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `clientes`:
--   `id_Huella`
--       `huellas` -> `id_Huella`
--   `id_Periodo`
--       `pesuscripciones` -> `id_Suscripcion`
--   `id_Gimnasio`
--       `gimnasios` -> `id_Gimnasio`
--

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_Cliente`, `nombre`, `telefono`, `estado`, `id_Huella`, `id_Periodo`, `id_Gimnasio`) VALUES
(2, 'Noe', '7382749382', 1, 3, 1, 1),
(3, 'Karla', '872736', 1, 9, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datosempleado`
--

CREATE TABLE `datosempleado` (
  `id_Dato` int(10) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `id_Rol` int(10) NOT NULL,
  `id_Huella` int(10) NOT NULL,
  `id_Turno` int(10) NOT NULL,
  `id_Gimnasio` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `datosempleado`:
--   `id_Rol`
--       `roles` -> `id_Rol`
--   `id_Huella`
--       `huellas` -> `id_Huella`
--   `id_Turno`
--       `turnos` -> `id_Turno`
--   `id_Gimnasio`
--       `gimnasios` -> `id_Gimnasio`
--

--
-- Volcado de datos para la tabla `datosempleado`
--

INSERT INTO `datosempleado` (`id_Dato`, `nombre`, `telefono`, `direccion`, `estado`, `id_Rol`, `id_Huella`, `id_Turno`, `id_Gimnasio`) VALUES
(1, 'Raul', '1837629083', 'Direccion_Raul', 1, 2, 1, 1, 1),
(2, 'Bere', '7384958273', 'direccion_Bere', 1, 1, 4, 1, 1),
(3, 'Pedro', '65443233', 'direccion pedro', 1, 5, 5, 1, 1),
(4, 'Pedro', '65443233', 'direccion pedro', 1, 5, 6, 1, 1),
(5, 'Pedro', '65443233', 'direccion pedro', 1, 5, 7, 1, 1),
(6, 'Pedro', '65443233', 'direccion pedro', 1, 5, 8, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos_rol`
--

CREATE TABLE `documentos_rol` (
  `id_DocR` int(10) NOT NULL,
  `documento` varchar(45) NOT NULL,
  `id_Empleado` int(10) NOT NULL,
  `id_Rol` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `documentos_rol`:
--   `id_Empleado`
--       `datosempleado` -> `id_Dato`
--   `id_Rol`
--       `roles` -> `id_Rol`
--

--
-- Volcado de datos para la tabla `documentos_rol`
--

INSERT INTO `documentos_rol` (`id_DocR`, `documento`, `id_Empleado`, `id_Rol`) VALUES
(1, 'diplomado', 6, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gimnasios`
--

CREATE TABLE `gimnasios` (
  `id_Gimnasio` int(10) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `gimnasios`:
--

--
-- Volcado de datos para la tabla `gimnasios`
--

INSERT INTO `gimnasios` (`id_Gimnasio`, `nombre`, `telefono`, `direccion`) VALUES
(1, 'Iron', '2234543678', 'calle Gym 1'),
(2, 'Maden', '2234543678', 'calle Gym 2'),
(3, 'Gym', '6765437654', 'direccion GyM');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gimnasio_roles`
--

CREATE TABLE `gimnasio_roles` (
  `id_Rol_gym` int(10) NOT NULL,
  `id_gym` int(10) NOT NULL,
  `id_rol` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `gimnasio_roles`:
--   `id_gym`
--       `gimnasios` -> `id_Gimnasio`
--   `id_rol`
--       `roles` -> `id_Rol`
--

--
-- Volcado de datos para la tabla `gimnasio_roles`
--

INSERT INTO `gimnasio_roles` (`id_Rol_gym`, `id_gym`, `id_rol`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 1),
(5, 2, 2),
(6, 2, 3),
(7, 2, 4),
(8, 3, 1),
(9, 3, 2),
(10, 3, 3),
(11, 1, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `huellas`
--

CREATE TABLE `huellas` (
  `id_Huella` int(10) NOT NULL,
  `cod_huella` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `huellas`:
--

--
-- Volcado de datos para la tabla `huellas`
--

INSERT INTO `huellas` (`id_Huella`, `cod_huella`) VALUES
(1, 'Huella_Empleado_Raul'),
(2, 'Huella_cliente_Noe'),
(3, 'Huella_cliente_Noe'),
(4, 'huella_Empleado_Bere'),
(5, 'huella_Pedro'),
(6, 'huella_Pedro'),
(7, 'huella_Pedro'),
(8, 'huella_Pedro'),
(9, 'huella_Karla');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instructor`
--

CREATE TABLE `instructor` (
  `id_Instructor` int(10) NOT NULL,
  `certificacion` varchar(45) NOT NULL,
  `id_Empleado` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `instructor`:
--   `id_Empleado`
--       `datosempleado` -> `id_Dato`
--

--
-- Volcado de datos para la tabla `instructor`
--

INSERT INTO `instructor` (`id_Instructor`, `certificacion`, `id_Empleado`) VALUES
(1, 'Certificado', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `limpieza`
--

CREATE TABLE `limpieza` (
  `id_Limpieza` int(10) NOT NULL,
  `solicitud` varchar(45) NOT NULL,
  `id_Empleado` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `limpieza`:
--   `id_Empleado`
--       `datosempleado` -> `id_Dato`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos_historial`
--

CREATE TABLE `pagos_historial` (
  `id_Pago` int(10) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `f_inicio` date NOT NULL,
  `f_fin` date NOT NULL,
  `id_Cliente` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `pagos_historial`:
--   `id_Cliente`
--       `clientes` -> `id_Cliente`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pesuscripciones`
--

CREATE TABLE `pesuscripciones` (
  `id_Suscripcion` int(10) NOT NULL,
  `periodo` varchar(45) NOT NULL,
  `duracion_dias` int(10) NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `id_Gimnasio` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `pesuscripciones`:
--   `id_Gimnasio`
--       `gimnasios` -> `id_Gimnasio`
--

--
-- Volcado de datos para la tabla `pesuscripciones`
--

INSERT INTO `pesuscripciones` (`id_Suscripcion`, `periodo`, `duracion_dias`, `costo`, `id_Gimnasio`) VALUES
(1, 'Mensual', 30, '180.00', 1),
(2, 'Anual', 365, '2000.00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_Proveedor` int(10) NOT NULL,
  `proveedor` varchar(45) NOT NULL,
  `h_entrada` datetime NOT NULL,
  `pago_proveedor` decimal(10,2) NOT NULL,
  `id_Recepcionista` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `proveedores`:
--   `id_Recepcionista`
--       `recepcion` -> `id_Recepcion`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcion`
--

CREATE TABLE `recepcion` (
  `id_Recepcion` int(10) NOT NULL,
  `carrera` varchar(45) NOT NULL,
  `id_Empleado` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `recepcion`:
--   `id_Empleado`
--       `datosempleado` -> `id_Dato`
--

--
-- Volcado de datos para la tabla `recepcion`
--

INSERT INTO `recepcion` (`id_Recepcion`, `carrera`, `id_Empleado`) VALUES
(1, 'titulo', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_Rol` int(10) NOT NULL,
  `rol` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `roles`:
--

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_Rol`, `rol`) VALUES
(1, 'Recepcion'),
(2, 'Instructor'),
(3, 'Limpieza'),
(4, 'Box'),
(5, 'Crosfit');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos`
--

CREATE TABLE `turnos` (
  `id_Turno` int(10) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `h_entrada` time NOT NULL,
  `h_salida` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `turnos`:
--

--
-- Volcado de datos para la tabla `turnos`
--

INSERT INTO `turnos` (`id_Turno`, `nombre`, `h_entrada`, `h_salida`) VALUES
(1, 'Matutino', '10:00:00', '16:00:00'),
(2, 'Vespertino', '16:00:00', '22:00:00');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_selectallclientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_selectallclientes` (
`id_Cliente` int(10)
,`nombre` varchar(45)
,`telefono` varchar(45)
,`estado` tinyint(1)
,`cod_huella` varchar(45)
,`Membresia` varchar(45)
,`Gimnasio` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_selectallempleados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_selectallempleados` (
`id_Dato` int(11)
,`nombre` varchar(45)
,`telefono` varchar(45)
,`direccion` varchar(45)
,`Status` tinyint(4)
,`rol` varchar(45)
,`Documentos` varchar(45)
,`cod_huella` varchar(45)
,`h_entrada` time
,`H_salida` time
,`Gimnasio` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_selectallrecepcionistas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_selectallrecepcionistas` (
`id_Dato` int(10)
,`nombre` varchar(45)
,`telefono` varchar(45)
,`direccion` varchar(45)
,`Status` tinyint(1)
,`rol` varchar(45)
,`Doc` varchar(45)
,`cod_huella` varchar(45)
,`h_entrada` time
,`H_salida` time
,`Gimnasio` varchar(45)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `visitas`
--

CREATE TABLE `visitas` (
  `id_Visita` int(10) NOT NULL,
  `visita` varchar(45) DEFAULT NULL,
  `pago` decimal(10,2) NOT NULL,
  `h_entrada` date DEFAULT NULL,
  `id_Recepcionista` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELACIONES PARA LA TABLA `visitas`:
--   `id_Recepcionista`
--       `recepcion` -> `id_Recepcion`
--

-- --------------------------------------------------------

--
-- Estructura para la vista de `view_selectallclientes` exportada como una tabla
--
DROP TABLE IF EXISTS `view_selectallclientes`;
CREATE TABLE`view_selectallclientes`(
    `id_Cliente` int(10) NOT NULL DEFAULT '0',
    `nombre` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `telefono` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `estado` tinyint(1) DEFAULT NULL,
    `cod_huella` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `Membresia` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `Gimnasio` varchar(45) COLLATE utf8mb4_general_ci NOT NULL
);

-- --------------------------------------------------------

--
-- Estructura para la vista de `view_selectallempleados` exportada como una tabla
--
DROP TABLE IF EXISTS `view_selectallempleados`;
CREATE TABLE`view_selectallempleados`(
    `id_Dato` int(11) NOT NULL DEFAULT '0',
    `nombre` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
    `telefono` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
    `direccion` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
    `Status` tinyint(4) DEFAULT NULL,
    `rol` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `Documentos` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
    `cod_huella` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
    `h_entrada` time NOT NULL DEFAULT '00:00:00',
    `H_salida` time NOT NULL DEFAULT '00:00:00',
    `Gimnasio` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
);

-- --------------------------------------------------------

--
-- Estructura para la vista de `view_selectallrecepcionistas` exportada como una tabla
--
DROP TABLE IF EXISTS `view_selectallrecepcionistas`;
CREATE TABLE`view_selectallrecepcionistas`(
    `id_Dato` int(10) NOT NULL DEFAULT '0',
    `nombre` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `telefono` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `direccion` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `Status` tinyint(1) DEFAULT NULL,
    `rol` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
    `Doc` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `cod_huella` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
    `h_entrada` time NOT NULL,
    `H_salida` time NOT NULL,
    `Gimnasio` varchar(45) COLLATE utf8mb4_general_ci NOT NULL
);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accesocliente`
--
ALTER TABLE `accesocliente`
  ADD PRIMARY KEY (`id_AccCl`),
  ADD KEY `id_Cliente` (`id_Cliente`);

--
-- Indices de la tabla `accesoempleado`
--
ALTER TABLE `accesoempleado`
  ADD PRIMARY KEY (`id_AccEm`),
  ADD KEY `id_Empleado` (`id_Empleado`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_Cliente`),
  ADD KEY `id_Huella` (`id_Huella`),
  ADD KEY `id_Periodo` (`id_Periodo`),
  ADD KEY `id_Gimnasio` (`id_Gimnasio`);

--
-- Indices de la tabla `datosempleado`
--
ALTER TABLE `datosempleado`
  ADD PRIMARY KEY (`id_Dato`),
  ADD KEY `id_Rol` (`id_Rol`),
  ADD KEY `id_Huella` (`id_Huella`),
  ADD KEY `id_Turno` (`id_Turno`),
  ADD KEY `id_Gimnasio` (`id_Gimnasio`);

--
-- Indices de la tabla `documentos_rol`
--
ALTER TABLE `documentos_rol`
  ADD PRIMARY KEY (`id_DocR`),
  ADD KEY `id_Empleado` (`id_Empleado`),
  ADD KEY `id_Rol` (`id_Rol`);

--
-- Indices de la tabla `gimnasios`
--
ALTER TABLE `gimnasios`
  ADD PRIMARY KEY (`id_Gimnasio`);

--
-- Indices de la tabla `gimnasio_roles`
--
ALTER TABLE `gimnasio_roles`
  ADD PRIMARY KEY (`id_Rol_gym`),
  ADD KEY `id_gym` (`id_gym`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `huellas`
--
ALTER TABLE `huellas`
  ADD PRIMARY KEY (`id_Huella`);

--
-- Indices de la tabla `instructor`
--
ALTER TABLE `instructor`
  ADD PRIMARY KEY (`id_Instructor`),
  ADD KEY `id_Empleado` (`id_Empleado`);

--
-- Indices de la tabla `limpieza`
--
ALTER TABLE `limpieza`
  ADD PRIMARY KEY (`id_Limpieza`),
  ADD KEY `id_Empleado` (`id_Empleado`);

--
-- Indices de la tabla `pagos_historial`
--
ALTER TABLE `pagos_historial`
  ADD PRIMARY KEY (`id_Pago`),
  ADD KEY `id_Cliente` (`id_Cliente`);

--
-- Indices de la tabla `pesuscripciones`
--
ALTER TABLE `pesuscripciones`
  ADD PRIMARY KEY (`id_Suscripcion`),
  ADD KEY `id_Gimnasio` (`id_Gimnasio`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_Proveedor`),
  ADD KEY `id_Recepcionista` (`id_Recepcionista`);

--
-- Indices de la tabla `recepcion`
--
ALTER TABLE `recepcion`
  ADD PRIMARY KEY (`id_Recepcion`),
  ADD KEY `id_Empleado` (`id_Empleado`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_Rol`);

--
-- Indices de la tabla `turnos`
--
ALTER TABLE `turnos`
  ADD PRIMARY KEY (`id_Turno`);

--
-- Indices de la tabla `visitas`
--
ALTER TABLE `visitas`
  ADD PRIMARY KEY (`id_Visita`),
  ADD KEY `id_Recepcionista` (`id_Recepcionista`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accesocliente`
--
ALTER TABLE `accesocliente`
  MODIFY `id_AccCl` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `accesoempleado`
--
ALTER TABLE `accesoempleado`
  MODIFY `id_AccEm` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_Cliente` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `datosempleado`
--
ALTER TABLE `datosempleado`
  MODIFY `id_Dato` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `documentos_rol`
--
ALTER TABLE `documentos_rol`
  MODIFY `id_DocR` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `gimnasios`
--
ALTER TABLE `gimnasios`
  MODIFY `id_Gimnasio` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `gimnasio_roles`
--
ALTER TABLE `gimnasio_roles`
  MODIFY `id_Rol_gym` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `huellas`
--
ALTER TABLE `huellas`
  MODIFY `id_Huella` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `instructor`
--
ALTER TABLE `instructor`
  MODIFY `id_Instructor` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `limpieza`
--
ALTER TABLE `limpieza`
  MODIFY `id_Limpieza` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos_historial`
--
ALTER TABLE `pagos_historial`
  MODIFY `id_Pago` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pesuscripciones`
--
ALTER TABLE `pesuscripciones`
  MODIFY `id_Suscripcion` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_Proveedor` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recepcion`
--
ALTER TABLE `recepcion`
  MODIFY `id_Recepcion` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_Rol` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `turnos`
--
ALTER TABLE `turnos`
  MODIFY `id_Turno` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `visitas`
--
ALTER TABLE `visitas`
  MODIFY `id_Visita` int(10) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `accesocliente`
--
ALTER TABLE `accesocliente`
  ADD CONSTRAINT `accesocliente_ibfk_1` FOREIGN KEY (`id_Cliente`) REFERENCES `clientes` (`id_Cliente`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `accesoempleado`
--
ALTER TABLE `accesoempleado`
  ADD CONSTRAINT `accesoempleado_ibfk_1` FOREIGN KEY (`id_Empleado`) REFERENCES `datosempleado` (`id_Dato`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_Huella`) REFERENCES `huellas` (`id_Huella`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clientes_ibfk_2` FOREIGN KEY (`id_Periodo`) REFERENCES `pesuscripciones` (`id_Suscripcion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clientes_ibfk_3` FOREIGN KEY (`id_Gimnasio`) REFERENCES `gimnasios` (`id_Gimnasio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `datosempleado`
--
ALTER TABLE `datosempleado`
  ADD CONSTRAINT `datosempleado_ibfk_1` FOREIGN KEY (`id_Rol`) REFERENCES `roles` (`id_Rol`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `datosempleado_ibfk_2` FOREIGN KEY (`id_Huella`) REFERENCES `huellas` (`id_Huella`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `datosempleado_ibfk_3` FOREIGN KEY (`id_Turno`) REFERENCES `turnos` (`id_Turno`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `datosempleado_ibfk_4` FOREIGN KEY (`id_Gimnasio`) REFERENCES `gimnasios` (`id_Gimnasio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `documentos_rol`
--
ALTER TABLE `documentos_rol`
  ADD CONSTRAINT `documentos_rol_ibfk_1` FOREIGN KEY (`id_Empleado`) REFERENCES `datosempleado` (`id_Dato`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `documentos_rol_ibfk_2` FOREIGN KEY (`id_Rol`) REFERENCES `roles` (`id_Rol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `gimnasio_roles`
--
ALTER TABLE `gimnasio_roles`
  ADD CONSTRAINT `gimnasio_roles_ibfk_1` FOREIGN KEY (`id_gym`) REFERENCES `gimnasios` (`id_Gimnasio`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gimnasio_roles_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_Rol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `instructor`
--
ALTER TABLE `instructor`
  ADD CONSTRAINT `instructor_ibfk_1` FOREIGN KEY (`id_Empleado`) REFERENCES `datosempleado` (`id_Dato`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `limpieza`
--
ALTER TABLE `limpieza`
  ADD CONSTRAINT `limpieza_ibfk_1` FOREIGN KEY (`id_Empleado`) REFERENCES `datosempleado` (`id_Dato`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos_historial`
--
ALTER TABLE `pagos_historial`
  ADD CONSTRAINT `pagos_historial_ibfk_1` FOREIGN KEY (`id_Cliente`) REFERENCES `clientes` (`id_Cliente`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pesuscripciones`
--
ALTER TABLE `pesuscripciones`
  ADD CONSTRAINT `pesuscripciones_ibfk_1` FOREIGN KEY (`id_Gimnasio`) REFERENCES `gimnasios` (`id_Gimnasio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD CONSTRAINT `proveedores_ibfk_1` FOREIGN KEY (`id_Recepcionista`) REFERENCES `recepcion` (`id_Recepcion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `recepcion`
--
ALTER TABLE `recepcion`
  ADD CONSTRAINT `recepcion_ibfk_1` FOREIGN KEY (`id_Empleado`) REFERENCES `datosempleado` (`id_Dato`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `visitas`
--
ALTER TABLE `visitas`
  ADD CONSTRAINT `visitas_ibfk_1` FOREIGN KEY (`id_Recepcionista`) REFERENCES `recepcion` (`id_Recepcion`) ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Metadatos
--
USE `phpmyadmin`;

--
-- Metadatos para la tabla accesocliente
--

--
-- Metadatos para la tabla accesoempleado
--

--
-- Metadatos para la tabla clientes
--

--
-- Metadatos para la tabla datosempleado
--

--
-- Metadatos para la tabla documentos_rol
--

--
-- Metadatos para la tabla gimnasios
--

--
-- Metadatos para la tabla gimnasio_roles
--

--
-- Metadatos para la tabla huellas
--

--
-- Metadatos para la tabla instructor
--

--
-- Metadatos para la tabla limpieza
--

--
-- Metadatos para la tabla pagos_historial
--

--
-- Metadatos para la tabla pesuscripciones
--

--
-- Metadatos para la tabla proveedores
--

--
-- Metadatos para la tabla recepcion
--

--
-- Metadatos para la tabla roles
--

--
-- Metadatos para la tabla turnos
--

--
-- Metadatos para la tabla view_selectallclientes
--

--
-- Metadatos para la tabla view_selectallempleados
--

--
-- Metadatos para la tabla view_selectallrecepcionistas
--

--
-- Metadatos para la tabla visitas
--

--
-- Metadatos para la base de datos db_gym
--
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
