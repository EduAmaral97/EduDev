    
    
    Function MILETest()
    Local aArquivos := { "arquivo1.txt", "arquivo2.txt", "arquivo3.txt" }
    Local cLayout := "TESTE"
    Local nX := 0
    Local oFWMILE

    oFWMILE := FWMILE():New()

    For nX := 1 To Len( aArquivos )
        oFWMILE:SetLayout( cLayout )
        oFWMILE:SetTXTFile( aArquivos[nX] )
        If oFWMILE:Activate()
            oFWMILE:Import()
            If oFWMILE:Error()
                ApMsgInfo( I18N( "Processamento terminado. Arquivo #1.", ;
                { aArquivos[nX] } ) )
            Else
                ApMsgStop( I18N( "Processamento terminado. Arquivo #1." ;
                "Houve erros no processamento. Verifique as ocorrências no LOG.", ;
                { aArquivos[nX] } ) )
            EndIf
                oFWMILE:Deactivate()
            Else
                ApMsgStop( I18N( "Problemas para importar. " + oFWMILE:GetError(), {} ) )
            EndIf
        Next
    
    Return NIL


