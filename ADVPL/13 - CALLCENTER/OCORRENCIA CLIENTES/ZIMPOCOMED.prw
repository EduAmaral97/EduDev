#Include "TOTVS.ch"
#Include "PROTHEUS.ch"
#Include "TopConn.ch"

/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para importar em massa documentos e placas na rotina de documentos no modulo gestão de frotas.

------------------------------------------------------------------------------- */


//Static nPosFilial       := 1 
//Static nPosCodCli       := 2 
//Static nPosLoja         := 3 
//Static nPosTipOco       := 4 
//Static nPosDtInc        := 5 
//Static nPosDtOco        := 6 
//Static nPosOcorrencia   := 7 
//Static nPosCodusu       := 8 
//Static nPosUser         := 9 

Static nPos01 := 1
Static nPos02 := 2
Static nPos03 := 3
Static nPos04 := 4
Static nPos05 := 5
Static nPos06 := 6
Static nPos07 := 7
Static nPos08 := 8
Static nPos09 := 9

User Function ZIMPOCOMED()

    Local aArea     := GetArea()
    Private cArqOri := ""
  
    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
      
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
          
        //Somente se existir o arquivo e for com a extensão CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
            //msginfo("Teste Importador Contrato")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
      
    RestArea(aArea)
Return
  
  
Static Function fImporta()

    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    //Local _nTam := TamSX3("ZOM_OCORRE")
    //Local _nTam1 := _nTam[1]
    Local cFilialArq := ""
    Local cCodCli := ""
    Local cLojaCli := ""
    Local cTipoco := ""
    Local cDtInc := ""
    Local cDtOco := ""
    Local cOcorrencia as MEMO
    Local cCodUsu := ""
    Local cUsuario := ""

    
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
      
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
      
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
  
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
  
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")

                if nLinhaAtu >= 2

                    if cLinAtu = ""

                        msginfo("Linha em branco.")

                    else 

                        cFilialArq  := aLinha[nPos01]
                        cCodCli     := aLinha[nPos02]
                        cLojaCli    := aLinha[nPos03]
                        cTipoco     := aLinha[nPos04]
                        cDtInc      := aLinha[nPos05]
                        cDtOco      := aLinha[nPos06]
                        cOcorrencia := aLinha[nPos07]
                        cCodUsu     := aLinha[nPos08]
                        cUsuario    := aLinha[nPos09]
                    
                    cOcorrencia := REPLACE(cOcorrencia, "\n", CHR(13)+CHR(10) )

                    RecLock("ZOM", .T.)
                        ZOM->ZOM_FILIAL  := alltrim(cFilialArq)
                        ZOM->ZOM_CODCLI  := alltrim(cCodCli)
                        ZOM->ZOM_LOJA    := alltrim(cLojaCli)
                        ZOM->ZOM_TIPOCO  := alltrim(cTipoco)
                        ZOM->ZOM_DTINC   := CToD(cDtInc)
                        ZOM->ZOM_DTOCOR  := CToD(cDtOco)
                        //ZOM->ZOM_OCORRE  := MSMM(,_nTam1,,cOcorrencia,1,,,"ZOM","ZOM_OCORRE")
                        ZOM->ZOM_OCORRE  := cOcorrencia
                        ZOM->ZOM_CODUSU  := alltrim(cCodUsu)
                        ZOM->ZOM_USER    := alltrim(cUsuario)
                    ZOM->(MsUnlock())
                      
                    EndIf

                EndIf

            EndDo

  
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf

        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)

Return
