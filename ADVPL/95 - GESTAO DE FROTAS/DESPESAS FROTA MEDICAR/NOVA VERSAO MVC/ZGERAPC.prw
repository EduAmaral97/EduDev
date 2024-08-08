#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"


User Function ZGERAPC(cFilialNF,cSerie,cDoc,cForn,cLoja,cPedido,cProduto,cCondpg)

    Local cQueryRateio
    Local cQueryPed
    Local cQueryQTOT
    Local cQueryVTOT
    Local cItem := 1
    Local cNumPed
    Private cAliasRat := GetNextAlias()
    Private cAliasPed := GetNextAlias()
    Private cAliasQTot := GetNextAlias()
    Private cAliasVTot := GetNextAlias()


    IF !EMPTY(cPedido)

        MsgInfo("NF com pedido gerado nao é possivel gerar o Pedido." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Pedido: " + cPedido, "Lancamento de despesas Frota Medicar")

    Else

        If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))

            cQueryQTOT := " SELECT COUNT(*) AS QTDTOT FROM ZC2010 A "
            cQueryQTOT += " WHERE 1=1 "
            cQueryQTOT += " AND A.D_E_L_E_T_ = '' "
            cQueryQTOT += " AND A.ZC2_FILIAL = '"+cFilialNF+"' "
            cQueryQTOT += " AND A.ZC2_SERIE = '"+cSerie+"' "
            cQueryQTOT += " AND A.ZC2_DOC = '"+cDoc+"' "
            cQueryQTOT += " AND A.ZC2_FORNEC = '"+cForn+"' "
            cQueryQTOT += " AND A.ZC2_LOJA = '"+cLoja+"' "
            
            cQueryVTOT := " SELECT SUM(ZC2_VALOR) AS VLRTOT FROM ZC2010 A "
            cQueryVTOT += " WHERE 1=1 "
            cQueryVTOT += " AND A.D_E_L_E_T_ = '' "
            cQueryVTOT += " AND A.ZC2_FILIAL = '"+cFilialNF+"' "
            cQueryVTOT += " AND A.ZC2_SERIE = '"+cSerie+"' "
            cQueryVTOT += " AND A.ZC2_DOC = '"+cDoc+"' "
            cQueryVTOT += " AND A.ZC2_FORNEC = '"+cForn+"' "
            cQueryVTOT += " AND A.ZC2_LOJA = '"+cLoja+"' "

            TCQUERY cQueryQTOT NEW ALIAS (cAliasQTot)
            DbSelectArea(cAliasQTot)

            TCQUERY cQueryVTOT NEW ALIAS (cAliasVTot)
            DbSelectArea(cAliasVTot)

            cQtdTotal := (cAliasQTot)->QTDTOT
            cVlrTotal := (cAliasVTot)->VLRTOT

            (cAliasQTot)->(DbCloseArea())
            (cAliasVTot)->(DbCloseArea())


            IF MsgYesNo("Confirma os dados para gerar o pedido?"  + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Qtd Placas: " + Alltrim(Transform(cQtdTotal, "@E 999999999")) + CHR(13)+CHR(10) + "- Valor Total: R$ " + Alltrim(Transform(cVlrTotal, "@E 999,999,999.99")) )

                cQueryPed := " SELECT C7_NUM AS PEDIDO FROM SC7010 WHERE C7_FILIAL = '"+cFilialNF+"' AND R_E_C_N_O_ = ISNULL((SELECT TOP 1 MAX(R_E_C_N_O_) FROM SC7010 WHERE C7_FILIAL = '"+cFilialNF+"'),'') "

                //Criar alias temporário
                TCQUERY cQueryPed NEW ALIAS (cAliasPed)
                DbSelectArea(cAliasPed)

                cNumPed := Soma1((cAliasPed)->PEDIDO)

                (cAliasPed)->(DbCloseArea())


                //GRAVA O PEDIDO
                IF RecLock("SC7", .T.)
                    
                    SC7->C7_FILIAL  := cFilialNF
                    SC7->C7_TIPO    := 1
                    SC7->C7_ITEM    := '0001'
                    SC7->C7_PRODUTO := cProduto
                    SC7->C7_DESCRI  := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_DESC')
                    SC7->C7_UM      := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_UM')
                    SC7->C7_QUANT   := 1
                    SC7->C7_PRECO   := cVlrTotal
                    SC7->C7_TOTAL   := cVlrTotal
                    SC7->C7_COND    := cCondpg
                    SC7->C7_LOCAL   := '01'
                    SC7->C7_FORNECE := cForn
                    SC7->C7_DATPRF  := DATE()
                    SC7->C7_EMISSAO := DATE()
                    SC7->C7_NUM     := cNumPed
                    SC7->C7_LOJA    := cLoja
                    SC7->C7_FILENT  := cFilialNF
                    SC7->C7_FLUXO   := 'S'
                    SC7->C7_USER    := RetCodUsr()

                    SC7->(MsUnlock())
                    ConfirmSX8() 
                
                ELSE
                    
                    RollbackSx8()

                EndIF

                cQueryRateio := " SELECT  "
                cQueryRateio += " A.ZC2_CC   AS CC, "
                cQueryRateio += " A.ZC2_CLVL AS CLVL, "
                cQueryRateio += " CAST( ( CAST( COUNT(*) AS NUMERIC(10,2)) * 100 ) /  ISNULL((SELECT COUNT(*) AS QTD1 FROM ZC2010 A1 WHERE 1=1 AND A1.D_E_L_E_T_ = '' AND A1.ZC2_FILIAL = A.ZC2_FILIAL AND A1.ZC2_SERIE = A.ZC2_SERIE AND A1.ZC2_DOC = A.ZC2_DOC AND A1.ZC2_FORNEC = A.ZC2_FORNEC AND A1.ZC2_LOJA = A.ZC2_LOJA ),0) AS NUMERIC(10,2)) AS PERC, "
                cQueryRateio += " SUM(A.ZC2_VALOR) AS VALOR "
                cQueryRateio += " FROM ZC2010 A "
                cQueryRateio += " WHERE 1=1 "
                cQueryRateio += " AND A.D_E_L_E_T_ = '' "
                cQueryRateio += " AND A.ZC2_FILIAL = '"+cFilialNF+"' "
                cQueryRateio += " AND A.ZC2_SERIE = '"+cSerie+"' "
                cQueryRateio += " AND A.ZC2_DOC = '"+cDoc+"' "
                cQueryRateio += " AND A.ZC2_FORNEC = '"+cForn+"' "
                cQueryRateio += " AND A.ZC2_LOJA = '"+cLoja+"' "
                cQueryRateio += " GROUP BY A.ZC2_CC, A.ZC2_CLVL, A.ZC2_FILIAL, A.ZC2_SERIE, A.ZC2_DOC,A.ZC2_FORNEC, A.ZC2_LOJA "
                
                //Criar alias temporário
                TCQUERY cQueryRateio NEW ALIAS (cAliasRat)
                DbSelectArea(cAliasRat)

                (cAliasRat)->(DbGoTop())

                While ! (cAliasRat)->(EoF())

                    //GRAVA O RATEIO
                    RecLock("SCH", .T.)
                        
                        SCH->CH_FILIAL  := cFilialNF
                        SCH->CH_PEDIDO  := cNumPed
                        SCH->CH_FORNECE := cForn
                        SCH->CH_LOJA    := cLoja
                        SCH->CH_ITEMPD  := '0001'
                        SCH->CH_ITEM    := alltrim(Strzero(cItem,2))
                        SCH->CH_PERC    := (cAliasRat)->PERC
                        SCH->CH_CC      := (cAliasRat)->CC
                        SCH->CH_CONTA   := Posicione('SB1', 1, FWxFilial('SB1') + cProduto, 'B1_CONTA')
                        SCH->CH_ITEMCTA := ''
                        SCH->CH_CLVL    := (cAliasRat)->CLVL
                        SCH->CH_CUSTO1  := (cAliasRat)->VALOR
                        SCH->CH_CUSTO2  := 0
                        SCH->CH_CUSTO3  := 0
                        SCH->CH_CUSTO4  := 0
                        SCH->CH_CUSTO5  := 0
                        
                    SCH->(MsUnlock())
                    ConfirmSX8()

                    cItem := cItem + 1

                    (cAliasRat)->(dBskip())

                EndDo

                (cAliasRat)->(DbCloseArea())

                RecLock("ZC1", .F.)
                    ZC1->ZC1_PEDIDO := cNumPed
                ZC1->(MsUnlock())

                MsgInfo("Pedido gerado com Sucesso.", "Lancamento de despesas Frota Medicar")

            Else

                MsgInfo("Cancelado pelo usuario Pedido nao gerado.", "Lancamento de despesas Frota Medicar")

            EndIF

        Else

            MsgInfo("NF sem placas vinculadas nao é possivel gerar o Pedido.", "Lancamento de despesas Frota Medicar")

        Endif


    Endif

Return 
