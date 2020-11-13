-- BLOCKCHAIN: FUNCTION PARA VERIFICAR SE O CPF DE UM DETERMINADO CLIENTE EXISTE NO BD BLOCKCHAIN
GO
CREATE PROCEDURE sp_verificar_usuario(@buscaCPF CHAR(15))
	AS
	BEGIN
	SET NOCOUNT off
		IF EXISTS (select cd_cpf from USUARIO WHERE cd_cpf = @buscaCPF)
		-- Verificando se existe algum usuario no BLOCKCHAIN com o CPF apresentado
			BEGIN
				PRINT 1
			-- Caso tenha, print 1
			END
		
		ELSE
			PRINT 0
			-- Caso não tenha, print 0
	END

	-- select nm_usuario, cd_cpf, ds_email from usuario;
-- Efetuando testes com cpf inexistente
exec sp_verificar_usuario '10700';

-- Efetuando testes com cpf existente
exec sp_verificar_usuario '10200';