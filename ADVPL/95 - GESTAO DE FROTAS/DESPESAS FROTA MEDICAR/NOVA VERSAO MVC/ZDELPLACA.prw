#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"


User Function ZDELPLACA(cFilialNF,cSerie,cDoc,cForn,cLoja,cPedido)

    Local cQuery

    cQuery := " UPDATE ZC2010 SET ZC2010.D_E_L_E_T_ = '*' "
    cQuery += " FROM ZC2010 "
    cQuery += " WHERE 1=1 "
    cQuery += " AND ZC2010.ZC2_FILIAL = '"+cFilialNF+"' "
    cQuery += " AND ZC2010.ZC2_SERIE = '"+cSerie+"' "
    cQuery += " AND ZC2010.ZC2_DOC = '"+cDoc+"' "
    cQuery += " AND ZC2010.ZC2_FORNEC = '"+cForn+"' "
    cQuery += " AND ZC2010.ZC2_LOJA = '"+cLoja+"' "


    IF !EMPTY(cPedido)

        MsgInfo("NF com pedido gerado nao é possivel deletar as placas." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Pedido: " + cPedido, "Lancamento de despesas Frota Medicar")

    Else

        If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))

            Begin Transaction

                //Tenta executar o update
                nErro := TcSqlExec(cQuery)

                //Se houve erro, mostra a mensagem e cancela a transacao
                If nErro != 0
                    MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                    //ABORTA O UPDATE
                    DisarmTransaction()       

                else
                    
                    MsgInfo("Placas deletadas com Sucesso.",  "Lancamento de despesas Frota Medicar")

                EndIf

            End Transaction

        Else

            MsgInfo("NF sem placas vinculadas.", "Lancamento de despesas Frota Medicar")

        Endif

    Endif






Return 
