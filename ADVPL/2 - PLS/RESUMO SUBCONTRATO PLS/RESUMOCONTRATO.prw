#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/*/ 
-----------------------------------------------------------------------------# 
							 U_RESUMOCONTATO							     #
-----------------------------------------------------------------------------# 
Funcao: U_RESUMOCONTATO														 #
Autor: Eduardo Jorge 													     #
Data: 15/01/2023														     #
Descricao: RESUMO DE VALORES E QUANTIDDADDE DE VIDAS DE UM CONTTRATO         #
*****************************************************************************#

*/

User function RESUMOCONTRATO()

    Local aArea   	:= GetArea()
    Local aAreaBQC	:= ("BQC") -> ( GetArea() )
    Local cSubcon	:= BQC->BQC_SUBCON
    local cCodint   := BQC->BQC_CODINT
    local cCodemp   := BQC->BQC_CODEMP
    local cConemp   := BQC->BQC_NUMCON
    local cVercon   := BQC->BQC_VERCON
    local cVersub   := BQC->BQC_VERSUB
    

    Local cQtdVidaTitular   := 0
    Local cQtdVidaDepedente := 0
    Local cQtdVidTotal      := 0

    Local cValorTitular     := 0
    Local cValorDepedente   := 0
    Local cValorTotal       := 0

    Private AliasCtr	    := GetNextAlias()
    Private AliasCtrBloq    := GetNextAlias()

    DbSelectArea("BQC")

	//Monta arquivo de trabalho temporário
	MsAguarde({||MontaQuery(cSubcon,cCodint,cCodemp,cConemp,cVercon,cVersub)},"Aguarde","Obtendo Dados...")

	//Verifica resultado da query
	DbSelectArea(AliasCtr)
    DbSelectArea(AliasCtrBloq)

    While (AliasCtr)->(!Eof())


        If (AliasCtr)->BA1_TIPUSU = 'T'

            cQtdVidaTitular := cQtdVidaTitular + 1
            cValorTitular := cValorTitular + (AliasCtr)->BDK_VALOR

        Else

            cQtdVidaDepedente := cQtdVidaDepedente + 1
            cValorDepedente := cValorDepedente + (AliasCtr)->BDK_VALOR

        Endif


        //Verifica a quebra de pagina
        (AliasCtr)->(dBskip())

    EndDo

    cQtdVidTotal := cQtdVidaTitular + cQtdVidaDepedente
    cValorTotal := cValorTitular + cValorDepedente

    DEFINE MSDIALOG oDlg FROM 05,10 TO 320,450 TITLE "RESUMO DO CONTRATO: " PIXEL

        @ 010,020 TO 075,200 LABEL " VALORES " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "VALOR TITULAR (Ativos): "                    SIZE 070, 020 OF oDlg PIXEL
        @ 032, 025 SAY oTitQtdVidas PROMPT "R$ " + Str(cValorTitular,10,2)               SIZE 050, 020 OF oDlg PIXEL
        
        @ 025, 120 SAY oTitQtdVidas PROMPT "VALOR DEPEDENTE (Ativos): "                  SIZE 100, 020 OF oDlg PIXEL
        @ 032, 120 SAY oTitQtdVidas PROMPT "R$ " +  Str(cValorDepedente,10,2)            SIZE 060, 020 OF oDlg PIXEL

        @ 050, 025 SAY oTitQtdVidas PROMPT "VALOR TOTAL VIDAS (Ativos): "                SIZE 100, 020 OF oDlg PIXEL
        @ 057, 025 SAY oTitQtdVidas PROMPT "R$ " +Str(cValorTotal,10,2)                  SIZE 050, 020 OF oDlg PIXEL
        
        @ 080,020 TO 135,200 LABEL " QUANTIDADE " OF oDlg PIXEL

        @ 090, 025 SAY oTitQtdVidas PROMPT "VIDAS TITULAR (Ativos): "                 SIZE 100, 020 OF oDlg PIXEL
        @ 097, 025 SAY oTitQtdVidas PROMPT cQtdVidaTitular                            SIZE 050, 020 OF oDlg PIXEL
        
        @ 090, 120 SAY oTitQtdVidas PROMPT "VIDAS DEPEDENTE (Ativos): "               SIZE 100, 020 OF oDlg PIXEL
        @ 097, 120 SAY oTitQtdVidas PROMPT cQtdVidaDepedente                          SIZE 050, 020 OF oDlg PIXEL

        @ 115, 025 SAY oTitQtdVidas PROMPT "TOTAL VIDAS (Ativos): "                   SIZE 100, 020 OF oDlg PIXEL
        @ 122, 025 SAY oTitQtdVidas PROMPT cQtdVidTotal                               SIZE 050, 020 OF oDlg PIXEL

        @ 112, 120 SAY oTitQtdVidas PROMPT "TOTAL BLOQUEADO: "                        SIZE 070, 020 OF oDlg PIXEL
        @ 122, 120 SAY oTitQtdVidas PROMPT (AliasCtrBloq)->QTDBLO                     SIZE 050, 020 OF oDlg PIXEL


    DEFINE SBUTTON FROM 140,180 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    (AliasCtr)->(DbCloseArea())
    (AliasCtrBloq)->(DbCloseArea())
    RestArea( aAreaBQC )
    RestArea( aArea    )

return


Static Function MontaQuery(cSubcon,cCodint,cCodemp,cConemp,cVercon,cVersub)

    Local cQuery
    Local cQueryBloq

    cQuery := " SELECT  "
    cQuery += " C.BA1_MATRIC,  "
    cQuery += " C.BA1_TIPUSU, "
    cQuery += " C.BA1_MOTBLO, "
    cQuery += " C.BA1_DATBLO, "
    cQuery += " D.BDK_VALOR "
    cQuery += " FROM BQC010 A  "
    cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
    cQuery += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''  "
    cQuery += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''  "
    cQuery += " WHERE 1=1  "
    cQuery += " AND A.D_E_L_E_T_ = ''  "
    cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
    cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQuery += " AND A.BQC_VERCON = '"+cVersub+"'  "
    cQuery += " AND A.BQC_VERSUB = '"+cVercon+"'  "
    cQuery += " AND C.BA1_MOTBLO = '' "
    cQuery += " AND C.BA1_DATBLO = '' "

    cQueryBloq := " SELECT  "
    cQueryBloq += " COUNT(*) AS QTDBLO  "
    cQueryBloq += " FROM BQC010 A  "
    cQueryBloq += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
    cQueryBloq += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''  "
    cQueryBloq += " WHERE 1=1  "
    cQueryBloq += " AND A.D_E_L_E_T_ = ''  "
    cQueryBloq += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQueryBloq += " AND A.BQC_CODINT = '"+cCodint+"'  "
    cQueryBloq += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQueryBloq += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQueryBloq += " AND A.BQC_VERCON = '"+cVersub+"'  "
    cQueryBloq += " AND A.BQC_VERSUB = '"+cVercon+"'  "
    cQueryBloq += " AND C.BA1_MOTBLO <> '' "
    cQueryBloq += " AND C.BA1_DATBLO <> '' "

    TCQUERY cQuery NEW ALIAS (AliasCtr)
    TCQUERY cQueryBloq NEW ALIAS (AliasCtrBloq)

Return
