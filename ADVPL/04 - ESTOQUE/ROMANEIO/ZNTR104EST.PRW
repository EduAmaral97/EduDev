#INCLUDE "rwmake.ch"
#INCLUDE 'TOPCONN.CH'

//  Funcao: APRSF203()
//  Finalidade: EmissЦo de Romaneio
//  Autor: Alexandre Lacerda / Ailton Minelli
//  Data: 05/2003
//
//  Atualizada em 06/2004
//  Autores: Alexandre Lacerda / Ailton Minelli

User Function ZNTR104EST(par01,par02,par03,par04)                 // EmissЦo de Romaneio
 
  Local cDesc1         	:= ""
  Local cDesc2         	:= "Relatorio de Romaneio"
  Local cDesc3         	:= ""
  //Local cPict          	:= ""
  Local titulo       	:= "Emissao de Romaneio"
  Local nLin         	:= 80
  //Local Cabec1       	:= ""
  //Local Cabec2       	:= ""
  //Local imprime      	:= .T.
  Local aOrd 			   := {}
  local cQuery1         := ""
  local TipoExpedicao   := ""
  
  LOCAL cDrive          := GetMv("MV_DRIVER")
  LOCAL cNomeImp        := GetMv("MV_PORTROM")
  LOCAL lServer         := .F.                            
*
  Private Achou         := .f.
  Private lEnd         	:= .F.
  Private lAbortPrint  	:= .F.
  Private CbTxt        	:= ""
  Private limite       	:= 80
  Private tamanho      	:= "P"
  Private nomeprog     	:= "ZNTR104EST"
  Private nTipo        	:= 18                                       
  Private aReturn      	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     	:= 0
 //Private cbtxt      	:= Space(10)
  Private cbcont     	:= 00
  Private CONTFL     	:= 01
  Private m_pag      	:= 01
  Private wnrel      	:= "ZNTR104EST"   	// Coloque aqui o nome do arquivo usado para impressao em disco
  Private cNExibJanImp  := ".F."     		// .f. valor padrЦo nЦo abre Janela de ImpressЦo

//  Private par01      	:= "000078"  // mv_par01 // DOC INICIAL
//  Private par02      	:= "000078"  // mv_par02 // DOC FINAL
//  Private par03      	:= "UNI"     // mv_par03 // SERIE
//  Private par04      	:= 2         // mv_par04 // TIPO E/S  1/2   

  Private cString 		:= "SF2"  
  Private cPerg         :="ZNTR104EST"
  Private TotItn        := 0          // Total de Itens
  Private TotQtd        := 0          // Total Quantidades

  Private cCodFil := SM0->M0_CODFIL   // Filial Corrente p/ Faturamento 
  Private cNomFil := SM0->M0_FILIAL   // Nome da Filial Faturamento
  
// SetPrvt("mv_par01,mv_par02,mv_par03,mv_par04")
  
  PUBLIC mv_par01
  PUBLIC mv_par02
  PUBLIC mv_par03
  PUBLIC mv_par04
  
  If FunName() = "MATA310"
     MSGALERT("SAINDO IMPRESSAO ROMANEIO !... ","ZNTR104EST")
    RETURN(.F.)
 ENDIF
  
  SET CENTURY On  
  SetPgEject(.F.) 		 // NЦo Permite AvanГo do FormulАrio                             
  MS_FLUSH()             // Prepara Ambiente de ImpressЦo
  
  dbSelectArea("SA1")
  dbSetOrder(1)         


  //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  //Ё Monta a interface padrao com o usuario...                           Ё
  //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
       
 // Pergunte(cPerg,.T.)                     // Pergunta no SX1
             
IF PAR01 = Nil   
   IF (Pergunte(cPerg,.T.)) = .F.   // Pergunta no SX1 
      RETURN
   ELSEIF MV_PAR04=1  
      ALERT(" ERRO! NцO EXISTE ROMAMEIO P/ NF DE ENTRADA ")
      RETURN
   ELSE   
//    mv_par03:=IIF(MV_PAR03=1,"001","RP")      // "UNI" ou "RP"
   ENDIF
//   cNExibJanImp:=GetMv("MV_PORTROM")
ENDIF
/*                    
//Itens da Nota Fiscal contem TES=890 NЦo Imprimir
  vTot890:=0
  dbselectArea("SD2")
  COUNT TO vTot890 FOR SD2->D2_DOC >= mv_par01 .AND. SD2->D2_DOC <= mv_par02 .AND. SD2->D2_SERIE = mv_par03 .AND. SD2->D2_TES="890"

  IF vTot890<>0
     Alert( " ATENгцO! Documento solicitado c/ TES 890 s/PermissЦo de ImpressЦo de ROMANEIO. ")
     RETURN
  ENDIF   
*/

// wnrel:=SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,nil,nil,nil,cDrive,.T.,lServer,cNomeImp)
   wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.t.,aOrd,.F.,Tamanho,nil,nil,nil,cDrive,&cNExibJanImp,lServer,cNomeImp)  

  If nLastKey == 27
	Return
  Endif

  SetDefault(aReturn,cString)

  If nLastKey == 27
     Return
  Endif

  nTipo := If(aReturn[4]==1,15,18)

  //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  //Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
  //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
VerImp()

#IFDEF WINDOWS
  RptStatus({|| RptDetail()})         // Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})	
  Return
  Static Function RptDetail()
#ENDIF  
*/

//  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,1) },Titulo)
//  Return

//  Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//  Local nOrdem

  dbSelectArea("SF2") //Cabecalho da NF
  dbSetOrder(1)                                

  dbseek(xFilial("SF2")+MV_PAR01+MV_PAR03,.T.)
  
  //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  //Ё SETREGUA -> Indica quantos registros serao processados para a regua Ё
  //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//  SetRegua(RecCount())
/*
  Set Printer to &wnrel
  Set Printer On
  Set Device  to Printer

  SETPRC(0,0)
*/
   
  Do While !eof() .and. TRIM(SF2->F2_DOC) >= TRIM(MV_PAR01) .and. TRIM(SF2->F2_DOC) <= TRIM(MV_PAR02) .and. SF2->F2_SERIE = MV_PAR03
         
     // incregua()
     
     If lAbortPrint
        nLin++
        @ nLin,10 PSAY "* * *   C A N C E L A D O   P E L O   O P E R A D O R  * * * "
        Exit
     Else
        Achou = .t.
     Endif
     
     IF SF2->F2_TIPO = "N" .OR. SF2->F2_TIPO = "C" .OR. SF2->F2_TIPO = "P" .OR. SF2->F2_TIPO = "I" .OR. SF2->F2_TIPO = "S" .OR. SF2->F2_TIPO = "T" .OR. SF2->F2_TIPO = "O" 
     
        //Arquivo de Cliente

        DbSelectArea("SA1")
        DbSetOrder(1)
        dbSeek(xfilial()+SF2->F2_CLIENTE)

        xCod     = SA1->A1_COD
        xNome    = SA1->A1_NOME
        xEnd     = SA1->A1_END
        xBairro  = SA1->A1_BAIRRO
        xMun     = SA1->A1_MUN
        xEst     = SA1->A1_EST
        xCEP     = SA1->A1_MUN

     ELSE
  
        DbSelectArea("SA2")
        DbSetOrder(1)
        dbSeek(xfilial()+SF2->F2_CLIENTE)

        xCod     = SA2->A2_COD
        xNome    = SA2->A2_NOME
        xEnd     = SA2->A2_END
        xBairro  = SA2->A2_BAIRRO
        xMun     = SA2->A2_MUN
        xEst     = SA2->A2_EST
        xCEP     = SA2->A2_MUN

     ENDIF

     //if dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
     
        //Arquivo de Transportadora
          dbselectarea("SA4")
          dbsetorder(1)
          dbseek(xFilial("SA4")+SF2->F2_TRANSP)
          
          //Arquivo de Vendedores
          dbselectarea("SA3")
          dbsetorder(1)
          dbseek(xFilial("SA3")+SF2->F2_VEND1)
     
         //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё AdiГЦo de campos do Callcenter | Por: Eduardo Jorge                  Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды 

      cQuery1 := "SELECT SF2.F2_FILIAL, SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_CLIENTE, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_NUM WHEN SUA.UA_NUM <> '' THEN SUA.UA_NUM ELSE '' END AS ATENDIMENTO, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZPRDMLT WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZPRDMLT ELSE '' END AS PROD_MULTI, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZPRDRIB WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZPRDRIB ELSE '' END AS PROD_RIB, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZMONTAG WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZMONTAG ELSE '' END AS MONTAGEM, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZPLOTAG WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZPLOTAG ELSE '' END AS PLOTAGEM, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZCRTPNL WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZCRTPNL ELSE '' END AS CORTE_PAINEL, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZMONTPN WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZMONTPN ELSE '' END AS MONTADOR_PAINEL, CASE WHEN SUA501.UA_NUM <> '' THEN SUA501.UA_ZCODFRT WHEN SUA.UA_NUM <> '' THEN SUA.UA_ZCODFRT ELSE '' END AS TRANSPORTE, CASE WHEN SUA501.UA_NUM <> '' THEN SA4501.A4_NOME WHEN SUA.UA_NUM <> '' THEN SA4.A4_NOME ELSE '' END AS TRANSPORTADOR FROM SF2010 SF2  LEFT JOIN SC9010 SC9 ON SC9.D_E_L_E_T_ = '' AND SC9.C9_FILIAL = SF2.F2_FILIAL AND SC9.C9_SERIENF = SF2.F2_SERIE AND SC9.C9_NFISCAL = SF2.F2_DOC LEFT JOIN SL1010 SL1 ON SL1.D_E_L_E_T_ = '' AND SL1.L1_FILIAL = SC9.C9_FILIAL AND SL1.L1_PEDRES = SC9.C9_PEDIDO AND SL1.L1_ORCRES <> '' LEFT JOIN SUA010 SUA ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = SL1.L1_FILRES AND SUA.UA_NUM = SL1.L1_NUMATEN LEFT JOIN SL1010 SL1501 ON SL1501.D_E_L_E_T_ = '' AND SL1501.L1_FILIAL = SF2.F2_FILIAL AND SL1501.L1_SERIE = SF2.F2_SERIE AND SL1501.L1_DOC = SF2.F2_DOC AND SL1501.L1_ORCRES = '' LEFT JOIN SUA010 SUA501 ON SUA501.D_E_L_E_T_ = '' AND SUA501.UA_FILIAL = SL1501.L1_FILIAL AND SUA501.UA_NUM = SL1501.L1_NUMATEN LEFT JOIN SA4010 SA4501 ON SA4501.D_E_L_E_T_ = '' AND SA4501.A4_COD = SUA501.UA_ZCODFRT LEFT JOIN SA4010 SA4 ON SA4.D_E_L_E_T_ = '' AND SA4.A4_COD = SUA.UA_ZCODFRT WHERE 1=1 AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '"+ xFilial("SF2") +"' AND SF2.F2_SERIE = '"+ mv_par03 +"'  AND SF2.F2_DOC BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' GROUP BY  SF2.F2_FILIAL, SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_CLIENTE, SUA.UA_NUM, SUA501.UA_NUM, SUA501.UA_ZPRDMLT, SUA501.UA_ZPRDRIB, SUA501.UA_ZMONTAG, SUA501.UA_ZPLOTAG, SUA501.UA_ZCRTPNL, SUA501.UA_ZMONTPN, SUA501.UA_ZCODFRT, SUA.UA_ZPRDMLT, SUA.UA_ZPRDRIB, SUA.UA_ZMONTAG, SUA.UA_ZPLOTAG, SUA.UA_ZCRTPNL, SUA.UA_ZMONTPN, SUA.UA_ZCODFRT, SA4501.A4_NOME, SA4.A4_NOME "
 
      If Select("AliasUA") > 0
         dbSelectArea("AliasUA")
         dbCloseArea()
      EndIf
      TcQuery cQuery1 New Alias AliasUA
      dbSelectArea("AliasUA")  

  	If AliasUA->TRANSPORTE = "000001"
		TipoExpedicao := "ZANOTTI REFRIGERAгцO"
	elseif AliasUA->TRANSPORTE = "000002"
		TipoExpedicao := "Cliente Retira"
	elseif AliasUA->TRANSPORTE = "000003"
		TipoExpedicao := "Cliente Retira"
	elseif AliasUA->TRANSPORTE >= "000004"
		TipoExpedicao := "Transportadora"
	elseif AliasUA->TRANSPORTE = ""
		TipoExpedicao := ""
	EndIf



        //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        //Ё Impressao do cabecalho do relatorio. . .                            Ё
        //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        
        If nLin > 50               // Salto de PАgina. Neste caso o formulario tem 55 linhas...
                                   // Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo
             nLin=1       
             @ nlin,000 PSAY CHR(27)+CHR(120)+"0"  // Estilo de ImpressЦo 0-Draft  1-NQL         
             @ nLin,000 psay CHR(27)+CHR(69)
	         @ nLin,000 psay SM0->M0_FILIAL                         
//           @ nLin,000 psay "REFRIZA" 
//           @ nLin,031 psay "Fone: " + SM0->M0_TEL
             @ nLin,061 psay "AP12     Folha: "+STRZERO(m_pag++,3)
         
             nLin++
             @ nLin,000 psay "ZNTR104EST.PRW"
             @ nLin,034 psay "R O M A N E I O"
             @ nLin,061 psay SUBSTR(TIME(),1,5)+"Hs. "+DTOC(DATE())
         
             nLin++
             @ nLin,000 psay Replicate("=",80)
             
//           nLin++        
             nLin=nLin+2                                              
         
/*
             IF EMPTY(PAR01)
                @ nLin,000 PSAY "( R e i m p r e s s a o )"
                nLin++
             Else           
                nLin=nLin+4
             EndIf    
*/
             
             @ nLin,033 psay CHR(27)+CHR(14)
             @ nLin,031 PSAY "Romaneio: "+TRIM(MV_PAR01)+"-"+MV_PAR03
             @ nLin,080 psay CHR(27)+CHR(20)
             nLin=nLin+2
        Endif
                                        
        
        @ nLin,000 PSAY "Atendimento: " + AliasUA->ATENDIMENTO 
        @ nLin,021 PSAY "Tipo ExpediГЦo: " + TipoExpedicao
        nLin++
        
        @ nLin,000 PSAY "Multifrio: " + AliasUA->PROD_MULTI 
        @ nLin,021 PSAY "Montagem: " + AliasUA->MONTAGEM 
        @ nLin,041 PSAY "Corte Painel: " + AliasUA->CORTE_PAINEL 
        nLin++
        
        @ nLin,000 PSAY "Metalrib: " + AliasUA->PROD_RIB
        @ nLin,021 PSAY "Plotagem: " + AliasUA->Plotagem 
        @ nLin,041 PSAY "Montagem Painel: " + AliasUA->MONTADOR_PAINEL
        nLin++
 

        @ nLin,000 PSAY "Nome: " +SUBSTR(xNome,1,60)+" "+xCod

        nLin++
        @ nLin,000 PSAY "End.: "+xEnd
        @ nLin,048 PSAY "Bairro: "+SUBSTR(xBairro,1,25)
        
        nLin++
        @ nLin,000 PSAY "Cid.: "+TRIM(xMun)+"-"+xEst
//      @ nLin,047 PSAY "Telefone: "+"("+SA1->A1_DDD+")"+" "+TRIM(SA1->A1_TEL
        @ nLin,047 PSAY "CEP...:"
        @ nLin,055 PSAY xCEP  PICTURE "@R 99.999-999"
        
        nLin=nLin+2                                                         
        @ nlin,000 PSAY "Transp..: "+ AliasUA->TRANSPORTADOR
        @ nLin,048 PSAY "Vendedor: "+TRIM(SF2->F2_VEND1)+" - "+SA3->A3_NOME

        nLin++                                                         
        @ nlin,000 PSAY "Telefone: "+"("+SA4->A4_DDD+")"+" "+TRIM(SA4->A4_TEL)

        
		AliasUA->(dbCloseArea()) //Fecha a Аrea de trabalho
     //EndIf

     nLin:= nLin+2
     @ nLin,000 PSAy REPLICATE("-",80)
     
     nLin++
//   @nlin,000 psay "It Codigo           Descricao de Produtos            Und                    Qtde"
//   @nlin,000 psay "   Qtde Codigo                 Descricao de Produtos                     Amz Und"
//	 @nlin,000 psay " Endereco   Codigo   Qtde       Descricao de Produtos                    Amz Und"      
//	 @nlin,000 psay "Codigo  Descricao Reduzida do Produto           Cod.Apresentacao  Armz  Qtde Und"      
 	 @nlin,000 psay "Codigo  Descricao Reduzida do Produto           Cod.Apresentacao        Qtde Und"      
//                   9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX 01 9999,99  XX          
                   //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     nlin++        //         1         2         3         4         5         6         7         8         9         0
     @ nLin,000 PSAy REPLICATE("-",80)
     @ nLin,080 psay CHR(27)+CHR(70)   
     nlin++
     
     //Itens da Nota Fiscal
     dbselectArea("SD2")
     dbsetorder(3)
     
     If DbSeek(xFilial("SD2")+MV_PAR01+MV_PAR03)
        Do While !eof() .and. SF2->F2_DOC   == SD2->D2_DOC .and.;
                              SF2->F2_SERIE == SD2->D2_SERIE
       
           IF (VerifTES())       // Verifica TES Movimenta Estoque
              dbselectArea("SB1")
              dbsetorder(1)
              dbseek(xFilial("SB1")+SD2->D2_COD)                                                                 
*             
              //AlteraГЦo Imprimir EndereГo do Produto             
              @ nlin,000 psay SD2->D2_COD                      	  	picture "@!S8"              
              @ nlin,008 psay TRIM(SUBSTR(SB1->B1_ZDESRDZ,1,40))  	picture "@!"
              @ nlin,048 psay TRIM(SUBSTR(SB1->B1_ZAPRES1,1,18))  	picture "@!"
//            @ nLin,066 psay SD2->D2_LOCAL    
              @ nlin,069 psay SD2->D2_QUANT                    		picture "@E 9999.99"
              @ nlin,078 psay SD2->D2_UM                       		picture "@!"
                                                                         
              TotItn++      
              nLin:=nLin+1
              TotQtd=TotQtd+SD2->D2_QUANT
           EndIf

           dbselectArea("SD2")
           dbskip()
        EndDo
       
        @ nLin,000 PSAY REPLICATE("-",80)
        
        nLin++
        @ nLin,000 PSAY TotQtd  PICTURE "@E 9999.99" 
        @ nLin,008 PSAY "/Itens por Qtde. a separar" 
        @ nLin,059 PSAY TotItn  PICTURE "@E 9,999" 
        @ nLin,064 PSAY "/Itens a separar"
        
        nLin=nLin+5
        @ nLin,000 PSAY "Separado por:" +Replicate("_",15)
        @ nLin,051 PSAY "Conferido por:"+Replicate("_",15)       
        
        nLin:=nLin+2
        @ nLin,000 PSAY "Observacoes:"
        nLin:=nLin+2
           
        @ nLin,000 PSAY SUBSTRING(SF2->F2_MENNOTA,001,50)    
        nLin++
        @ nLin,000 PSAY SUBSTRING(SF2->F2_MENNOTA,051,100)
        nLin++
        @ nLin,000 PSAY SUBSTRING(SF2->F2_MENNOTA,101,150)
        nLin++
        @ nLin,000 PSAY SUBSTRING(SF2->F2_MENNOTA,151,200)
        nLin++
        @ nLin,000 PSAY SUBSTRING(SF2->F2_MENNOTA,251,250)
      //nLin++
      //@ nLin,000 PSAY SF2->F2_OBS6NF
     EndIf
    
     dbSelectArea("SF2")
     dbskip()
  enddo
  
  Set Century Off

  IF !achou
     ALERT(" A T E N г ц O !... NENHUM ROMANEIO ENCONTRADO  ")
  ELSE
     SetPgEject(.t.)            //  Permite AvanГo do FormulАrio
     If aReturn[5] == 1
        Set Printer To 
        dbCommitAll()
        ourspool(wnrel)
     Endif
     MS_FLUSH()
  EndIf
RETURN 
/*
Static Function VerImp()
  nLin:= 0                // Contador de Linhas
  nLinIni:=0
 
  If aReturn[5]==2
     nOpc       := 1
 
     While .T.
       SetPrc(0,0)
       dbCommitAll()
       @ nLin ,000 PSAY " "
       @ nLin ,004 PSAY "*"
       @ nLin ,022 PSAY "."
 
       #IFNDEF WINDOWS
          Set Device to Screen
          DrawAdvWindow(" Formulario ",10,25,14,56)
          @ 12,27 Say "Formulario esta posicionado?"
          nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
          Set Device to Print
       #ELSE
          IF MsgYesNo("Fomulario esta posicionado ? ")
          nOpc := 1
          ElseIF MsgYesNo("Tenta Novamente ? ")
          nOpc := 2
          Else
          nOpc := 3
          Endif
        #ENDIF
 
        Do Case
           Case nOpc==1
              lContinua:=.T.
              Exit
           Case nOpc==2
              Loop
           Case nOpc==3
              lContinua:=.F.
              Return
        EndCase
     EndDO
  Endif
Return
*/
Static Function VerifTES()

  dbSelectArea("SF4")     //ARQUIVO DE TES
  dbSetOrder(1)
  dbGoTop()
                      
  IF SB1->B1_LOCPAD <> "2 "
     FlagImp := .f. 
     dbseek(xfilial("SF4")+SD2->D2_TES)

     IF !EOF()                                  
        IF F4_ESTOQUE = "S" 
           FlagImp := .t. 
        ENDIF      
     ENDIF
   ELSE             
     FlagImp := .t.
   ENDIF
Return(FlagImp)
