#Include "TOTVS.ch"
#Include "PROTHEUS.ch"

User Function MA030TOK()
    
    Local aArea := FWGetArea()
    //Local aParam := PARAMIXB 
    Local lRet := .T.
    Local cChaveCli := SA1->A1_COD+SA1->A1_loja
 
    DbSelectArea('AC8')
    AC8->(DbSetOrder(3))

    If !AC8->(DbSeek("      "+"      "+"SA1"+cChaveCli))

        If MsgYesNo("Cadastro sem contato deseja inserir?")

            MsAguarde({||fGatilhoContato(cChaveCli)},"Aguarde","Criando Contatos...") 

        Else

            MsgInfo("Cancelado pelo usuario", "Contatos Clientes Medicar.")

        EndIF

    EndIF

    AC8->(DbCloseArea())
    RestArea(aArea)
     
Return lRet


Static Function fGatilhoContato(cChaveCli)


    IF !EMPTY(M->A1_TEL)
        
        cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))

        RecLock("SU5", .T.)

                SU5->U5_FILIAL 	:= FWxFilial('SU5')
                SU5->U5_CODCONT := cProxCont
                SU5->U5_CONTAT	:= SUBSTR(M->A1_NREDUZ,1,30)
                SU5->U5_CPF		:= M->A1_CGC
                SU5->U5_END		:= M->A1_END
                SU5->U5_BAIRRO	:= M->A1_BAIRRO
                SU5->U5_MUN		:= M->A1_MUN
                SU5->U5_EST		:= M->A1_EST
                SU5->U5_CEP		:= M->A1_CEP
                SU5->U5_DDD		:= M->A1_DDD
                SU5->U5_FONE	:= M->A1_TEL
                SU5->U5_ATIVO 	:= '1'
                SU5->U5_STATUS 	:= '2'
                SU5->U5_CLIENTE := M->A1_COD
                SU5->U5_LOJA 	:= M->A1_LOJA

        SU5->(MsUnlock())
        ConfirmSX8()

        //RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
        RecLock('AC8', .T.)

            AC8->AC8_ENTIDA := 'SA1'
            AC8->AC8_CODENT := cChaveCli
            AC8->AC8_CODCON := cProxCont

        AC8->(MsUnlock())

    EndIF

    IF !EMPTY(M->A1_ZZTEL2)
        
        cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))

        RecLock("SU5", .T.)

                SU5->U5_FILIAL 	:= FWxFilial('SU5')
                SU5->U5_CODCONT := cProxCont
                SU5->U5_CONTAT	:= SUBSTR(M->A1_NREDUZ,1,30)
                SU5->U5_CPF		:= M->A1_CGC
                SU5->U5_END		:= M->A1_END
                SU5->U5_BAIRRO	:= M->A1_BAIRRO
                SU5->U5_MUN		:= M->A1_MUN
                SU5->U5_EST		:= M->A1_EST
                SU5->U5_CEP		:= M->A1_CEP
                SU5->U5_DDD		:= M->A1_ZZDDD2
                SU5->U5_FONE	:= M->A1_ZZTEL2
                SU5->U5_ATIVO 	:= '1'
                SU5->U5_STATUS 	:= '2'
                SU5->U5_CLIENTE := M->A1_COD
                SU5->U5_LOJA 	:= M->A1_LOJA

        SU5->(MsUnlock())
        ConfirmSX8()

        //RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
        RecLock('AC8', .T.)

            AC8->AC8_ENTIDA := 'SA1'
            AC8->AC8_CODENT := cChaveCli
            AC8->AC8_CODCON := cProxCont

        AC8->(MsUnlock())

    EndIF


    IF !EMPTY(M->A1_ZZTEL3)
        
        cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))

        RecLock("SU5", .T.)

                SU5->U5_FILIAL 	:= FWxFilial('SU5')
                SU5->U5_CODCONT := cProxCont
                SU5->U5_CONTAT	:= SUBSTR(M->A1_NREDUZ,1,30)
                SU5->U5_CPF		:= M->A1_CGC
                SU5->U5_END		:= M->A1_END
                SU5->U5_BAIRRO	:= M->A1_BAIRRO
                SU5->U5_MUN		:= M->A1_MUN
                SU5->U5_EST		:= M->A1_EST
                SU5->U5_CEP		:= M->A1_CEP
                SU5->U5_DDD		:= M->A1_ZZDDD3
                SU5->U5_FONE	:= M->ZZA1_TEL3
                SU5->U5_ATIVO 	:= '1'
                SU5->U5_STATUS 	:= '2'
                SU5->U5_CLIENTE := M->A1_COD
                SU5->U5_LOJA 	:= M->A1_LOJA

        SU5->(MsUnlock())
        ConfirmSX8()

        //RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
        RecLock('AC8', .T.)

            AC8->AC8_ENTIDA := 'SA1'
            AC8->AC8_CODENT := cChaveCli
            AC8->AC8_CODCON := cProxCont

        AC8->(MsUnlock())

    EndIF


    IF !EMPTY(M->A1_FAX)
        
        cProxCont := SU5->(GetSx8Num("SU5","U5_CODCONT"))

        RecLock("SU5", .T.)

                SU5->U5_FILIAL 	:= FWxFilial('SU5')
                SU5->U5_CODCONT := cProxCont
                SU5->U5_CONTAT	:= SUBSTR(M->A1_NREDUZ,1,30)
                SU5->U5_CPF		:= M->A1_CGC
                SU5->U5_END		:= M->A1_END
                SU5->U5_BAIRRO	:= M->A1_BAIRRO
                SU5->U5_MUN		:= M->A1_MUN
                SU5->U5_EST		:= M->A1_EST
                SU5->U5_CEP		:= M->A1_CEP
                SU5->U5_DDD		:= ""
                SU5->U5_FONE	:= M->A1_FAX
                SU5->U5_ATIVO 	:= '1'
                SU5->U5_STATUS 	:= '2'
                SU5->U5_CLIENTE := M->A1_COD
                SU5->U5_LOJA 	:= M->A1_LOJA

        SU5->(MsUnlock())
        ConfirmSX8()

        //RECLOCK TABELA AC8 VINCULO NAS DUAS TABELAS
        RecLock('AC8', .T.)

            AC8->AC8_ENTIDA := 'SA1'
            AC8->AC8_CODENT := cChaveCli
            AC8->AC8_CODCON := cProxCont

        AC8->(MsUnlock())

    EndIF

Return
