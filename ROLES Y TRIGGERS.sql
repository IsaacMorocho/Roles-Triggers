-- Usuario SuperAdministrador
CREATE USER 'SuperAdmin'@'localhost' IDENTIFIED BY '111';
GRANT ALL PRIVILEGES ON *.* TO 'SuperAdmin'@'localhost' WITH GRANT OPTION;
-- Usuario Administrador
CREATE USER 'Admin'@'localhost' IDENTIFIED BY '222';
GRANT CREATE USER, PROCESS ON *.* TO 'Admin'@'localhost';
-- Usuario CRUD
CREATE USER 'CRUDUsuario'@'localhost' IDENTIFIED BY '333';
GRANT INSERT, UPDATE, DELETE ON *.* TO 'CRUDUsuario'@'localhost';
-- Usuario CRU
CREATE USER 'CRUUsuario'@'localhost' IDENTIFIED BY '444';
GRANT INSERT, UPDATE ON *.* TO 'CRUUsuario'@'localhost';
-- Usuario solo lectura
CREATE USER 'LecturaUsuario'@'localhost' IDENTIFIED BY '555';
GRANT SELECT ON *.* TO 'LecturaUsuario'@'localhost';

SHOW GRANTS FOR 'LecturaUsuario'@'localhost'; 

use db1;
create table empleados (
    EmpID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Departamento VARCHAR(50),
    Salario decimal (10,2)
);

create table auditoria(
	AudID INT PRIMARY KEY AUTO_INCREMENT,
    Accion VARCHAR(10),
    EmpID INT,
    Nombre VARCHAR(100),
    Departamento VARCHAR(100),
    Salario DECIMAL(10,2),
    Fecha DATE,
    FOREIGN KEY (EmpID) REFERENCES empleados(EmpID)
);

-- Trigger
DELIMITER //
-- Despuies de insertar
CREATE TRIGGER auditoria_empleados
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('INSERT', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END; //
-- Despue de actualizar datos
CREATE TRIGGER auditoria_empleados_update
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('UPDATE', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END; //
-- Despues de eliminar datos
CREATE TRIGGER auditoria_empleados_delete
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('DELETE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END; //

DELIMITER ;
