
/* ---------------------------------------------------|
|                                                     |
|------------------ Z_AGENDAMENTOS -------------------|
|                                                     |
| HANDLE = 10 (TOTALIZADOR CONTABIL)                  |
|                                                     |
|----------------- Z_AGENDAMENTOLOG ------------------|
|                                                     |
| STATUS = 1 (EXECUTANDO)                             |
| STATUS = 2 (FINALIZADO COM SUCESSO)                 |
| STATUS = 3 (FINALIZADO COM ERRO)                    |
| STATUS = 4 (PENDENTE)                               |
|                                                     |
|----------------------------------------------------*/


/* -------------------- AGENDAMENTOS ------------------- */

SELECT * FROM Z_AGENDAMENTOS 

/* ----------------- LOGS AGENDAMENTOS ----------------- */

SELECT TOP 10 * FROM Z_AGENDAMENTOLOG WHERE AGENDAMENTO = 10