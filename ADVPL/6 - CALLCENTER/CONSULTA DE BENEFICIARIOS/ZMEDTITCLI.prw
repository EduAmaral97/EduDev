#Include "Totvs.ch"
#INCLUDE "TOPCONN.CH"

    
User Function ZMEDTITCLI(cCodcli,cLojacli,cNomecli)
 
    Local aArea := GetArea()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local aCoors as array
    Local cQueryTit
    Private AliasTit := GetNextAlias()

    aCoors := FWGetDialogSize()

		cQueryTit := " SELECT "
		cQueryTit += " SE1.E1_FILIAL   	AS FILIAL,  "
		cQueryTit += " SE1.E1_PREFIXO  	AS PREFIXO,  "
		cQueryTit += " SE1.E1_NUM	    	AS NUMTIT,  "
		cQueryTit += " CONCAT(SUBSTRING(SE1.E1_EMISSAO,7,2),'/',SUBSTRING(SE1.E1_EMISSAO,5,2),'/',SUBSTRING(SE1.E1_EMISSAO,1,4)) AS DTEMI, "
		cQueryTit += " CONCAT(SUBSTRING(SE1.E1_VENCTO,7,2),'/',SUBSTRING(SE1.E1_VENCTO,5,2),'/',SUBSTRING(SE1.E1_VENCTO,1,4)) AS DTVENC, "
        cQueryTit += " CONCAT(SUBSTRING(SE1.E1_VENCREA,7,2),'/',SUBSTRING(SE1.E1_VENCREA,5,2),'/',SUBSTRING(SE1.E1_VENCREA,1,4)) AS DTVENCREA, "
        cQueryTit += " CONCAT(SUBSTRING(SE1.E1_BAIXA,7,2),'/',SUBSTRING(SE1.E1_BAIXA,5,2),'/',SUBSTRING(SE1.E1_BAIXA,1,4)) AS DTBAIXA, "
		cQueryTit += " SE1.E1_VALOR    	AS VALOR,  "
		cQueryTit += " (SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0) AS VALORLIQ,  "
		cQueryTit += " ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS SALDO,  "
		cQueryTit += " ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) AS VALORBX, "
        cQueryTit += " CASE "
        cQueryTit += "  WHEN ((SE1.E1_VALOR + SE1.E1_ACRESC) - SE1.E1_DECRESC - ISNULL((SELECT SUM(A.E1_VALOR) FROM SE1010 A WHERE 1=1 AND A.D_E_L_E_T_ = ''  AND A.E1_TIPO IN ('CF-','PI-','CS-','IN-','IS-','IR-')  AND A.E1_FILIAL = SE1.E1_FILIAL  AND A.E1_PREFIXO = SE1.E1_PREFIXO AND A.E1_NUM = SE1.E1_NUM AND A.E1_CLIENTE = SE1.E1_CLIENTE AND A.E1_LOJA = SE1.E1_LOJA),0)) + ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'P'),0) - ISNULL((SELECT SUM(SE5.E5_VALOR) FROM SE5010 SE5 WHERE 1=1 AND SE5.D_E_L_E_T_ = '' AND SE5.E5_FILIAL = SE1.E1_FILIAL AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.E5_CLIFOR = SE1.E1_CLIENTE AND SE5.E5_LOJA = SE1.E1_LOJA AND SE5.E5_RECPAG = 'R'),0) > 1 THEN 'ABERTO' "
        cQueryTit += "  ELSE 'BAIXADO' "
        cQueryTit += " END AS STATUSTIT "
        cQueryTit += " FROM SE1010 SE1  "
		cQueryTit += " WHERE 1=1    "
		cQueryTit += " AND SE1.D_E_L_E_T_ = ''  "
		cQueryTit += " AND SE1.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR')  "
        cQueryTit += " AND SE1.E1_CLIENTE = '"+cCodcli+"' "
        cQueryTit += " AND SE1.E1_LOJA = '"+cLojacli+"' "
		cQueryTit += " ORDER BY SE1.E1_VENCREA DESC"


    TCQUERY cQueryTit NEW ALIAS (AliasTit)


    //Verifica resultado da query
	DbSelectArea(AliasTit)
    (AliasTit)->(DbGoTop())

    If (AliasTit)->(Eof())

        MsgInfo("Cliente nao possui titulos.", "Contratos Medicar")

    Else


        DEFINE DIALOG oDlg TITLE "Titulos Cliente - Contrato Medicar " FROM aCoors[1], aCoors[2] TO aCoors[3] - (aCoors[3]/4), aCoors[4] - (aCoors[4]/3) PIXEL
        
            aGradeTit := {}

            While (AliasTit)->(!Eof())

                aAdd(aGradeTit, { IF((AliasTit)->STATUSTIT = 'BAIXADO',.T.,.F.),(AliasTit)->FILIAL,(AliasTit)->PREFIXO,(AliasTit)->NUMTIT,(AliasTit)->DTEMI,(AliasTit)->DTVENC,(AliasTit)->DTVENCREA,(AliasTit)->VALOR,(AliasTit)->VALORLIQ,(AliasTit)->SALDO,(AliasTit)->VALORBX,(AliasTit)->DTBAIXA }) // DADOS DA GRADE
            
                (AliasTit)->(dBskip())

            EndDo

            oBrowse := TCBrowse():New( aCoors[1]+30 , aCoors[1], aCoors[3] - (aCoors[3]/2.75), aCoors[3]/3,, {'Status','Filial','Prefixo','Titulo','Dt Emissao','Vencimento','Vencimento Real','Valor','Valor Liq','Saldo','Valor Baixado','Dt Baixa'},{30,50,50,50,50,50,50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGradeTit)
            oBrowse:bLine := {||{ If(aGradeTit[oBrowse:nAt,01],oOK,oNO),aGradeTit[oBrowse:nAt,02],aGradeTit[oBrowse:nAt,03],aGradeTit[oBrowse:nAt,04],aGradeTit[oBrowse:nAt,05],aGradeTit[oBrowse:nAt,06],aGradeTit[oBrowse:nAt,07],aGradeTit[oBrowse:nAt,08],aGradeTit[oBrowse:nAt,09],aGradeTit[oBrowse:nAt,10],aGradeTit[oBrowse:nAt,11],aGradeTit[oBrowse:nAt,12] }} //EXIBICAO DA GRADE

            TButton():New( aCoors[1]+10, aCoors[3] - (aCoors[3]/2.77) , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
        
        ACTIVATE DIALOG oDlg CENTERED

    EndIF

    (AliasTit)->(DbCloseArea())

    RestArea(aArea)

Return
    


