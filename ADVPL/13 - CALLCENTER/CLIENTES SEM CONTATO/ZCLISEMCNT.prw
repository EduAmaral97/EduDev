#Include "TOTVS.ch"
#Include "PROTHEUS.ch"
#INCLUDE "TOPCONN.CH"


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para atualizar/criar em massa os contatos de clientes que nao os possuem.

------------------------------------------------------------------------------- */



User Function ZCLISEMCNT()

	Processa({|| zCriaContato()}, "Criando Contatos...")

Return


Static Function zCriaContato()

	Local cQuery  
	local _cAlias	  := GetNextAlias()
	local cProxCont := ''
	Local nLinhaAtu := 0
    Local nTotLinhas := 0

	cQuery := " SELECT "
	cQuery += " A.A1_COD	AS CODCLI, "
	cQuery += " A.A1_LOJA	AS LOJACLI, "
	cQuery += " A.A1_NOME	AS CLIENTE, "
	cQuery += " A.A1_CGC	AS CGC, "
	cQuery += " A.A1_END	AS ENDERECO, "
	cQuery += " A.A1_BAIRRO	AS BAIRRO, "
	cQuery += " A.A1_MUN	AS MUNICIPIO, "
	cQuery += " A.A1_EST	AS ESTADO, "
	cQuery += " A.A1_CEP	AS CEP, "
	cQuery += " A.A1_DDD	AS DDD1, "
	cQuery += " A.A1_TEL	AS TEL1, "
	cQuery += " A.A1_ZZDDD2 AS DDD2, "
	cQuery += " A.A1_ZZTEL2	AS TEL2, "
	cQuery += " A.A1_ZZDDD3	AS DDD3, "
	cQuery += " A.A1_ZZTEL3	AS TEL3 "
	cQuery += " FROM SA1010 A "
	cQuery += " LEFT JOIN SU5010 B ON B.D_E_L_E_T_ = '' AND B.U5_CLIENTE = A.A1_COD AND B.U5_LOJA = A.A1_LOJA "
	cQuery += " WHERE 1=1 "
	cQuery += " AND A.D_E_L_E_T_ = '' "
	cQuery += " AND B.U5_CODCONT IS NULL "


	TCQUERY cQuery NEW ALIAS (_cAlias)
	DbSelectArea(_cAlias)
 
    //Define o tamanho da régua
    Count To nTotLinhas
    ProcRegua(nTotLinhas)


	if MsgYesNo("Deseja Atualizar os contatos? " +  CHR(13)+CHR(10) +  CHR(13)+CHR(10) + "Clientes sem Contatos: " + STR(nTotLinhas)  )

		(_cAlias)->(DbGoTop())

		//PERCORRER
		While (_cAlias)->(!Eof())

			nLinhaAtu++
 	       	IncProc("Craidno Contato " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
     	

			IF !EMPTY((_cAlias)->TEL1)
				
				cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))
				//CRIA NOVA MATRICULA VIDA
				RecLock("SU5", .T.)

						SU5->U5_FILIAL 	:= FWxFilial('BTS')
						SU5->U5_CODCONT := cProxCont
						SU5->U5_CONTAT	:= SUBSTR((_cAlias)->CLIENTE,1,30)
						SU5->U5_CPF		:= (_cAlias)->CGC
						SU5->U5_END		:= (_cAlias)->ENDERECO
						SU5->U5_BAIRRO	:= (_cAlias)->BAIRRO
						SU5->U5_MUN		:= (_cAlias)->MUNICIPIO
						SU5->U5_EST		:= (_cAlias)->ESTADO
						SU5->U5_CEP		:= (_cAlias)->CEP
						SU5->U5_DDD		:= (_cAlias)->DDD1
						SU5->U5_FONE	:= (_cAlias)->TEL1
						SU5->U5_ATIVO 	:= '1'
						SU5->U5_STATUS 	:= '2'
						SU5->U5_CLIENTE := (_cAlias)->CODCLI
						SU5->U5_LOJA 	:= (_cAlias)->LOJACLI

				SU5->(MsUnlock())
				ConfirmSX8()

				//RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
				RecLock('AC8', .T.)

					AC8->AC8_ENTIDA := 'SA1'
					AC8->AC8_CODENT := (_cAlias)->CODCLI+(_cAlias)->LOJACLI
					AC8->AC8_CODCON := cProxCont
			
				AC8->(MsUnlock())

			EndIF

			IF !EMPTY((_cAlias)->TEL2)
				
				cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))
				//CRIA NOVA MATRICULA VIDA
				RecLock("SU5", .T.)

						SU5->U5_FILIAL 	:= FWxFilial('BTS')
						SU5->U5_CODCONT := cProxCont
						SU5->U5_CONTAT	:= SUBSTR((_cAlias)->CLIENTE,1,30)
						SU5->U5_CPF		:= (_cAlias)->CGC
						SU5->U5_END		:= (_cAlias)->ENDERECO
						SU5->U5_BAIRRO	:= (_cAlias)->BAIRRO
						SU5->U5_MUN		:= (_cAlias)->MUNICIPIO
						SU5->U5_EST		:= (_cAlias)->ESTADO
						SU5->U5_CEP		:= (_cAlias)->CEP
						SU5->U5_DDD		:= (_cAlias)->DDD2
						SU5->U5_FONE	:= (_cAlias)->TEL2
						SU5->U5_ATIVO 	:= '1'
						SU5->U5_STATUS 	:= '2'
						SU5->U5_CLIENTE := (_cAlias)->CODCLI
						SU5->U5_LOJA 	:= (_cAlias)->LOJACLI

				SU5->(MsUnlock())
				ConfirmSX8()

				//RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
				RecLock('AC8', .T.)

					AC8->AC8_ENTIDA := 'SA1'
					AC8->AC8_CODENT := (_cAlias)->CODCLI+(_cAlias)->LOJACLI
					AC8->AC8_CODCON := cProxCont
			
				AC8->(MsUnlock())

			EndIF


			IF !EMPTY((_cAlias)->TEL3)
				
				cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))
				//CRIA NOVA MATRICULA VIDA
				RecLock("SU5", .T.)

						SU5->U5_FILIAL 	:= FWxFilial('BTS')
						SU5->U5_CODCONT := cProxCont
						SU5->U5_CONTAT	:= SUBSTR((_cAlias)->CLIENTE,1,30)
						SU5->U5_CPF		:= (_cAlias)->CGC
						SU5->U5_END		:= (_cAlias)->ENDERECO
						SU5->U5_BAIRRO	:= (_cAlias)->BAIRRO
						SU5->U5_MUN		:= (_cAlias)->MUNICIPIO
						SU5->U5_EST		:= (_cAlias)->ESTADO
						SU5->U5_CEP		:= (_cAlias)->CEP
						SU5->U5_DDD		:= (_cAlias)->DDD3
						SU5->U5_FONE	:= (_cAlias)->TEL3
						SU5->U5_ATIVO 	:= '1'
						SU5->U5_STATUS 	:= '2'
						SU5->U5_CLIENTE := (_cAlias)->CODCLI
						SU5->U5_LOJA 	:= (_cAlias)->LOJACLI

				SU5->(MsUnlock())
				ConfirmSX8()

				//RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
				RecLock('AC8', .T.)

					AC8->AC8_ENTIDA := 'SA1'
					AC8->AC8_CODENT := (_cAlias)->CODCLI+(_cAlias)->LOJACLI
					AC8->AC8_CODCON := cProxCont
			
				AC8->(MsUnlock())

			EndIF

			(_cAlias)->(dBskip())

		EndDo

		(_cAlias)->(DbCloseArea())

	Else

		MsgInfo("Cancelado pelo usuario.", "Clientes sem contatos Medicar.")		

	EndIF

return



