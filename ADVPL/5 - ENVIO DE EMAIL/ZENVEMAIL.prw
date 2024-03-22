#include "PROTHEUS.CH"

/*

Pessoal, para quem quer usar uma rotina mais padrão possível, existe a função GPEMail, 
que utiliza os parâmetros:

- MV_RELAUTH 
- MV_RELSERV 
- MV_RELACNT 
- MV_RELPSW 
- MV_RELSSL 
- MV_RELTLS
- MV_RELFROM

*/

User Function ZENVEMAIL()
    Local aArea    := GetArea()
    Local lEnvioOK := .F.
     
    Default cPara      := "eduardo.amaral@medicar.com.br"
    Default cAssunto   := "RELATORIO TELEMEDICINA MEDICAR"
    Default cCorpo     := "Segue em anexo relatorio de Telemedicina"
    Default aAnexos    := {}

    //Mensagem com anexos (devem estar dentro da Protheus Data)
    aAdd(aAnexos, "data\anexos\clicklife_exc_19032024.xlsx")

    lEnvioOK := GPEMail(cAssunto, cCorpo, cPara, aAnexos)

    FErase("data\anexos\clicklife_exc_19032024.xlsx")
    
    RestArea(aArea)
Return lEnvioOK
