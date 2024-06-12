#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRCLI

	Relatorio: Pedido de compras Modelo 2 (Eduardo)

/*/
User Function ZNTPEDCOMP2()

//VARIAVEIS
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := "PEDCOM2"

//Função que cria as perguntas/filtros que iremos usar no relatório, na SX1
ValidPerg()

//Função responsável por chamar a pergunta criada na função ValidaPerg, a variável PRIVATE cPerg, é passada.
Pergunte(cPerg,.F.)

//CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
ReportDef()
oReport:PrintDialog()

Return 

/*/{Protheus.doc} ReportDef
Função responsável por estruturar as seções e campos que darão forma ao relatório, bem como outras características.
Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport(): New("PEDCOM2","Relatório - Pedido de Compras Modelo 2",cPerg,{|oReport| PrintReport(oReport)},"Relatorio Pedido de Compras")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELATÓRIO SERÁ EM PAISAGEM

//TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
oSecCab := TRSection(): New( oReport , "Pedido de Compras", {"SQL"} )

/*
TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/
TRCell():New( oSecCab, "SC7.C7_NUM"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_ITEM"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_FILENT"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_VALFRE"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_UM"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_OP"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_QUANT"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_PRODUTO"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_FORNECE"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_LOJA"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DESCRI"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_PRECO"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_TOTAL"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_TOTAL"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_EMISSAO"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DATPRF"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_IPI"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DESC1"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DESC2"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DESC3"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_VLDESC"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_BASEICM"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_BASEIPI"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_VALIPI"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_VALICM"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DT_EMB"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_TOTAL"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_CODTAB"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_SEGURO"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_DESPESA"     , "SQL")
TRCell():New( oSecCab, "SC7.C7_ICMSRET"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_COD"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_NOME"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_END"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_EST"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_MUN"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_CEP"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_CGC"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_INSCR"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_TEL"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_FAX"     , "SQL")
TRCell():New( oSecCab, "SA2.A2_DDD"     , "SQL")
TRCell():New( oSecCab, "SA5.A5_CODPRF"   , "SQL")
TRCell():New( oSecCab, "SB1.B1_DESC"     , "SQL")


//ESTA LINHA IRÁ CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATÓRIO PARA A ÚNICA SEÇÃO QUE TEMOS
TRFunction():New(oSecCab:Cell("SC7.C7_ITEM"),,"COUNT"     ,,,,,.F.,.T.,.F.,oSecCab)

Return 

/*/{Protheus.doc} PrintReport
Nesta função é inserida a querie utilizada para exibição dos dados;
A função de PERGUNTAS  é chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
//VARIÁVEL responsável por armazenar o Alias que será utilizado pela querie 
Local cAlias := GetNextAlias()

//INICIO DA QUERY
BeginSql Alias cAlias

SELECT DISTINCT TOP 1
SC7.C7_NUM,SC7.C7_ITEM,SC7.C7_FILENT, SC7.C7_VALFRE, SC7.C7_UM, SC7.C7_OP, 
SC7.C7_QUANT, SC7.C7_PRODUTO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_DESCRI, SC7.C7_PRECO, 
SC7.C7_TOTAL, SC7.C7_EMISSAO, SC7.C7_DATPRF, SC7.C7_IPI, SC7.C7_DESC1, 
SC7.C7_DESC2, SC7.C7_DESC3, SC7.C7_VLDESC, SC7.C7_BASEICM, SC7.C7_BASEIPI, SC7.C7_VALIPI, 
SC7.C7_VALICM,SC7.C7_DT_EMB, SC7.C7_TOTAL, SC7.C7_CODTAB, SC7.C7_SEGURO, SC7.C7_DESPESA, SC7.C7_ICMSRET, 
SA2.A2_COD, SA2.A2_NOME, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP, 
SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SA5.A5_CODPRF, SB1.B1_DESC 
FROM  %table:SC7%  SC7  
INNER JOIN  %table:SA2% SA2 ON SC7.C7_FORNECE =  SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ <> '*'  
LEFT JOIN   %table:SA5% SA5 ON SC7.C7_PRODUTO =  SA5.A5_PRODUTO AND SC7.C7_FORNECE =  SA5.A5_FORNECE AND SC7.C7_LOJA = SA5.A5_LOJA  AND SA5.D_E_L_E_T_ <> '*'  
INNER JOIN  %table:SB1% SB1 ON SC7.C7_PRODUTO =  SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*'  
WHERE SC7.C7_FILIAL = "'"+ xFilial( SC7 ) + "'" 
AND SC7.C7_FORNECE BETWEEN  %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% 
AND SC7.C7_LOJA    BETWEEN  %exp:(MV_PAR05)% AND %exp:(MV_PAR06)% 
AND SC7.C7_NUM     BETWEEN  %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% 
AND SC7.C7_EMISSAO BETWEEN  %exp:(MV_PAR07)% AND %exp:(MV_PAR07)%   
AND SC7.D_E_L_E_T_ <> '*'  

	//OBSERVE QUE O CAMPO A1_TIPO NÃO SERÁ LISTADO NO RELATÓRIO

//FIM DA QUERY
EndSql


oSecCab:BeginQuery() //Relatório começa a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias}) //Recebe a querie e constrói o relatório
oSecCab:Print() //É dada a ordem de impressão, visto os filtros selecionados

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 


/*/{Protheus.doc} ValidPerg
FUNÇÃO RESPONSÁVEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j


	aadd( aRegs, { cPerg,"01","Fornecedor de ?","Fornecedor de ?","Fornecedor de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"          } )
	aadd( aRegs, { cPerg,"02","Fornecedor ate ?","Fornecedor ate ?","Fornecedor ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Pedido de ?","Pedido de ?","Pedido de ?","mv_ch3","C", 6,0,0,"G","","mv_par03","","","mv_par03"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Pedido ate ?","Pedido ate ?","Pedido ate ?","mv_ch4","C", 6,0,0,"G","","mv_par04","","","mv_par04"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Loja de ?","Loja de ?","Loja de ?","mv_ch5","C", 6,0,0,"G","","mv_par05","","","mv_par05"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Loja ate ?","Loja ate ?","Loja ate ?","mv_ch6","C", 6,0,0,"G","","mv_par06","","","mv_par06"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Data Emissao de ?","Data Emissao de ?","Data Emissao de ?","mv_ch7","D", 6,0,0,"G","","mv_par07","","","mv_par07"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )
	aadd( aRegs, { cPerg,"02","Data Emissao ate ?","Data Emissao ate ?","Data Emissao ate ?","mv_ch8","D", 6,0,0,"G","","mv_par08","","","mv_par08"," ","",""," ","","","","","","","","","","","","","","","","","","SC7"       } )



	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)
