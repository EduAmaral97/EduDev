//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"



User Function ZRCOBCOMIS()


    Local dDataDe  := ctod("01/01/1900")
    Local dDataAte := date()
	Local cOperDe := Space(6)
	Local cOperAte := Space(6)
	Local cUser := RetCodUsr()

	
	DbSelectArea('SU7')
    SU7->(DbSetOrder(4))

    If SU7->(DbSeek("      "+cUser))
	
		cOperDe := SU7->U7_COD
		cOperAte := SU7->U7_COD
       
        
    EndIF

 	DEFINE MSDIALOG oDlg FROM 05,10 TO 280,500 TITLE " Comissao Cobranca Medicar " PIXEL

        @ 010,020 TO 050,210 LABEL " Filtro de Data " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Data de: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 022, 050 MSGET oGrupo  VAR dDataDe  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"

        @ 025, 110 SAY oTitQtdVidas PROMPT "Data ate: "                 SIZE 070, 020 OF oDlg PIXEL
        @ 022, 135 MSGET oGrupo  VAR dDataAte  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"

		@ 060,020 TO 100,210 LABEL " Filtro de Operador " OF oDlg PIXEL
        
		@ 075, 025 SAY oTitQtdVidas PROMPT "Operador de: "              SIZE 070, 020 OF oDlg PIXEL	
		IF cUser == "000000" .OR. cUser == "000035"
			@ 072, 060 MSGET oGrupo  VAR cOperDe  						SIZE 050, 011 OF oDlg PIXEL WHEN .T. F3 "SU7" PICTURE "@!"
		ELSE
			@ 072, 060 MSGET oGrupo  VAR cOperDe  						SIZE 050, 011 OF oDlg PIXEL WHEN .F. F3 "SU7" PICTURE "@!"
        ENDIF
		
		@ 075, 110 SAY oTitQtdVidas PROMPT "Operador ate: "             SIZE 070, 020 OF oDlg PIXEL
		IF cUser == "000000" .OR. cUser == "000035"
        	@ 072, 145 MSGET oGrupo  VAR cOperAte  						SIZE 050, 011 OF oDlg PIXEL WHEN .T. F3 "SU7" PICTURE "@!"
		ELSE
			@ 072, 145 MSGET oGrupo  VAR cOperAte  						SIZE 050, 011 OF oDlg PIXEL WHEN .F. F3 "SU7" PICTURE "@!"
		ENDIF


		TButton():New( 110, 140 , "Gerar" , oDlg, {|| fPegaDir(dDataDe,dDataAte,cOperDe,cOperAte) }, 030,011, ,,,.T.,,,,,,)

    	DEFINE SBUTTON FROM 110,180 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER


Return


Static Function fPegaDir(dDataDe,dDataAte,cOperDe,cOperAte)

	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.

	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */


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

	
	MsAguarde({||fMontaExcel(cPasta,dDataDe,dDataAte,cOperDe,cOperAte)},"Aguarde","Motando Relatorio de Comissao...") 


Return 


Static Function fMontaExcel(cPasta,dDataDe,dDataAte,cOperDe,cOperAte)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("COMCOB")
	oExcel:AddworkSheet("COMCOB")
	
	oExcel:AddTable ("COMCOB","TITULOS",.F.)
	oExcel:AddColumn("COMCOB","TITULOS", "FILIAL",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "PREFIXO",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "TITULO",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "PARCELA",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "TIPO",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "ATENDIMENTO",	1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "CODOPER",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "OPERADOR",	1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "ULTALT",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "VENCIMENTO",	1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "VENCREA",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "VALOR",		1,3,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "RECEBIDO",		1,3,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "SALDO",		1,3,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "CODCLI",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "CLIENTE",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "TIPOCLI",		1,1,.F., "")
	oExcel:AddColumn("COMCOB","TITULOS", "DTBAIXA",		1,1,.F., "")


	cQuery := " SELECT "
	cQuery += " A.ACG_FILIAL	AS FILIAL, "
	cQuery += " A.ACG_PREFIX	AS PREFIXO, "
	cQuery += " A.ACG_TITULO	AS TITULO, "
	cQuery += " A.ACG_PARCEL	AS PARCELA, "
	cQuery += " A.ACG_TIPO		AS TIPO, "
	cQuery += " B.ACF_CODIGO	AS ATENDIMENTO, "
	cQuery += " E.U7_COD		AS CODOPER, "
	cQuery += " E.U7_NOME		AS OPERADOR, "
	cQuery += " CONCAT(SUBSTRING(B.ACF_ULTATE,7,2),'/',SUBSTRING(B.ACF_ULTATE,5,2),'/',SUBSTRING(B.ACF_ULTATE,1,4))	AS ULTALT, "
	cQuery += " CONCAT(SUBSTRING(A.ACG_DTVENC,7,2),'/',SUBSTRING(A.ACG_DTVENC,5,2),'/',SUBSTRING(A.ACG_DTVENC,1,4))	AS VENCIMENTO, "
	cQuery += " CONCAT(SUBSTRING(A.ACG_DTREAL,7,2),'/',SUBSTRING(A.ACG_DTREAL,5,2),'/',SUBSTRING(A.ACG_DTREAL,1,4))	AS VENCREA, "
	cQuery += " A.ACG_VALOR		AS VALOR, "
	cQuery += " A.ACG_VALOR - C.E1_SALDO AS RECEBIDO, "
	cQuery += " C.E1_SALDO		AS SALDO, "
	cQuery += " D.A1_COD		AS CODCLI, "
	cQuery += " D.A1_NOME		AS CLIENTE, "
	cQuery += " D.A1_PESSOA		AS TIPOCLI, "
	cQuery += " CONCAT(SUBSTRING(C.E1_BAIXA,7,2),'/',SUBSTRING(C.E1_BAIXA,5,2),'/',SUBSTRING(C.E1_BAIXA,1,4)) AS DTBAIXA "
	cQuery += " FROM ACG010 A "
	cQuery += " LEFT JOIN ACF010 B ON B.D_E_L_E_T_ = '' AND B.ACF_FILIAL = A.ACG_FILIAL AND B.ACF_CODIGO = A.ACG_CODIGO "
	cQuery += " LEFT JOIN SE1010 C ON C.D_E_L_E_T_ = '' AND C.E1_PREFIXO = A.ACG_PREFIX AND C.E1_NUM = A.ACG_TITULO AND C.E1_PARCELA = A.ACG_PARCEL AND C.E1_TIPO = A.ACG_TIPO AND C.E1_CLIENTE = B.ACF_CLIENT AND C.E1_LOJA = B.ACF_LOJA "
	cQuery += " LEFT JOIN SA1010 D ON D.D_E_L_E_T_ = '' AND D.A1_COD = B.ACF_CLIENT AND D.A1_LOJA = B.ACF_LOJA "
	cQuery += " LEFT JOIN SU7010 E ON E.D_E_L_E_T_ = '' AND E.U7_COD = B.ACF_OPERAD "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND ACF_ULTATE BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "	
	cQuery += " AND ACF_OPERAD >= '"+cOperDe+"' "
	cQuery += " AND ACF_OPERAD <= '"+cOperAte+"' "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("COMCOB","TITULOS",{ (_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->TITULO,(_cAlias)->PARCELA,(_cAlias)->TIPO,(_cAlias)->ATENDIMENTO,(_cAlias)->CODOPER,(_cAlias)->OPERADOR,(_cAlias)->ULTALT,(_cAlias)->VENCIMENTO,(_cAlias)->VENCREA,(_cAlias)->VALOR,(_cAlias)->RECEBIDO,(_cAlias)->SALDO,(_cAlias)->CODCLI,(_cAlias)->CLIENTE,(_cAlias)->TIPOCLI,(_cAlias)->DTBAIXA })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'COMISSAO_COBRANCA_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
