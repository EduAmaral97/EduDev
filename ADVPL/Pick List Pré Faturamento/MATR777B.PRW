/*

//#############################################################################
//#                  MATR777B - Pick-List de Pré Faturamento                  #
//#############################################################################
//# Módulo:         Compras					                                  #
//# Categoria:      Relatório               	                              #
//# Solicitante:    Rodrigo / Diretoria                                       #
//# Data:           13/08/2020                                                #
//# Autor:          Alexandre Lacerda                                         #
//# Observações:    Relatório em substituição MATR777.PRX	     			  #
//#############################################################################
//# Relacionamento:                                                           #
//# Variáveis Ent:  		                                                  #
//# Descrição:      Relatório de Pick-List de Pré Faturamento 		  		  #
//# 				Impresso pelo número do Pedido de Venda / produtos 	      #
//#                 liberados conforme situação tabela SC9  				  #
//#############################################################################     
*/

#INCLUDE "MATR777.ch" 
#INCLUDE 'TOPCONN.CH'

User Function MATR777B()

Local wnrel   := "MATR777"
Local tamanho := "M"
Local titulo  := OemToAnsi("PICK-LIST PRE FATURAMENTO") //"Pick-List  (Expedicao)"
Local cDesc1  := OemToAnsi(STR0002) //"Emissao de produtos a serem separados pela expedicao, para"
Local cDesc2  := OemToAnsi(STR0003) //"determinada faixa de pedidos."
Local cDesc3  := ""
Local cString := "SC9"
Local cPerg   := "MTR777"

PRIVATE aReturn  := {STR0004, 1,STR0005, 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
PRIVATE nomeprog := "MATR777B"
PRIVATE nLastKey := 0
PRIVATE nBegin   := 0
PRIVATE aLinha   := {}
PRIVATE li 		 := 80
PRIVATE limite   := 132
PRIVATE lRodape  := .F.
PRIVATE m_pag    := 1
PRIVATE lImpCab	 := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1(cPerg)
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01  De Pedido                                       ³
//³ mv_par02  Ate Pedido 		OBS: Parâmetro sem Efeito     ³
//³ mv_par03  Imprime pedidos ? 1 - Estoque                   ³
//³                             2 - Credito                   ³
//³                             3 - Estoque/Credito           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C777Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C777IMP  ³                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C777Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)

Local cFilterUser := aReturn[7]
Local lUsaLocal  := (SuperGetMV("MV_LOCALIZ") == "S")
Local cbtxt      := SPACE(10)
Local cbcont	 := 0
Local lQuery     := .F.
Local lRet       := .F.
Local cEndereco  := ""
Local nQtde      := 0
Local cAliasNew  := "SC9"

#IFDEF TOP
	Local aStruSC9   := {}
	Local cName      := ""
	Local cQryAd     := ""
	Local nX         := 0
#ELSE
	Local cFilter    := ""
	Local cKey 	     := ""
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("PICK-LIST PRE FATURAMENTO") //"PICK-LIST"
// "Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Dat.de Validade Potencia"
//            1         2         3         4         5         6         7         8         9        10        11        12        13
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//
// "Codigo    Desc. do Material                                                      Cod.Apres.         Fornecedor         	    Quant UM "
//  1234567   1234567890123456789012345678901234567890123456789012345678901234567890 123456789012345678 12345678901234567890 9.999.99 XX     
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//
//  NOVO CABECARIO
//
// "Codigo    Desc. do Material                                                         Quant UM Cod.Apres.         Fornecedor   	 Armz"
//  1234567   1234567890123456789012345678901234567890123456789012345678901234567890 9.999.99 XX 123456789012345678 12345678901234567 01      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012 
//            10        20        30        40        50        60        70        80        90        100       110       120       130

#IFDEF TOP
	cAliasNew:= GetNextAlias()
	aStruSC9 := SC9->(dbStruct())
	lQuery := .T.
	cQuery := "SELECT SC9.R_E_C_N_O_  AS SC9REC,SC9.C9_CLIENTE,SC9.C9_LOJA, "
	cQuery += "SC9.C9_PEDIDO,SC9.C9_FILIAL,SC9.C9_QTDLIB,SC9.C9_PRODUTO, SC9.C9_ITEM,"
	cQuery += "SC9.C9_LOCAL,SC9.C9_LOTECTL,SC9.C9_POTENCI,"
	cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID,SC9.C9_NFISCAL"
	If lUsaLocal
		cQuery += ",SDC.DC_LOCALIZ,SDC.DC_QUANT,SDC.DC_QTDORIG"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Esta rotina foi escrita para adicionar no select os campos do SC9 usados no filtro do usuario ³
	//³quando houver, a rotina acrecenta somente os campos que forem adicionados ao filtro testando  ³
	//³se os mesmo ja existem no selec ou se forem definidos novamente pelo o usuario no filtro.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7])
		For nX := 1 To SC9->(FCount())
			cName := SC9->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStruSC9[nX,2] <> "M"
					If !cName $ cQuery .And. !cName $ cQryAd
						cQryAd += ",SC9."+ cName
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf 
			
	cQuery += cQryAd
	cQuery += " FROM "
	cQuery += RetSqlName("SC9") + " SC9 "
	If lUsaLocal
		cQuery += "RIGHT JOIN "+RetSqlName("SDC") + " SDC "
		cQuery += "ON SDC.DC_PEDIDO=SC9.C9_PEDIDO AND SDC.DC_ITEM=SC9.C9_ITEM AND SDC.DC_SEQ=SC9.C9_SEQUEN AND SDC.D_E_L_E_T_ = ' '"
	EndIf
	cQuery += "WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
	cQuery += " AND  SC9.C9_PEDIDO >= '"+mv_par01+"'"
	cQuery += " AND  SC9.C9_PEDIDO <= '"+mv_par01+"'"
	If mv_par03 == 1 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLEST  = '  '"
	EndIf
	If mv_par03 == 2 .Or. mv_par03 == 3
		cQuery += " AND SC9.C9_BLCRED = '  '"
	EndIf
	cQuery += " AND SC9.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM "
/*
	cQuery += "ORDER BY SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_PRODUTO,SC9.C9_LOTECTL,"
	cQuery += "SC9.C9_NUMLOTE,SC9.C9_DTVALID"
*/
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
	For nX := 1 To Len(aStruSC9)
		If aStruSC9[nX][2] <> "C" .and.  FieldPos(aStruSC9[nX][1]) > 0
			TcSetField(cAliasNew,aStruSC9[nX][1],aStruSC9[nX][2],aStruSC9[nX][3],aStruSC9[nX][4])
		EndIf
	Next nX
#ELSE
	dbSelectArea(cString)
	cIndexSC9 := CriaTrab(nil,.F.)
	cKey :="C9_FILIAL+C9_PEDIDO+C9_CLIENTE+C9_LOJA+C9_PRODUTO+C9_LOTECTL+C9_NUMLOTE+DTOS(C9_DTVALID)"
	cFilter := "C9_FILIAL  = '" + xFilial("SC9") + "' .And. "
	cFilter += "C9_PEDIDO >= '"+mv_par01+"' .And. "
	cFilter += "C9_PEDIDO <= '"+mv_par01+"'"
	If mv_par03 == 1 .Or. mv_par03 == 3
		cFilter += " .And. C9_BLEST  = '  '"
	EndIf
	If mv_par03 == 2 .Or. mv_par03 == 3
		cFilter += " .And. C9_BLCRED = '  '"
	EndIf
	IndRegua(cAliasNew,cIndexSC9,cKey,,cFilter,STR0008) //"Selecionando Registros..."
	dbSetIndex(cIndexSC9+OrdBagExt())
#ENDIF
SetRegua(RecCount())
(cAliasNew)->(dbGoTop())
While (cAliasNew)->(!Eof())

	If!Empty(cFilterUser) .AND. !(&cFilterUser)
		dbSelectArea(cAliasNew)
		dbSkip()
		Loop
	EndIf

#IFDEF TOP
	If lUsaLocal
		cEndereco := (cAliasNew)->DC_LOCALIZ
		nQtde     := (cAliasNew)->DC_QUANT
	Else
		cEndereco := ""
		nQtde     := (cAliasNew)->C9_QTDLIB
	EndIf
	lRet := C777ImpDet(cAliasNew,lQuery,nQtde,cEndereco,@lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho)
#ELSE
	If lUsaLocal
		cSeek := xFilial("SDC")+(cAliasNew)->(C9_PRODUTO+C9_LOCAL+"SC6"+C9_PEDIDO+C9_ITEM+C9_SEQUEN)
		SDC->(dbGoTop())
		SDC->(dbSetOrder(1))
		SDC->(dbSeek(cSeek))
		While SDC->(!EOF()) .And. cSeek == SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ)
			cEndereco := SDC->DC_LOCALIZ
			nQtde     := SDC->DC_QUANT
			If !(lRet := C777ImpDet(cAliasNew,lQuery,nQtde,cEndereco,@lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho))
				Exit
			EndIf
			SDC->(dbSkip())
		EndDo
	Else
		lRet := C777ImpDet(cAliasNew,lQuery,(cAliasNew)->C9_QTDLIB,"",@lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho)
	EndIf
#ENDIF
	If !lRet
		Exit
	EndIf
	(cAliasNew)->(dbSkip())
EndDo

If lRodape
	roda(cbcont,cbtxt,"M")
EndIf

If lQuery
	dbSelectArea(cAliasNew)
	dbCloseArea()
	dbSelectArea("SC9")
Else
	RetIndex("SC9")
	Ferase(cIndexSC9+OrdBagExt())
	dbSelectArea("SC9")
	dbClearFilter()
	dbSetOrder(1)
	dbGotop()
EndIf

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return NIL


Static Function C777ImpDet(cAliasNew, lQuery,nQtde,cEndereco,lEnd,titulo,cDesc1,cDesc2,cDesc3,tamanho)


//Local cabec1 	:= OemToAnsi(STR0006) //"Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Validade   Potencia    Pedido"
Local cabec1 	:= OemToAnsi("Codigo    Descricao do Produto                                                      Quant UM Cod.Apres.         Fornecedor   	 Armz")
Local cabec2 	:= ""

Local cCodCli := ""
Local cRazCli := ""
Local cCidCli := ""
Local cUF_Cli := ""
Local cClient := ""

Local cCodFor := ""
Local cRazFor := ""
Local cCidFor := ""
Local cUF_For := ""
Local cFornec := ""
Local cNomFor := ""

Local cTipDoc := POSICIONE("SC5",1,XFILIAL("SC5")+(cAliasNew)->C9_PEDIDO,"C5_TIPO")
//Local cCodTrp := POSICIONE("SC5",1,XFILIAL("SC5")+(cAliasNew)->C9_PEDIDO,"C5_TRANSP")
//Local cTransp := cCodTrp + "-" + POSICIONE("SA4",1,XFILIAL("SA4")+cCodTrp,"A4_NREDUZ")
//Local cTrpDDD := STRZERO(VAL(TRIM(POSICIONE("SA4",1,XFILIAL("SA4")+cCodTrp,"A4_DDD"))),2)
//Local cTrpTel := POSICIONE("SA4",1,XFILIAL("SA4")+cCodTrp,"A4_TEL")
//Local cTrpCon := POSICIONE("SA4",1,XFILIAL("SA4")+cCodTrp,"A4_CONTATO")

	local cQuery2 := ""
	local cQuery3 := ""
	local cQuery4 := ""
	Local TipoExpedicao :=""
	Local MontadorPainel :=""

local cQuery1 := "SELECT L1_FILIAL, L1_NUM, L1_NUMATEN, L1_FILRES FROM SL1010 WHERE D_E_L_E_T_ = '' AND L1_FILIAL = '" +xFilial("SC9")+  "' AND L1_PEDRES = '"+mv_par01+"'"
If Select("AliasVD") > 0
     dbSelectArea("AliasVD")
     dbCloseArea()
EndIf
TcQuery cQuery1 New Alias AliasVD
dbSelectArea("AliasVD")


cQuery2 := "SELECT UA_FILIAL, UA_NUM,  UA_ZPRDMLT, UA_ZPRDRIB, UA_ZMONTAG, UA_ZPLOTAG, UA_ZMONTPN, UA_ZCRTPNL, UA_ZCODFRT, UA_VEND FROM SUA010 WHERE D_E_L_E_T_ = '' AND UA_FILIAL = '"+AliasVD->L1_FILRES+"' AND UA_NUM = '"+AliasVD->L1_NUMATEN+"'"
If Select("AliasUA") > 0
     dbSelectArea("AliasUA")
     dbCloseArea()
EndIf
TcQuery cQuery2 New Alias AliasUA
dbSelectArea("AliasUA")


cQuery3 := "SELECT A4_COD, A4_NOME FROM SA4010 WHERE D_E_L_E_T_ = '' AND A4_COD = '"+ AliasUA->UA_VEND +"' "
If Select("AliasA4") > 0
     dbSelectArea("AliasA4")
     dbCloseArea()
EndIf
TcQuery cQuery3 New Alias AliasA4
dbSelectArea("AliasA4")


cQuery4 := "SELECT A3_COD, A3_NOME FROM SA3010 WHERE D_E_L_E_T_ = '' AND A3_COD = '"+ AliasUA->UA_VEND +"'"
If Select("AliasA3") > 0
     dbSelectArea("AliasA3")
     dbCloseArea()
EndIf
TcQuery cQuery4 New Alias AliasA3
dbSelectArea("AliasA3")



	If AliasUA->UA_ZCODFRT = "000001"
		TipoExpedicao := "ZANOTTI REFRIGERAÇÃO"
	elseif AliasUA->UA_ZCODFRT = "000002"
		TipoExpedicao := "Cliente Retira"
	elseif AliasUA->UA_ZCODFRT = "000003"
		TipoExpedicao := "Cliente Retira"
	elseif AliasUA->UA_ZCODFRT >= "000004"
		TipoExpedicao := "Transportadora"
	elseif AliasUA->UA_ZCODFRT = ""
		TipoExpedicao := ""
	EndIf

	If AliasUA->UA_ZMONTPN = "Z"
		MontadorPainel := "Venda Zanotti"
	elseif AliasUA->UA_ZMONTPN = "P"
		MontadorPainel := "Parceiro"
	elseif AliasUA->UA_ZMONTPN = "R"
		MontadorPainel := "Responsavel Cliente"
	elseif AliasUA->UA_ZMONTPN = ""
		MontadorPainel := ""
	EndIf


Static lFirst 	:= .T.

If lEnd
	@PROW()+1,001 Psay STR0009 //"CANCELADO PELO OPERADOR"
	Return .F.
EndIf

If !lQuery
	IncRegua()
EndIf

If li > 55 .or. lFirst

	lFirst  := .F.
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	lRodape := .T.
		
	If lImpCab
		
		lImpCab := .F.
		
		// Aqui imprime os resultados no relatorio	
		@ li,01 Psay "Pedido: " + (cAliasNew)->C9_PEDIDO
		li  := li+2
		@ li,01 Psay "Atendimento: " + AliasVD->L1_NUMATEN
		li  := li+1
		@ li,01 Psay "Vendedor: " + AliasA3->A3_NOME
		li  := li+1
		@ li,01 Psay "Tipo de Expedição: " + TipoExpedicao
		li  := li+1
		@ li,01 Psay "Multifrio: " + AliasUA->UA_ZPRDMLT
		@ li,21 Psay "Montagem: " + AliasUA->UA_ZMONTAG
		@ li,41 Psay "Corte Painel: " + AliasUA->UA_ZCRTPNL
		li  := li+1
		@ li,01 Psay "Metalrib: " + AliasUA->UA_ZPRDRIB
		@ li,21 Psay "Plotagem: " + AliasUA->UA_ZPLOTAG
		@ li,41 Psay "Montagem Painel: " + MontadorPainel
		li  := li+2


		AliasVD->(dbCloseArea()) //Fecha a área de trabalho
		AliasUA->(dbCloseArea()) //Fecha a área de trabalho



		IF cTipDoc <> "N"
			cCodFor := POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A2_COD")
			cRazFor := POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A2_NOME")
			cCidFor := POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A2_MUN")
			cUF_For := POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A2_EST")
			cFornec := cRazFor+" "+cCodFor+SPACE(10)+TRIM(cCidFor)+"/"+cUF_For
			@ li,00 Psay "Fornecedor: " + cFornec
		ELSE
			cCodCli := POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A1_COD")
			cRazCli := POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A1_NOME")
			cCidCli := POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A1_MUN")
			cUF_Cli := POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasNew)->C9_CLIENTE+(cAliasNew)->C9_LOJA,"A1_EST")
			cClient := cRazCli+" "+cCodCli+SPACE(10)+TRIM(cCidCli)+"/"+cUF_Cli
			@ li,00 Psay "Cliente: " + cClient
		ENDIF
		
		li++
		//@ li, 00 Psay "Transportadora: " + cTransp + SPACE(10) + "Fone: (" + cTrpDDD + ") " + cTrpTel + SPACE(06) + "Contato: " + cTrpCon
		@ li, 00 Psay "Transportadora: " + AliasA4->A4_NOME
		AliasA4->(dbCloseArea()) //Fecha a área de trabalho	
		li  := li+2
		
	EndIf
	
EndIf

SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C9_PRODUTO)) 
cNomFor := POSICIONE("SA2",1,XFILIAL("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC,"A2_NREDUZ")

@ li, 00 Psay (cAliasNew)->C9_PRODUTO		Picture "@!"
@ li, 10 Psay Subs(SB1->B1_ZDESRDZ,1,58)	Picture "@!"
@ li, 81 Psay nQtde							Picture "@E 9,999.99"
@ li, 90 Psay SB1->B1_UM   					Picture "@!"
@ li, 93 Psay Subs(SB1->B1_ZAPRES1,1,18)	Picture "@!"
@ li,112 Psay Subs(cNomFor,1,17)			Picture "@!"
@ li,130 Psay (cAliasNew)->C9_LOCAL			Picture "@!"
li++

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1(cPerg)

Local aHelpPor01 := {"Informe o numero do pedido inicial a ser ",    "considerado na selecao."}
Local aHelpEng01 := {"Enter the initial order number to be taken in","consideration."}
Local aHelpSpa01 := {"Digite el numero del pedido inicial que debe ","considerarse en la seleccion."}
Local aHelpPor02 := {"Informe o numero do pedido final a ser ",    "considerado na selecao."}
Local aHelpEng02 := {"Enter the final order number to be taken in","consideration."}
Local aHelpSpa02 := {"Digite el numero del pedido final que debe ","considerarse en la seleccion."}
Local aHelpPor03 := {"Seleciona a condicao do pedido de compras a",    "ser impressa."}
Local aHelpEng03 := {"Select the purchase order terms to print.",      ""}
Local aHelpSpa03 := {"Elija la condicion del pedido de compras que se","debe imprimir."}

PutSX1(cPerg,"01","De pedido ?",       "¿De pedido ?",       "From order ?","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","",      "","","","","","","","","","","","",aHelpPor01,aHelpEng01,aHelpSpa01)
PutSX1(cPerg,"02","Ate pedido ?",      "¿A pedido ?",        "To order ?",  "mv_ch2","C",6,0,0,"G","","","","","mv_par02","","","","zzzzzz","","","","","","","","","","","","",aHelpPor02,aHelpEng02,aHelpSpa02)
PutSX1(cPerg,"03","Pedidos liberados?","¿Pedidos Aprobados?","orders ?",    "mv_ch3","N",1,0,3,"C","","","","","mv_par03","Estoque","Stock","Inventory","","Credito","Credito","Credit","Credito/Estoque","Credito/Stock","Credit/Invent.","","","","","","",aHelpPor03,aHelpEng03,aHelpSpa03)

Return
