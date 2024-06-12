#Include 'Protheus.ch'

User Function ALTDATAL()

Local dDataLanc := paramixb[1]
//Local cRotina   := paramixb[2]

dData := CTOD('30/06/16')

MsgAlert("Nova data contabilizada: " + dtoc(dDataLanc))

Return dDataLanc
