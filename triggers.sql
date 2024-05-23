-- TRIGGER

-- Criação da função do trigger
CREATE OR REPLACE FUNCTION fnc_teste_trigger()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO bkp_usuario(idusuario, nome, login) VALUES(OLD.idusuario, OLD.nome, OLD.login);
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger
CREATE TRIGGER teste_trigger
BEFORE DELETE ON usuario
FOR EACH ROW
EXECUTE FUNCTION fnc_teste_trigger();

CREATE TABLE usuario
(
	idusuario SERIAL
	,nome VARCHAR(30)
	,login VARCHAR(30)
	,senha VARCHAR(100)
);

CREATE TABLE bkp_usuario
(
	idbackup SERIAL
	,idusuario INT
	,nome VARCHAR(30)
	,login VARCHAR(30)
);

-- A senha do banco deve ser armazenada criptografada, nao pode ser texto puro, do contrario qualquer um que acessar o banco tem acesso a senha...


-- COMUNICACAO ENTRE BANCOS (Só funciona no MySQL, não tem como no Postgres)

CREATE DATABASE store;

\c store;

CREATE TABLE product
(
	idproduct SERIAL
	,name VARCHAR(30)
	,value NUMERIC(10,2)
);

CREATE DATABASE backup;

\c backup

CREATE TABLE bkp_product
(
	idbackup SERIAL
	,idproduct INT
	,name VARCHAR(30)
	,value NUMERIC(10,2)
);


-- Criação da função do trigger
CREATE OR REPLACE FUNCTION fnc_bkp_product()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO backup.bkp_product(idproduct, name, value) VALUES(NEW.idproduct, NEW.name, NEW.value);
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger
CREATE TRIGGER trigger_bkp_product
BEFORE INSERT ON product
FOR EACH ROW
EXECUTE FUNCTION fnc_bkp_product();

