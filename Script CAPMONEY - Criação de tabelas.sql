-- Criação da tabela 'Funcionario' e 'Cliente' no banco do Sistema CAPMONEY
use [CAPMONEY];


CREATE TABLE FUNCIONARIO
(
	id_funcionario	INT			IDENTITY(1,1)	NOT NULL
	,nm_funcionario VARCHAR(30)					NOT NULL
	,cd_cpf			CHAR(15)	UNIQUE		    NOT NULL
	,dt_nascimento	DATE						NOT NULL
	,ds_email		VARCHAR(50)					NOT NULL
	,nr_telefone	VARCHAR(15)					NOT NULL
	,cd_senha		VARBINARY(100)				NOT NULL
	,ds_endereco	VARCHAR(200)				NOT NULL
	,cd_categoria	CHAR(1)	 CHECK(cd_categoria = 'A'  OR cd_categoria = 'G') DEFAULT 'A' NOT NULL
	,CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (id_funcionario)
);
-- Inserindo registros na tabela 'Funcionario', um Gestor e dois Atendentes
	INSERT INTO FUNCIONARIO (nm_funcionario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha,ds_endereco, cd_categoria)
				VALUES		('Rogério Gião','20100','1964/05/21','giao@capmoney.com','11-9981-3434',HASHBYTES('md5','password'),'Av. Brigadeiro - Paulista','G');
-- Atendentes
INSERT INTO FUNCIONARIO (nm_funcionario, cd_cpf, dt_nascimento, ds_email, nr_telefone, cd_senha,ds_endereco)
				VALUES		('Matheus Alves','20200','1998/09/12','alves@capmoney.com','13-9982-3534',HASHBYTES('md5','password'),'Principal Peruíbe, Edifício Arkham 32, AP: 18'),
							('Leandro Ferreira','20300','1990/05/03','ferreira@capmoney.com','13-9982-3634',HASHBYTES('md5','password'),'Av. Marechal Mallet, C.Forte, CS: 453');
SELECT * FROM FUNCIONARIO;
-- Criação da tabela 'Cliente

CREATE TABLE CLIENTE
(
	id_cliente		INT			IDENTITY (1,1)	
	,nm_cliente		VARCHAR(30)										NOT NULL
	,cd_cpf			CHAR(15)	 UNIQUE								NOT NULL
	,dt_nascimento	DATE											NOT NULL
	,ds_email		VARCHAR(50)										NOT NULL
	,nr_telefone	VARCHAR(15)										NOT NULL
	,cd_senha		VARBINARY(100)									NOT NULL
	,ds_endereço	VARCHAR(200)									NOT NULL
	,cd_categoria	CHAR(1)	 CHECK(cd_categoria = 'C') DEFAULT 'C'	NOT NULL
	,nm_corretora   VARCHAR(30) DEFAULT ('Individual')				NOT NULL
	,nr_conta		CHAR(5)		DEFAULT	('NP')						NOT NULL
	,dt_criacao		DATE		DEFAULT GETDATE()					NOT NULL
	,CONSTRAINT PK_CLIENTE PRIMARY KEY (id_cliente)
); 