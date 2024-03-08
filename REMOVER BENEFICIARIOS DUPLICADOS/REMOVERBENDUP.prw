#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*

	SELECT 
	A.BA1_FILIAL,
	A.BA1_CODINT,
	A.BA1_CODEMP,
	A.BA1_CONEMP,
	A.BA1_SUBCON,
	A.BA1_MATVID,
	A.BA1_NOMUSR,
    A.R_E_C_N_O_
	FROM BA1010 A
	WHERE 1=1 
	AND A.D_E_L_E_T_ = '' 	
	AND A.BA1_SUBCON <> '000000001'
	AND A.BA1_SUBCON = '000023099'
	AND A.BA1_NOMUSR = 'VICENTE VITAL DA SILVA'


    SELECT 
	A.BA1_FILIAL,
	A.BA1_CODINT,
	A.BA1_CODEMP,
	A.BA1_CONEMP,
	A.BA1_SUBCON,
	A.BA1_MATVID,
	A.BA1_NOMUSR,
    COUNT(*)
	FROM BA1010 A
	WHERE 1=1 
	AND A.D_E_L_E_T_ = '' 	
	AND A.BA1_SUBCON <> '000000001'
    GROUP BY A.BA1_FILIAL,	A.BA1_CODINT,	A.BA1_CODEMP,	A.BA1_CONEMP,	A.BA1_SUBCON,	A.BA1_MATVID,	A.BA1_NOMUSR
    HAVING COUNT (*) > 1 


    SELECT 
	COUNT(*) AS QTD_BENE
	FROM(	
	SELECT  
	A.BA1_FILIAL,	A.BA1_CODINT,	A.BA1_CODEMP,	A.BA1_CONEMP,	A.BA1_SUBCON,	A.BA1_MATVID,	A.BA1_NOMUSR,    COUNT(*) AS QTD
	FROM BA1010 A
	WHERE 1=1 
	AND A.D_E_L_E_T_ = '' 	
	AND A.BA1_SUBCON <> '000000001'
    GROUP BY A.BA1_FILIAL,	A.BA1_CODINT,	A.BA1_CODEMP,	A.BA1_CONEMP,	A.BA1_SUBCON,	A.BA1_MATVID,	A.BA1_NOMUSR
    HAVING COUNT (*) > 1 
	) BENE


SELECT 
A.BA3_MATEMP,
B.BA1_MATEMP
FROM BA3010 A 
LEFT JOIN BA1010 B ON B.D_E_L_E_T_ = '' AND B.BA1_MATEMP = A.BA3_MATEMP
WHERE A.D_E_L_E_T_ = ''
AND BA3_MATEMP <> ''
AND BA1_MATEMP IS NULL



*/

User function REMOVERBENDUP()

Local cQuery 
Local cQryUpd
local cQueryBen
local _cAlias := GetNextAlias()
local _cAliasBen := GetNextAlias()

    cQuery := " SELECT 	A.BA1_FILIAL, A.BA1_CODINT,	A.BA1_CODEMP, A.BA1_CONEMP,	A.BA1_SUBCON,A.BA1_MATVID,A.BA1_NOMUSR,	COUNT(*) "
	cQuery += " FROM BA1010 A "
	cQuery += " WHERE 1=1  "
	cQuery += " AND A.D_E_L_E_T_ = '' 	 "
	cQuery += " AND A.BA1_SUBCON <> '000000001' "
	cQuery += " GROUP BY A.BA1_FILIAL,	A.BA1_CODINT,	A.BA1_CODEMP,	A.BA1_CONEMP,	A.BA1_SUBCON,	A.BA1_MATVID,	A.BA1_NOMUSR "
    cQuery += " HAVING COUNT (*) > 1 "

TCQUERY cQuery NEW ALIAS (_cAlias)
DbSelectArea(_cAlias)


//PERCORRER
While (_cAlias)->(!Eof())

    cQueryBen := " SELECT MIN(A.R_E_C_N_O_) AS IDBEN "
	cQueryBen += " FROM BA1010 A "
	cQueryBen += " WHERE 1=1  "
	cQueryBen += " AND A.D_E_L_E_T_ = '' 	 "
	cQueryBen += " AND A.BA1_FILIAL = '" +(_cAlias)->BA1_FILIAL+ "' "
    cQueryBen += " AND A.BA1_CODINT = '" +(_cAlias)->BA1_CODINT+ "' "
    cQueryBen += " AND A.BA1_CODEMP = '" +(_cAlias)->BA1_CODEMP+ "' "
    cQueryBen += " AND A.BA1_SUBCON = '" +(_cAlias)->BA1_SUBCON+ "' "
    cQueryBen += " AND A.BA1_MATVID = '" +(_cAlias)->BA1_MATVID+ "' "
    cQueryBen += " AND A.BA1_NOMUSR = '" +(_cAlias)->BA1_NOMUSR+ "' "

    TCQUERY cQueryBen NEW ALIAS (_cAliasBen)
    DbSelectArea(_cAliasBen)

        Begin Transaction
            /* ------------------------------- UPDATE  ------------------------------- */
            //Monta o Update
            cQryUpd := " UPDATE BA1010 "
            cQryUpd += "    SET D_E_L_E_T_ = '*' "
            cQryUpd += " FROM BA1010 "
            cQryUpd += " WHERE 1=1 "
            cQryUpd += " AND BA1010.R_E_C_N_O_ = " + str((_cAliasBen)->IDBEN)

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
