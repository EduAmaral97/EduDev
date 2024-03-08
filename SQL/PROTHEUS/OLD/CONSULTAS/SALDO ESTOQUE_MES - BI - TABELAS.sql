/*----------SB1--------------*/


SELECT * FROM SB1010 A 
WHERE 1=1
AND A.D_E_L_E_T_ = ''
 

/*-----------SB9-------------*/


SELECT * FROM SB9010 A 
WHERE 1=1
AND A.D_E_L_E_T_ = ''
AND YEAR(A.B9_DATA) = 2017


/*----------SD1--------------*/


SELECT * FROM SD1010 A
WHERE 1=1
AND A.D_E_L_E_T_ = ''
AND YEAR(C.D1_DTDIGIT) = 2018
AND MONTH(C.D1_DTDIGIT) = 01


/*----------SD2-------------*/


SELECT * FROM SD2010 A
WHERE 1=1
AND A.D_E_L_E_T_ = ''


/*----------SD3-------------*/


SELECT * FROM SD3010 A
WHERE 1=1
AND A.D_E_L_E_T_ = ''

/*----------SF4------------*/


SELECT * FROM SF4010 A
WHERE A.D_E_L_E_T_ =''
AND A.F4_ESTOQUE = 'S'
