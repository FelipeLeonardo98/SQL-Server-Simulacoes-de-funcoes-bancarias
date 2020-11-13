-- Criação da tabela 'usuario' no banco do Sistema BLOCKCHAIN

CREATE DATABASE BLOCKCHAIN;
use [BLOCKCHAIN];
 
CREATE TABLE USUARIO
(
	id_usuario		INT			IDENTITY (1,1)	
	,nm_usuario		VARCHAR(30)							    NOT NULL
	,cd_cpf			CHAR(15)	 UNIQUE						NOT NULL
	,dt_nascimento	DATE								    NOT NULL
	,ds_email		VARCHAR(50)								NOT NULL
	,nr_telefone	VARCHAR(15)								NOT NULL
	,cd_senha		VARBINARY(100)							NOT NULL
	,ds_endereço	VARCHAR(200)							NOT NULL
	,nm_corretora   VARCHAR(30) DEFAULT ('Individual')		NOT NULL
	,nr_conta		CHAR(5)		DEFAULT	('NP')				NOT NULL
	,dt_criacao		DATE		DEFAULT GETDATE()			NOT NULL
	,vl_saldo		DECIMAL(8,2) DEFAULT (0.00)				NOT NULL
	,CONSTRAINT PK_USUARIO PRIMARY KEY (id_usuario)
);

-- ,cd_categoria	CHAR(1) CHECK(cd_categoria = 'C')		NOT NULL
 -- Inserindo para fins de teste
 INSERT INTO USUARIO (nm_usuario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha, ds_endereço, nm_corretora, nr_conta)
 VALUES				 ('Alessandra Thais','10100','1990-09-28','alessandra@gmail.com','11-9988-1133',hashbytes('md5','password'),'Av. Paulista - 1','RICO','20100');
 -- Testando outros valores DEFAULT: corretora e conta
  INSERT INTO USUARIO (nm_usuario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha, ds_endereço)
 VALUES				 ('Thatyana','10200','1987-03-17','thatyana@amazon.com','11-9918-1235',hashbytes('md5','password'),'Bairro Liberdade, R. Carmesin - CS: 34');

 select * from USUARIO;
 INSERT INTO USUARIO (nm_usuario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha, ds_endereço, nm_corretora, nr_conta)
 VALUES				 ('Diego Andrade','10300','1996-04-01','diego@amazon.com','13-9974-1213',hashbytes('md5','password'),'Ponte Mar Pequeno - São Vicente','CLEAR','30100'),
					 ('Bruno Augusto','10400','1992-06-14','bruno@microsoft.com','13-9915-1516',hashbytes('md5','senha'),'Canal 1, Santos, 344 - AP:32','CLEAR','30200');

 INSERT INTO USUARIO (nm_usuario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha, ds_endereço)
 VALUES				 ('Felipe Leonardo','10500','1998-06-22','fleonardo@amazon.com','13-9900-1200',hashbytes('md5','password'),'Bairro Samambaia,Praia Grande ,R.Planta - CS: 701');

 -- verificando todos registros
 select * from USUARIO;

