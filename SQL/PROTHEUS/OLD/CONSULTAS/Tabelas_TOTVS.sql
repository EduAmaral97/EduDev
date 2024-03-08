
/*--------------------- Atendimento ---------------------*/

SELECT * FROM SUA010 -- Cabeçario
SELECT * FROM SUB010 -- Itens 

/*----------- Or�amento / Venda direta (V.D) -----------*/

SELECT * FROM SL1010 -- Cabeçario
SELECT * FROM SL2010 -- Itens 

/*--------------------- Financeiro --------------------*/

SELECT * FROM SE1010 -- Financeiro receber
SELECT * FROM SE2010 -- Financeiro pagar
SELECT * FROM SE3010 -- Comissão
SELECT * FROM SE4010 -- Condições de pagamento
SELECT * FROM SE5010 -- Mov bancaria

/*------------------------ NF-e -----------------------*/

SELECT * FROM SF1010 -- NF-e Entrada
SELECT * FROM SD1010 -- Itens NF-e (entrada)
SELECT * FROM SF2010 -- NF-e Saida 
SELECT * FROM SD2010 -- Itens NF-e (saida)
SELECT * FROM SFT010 -- XML (chave NF-e)

/*--------------------- Estoque -----------------------*/

SELECT * FROM SD3010 -- Mov Estoque
SELECT * FROM SD2010 -- Mov Estoque

/*---------------------- Fical ------------------------*/

SELECT * FROM SF3010 -- Livros fiscais impostos

/*----------------- Pedido de venda -------------------*/

SELECT * FROM SC5010 -- Cabeçario
SELECT * FROM SC6010 -- Itens

/*--------------------- Compras ----------------------*/

SELECT * FROM SC1010 -- Solicitação de compra
SELECT * FROM SC7010 -- Pedido de compra
 
/*-------------------- Reserva ----------------------*/
 
SELECT * FROM SC9010 -- Reserva de mercadoria
SELECT * FROM SC0010 -- Controle de reserva
 
/*------------------- Cadastros --------------------*/

SELECT * FROM SB1010 -- Cadastro de Produto
SELECT * FROM SA1010 -- Cadastro de Cliente
SELECT * FROM SA2010 -- Cadastro de Fornecedor
SELECT * FROM SA3010 -- Cadastro de Vendedor
SELECT * FROM SF4010 -- Cadastro de TES
SELECT * FROM SFM010 -- Cadastro de TES iteligente

/*---------------- Saldo de estoque ---------------*/

SELECT * FROM SB2010 -- Saldo de estoque

/*---------------- Tabela de pre�o ---------------*/

SELECT * FROM DA0010 -- Tabela de preço
SELECT * FROM DA1010 -- Tabela de preço
