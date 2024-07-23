#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"
#INCLUDE "PRTOPDEF.CH"


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 19/07/2024
Objetivo: Rotina desenvolvida para importar novos cadastro de produtos

------------------------------------------------------------------------------- */

//Posições do Array
Static nPosCodprod      := 1 
Static nPosArmzOri      := 2 
Static nPosArmzDest     := 3 
Static nPosQuantidade   := 4
Static nPosLote         := 5 
Static nPosValidade     := 6 


User function ZIMPPROD()
    
    Local aArea    := GetArea()
    Private cArqOri := ""

    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
    
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
        
        //Somente se existir o arquivo e for com a extensão CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando Produtos...")
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
    Local cCodprod      := ""
    Local cArmzOri      := ""
    Local cArmzDest     := ""
    Local cQuantidade   := ""
    Local cLote         := ""
    Local cValidade     := ""
    Local oModel        := FWLoadModel("MATA010")
    Local nOperation    := 3
    Local aFields       := {}

    Private cDirLog     := GetTempPath() + "x_importacao\"
    Private cLog        := ""




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

                        //PEGA O PROXIMO CODIGO DE PRODUTO DISPONIVEL
                        cCodProd := BTS->(GetSx8Num("SB1","B1_COD"))
                        
                        //ADICIONA OS CAMPOS QUE VAMOS INSERIR NO CADASTRO
                        aAdd(aFields, {"B1_COD", cCodProd, Nil})
                        aAdd(aFields, {"B1_COD", cCod, Nil})
                        aAdd(aFields, {"B1_COD", cCod, Nil})


                        //EXECUTA A INCLUSAO VIA EXECAUTO
                        FWMVCRotAuto(oModel, "SB1", nOperation, {{"SB1MASTER", aFields}} ,,.T.)

                        ConfirmSX8()   
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

Return

