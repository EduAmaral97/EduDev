#include 'protheus.ch'
#include 'topconn.ch'


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para executar de forma rapida e simples updates em SQL direto do protheus.

------------------------------------------------------------------------------- */


user function UPDATEMEDICAR()

    Local cQuery := ""

    DEFINE MSDIALOG oDlg FROM 05,10 TO 400,650 TITLE "SQL EXEC - MEDICAR " PIXEL

        @ 010,020 TO 180,300 LABEL " Sql Exec " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Query: "                    SIZE 070, 020 OF oDlg PIXEL
        @ 020,050 GET OMEMO VAR cQuery MEMO                              SIZE 200,150 PIXEL OF oDlg

        @ 025,260  BUTTON oBtn1 PROMPT "Executar"                        SIZE 030,011   ACTION (execupdatesqlmedicar(cQuery)) OF oDlg PIXEL
        @ 040,260  BUTTON oBtn1 PROMPT "Exportar"                        SIZE 030,011   ACTION (exportexcel(cQuery,oDlg)) OF oDlg PIXEL
        @ 055,260  BUTTON oBtn1 PROMPT "Sair"                            SIZE 030,011   ACTION (oDlg:End()) OF oDlg PIXEL

    ACTIVATE MSDIALOG oDlg CENTER

return


Static function execupdatesqlmedicar(cQuery)

    //MsgAlert(cQuery)

    Begin Transaction

        //Tenta executar o update
        nErro := TcSqlExec(cQuery)

        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            //ABORTA O UPDATE
            DisarmTransaction()
        Else
            MsgInfo("Query executado com sucesso", "SQL Exec Medicar")            
        EndIf

    End Transaction

return


Static Function exportexcel(cQuery,oDlg)


    MsAguarde({||MontaRel(cQuery)},"Aguarde","Exportando os dados...")

    MsgInfo("Dados Exportados com Sucesso.")

    oDlg:End()


Return


Static Function MontaRel(cQuery)

    Local nAtual
    Local nAtualDados
    Local nCol
    Local aDados := {}
	Private cAlias := GetNextAlias()


    TCSqlToArr(cQuery,aDados)


    //Criar alias tempor�rio
	TCQUERY cQuery NEW ALIAS (cAlias)

	DbSelectArea(cAlias)
    nCol := (cAlias)->(FCount())


    IF (cAlias)->(Eof())

        MsgInfo("N�o h� dados, opera��o finalizada", "Exportar em Dados SQL - Excel")
        
        (cAlias)->(DbCloseArea())

    ELSE

    	oExcel := FwMsExcelXlsx():New()
        lRet := oExcel:IsWorkSheet("EXECSQL")
        oExcel:AddworkSheet("EXECSQL")
        oExcel:AddTable ("EXECSQL","DADOS",.F.)


        //CRIA AS COLUNAS DO EXCEL
        For nAtual := 1 To nCol
            
            oExcel:AddColumn("EXECSQL","DADOS", Field( nAtual ),		,1,1,.F., "")
            
        Next

        
        // Adiciona os dados do excel
        For nAtualDados := 1 To Len(aDados)

            oExcel:AddRow("EXECSQL","DADOS",  aDados[nAtualDados]  )
            
        Next


        oExcel:SetFont("Calibri")
        oExcel:SetFontSize(11)
        oExcel:SetItalic(.F.)
        oExcel:SetBold(.F.)
        oExcel:SetUnderline(.F.)
        oExcel:Activate()

        cArqBem := fPegaDir() + '\' + 'dadosexp' + SubStr( DTOC(Date()),1,2 ) + SubStr( DTOC(Date()),4,2 ) + SubStr( DTOC(Date()),7,4 ) + '.xlsx'
        
        oExcel:GetXMLFile(cArqBem)
        oExcel:DeActivate()
        
        (cAlias)->(DbCloseArea())

    ENDIF


Return


Static Function fPegaDir()

	Local cPasta := ""  
    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Sele��o de Pasta para Salvar arquivo"
    Local lSalvar := .F.
 

	/* ---------------------------- DIRETORIO SALVAR ---------------------------- */


    //Se n�o estiver sendo executado via job
    If ! IsBlind()
 
        //Chama a fun��o para buscar arquivos
        cPasta := tFileDialog(;
            cTipArq,;                  // Filtragem de tipos de arquivos que ser�o selecionados
            cTitulo,;                  // T�tulo da Janela para sele��o dos arquivos
            ,;                         // Compatibilidade
            cDirIni,;                  // Diret�rio inicial da busca de arquivos
            lSalvar,;                  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
            GETF_RETDIRECTORY;         // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
        )
 
    EndIf 

Return (cPasta)
