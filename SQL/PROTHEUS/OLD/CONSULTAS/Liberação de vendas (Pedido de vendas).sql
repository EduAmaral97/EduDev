
/*Abertuda de venda direta

Apagar o campo C5_ORCRES para a liberação do venda direta

após os ajustes fechar o venda direta novamente com o valor do campo

C5_ZORCRES no campo C5_ORCRES novamente

*/


SELECT C5_FILIAL, C5_NUM, C5_CLIENTE, C5_ORCRES, C5_ZORCRES FROM SC5010
WHERE C5_NUM = '008830' --Numero do venda direta para consulta

