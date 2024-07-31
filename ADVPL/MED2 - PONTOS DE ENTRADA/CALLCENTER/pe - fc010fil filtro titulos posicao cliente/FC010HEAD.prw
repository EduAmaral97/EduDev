#include "protheus.ch"
 
User function FC010HEAD()
 
    Local aHeader := {}
 
     //Conteúdo das colunas
     //AllTrim(X3Titulo())
     //X3_CAMPO
     //X3_PICTURE
     //X3_TAMANHO
     //X3_DECIMAL
     //X3_VALID
     //X3_USADO
     //X3_TIPO
     //X3_ARQUIVO
     //X3_CONTEXT
    AADD(aHeader,{"Status Titulo","STATTIT","@!",16,0,"","","C","",""} )
 
Return aHeader
