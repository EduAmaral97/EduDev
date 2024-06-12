//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


User Function ZRELFORNPG()
	
	DEFAULT cForn := ""
	Local cPasta := ""  
	
	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Seleção de Pasta para Salvar arquivo"
    Local lSalvar := .F.

	/* ---------------------------- GRUPO DE PERGUNTAS/FILTRO ---------------------------- */


	Private cPerg := "ZFORNPG" // Nome do grupo de perguntas


	If !Empty(cForn)
		Pergunte(cPerg,.F.)
		cForn := MV_PAR04 + MV_PAR05 
	ElseIf !Pergunte(cPerg,.T.)
		Return
	Endif


 
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
	
	if cPasta <> ''
		MsAguarde({||fMontaExcel(cPasta)},"Aguarde","Motando os Dados do Relatorio...") 
	else
		MsgAlert('Caminho nao selecionado fim da execução.')
	Endif
	
Return

Static Function fMontaExcel(cPasta)
	
	Local cQuery 
	Local cArqInc
	Local cForn
	Private _cAlias := GetNextAlias()

	/* ---------------------------- ARQUIVO EXCEL ---------------------------- */
	
	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("FORNPG")
	oExcel:AddworkSheet("FORNPG")

	oExcel:AddTable ("FORNPG","ZFORNPG",.F.)
	oExcel:AddColumn("FORNPG","ZFORNPG","FILIAL" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","PREFIXO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","TITULO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","PARCELA" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","TIPO" 			,1,1,.F., "")	
	oExcel:AddColumn("FORNPG","ZFORNPG","CNPJ" 			,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","FORNECEDOR" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","EMISSAO" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","VENCIMENTO" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","VALOR" 		,1,3,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","SALDO" 		,1,3,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","DTBAIXA" 		,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","HISTORICO" 	,1,1,.F., "")
	oExcel:AddColumn("FORNPG","ZFORNPG","SITUACAO" 		,1,1,.F., "")
	
	cQuery := " SELECT  "
	cQuery += " A.E2_FILIAL		AS FILIAL, "
	cQuery += " A.E2_PREFIXO	AS PREFIXO, "
	cQuery += " A.E2_NUM		AS TITULO, "
	cQuery += " A.E2_PARCELA	AS PARCELA, "
	cQuery += " A.E2_TIPO 		AS TIPO, "
	cQuery += " B.A2_CGC 		AS CNPJ, "
	cQuery += " B.A2_NREDUZ		AS FORNECEDOR, "
	cQuery += " A.E2_EMISSAO	AS EMISSAO, "
	cQuery += " A.E2_VENCREA 	AS VENCIMENTO, "
	cQuery += " A.E2_VALOR 		AS VALOR, "
	cQuery += " A.E2_SALDO 		AS SALDO, "
	cQuery += " A.E2_BAIXA 		AS DTBAIXA, "
	cQuery += " A.E2_HIST		AS HISTORICO, "
	cQuery += " CASE "
	cQuery += " 	WHEN A.E2_SALDO = 0 AND A.E2_BAIXA <> '' THEN 'BAIXADO' "
	cQuery += " 	WHEN A.E2_SALDO > 0 AND A.E2_BAIXA <> '' THEN 'BAIXADO PARCIALMENTE' "
	cQuery += " 	WHEN A.E2_SALDO > 0 AND A.E2_BAIXA = '' THEN 'EM ABERTO' "
	cQuery += " 	ELSE '' "
	cQuery += " END 			AS SITUACAO "
	cQuery += " FROM SE2010 A "
	cQuery += " LEFT JOIN SA2010 B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.E2_FORNECE AND B.A2_LOJA = A.E2_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND A.E2_FILIAL = '"+MV_PAR01+"' "
	cQuery += " AND A.E2_VENCREA BETWEEN '"+Dtos(MV_PAR02)+"' AND '"+Dtos(MV_PAR03)+"' " "
	cQuery += " AND A.E2_FORNECE = '"+MV_PAR04+"' "
	cQuery += " AND A.E2_LOJA = '"+MV_PAR05+"' "
	If MV_PAR06 = 1
		cQuery += " AND A.SALDO > 0 "
		cQuery += " AND A.E2_BAIXA <> '' "
	Elseif MV_PAR06 = 2
		cQuery += " AND A.SALDO = 0 "
		cQuery += " AND A.E2_BAIXA = '' "
	Endif
	

	//Criar alias temporário
	TCQUERY cQuery NEW ALIAS (_cAlias)

	DbSelectArea(_cAlias)

	cForn := (_cAlias)->FORNECEDOR

	While (_cAlias)->(!Eof())

		oExcel:AddRow("FORNPG","ZFORNPG",{(_cAlias)->FILIAL,(_cAlias)->PREFIXO,(_cAlias)->TITULO,(_cAlias)->PARCELA,(_cAlias)->TIPO,SubStr( (_cAlias)->CNPJ,1,2 ) + '.' + SubStr( (_cAlias)->CNPJ,3,3 ) + '.' + SubStr( (_cAlias)->CNPJ,6,3 ) + '/' + SubStr( (_cAlias)->CNPJ,9,4 ) + '-' + SubStr( (_cAlias)->CNPJ,12,2),(_cAlias)->FORNECEDOR,SubStr((_cAlias)->EMISSAO,7,2) + "/" + SubStr((_cAlias)->EMISSAO,5,2) + "/" + SubStr((_cAlias)->EMISSAO,1,4),SubStr((_cAlias)->VENCIMENTO,7,2) + "/" + SubStr((_cAlias)->VENCIMENTO,5,2) + "/" + SubStr((_cAlias)->VENCIMENTO,1,4),(_cAlias)->VALOR,(_cAlias)->SALDO,SubStr((_cAlias)->DTBAIXA,7,2) + "/" + SubStr((_cAlias)->DTBAIXA,5,2) + "/" + SubStr((_cAlias)->DTBAIXA,1,4),(_cAlias)->HISTORICO,(_cAlias)->SITUACAO})

		(_cAlias)->(dBskip())

	EndDo

	(_cAlias)->(DbCloseArea())

	oExcel:SetFont("Calibri")
	oExcel:SetFontSize(11)
	oExcel:SetItalic(.F.)
	oExcel:SetBold(.F.)
	oExcel:SetUnderline(.F.)

	oExcel:Activate()
	cArqInc := cPasta + '\' + cForn + '_' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
	oExcel:GetXMLFile(cArqInc)
	
	oExcel:DeActivate()

Return
