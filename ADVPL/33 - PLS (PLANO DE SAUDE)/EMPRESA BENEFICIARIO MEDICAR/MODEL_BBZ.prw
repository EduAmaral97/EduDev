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

 
User Function MODEL_BBZ()
    
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local lInc := INCLUI
    //Local cQuery
    //Local cNextCod
    Private cAlias := GetNextAlias()

    //NEXTNUMERO('BBZ',1,'BBZ_CODORG',.T., '00099999')


    If aParam[2] = "MODELVLDACTIVE" .AND. lInc = .T.

        //cQuery := "SELECT MAX(BBZ_CODORG) + 1 AS CODORG FROM BBZ010" 
        //TCQUERY cQuery NEW ALIAS (cAlias)
        //DbSelectArea(cAlias)
        //cNextCod := Strzero(val(Str((cAlias)->CODORG,8)),8)
        //BBZ_CODORG := cNextCod
        //(cAlias)->(DbCloseArea())
        
        MsgAlert("Entrou para incluir.")
  
    Endif

    

Return xRet
 



