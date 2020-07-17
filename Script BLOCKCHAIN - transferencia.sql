-- FUNCIONALIDADE DE TRANSFERÊNCIA: BLOCKCHAIN
exec sp_columns 'usuario';

BEGIN TRANSACTION;
-- Criação da tabela de transferencia
	CREATE TABLE HISTORICO_TRANSACAO
	(
		 id_transacao				INT			IDENTITY (1,1)	
		,nm_usuario_origem		VARCHAR(30)							    NOT NULL
		,cd_cpf_origem			CHAR(15)	 							NOT NULL
		,nm_corretora_origem   VARCHAR(30) DEFAULT ('Individual')		NOT NULL
		,vl_valor		DECIMAL(8,2) DEFAULT (0.00)						NOT NULL
		,nm_usuario_destino		VARCHAR(30)							    NOT NULL
		,cd_cpf_destino			CHAR(15)	 							NOT NULL
		,dt_transacao		DATETIME		DEFAULT GETUTCDATE()		NOT NULL
		,CONSTRAINT PK_TRANSACAO PRIMARY KEY (id_transacao)
	);
GO
	ALTER PROCEDURE sp_transferencia
		@clienteOrigem VARCHAR(30)
		,@cpfOrigem		CHAR(15)
		,@corretoraOrigem  VARCHAR(30) 
		,@valor				DECIMAL(8,2)
		,@clienteDestino	VARCHAR(30)
		,@cpfDestino      CHAR(15)
AS
	-- Atualizando saldo: origem
BEGIN TRY
		-- Verificando se o valor é maior que o saldo
		IF @valor > (select vl_saldo from USUARIO WHERE cd_cpf = @cpfOrigem)
				BEGIN
					PRINT 'O valor solicitado para transferência é maior que o saldo atual, entre com um  valor menor para efetuar a transferência.'
				END

		ELSE
			BEGIN
				--efetuar Transferência
				UPDATE USUARIO
				SET vl_saldo = vl_saldo - @valor
				WHERE cd_cpf = @cpfOrigem

				--Atualizando saldo cliente de destino
				UPDATE USUARIO
					set vl_saldo = vl_saldo + @valor
					where cd_cpf = @cpfDestino;
				PRINT CONCAT('Transferência entre Sr(a): ', @clienteOrigem, ' para CPF: ', @cpfDestino, ' com valor de: R$', @valor , 'realizada com sucesso!') ;
				-- Inserindo valores no historico de transação
					INSERT INTO HISTORICO_TRANSACAO (nm_usuario_origem, cd_cpf_origem ,nm_corretora_origem, vl_valor ,nm_usuario_destino ,cd_cpf_destino)
					VALUES							(@clienteOrigem, @cpfOrigem , @corretoraOrigem , @valor , @clienteDestino , @cpfDestino)
			END
END TRY

BEGIN CATCH
	PRINT CONCAT('Ocorreu o seguinte erro no momento da transação : ', ERROR_NUMBER(), ' ' , ERROR_PROCEDURE() , 'entre em contato com a equipe de suporte.' );
END CATCH;

-- Efetuando testes
	select * from USUARIO;
	-- id: 1 Alessandra, R$ 400 vai transferir 200 para id: 5 Felipe, felipe ficará com 200, Alessandra 200
	EXEC sp_transferencia 'Alessandra Thais','10100','RICO',200,'Felipe Leonardo','10500';
	select id_usuario, nm_usuario,cd_cpf , nm_corretora , vl_saldo from usuario where id_usuario = 1 OR  id_usuario = 5;
	SELECT * FROM HISTORICO_TRANSACAO;
	-- tudo certo, vamo tentar  fazer a mesma coisa, mas tirar 300 da Alessandra, lembrando que ela tem 200
	EXEC sp_transferencia 'Alessandra Thais','10100','RICO',300,'Felipe Leonardo','10500';
	-- BLOQUEADO, pois o valor desejado para transferir é maio que o saldo em conta.... mais testes abaixo

	-- id: 4 Bruno Augusto, R$ 400 vai transferir 100 para id: 3 Diego Andrade, Diego Andrade ficará com 100, Bruno Augusto 300
	EXEC sp_transferencia 'Bruno Augusto','10400','CLEAR',100,'Diego Andrade','10300';
	select id_usuario, nm_usuario,cd_cpf , nm_corretora , vl_saldo from usuario where id_usuario = 4 OR  id_usuario = 3;
	
	-- id: 3 Diego Andrade, R$ 100 vai transferir 37 para id: 4 Bruno Augusto, Bruno Augusto ficará com 337, Diego Andrade 63
	EXEC sp_transferencia 'Diego Andrade','10300','CLEAR',37,'Bruno Augusto','10400';
	select id_usuario, nm_usuario,cd_cpf , nm_corretora , vl_saldo from usuario where id_usuario = 4 OR  id_usuario = 3;
	select * from HISTORICO_TRANSACAO;
 
ROLLBACK TRANSACTION;
COMMIT TRANSACTION;
