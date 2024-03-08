
/*

1 - Acessar aplicativo do banco na Statum
2 - Executar os comando na ordem correta
3 - Sempre verificar antes de executar os comandos

*/


-- PASSO 1 DELETAR ASSINALAÇÃO
SELECT * FROM R174CND WHERE 1=1 AND codclc > 53 AND codclc < 1200

-- PASSO 2 DELETAR AMARRAÇÃO ENTRE CLC'S
SELECT * FROM R048CLB  WHERE 1=1 AND codclc > 53 AND codclc < 1200

-- PASSO 3 TABELAS RELACIONADAS
SELECT * FROM R174CCU WHERE 1=1 AND codclc > 53 AND codclc < 1200

-- PASSO 4 DELETAR A CLC
SELECT * FROM R048CLC WHERE 1=1 AND codclc > 53 AND codclc < 1200




