#INCLUDE "TOTVS.CH"

/*/=========================================================================================================================
Descrição:
O ponto de entrada PL660FC permite incluir botões na tela de cadastro do Grupo/Empresa, na tela de Contrato.
Programa Fonte: PLSA660.PRW
Sintaxe: PLS660BOT - Inclusão de botões no cadastro de Grupo/Empresa ( [ ] ) --> aRetBts

@author Montoro
@since 2023-10
@version P12
/*/
User Function PL660FC()
    Local aRet      := {}
    //Local aPadrao   := PARAMIXB
    //aadd(aRet,{"Resumo Contrato" ,"U_RESUMOCONTRATO",0,3})
    aadd(aRet,{"Importador de Contratos","U_IZIMPCT1",0,3})
Return(aRet)

/*/=========================================================================================================================
Descrição:
O ponto de entrada PLS660SC permite efetuar ou não manutenção na tela de Contrato. 
Iremos manipular o aRotina
Programa Fonte: PLSA660.PRW

@author Montoro
@since 2023-10
@version P12
*/

User Function PLS660SC()
    Local lRet      := .T.
    
    aadd(aRotina,{"Resumo Contrato","U_RESUMOCONTRATO",0,3})
    aadd(aRotina,{"Auditoria","U_ZMEDAUDITORIA",0,3})
    
Return(lRet)


/*=========================================================================================================================
Descrição:
O ponto de entrada PLS660BOT permite incluir botões na tela de cadastro do Grupo/Empresa, na tela do grupo/empresa.
Programa Fonte: PLSA660.PRW
Sintaxe: PLS660BOT - Inclusão de botões no cadastro de Grupo/Empresa ( [ ] ) --> aRetBts

@author Montoro
@since 2023-10
@version P12
/*/
//User Function PLS660BOT()
	//Local aRetBts := {}
	//aAdd(aRetBts,{"GRUPO EMPRESA",{ || U_BOTAO1()  },"Executa botao grupo/empresa","Botao grupo/empresa"})
//Return(aRetBts)

/*/=========================================================================================================================
Descrição:
O ponto de entrada PL660SBUT permite incluir botões na tela de cadastro do Grupo/Empresa, na tela de SubContrato.
Programa Fonte: PLSA660.PRW
Sintaxe: PLS660BOT - Inclusão de botões no cadastro de Grupo/Empresa ( [ ] ) --> aRetBts

@author Montoro
@since 2023-10
@version P12
/*/
//User Function PL660SBUT()
    //Local aRet := {}
    //aadd(aRet,{"Resumo Contrato" ,"U_RESUMOCONTATO",0,3})
    //aAdd(aRet,{"SUBCONTRATO",{ || U_BOTAO1()  },"Executa botao subcontrato","Botao subcontrato"}) 
//Return(aRet)
