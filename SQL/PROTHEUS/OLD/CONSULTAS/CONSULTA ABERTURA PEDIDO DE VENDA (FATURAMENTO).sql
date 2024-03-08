
/*-------------------------------CONSULTA ABRETURA DE PV------------------------------------*/


DEFINE @VAR VARCHAR(6)
DECLARE @VAR VARCHAR(6)
SET @VAR = $(@VAR)
SELECT 
C5_ORCRES, 
C5_ZORCRES,  
* 
FROM SC5010 
WHERE C5_NUM = @VAR

