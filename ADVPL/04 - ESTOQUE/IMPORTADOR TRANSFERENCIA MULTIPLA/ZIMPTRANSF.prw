#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para importar em massa produtos na rotina de tranferencia mutipla entre armazens (Na mesma filial)

------------------------------------------------------------------------------- */



//Posições do Array
Static nPosCodprod      := 1 
Static nPosArmzOri      := 2 
Static nPosArmzDest     := 3 
Static nPosQuantidade   := 4
Static nPosLote         := 5 
Static nPosValidade     := 6 


User function ZIMPTRANSF()
    
    Local aArea    := GetArea()
    Private cArqOri := ""


    IF MsgYesNo("Confirma inclusao da Grid?")


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
        

    Else 

        MsgInfo("Cancelado pelo usuario", "Importador Medicar")

    Endif

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
    Local cCodprod      := ""
    Local cArmzOri      := ""
    Local cArmzDest     := ""
    Local cQuantidade   := ""
    Local cLote         := ""
    Local cValidade     := ""

    Local cQuery
    Local cMaxSeq       := 0

    //Local cQuerySB9

    acols := {}
    
    Private cDirLog     := GetTempPath() + "x_importacao\"
    Private cLog        := ""
    Private _cAlias     := GetNextAlias()
    Private cAliasSB9   := GetNextAlias()


    cQuery := " SELECT MAX(R_E_C_N_O_) AS MAXREC FROM SD3010 "

    TCQUERY cQuery NEW ALIAS (_cAlias)

    cMaxSeq := (_cAlias)->MAXREC + 1

    (_cAlias)->(DbCloseArea())


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

                        cCodprod        := aLinha[nPosCodprod]
                        cArmzOri        := aLinha[nPosArmzOri]
                        cArmzDest       := aLinha[nPosArmzDest]
                        cQuantidade     := aLinha[nPosQuantidade]
                        cLote           := IF(aLinha[nPosLote] = "", " ", aLinha[nPosLote])
                        cValidade       := IF(aLinha[nPosValidade] = "", "01/01/2000", aLinha[nPosValidade])

                        //ACOLS[1][1] :"CODPROD"
                        //ACOLS[1][2] :"DESCPROD"
                        //ACOLS[1][3] :"UM"
                        //ACOLS[1][4] :"ARMZ ORI"
                        //ACOLS[1][5] :"END ORI" (EM BRANCO)
                        //ACOLS[1][6] :"CODPROD"
                        //ACOLS[1][7] :"DESCPROD"
                        //ACOLS[1][8] :"UM"
                        //ACOLS[1][9] :"ARMZ DEST"
                        //ACOLS[1][10]:"END DEST" (EM BRANCO)
                        //ACOLS[1][11]:"NUM SERIE" (EM BRANCO)
                        //ACOLS[1][12]:"LOTE"
                        //ACOLS[1][13]:"SUB-LOTE" (EM BRANCO)
                        //ACOLS[1][14]: 01/01/2000 (VALIDADE)
                        //ACOLS[1][15]:0 (POTENCIA SEMPRE 0)
                        //ACOLS[1][16]:0 (QUANTIDADE)
                        //ACOLS[1][17]:0 (QTD 2 UM)
                        //ACOLS[1][18]:"ESTORNADO" (EM BRANCO)
                        //ACOLS[1][19]:"SEQUENCIA" (SEQUENCIAL ++)
                        //ACOLS[1][20]:"LOTE DESTINO"
                        //ACOLS[1][21]: 01/01/2000 (VALIDADE DEST)    
                        //ACOLS[1][22]:"ITEM GRADE" (EM BRANCO)
                        //ACOLS[1][23]:"SD3"
                        //ACOLS[1][24]:0    (RECNO SEQUENCIAL ++)
                        //ACOLS[1][25]:.F.
                        //aAdd(acols, { "000013","CAFE 500 GRS","UN","01","","000013","CAFE 500 GRS","UN","02","","","111111","",CTOD("01/01/2000"),0,1,0,"",14752,"111111",CTOD("01/01/2000"),"","SD3",14752,.F. })


                        aAdd(acols, {IF( ExistCPO("SB1", "" + StrZero(val(cCodprod),6)), AvKey( StrZero(val(cCodprod),6), "B1_COD" ), "" ),;
                            Posicione('SB1', 1, FWxFilial('SB1') + StrZero(val(cCodprod),6), 'B1_DESC'),;
                            Posicione('SB1', 1, FWxFilial('SB1') + StrZero(val(cCodprod),6), 'B1_UM'),;
                            StrZero(val(cArmzOri),2),;
                            "",;
                            IF( ExistCPO("SB1", "" + StrZero(val(cCodprod),6)), AvKey( StrZero(val(cCodprod),6), "B1_COD" ), "" ),;
                            Posicione('SB1', 1, FWxFilial('SB1') + StrZero(val(cCodprod),6), 'B1_DESC'),;
                            Posicione('SB1', 1, FWxFilial('SB1') + StrZero(val(cCodprod),6), 'B1_UM'),;
                            StrZero(val(cArmzDest),2),;
                            "",;
                            "",;
                            cLote,;
                            "",;
                            CToD(cValidade),;
                            0,;
                            val(cQuantidade),;
                            0,;
                            "",;
                            "",;
                            cLote,;
                            CToD(cValidade),;
                            "",;
                            "",;
                            0,;
                            .F.})
                        
                                                        
                        cMaxSeq := cMaxSeq + 1


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

Return acols
