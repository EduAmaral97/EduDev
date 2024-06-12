//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELDESPFRTDOC()

	DEFAULT cVar01 := ""	
	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.
	Private cPerg  := "ZRDFDOC" // Nome do grupo de perguntas
 

	/* ---------------------------- PERGUNTAS E FILTROS ---------------------------- */
	
	If !Empty(cVar01)
		Pergunte(cPerg,.F.)
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


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

	
	MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	
	
Return


Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqBem
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("DOCFROTA")
	oExcel:AddworkSheet("DOCFROTA")
	
	oExcel:AddTable ("DOCFROTA","DOCFRT",.F.)
	oExcel:AddColumn("DOCFROTA","DOCFRT", "FILIAL",				,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "EMISSAO",			,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "VENCIMENTO",			,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "VENCIMENTO REAL",	,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "DATA BAIXA",			,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "TITULO",				,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "PLACA",				,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "TIPO DOC",			,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "CENTRO CUSTO",		,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "CLASSE VALOR",		,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "NATUREZA",			,1,1,.F., "")
	oExcel:AddColumn("DOCFROTA","DOCFRT", "VALOR",				,1,2,.F., "@E 999,999,999.99")


	cQuery := " SELECT  "
	cQuery += " A.TS1_FILIAL AS FILIAL, "
	cQuery += " CONCAT(SUBSTRING(B.E2_EMISSAO,7,2),'/',SUBSTRING(B.E2_EMISSAO,5,2),'/',SUBSTRING(B.E2_EMISSAO,1,4)) AS EMISSAO, "
	cQuery += " CONCAT(SUBSTRING(B.E2_VENCTO,7,2),'/',SUBSTRING(B.E2_VENCTO,5,2),'/',SUBSTRING(B.E2_VENCTO,1,4))  AS VENCIMENTO, "
	cQuery += " CONCAT(SUBSTRING(B.E2_VENCREA,7,2),'/',SUBSTRING(B.E2_VENCREA,5,2),'/',SUBSTRING(B.E2_VENCREA,1,4)) AS VENCREAL, "
	cQuery += " CONCAT(SUBSTRING(B.E2_BAIXA,7,2),'/',SUBSTRING(B.E2_BAIXA,5,2),'/',SUBSTRING(B.E2_BAIXA,1,4))   AS DTBAIXA, "
	cQuery += " B.E2_NUM	 AS NUMERO, "
	cQuery += " A.TS1_PLACA  AS PLACA, "
	cQuery += " A.TS1_DOCTO	 AS TIPODOC, "
	cQuery += " B.E2_CCUSTO  AS CC, "
	cQuery += " B.E2_CLVL	 AS CLVL, "
	cQuery += " B.E2_NATUREZ AS NATUREZA, "
	cQuery += " B.E2_VALOR   AS VALOR "
	cQuery += " FROM TS1010 A "
	cQuery += " LEFT JOIN SE2010 B ON B.D_E_L_E_T_ = '' AND B.E2_FILIAL =  A.TS1_FILIAL AND B.E2_PREFIXO = A.TS1_PREFIX AND B.E2_NUM = A.TS1_NUMSE2 AND B.E2_TIPO = A.TS1_TIPO AND B.E2_FORNECE = A.TS1_FORNEC AND B.E2_LOJA = A.TS1_LOJA  "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	IF MV_PAR03 = 2
		cQuery += " AND B.E2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	ELSE
		cQuery += " AND B.E2_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
	ENDIF
	cQuery += " ORDER BY B.E2_VENCREA "


	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	While (_cAlias)->(!Eof())

		oExcel:AddRow("DOCFROTA","DOCFRT",{ (_cAlias)->FILIAL,(_cAlias)->EMISSAO,(_cAlias)->VENCIMENTO,(_cAlias)->VENCREAL,(_cAlias)->DTBAIXA,(_cAlias)->NUMERO,(_cAlias)->PLACA,(_cAlias)->TIPODOC,(_cAlias)->CC,(_cAlias)->CLVL,(_cAlias)->NATUREZA,(_cAlias)->VALOR })

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqBem := cPasta + '\' + 'DOCFROTA' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqBem)
	
	oExcel:DeActivate()

Return
