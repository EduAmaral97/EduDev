//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELTMK()

	Local dDataDe  := ctod("01/01/08")
	Local dDataAte := ctod("01/01/08")
	Local lRPPF := .F.
	Local lRPPJ := .F.
	Local lCAMPPF := .F.
	Local lCAMPPJ := .F.
	Local lSPPF := .F.
	Local lSPPJ := .F.
	Local lLITPF := .F.
	Local lLITPJ := .F.
	Local lRIOPF := .F.
	Local lRIOPJ := .F.
	Local lTECHPF := .F.
	Local lTECHPJ := .F.
	Local lLOCAMEDIPF := .F.
	Local lLOCAMEDIPJ := .F.


    DEFINE MSDIALOG oDlg FROM 05,10 TO 440,470 TITLE " Cobranca TMK " PIXEL

        @ 010,020 TO 050,210 LABEL " Filtros de Data " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Data de: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 022, 050 MSGET oGrupo  VAR dDataDe  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"

        @ 025, 110 SAY oTitQtdVidas PROMPT "Data ate: "                 SIZE 070, 020 OF oDlg PIXEL
        @ 022, 135 MSGET oGrupo  VAR dDataAte  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"
	   	
		@ 060,020 TO 210,210 LABEL " Selecione as opcoes " OF oDlg PIXEL

		@ 075,025 CHECKBOX oSN VAR lRPPF PROMPT "Ribeirao Preto (PF)" 		SIZE 85,8 PIXEL OF oDlg
		@ 075,100 CHECKBOX oSN VAR lRPPJ PROMPT "Ribeirao Preto (PJ)" 		SIZE 85,8 PIXEL OF oDlg

		@ 090,025 CHECKBOX oSN VAR lCAMPPF PROMPT "Campinas (PF)" 			SIZE 85,8 PIXEL OF oDlg
		@ 090,100 CHECKBOX oSN VAR lCAMPPJ PROMPT "Campinas (PJ)" 			SIZE 85,8 PIXEL OF oDlg

		@ 105,025 CHECKBOX oSN VAR lSPPF PROMPT "Sao Paulo (PF)" 			SIZE 85,8 PIXEL OF oDlg
		@ 105,100 CHECKBOX oSN VAR lSPPJ PROMPT "Sao Paulo (PJ)" 			SIZE 85,8 PIXEL OF oDlg

		@ 120,025 CHECKBOX oSN VAR lLITPF PROMPT "Litoral (PF)" 			SIZE 85,8 PIXEL OF oDlg
		@ 120,100 CHECKBOX oSN VAR lLITPJ PROMPT "Litoral (PJ)" 			SIZE 85,8 PIXEL OF oDlg

		@ 135,025 CHECKBOX oSN VAR lRIOPF PROMPT "Rio de Janeiro (PF)" 		SIZE 85,8 PIXEL OF oDlg
		@ 135,100 CHECKBOX oSN VAR lRIOPJ PROMPT "Rio de Janeiro (PJ)" 		SIZE 85,8 PIXEL OF oDlg

		@ 150,025 CHECKBOX oSN VAR lTECHPF PROMPT "Medicar Tech (PF)" 		SIZE 85,8 PIXEL OF oDlg
		@ 150,100 CHECKBOX oSN VAR lTECHPJ PROMPT "Medicar Tech (PJ)" 		SIZE 85,8 PIXEL OF oDlg

		@ 165,025 CHECKBOX oSN VAR lLOCAMEDIPF PROMPT "Locamedi (PF)" 		SIZE 85,8 PIXEL OF oDlg
		@ 165,100 CHECKBOX oSN VAR lLOCAMEDIPJ PROMPT "Locamedi (PJ)" 		SIZE 85,8 PIXEL OF oDlg


		TButton():New( 190, 140 , "Gerar" , oDlg, {|| fPegaDir(dDataDe,dDataAte,lRPPF,lRPPJ,lCAMPPF,lCAMPPJ,lSPPF,lSPPJ,lLITPF,lLITPJ,lRIOPF,lRIOPJ,lTECHPF,lTECHPJ,lLOCAMEDIPF,lLOCAMEDIPJ) }, 030,011, ,,,.T.,,,,,,)


    DEFINE SBUTTON FROM 190,180 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER


Return


Static Function fPegaDir(dDataDe,dDataAte,lRPPF,lRPPJ,lCAMPPF,lCAMPPJ,lSPPF,lSPPJ,lLITPF,lLITPJ,lRIOPF,lRIOPJ,lTECHPF,lTECHPJ,lLOCAMEDIPF,lLOCAMEDIPJ)


	Local cPasta := ""  

	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
 
    //Se não estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a função para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;                  // Título da Janela para seleção dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diretório inicial da busca de arquivos
            lSalvar,;                  // Se for .T., será uma Save Dialog, senão será Open Dialog
            GETF_RETDIRECTORY;         // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )
 
    EndIf 


	IF lRPPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FRPPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Ribeirao Preto PF)...") 

	EndIf

	IF lCAMPPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FCAMPPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Capinas PF)...") 

	EndIf

	IF lSPPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FSPPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Sao Paulo PF)...") 

	EndIf

	IF lLITPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FLITPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Litoral PF)...") 

	EndIf

	IF lRIOPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FRIOPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Rio de Janeiro PF)...") 

	EndIf

	IF lTECHPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FTECHPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Medicar Tech PF)...") 

	EndIf

	IF lLOCAMEDIPF == .T.

		/* PESSOA FISICA */
		MsAguarde({||FLOCPF(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Locamedi PF)...") 

	EndIf



	IF lRPPJ == .T.

		MsAguarde({||FRPPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Ribeirao Preto PJ)...") 

	EndIf

	IF lCAMPPJ == .T.

		MsAguarde({||FCAMPPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Capinas PJ)...") 

	EndIf

	IF lSPPJ == .T.

		MsAguarde({||FSPPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Sao Paulo PJ)...") 

	EndIf


	IF lLITPJ == .T.

		MsAguarde({||FLITPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Litoral PJ)...") 

	EndIf

	IF lRIOPJ == .T.

		MsAguarde({||FRIOPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Rio de Janeiro PJ)...") 

	EndIf

	IF lTECHPJ == .T.

		MsAguarde({||FTECHPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Medicar Tech PJ)...") 

	EndIf

	IF lLOCAMEDIPJ == .T.

		MsAguarde({||FLOCPJ(dDataDe,dDataAte,cPasta)},"Aguarde","Motando Relatorio TMK (Locamedi PJ)...") 

	EndIf

Return


/* ----------------------- PESSOA FISICA ----------------------- */


Static Function FRPPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)		AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)		AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '001001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKRPPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FCAMPPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '002001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_TIPO = 'TMK'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKCAMPPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FSPPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '003001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKSPPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FLITPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '008001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKLITPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FRIOPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '0210001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKRIOPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FTECHPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '006001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKTECHPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FLOCPF(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '014001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'F' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKLOCAMEDIPF' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return



/* ----------------------- PESSOA JURIDICA ----------------------- */

Static Function FRPPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)		AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)		AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '001001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKRPPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FCAMPPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '002001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKCAMPPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FSPPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '003001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKSPPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FLITPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '008001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKLITPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FRIOPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '0210001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKRIOPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FTECHPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '006001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKTECHPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return


Static Function FLOCPJ(dDataDe,dDataAte,cPasta)
	
	Local cQuery 
	Local cArqInc
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("TMK")
	oExcel:AddworkSheet("TMK")

	oExcel:AddTable ("TMK","TBLTMK",.F.)
	oExcel:AddColumn("TMK","TBLTMK","CODUSUARIO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NOME" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NASCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPF" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","RESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CPFRESPFINAN" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ENDERECO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","NUMERO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","COMPLEMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","BAIRRO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CIDADE" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","ESTADO" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CEP" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE" 				,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE1" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","FONE2" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","CELULAR" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DUPLICATA" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DTVENCIMENTO" 		,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","VALOR" 			,1,2,.F., "@E 999,999,999.99")
	oExcel:AddColumn("TMK","TBLTMK","EMAIL" 			,1,1,.F., "")
	oExcel:AddColumn("TMK","TBLTMK","DOCUMENTO"			,1,1,.F., "")

	cQuery := " SELECT "
	cQuery += " B.A1_COD						AS CODUSUARIO, "
	cQuery += " B.A1_NOME						AS NOME, "
	cQuery += " B.A1_DTNASC						AS NASCIMENTO, "
	cQuery += " B.A1_CGC						AS CPF, "
	cQuery += " B.A1_NOME						AS RESPFINAN, "
	cQuery += " B.A1_CGC						AS CPFRESPFINAN, "
	cQuery += " B.A1_END						AS ENDERECO, "
	cQuery += " '' 								AS NUMERO, "
	cQuery += " B.A1_COMPENT					AS COMPLEMENTO, "
	cQuery += " B.A1_BAIRRO						AS BAIRRO, "
	cQuery += " B.A1_MUN						AS CIDADE, "
	cQuery += " B.A1_EST						AS ESTADO, "
	cQuery += " B.A1_CEP						AS CEP, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS FONE, "
	cQuery += " CONCAT(B.A1_ZZDDD2,B.A1_ZZTEL2)	AS FONE1, "
	cQuery += " CONCAT(B.A1_ZZDDD3,B.A1_ZZTEL3)	AS FONE2, "
	cQuery += " CONCAT(B.A1_DDD,B.A1_TEL)						AS CELULAR, "
	cQuery += " A.E1_NUM						AS DUPLICATA, "
	cQuery += " CONCAT(SUBSTRING(A.E1_VENCREA,7,2),'/',SUBSTRING(A.E1_VENCREA,5,2),'/',SUBSTRING(A.E1_VENCREA,1,4)) AS DTVENCIMENTO, "
	cQuery += " A.E1_SALDO						AS VALOR, "
	cQuery += " B.A1_EMAIL						AS EMAIL, "
	cQuery += " CONCAT(A.E1_FILIAL, ' - ',	A.E1_PREFIXO, ' - ',A.E1_NUM, ' - ',	A.E1_TIPO) AS DOCUMENTO "
	cQuery += " FROM SE1010 A "
	cQuery += " LEFT JOIN SA1010 B ON B.D_E_L_E_T_ = '' AND B.A1_COD = A.E1_CLIENTE AND B.A1_LOJA = A.E1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E1_FILIAL = '014001' "
	cQuery += " AND A.E1_SALDO > 0 "
	cQuery += " AND A.E1_ZSTSLD = '2'
	cQuery += " AND B.A1_PESSOA = 'J' "
	cQuery += " AND B.A1_COD NOT IN ('000541','009890','009891','009895','009954','009956','009962','009973','044820','044913','044916','044918','048535','050012','050812','052684','052843','053141','053586','053959','054399','054651','056862','058136','061989','062014','062655','063184','063473','070560','075194','075374','075542','075565','075827','075833','075839','078334','078335','060203','009969','061324','062918','063267','063268','063269','069043','074137') "
	cQuery += " AND A.E1_VENCREA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
	//cQuery += " AND A.E1_VENCREA <= DATEADD(day, -30, getdate()) "
	//cQuery += " AND YEAR(A.E1_VENCREA) >= 2020 "
	//cQuery += " AND A.E1_TIPO NOT IN ('TMK','IR-','IN-','IS-','CS-','PI-','CF-') "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("TMK","TBLTMK",{ (_cAlias)->CODUSUARIO,(_cAlias)->NOME,(_cAlias)->NASCIMENTO,(_cAlias)->CPF,(_cAlias)->RESPFINAN,(_cAlias)->CPFRESPFINAN,(_cAlias)->ENDERECO,(_cAlias)->NUMERO,(_cAlias)->COMPLEMENTO,(_cAlias)->BAIRRO,(_cAlias)->CIDADE,(_cAlias)->ESTADO,(_cAlias)->CEP,(_cAlias)->FONE,(_cAlias)->FONE1,(_cAlias)->FONE2,(_cAlias)->CELULAR,(_cAlias)->DUPLICATA,(_cAlias)->DTVENCIMENTO,(_cAlias)->VALOR,(_cAlias)->EMAIL,(_cAlias)->DOCUMENTO })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + 'TMKLOCAMEDIPJ' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return
