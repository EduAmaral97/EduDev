#Include "Totvs.ch"  
#Include "PROTHEUS.CH"


User Function CRMA980()
    Local aArea := FWGetArea()
    Local aParam := PARAMIXB 
    Local xRet := .T.
    Local oObj := Nil
    Local cIdPonto := ""
    Local cIdModel := ""
      
    //Se tiver parametros
    If aParam != Nil
          
        //Pega informacoes dos parametros
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
              
        //Na validacao total do formulario 
        If cIdPonto == "FORMPOS" .And. cIdModel == "SA1MASTER"
            xRet := u_MA030TOK()
       
        EndIf
          
    EndIf
      
    FWRestArea(aArea)
Return xRet
