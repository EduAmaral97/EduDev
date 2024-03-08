//Bibliotecas
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

User Function RELATSQLEXCEL()

	Local cPasta := ""   

/* ---------------------------- DIRETORIO SALVAR ---------------------------- */

    Local cDirIni := GetTempPath()
    Local cTipArq := ""
    Local cTitulo := "Sele��o de Pasta para Salvar arquivo"
    Local lSalvar := .F.
    //Local cPasta  := ""
 
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
	
	 cPasta := cPasta + '\'


/* ---------------------------- ARQUIVO EXCEL ---------------------------- */

	oExcel := FwMsExcelXlsx():New()

	lRet := oExcel:IsWorkSheet("WorkSheet1")
	oExcel:AddworkSheet("WorkSheet1")

	lRet := oExcel:IsWorkSheet("PLANILHA1")
	oExcel:AddTable ("WorkSheet1","TABELA TESTE")
	oExcel:AddColumn("WorkSheet1","TABELA TESTE","COLUNA 1",1,1,.F., "999.9")
	oExcel:AddColumn("WorkSheet1","TABELA TESTE","COLUNA 2",2,2,.F., "999.99")

	oExcel:AddRow("WorkSheet1","Table1",{"DADOS COLUNA 1","DADOS COLUNA 2"})

	oExcel:SetFont("arial")
	oExcel:SetFontSize(20)
	oExcel:SetItalic(.T.)
	oExcel:SetBold(.T.)
	oExcel:SetUnderline(.T.)


	oExcel:Activate()

	oExcel:GetXMLFile(cPasta + "arquivoedu.xlsx")

	oExcel:DeActivate()

Return

