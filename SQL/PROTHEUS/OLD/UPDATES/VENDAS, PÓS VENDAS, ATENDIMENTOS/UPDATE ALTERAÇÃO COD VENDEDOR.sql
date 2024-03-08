-- Declaração das variáveis
DECLARE @CodVd1 VARCHAR(06);
DECLARE @CodVd2 VARCHAR(06);
DECLARE @CodFil VARCHAR(04);
DECLARE @SerDoc VARCHAR(03);
DECLARE @NumDoc VARCHAR(09);
DECLARE @NumOrc VARCHAR(06);
DECLARE @NumAtm VARCHAR(06);


-- Atribuição dos valores a variáveis
SET @CodVd1 = '000091';   	-- Vendedor Old
SET @CodVd2 = '000069';	  	-- Vendedor New	
SET @CodFil = '0102';		-- Código da Filial
SET @SerDoc = '700';	 	-- Número Documento
SET @NumDoc = '000001899';	-- Série Documento

SELECT E3_VEND, * FROM SE3010 WHERE D_E_L_E_T_ = '' AND E3_FILIAL = @CodFil AND E3_SERIE = @SerDoc AND E3_NUM = @NumDoc 
--	UPDATE SE3010 SET E3_VEND = @CodVd2 FROM SE3010 WHERE D_E_L_E_T_ = '' AND E3_FILIAL = @CodFil AND E3_SERIE = @SerDoc AND E3_NUM = @NumDoc 

SELECT E1_VEND1, * FROM SE1010 WHERE D_E_L_E_T_ = '' AND E1_FILIAL = @CodFil AND E1_PREFIXO = @SerDoc AND E1_NUM = @NumDoc
--	UPDATE SE1010 SET E1_VEND1 = @CodVd2 FROM SE1010 WHERE D_E_L_E_T_ = '' AND E1_FILIAL = @CodFil AND E1_PREFIXO = @SerDoc AND E1_NUM = @NumDoc 

IF @SerDoc = '700'
	BEGIN
		SELECT @NumOrc = L1_NUM,  @NumAtm = L1_NUMATEN FROM SL1010 WHERE D_E_L_E_T_ = '' AND L1_FILIAL = @CodFil AND L1_SERPED = @SerDoc AND L1_DOCPED = @NumDoc 
		SELECT @NumOrc AS NumOrc, @NumAtm AS NumAtm
--		UPDATE SL1010 SET L1_VEND = @CodVd2 WHERE D_E_L_E_T_ = '' AND L1_FILIAL = @CodFil AND L1_SERPED = @SerDoc AND L1_DOCPED = @NumDoc
	END	
ELSE
	BEGIN   
		SELECT @NumOrc = L1_NUM,  @NumAtm = L1_NUMATEN FROM SL1010 WHERE D_E_L_E_T_ = '' AND L1_FILIAL = @CodFil AND L1_SERIE = @SerDoc AND L1_DOC = @NumDoc 
		SELECT @NumOrc AS NumOrc, @NumAtm AS NumAtm
--		UPDATE SL1010 SET L1_VEND = @CodVd2 WHERE D_E_L_E_T_ = '' AND L1_FILIAL = @CodFil AND L1_SERIE = @SerDoc AND L1_DOCPED = @NumDoc
	END		
	
SELECT L2_VEND, * FROM SL2010 WHERE D_E_L_E_T_ = '' AND L2_FILIAL = @CodFil AND L2_NUM = @NumOrc 
--	UPDATE SL2010 SET L2_VEND = @CodVd2 WHERE D_E_L_E_T_ = '' AND L2_FILIAL = @CodFil AND L2_NUM = @NumOrc

SELECT UA_VEND FROM SUA010 WHERE D_E_L_E_T_ = '' AND UA_FILIAL = @CodFil AND UA_NUM = @NumAtm
--	UPDATE SUA010 SET UA_VEND = @CodVd2,UA_OPERADO = @CodVd2 WHERE D_E_L_E_T_ = '' AND UA_FILIAL = @CodFil AND UA_NUM = @NumAtm

IF @SerDoc = '001' OR @SerDoc = 'RP'
	SELECT F2_VEND1 FROM SF2010 WHERE D_E_L_E_T_ = '' AND F2_FILIAL = @CodFil AND F2_SERIE = @SerDoc AND F2_DOC = @NumDoc
--	UPDATE SF2010 SET F2_VEND1 = @CodVd2 WHERE D_E_L_E_T_ = '' AND F2_FILIAL = @CodFil AND F2_SERIE = @SerDoc AND F2_DOC = @NumDoc


/*
Obs.: Corrigir quando existir Atendimento em uma filial Ex. 0102 ATM: 011475, Financeiro 0102 Orç: 011721 Doc: 000.001.867-700
      com reserva em outra filial 0101 Orç: 017306 Doc 000.027.110-001, CLIENTE: 021292  PV.: 0101 008930   

*/