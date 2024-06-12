#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*

SELECT BDK_FILIAL,BDK_CODFAI,BDK_IDAINI,BDK_IDAFIN,BDK_VALOR,BDK_CODINT,BDK_CODEMP,BDK_MATRIC,BDK_TIPREG,BDK_ANOMES,BDK_VLRANT,BDK_RGIMP,BDK_TABVLD,COUNT(*) 
FROM BDK010 
GROUP BY BDK_FILIAL,BDK_CODFAI,BDK_IDAINI,BDK_IDAFIN,BDK_VALOR,BDK_CODINT,BDK_CODEMP,BDK_MATRIC,BDK_TIPREG,BDK_ANOMES,BDK_VLRANT,BDK_RGIMP,BDK_TABVLD
HAVING COUNT (*) > 1 

*/

User function REMOVERVLRDUP()

Local cQuery 
Local cQryUpd
local cQueryBen
local _cAlias := GetNextAlias()
local _cAliasBen := GetNextAlias()

	cQuery := " SELECT BDK_FILIAL,BDK_CODFAI,BDK_IDAINI,BDK_IDAFIN,BDK_VALOR,BDK_CODINT,BDK_CODEMP,BDK_MATRIC,BDK_TIPREG,BDK_ANOMES,BDK_VLRANT,BDK_RGIMP,BDK_TABVLD,COUNT(*)  "
	cQuery += " FROM BDK010 
	cQuery += " GROUP BY BDK_FILIAL,BDK_CODFAI,BDK_IDAINI,BDK_IDAFIN,BDK_VALOR,BDK_CODINT,BDK_CODEMP,BDK_MATRIC,BDK_TIPREG,BDK_ANOMES,BDK_VLRANT,BDK_RGIMP,BDK_TABVLD "
	cQuery += " HAVING COUNT (*) > 1  " 

TCQUERY cQuery NEW ALIAS (_cAlias)
DbSelectArea(_cAlias)


//PERCORRER
While (_cAlias)->(!Eof())

    cQueryBen := " SELECT MAX(A.R_E_C_N_O_) AS IDBEN "
	cQueryBen += " FROM BDK010 A "
	cQueryBen += " WHERE 1=1 "
	cQueryBen += " AND A.D_E_L_E_T_ = '' "
	cQueryBen += " AND A.BDK_FILIAL  = '" + (_cAlias)->BDK_FILIAL + "' "
	cQueryBen += " AND A.BDK_CODFAI  = '" + (_cAlias)->BDK_CODFAI + "' "
	cQueryBen += " AND A.BDK_IDAINI  = "  + str((_cAlias)->BDK_IDAINI) + " "
	cQueryBen += " AND A.BDK_IDAFIN  = "  + str((_cAlias)->BDK_IDAFIN) + " "
	cQueryBen += " AND A.BDK_VALOR   = "  + str((_cAlias)->BDK_VALOR)  + " "
	cQueryBen += " AND A.BDK_CODINT  = '" + (_cAlias)->BDK_CODINT +	"' "
	cQueryBen += " AND A.BDK_CODEMP  = '" + (_cAlias)->BDK_CODEMP +	"' "
	cQueryBen += " AND A.BDK_MATRIC  = '" + (_cAlias)->BDK_MATRIC +	"' "
	cQueryBen += " AND A.BDK_TIPREG  = '" + (_cAlias)->BDK_TIPREG +	"' "
	cQueryBen += " AND A.BDK_ANOMES  = '" + (_cAlias)->BDK_ANOMES +	"' "
	cQueryBen += " AND A.BDK_VLRANT  = "  + str((_cAlias)->BDK_VLRANT) + " "
	cQueryBen += " AND A.BDK_RGIMP   = '" + (_cAlias)->BDK_RGIMP  +	"' "
	cQueryBen += " AND A.BDK_TABVLD  = '"  + (_cAlias)->BDK_TABVLD +"' "

    TCQUERY cQueryBen NEW ALIAS (_cAliasBen)
    DbSelectArea(_cAliasBen)

        Begin Transaction
            /* ------------------------------- UPDATE  ------------------------------- */
            //Monta o Update
            cQryUpd := " UPDATE BDK010 "
            cQryUpd += "    SET D_E_L_E_T_ = '*' "
            cQryUpd += " FROM BDK010 "
            cQryUpd += " WHERE 1=1 "
            cQryUpd += " AND BDK010.R_E_C_N_O_ = " + str((_cAliasBen)->IDBEN)

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

    (_cAliasBen)->(DbCloseArea())

	(_cAlias)->(dBskip())
EndDo

(_cAlias)->(DbCloseArea())

return
