#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "parmtype.ch"

/*

Descricao: Fonte onde concetra-se todos os pontos de entrada da rotina MVC
Data: 02/08/2024
Autor: Eduardo Amaral

-------------------- ALGUNS DOS PONTOS DE ENTRADA PADROES MVC --------------------

- ANTES DE ABRIR O FORMULARIO
PARAMIXB[2] - "MODELVLDACTIVE"

- BOTOES DE DENTRO DO FORMULARIO
PARAMIXB[2] - "BUTTONBAR"

- VALIDACAO NA HORA DE SALVAR
PARAMIXB[2] - "FORMPOS"  | PARAMIXB[2] - "MODELPOS" | PARAMIXB[2] - "FORMCOMMITTTSPRE"

- AO CLICAR EM CANCELAR DENTRO DO FORMULARIO
PARAMIXB[2] - "MODELCANCEL"

*/

 
User Function MODEL_ZC1()
    
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local lInc := INCLUI
    Local lAlt := ALTERA


    /* ------------- TODAS AS VALIDAÇOES ANTES DE SALVAR O FORMULARIO ------------- */
    

    // - INCLUIR
    If aParam[2] = "MODELPOS" .AND. lInc = .T.
    
            //MsgAlert("INCLUIR - VERIFICAR TODOS OS CAMPOS ANTES DE SALVAR")
            xRet := .T.
    


    // - ALTERAR
    Elseif aParam[2] = "MODELPOS" .AND. lAlt = .T.
        
        IF !EMPTY(ZC1_PEDIDO)

            MsgInfo("NF com pedido gerado nao é possivel alterar." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Delete o pedido para proseguir.", "Lancamento de despesas Frota Medicar")
            xRet := .F.

        Else

            If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))
                MsgInfo("NF com placas vinculadas nao é possivel alterar." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Delete as placas para proseguir.", "Lancamento de despesas Frota Medicar")
                xRet := .F.
            Else
                xRet := .T.
            Endif

        Endif
        
    
    // - EXCLUIR
    Elseif aParam[2] = "MODELPOS" .AND. lAlt = .F. .AND. lInc = .F.
    
        IF !EMPTY(ZC1_PEDIDO)

            MsgInfo("NF com pedido gerado nao é possivel excluir." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Delete o pedido para proseguir.", "Lancamento de despesas Frota Medicar")
            xRet := .F.

        Else
            
            If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))
                IF MsgYesNo("Confirma exclusao das placas + NF?")
                
                    fPlacaDelet(ZC1_FILIAL,ZC1_SERIE,ZC1_DOC,ZC1_FORNEC,ZC1_LOJA)
                    xRet := .T.
                Else
                    MsgInfo("Cancelado pelo usuario.","Lancamento de despesas Frota Medicar")
                    xRet := .F.
                Endif
            Else
                xRet := .T.
            Endif

        Endif

    Endif
    

    /* ------------- ADICIONA BOTOES DENTRO DO FORMULARIO ------------- */
    /*
    IF aParam[2] = "BUTTONBAR"

        xRet := {   {'Importar Placas', 'BTNPLACA', {|| fImpPlacas()}} , {'Gerar Pedido', 'BTNPC', {|| fGeraPedido()}}, {'Deletar Placas', 'BTNDELP', {|| if ( MsgYesNo("Confirma exclusao das placas?"), fPlacaDelet(ZC1_FILIAL,ZC1_SERIE,ZC1_DOC,ZC1_FORNEC,ZC1_LOJA),  MsgInfo("Cancelado pelo usuario.","Lancamento de despesas Frota Medicar") ), xRet := .T. } }  }

    Endif
    */

Return xRet
 

Static Function fPlacaDelet(cFilialNF,cSerie,cDoc,cForn,cLoja)

    Local cQuery
   
    cQuery := " UPDATE ZC2010 SET ZC2010.D_E_L_E_T_ = '*' "
    cQuery += " FROM ZC2010 "
    cQuery += " WHERE 1=1 "
    cQuery += " AND ZC2010.ZC2_FILIAL = '"+cFilialNF+"' "
    cQuery += " AND ZC2010.ZC2_SERIE = '"+cSerie+"' "
    cQuery += " AND ZC2010.ZC2_DOC = '"+cDoc+"' "
    cQuery += " AND ZC2010.ZC2_FORNEC = '"+cForn+"' "
    cQuery += " AND ZC2010.ZC2_LOJA = '"+cLoja+"' "

    Begin Transaction

        //Tenta executar o update
        nErro := TcSqlExec(cQuery)

        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            //ABORTA O UPDATE
            DisarmTransaction()       
        EndIf

    End Transaction

Return 


