#Include 'Protheus.ch'
 
User Function MNTA8053()
 
    Local aRot := aClone( ParamIXB[1] )
    aAdd( aRot, { "Importador Documentos", "U_ZIMPDOCFRT", 0, 7} )

 
Return aRot
