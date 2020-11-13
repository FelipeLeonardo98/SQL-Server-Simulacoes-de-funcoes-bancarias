-- BLOCKCHAIN: Criação de funcionalidades de Depósito e Saque

-- Criando bloco TRAN por segurança
BEGIN TRANSACTION;
GO
	CREATE PROCEDURE sp_depositar_sacar
			 @operacao CHAR(1)
			 ,@paraCPF CHAR(15) OUTPUT
			 ,@valor   DECIMAL(8,2) OUTPUT
	AS
	BEGIN TRY
		IF @operacao = UPPER('d') 
		BEGIN
			-- efetuar depósito
			UPDATE USUARIO 
			SET vl_saldo = vl_saldo + @valor
			WHERE cd_cpf = @paraCPF;
			PRINT CONCAT('Depósito de: R$ ', @valor , ' realizado com sucesso para o CPF: ' , @paraCPF );
		END

		ELSE 
			IF @operacao = UPPER('s')
			-- verificando se a quantidade é maior que o valor atual do saldo
				IF @valor > (select vl_saldo from USUARIO WHERE cd_cpf = @paraCPF)
				BEGIN
					PRINT 'O valor solicitado para saque é maior que o valor do saldo atual,
							entre com um  valor menor para efetuar o saque.'
				END

			ELSE
			BEGIN
				--efetuar saque
				UPDATE USUARIO
				SET vl_saldo = vl_saldo - @valor
				WHERE cd_cpf = @paraCPF
				PRINT CONCAT('Saque de: R$ ', @valor , ' realizado com sucesso para o CPF: ' , @paraCPF );
			END
	

	 ELSE
		 IF @operacao NOT IN ( UPPER('D'),UPPER('S') )
			BEGIN
				PRINT 'Opção inválida, entre com "D" para DEPÓSITO ou "S" para SAQUE.';
			END;
	END TRY	
	BEGIN CATCH
		PRINT CONCAT ('Oops, parece que um erro ocorreu: ', ERROR_NUMBER() , ' ' , ERROR_PROCEDURE() , ' ' , ERROR_LINE() , ' ', ERROR_MESSAGE(),
						' contate o suporte do sistema e informa as mensagens apresentadas');
	END CATCH;
-- Efetuando testes: Depósito
	EXEC sp_depositar_sacar 'd','10100', 800;
	SELECT nm_usuario, cd_cpf, vl_saldo FROM USUARIO WHERE cd_cpf = '10100' ;
-- Depósito OK !

-- Efetuando testes: Saque
	EXEC sp_depositar_sacar 's','10100', 400;
	SELECT nm_usuario, cd_cpf, vl_saldo FROM USUARIO WHERE cd_cpf = '10100' ;
-- 800 - 400 = 400, agora vamos tentar tirar 500
	EXEC sp_depositar_sacar 's','10100', 500;
	SELECT nm_usuario, cd_cpf, vl_saldo FROM USUARIO WHERE cd_cpf = '10100' ;
-- Sucesso
	EXEC sp_depositar_sacar 'd','10200', 300;
	EXEC sp_depositar_sacar 'd','10400', 400;

	EXEC sp_depositar_sacar 'S','10200',500;
-- Impediu, pois o registro 2 tem R$ 300
EXEC sp_depositar_sacar 'D','10200',500;
-- Adicionado R$ 500


ROLLBACK TRANSACTION;
COMMIT TRANSACTION;

-- Testando alguns erros
	SELECT nm_usuario, cd_cpf, vl_saldo FROM USUARIO WHERE cd_cpf = '10400' ;
	EXEC sp_depositar_sacar 'dsfffffffc','104006', 400;
	EXEC sp_depositar_sacar 'f','10400', 400;
	EXEC sp_depositar_sacar 'f','10400', X;
	EXEC sp_depositar_sacar 's','10400', m;
	EXEC sp_depositar_sacar 's','10400', 'd';
