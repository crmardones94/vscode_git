--CASO 1
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUN CLIENTE",
INITCAP(C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO) AS "NOMBRE CLIENTE",
TO_CHAR(FECHA_NACIMIENTO,'DD "De" Month') AS "FECHA DE NACIMIENTO",
SR.DIRECCION||'/'||UPPER(R.NOMBRE_REGION) AS "DIRECCION"
FROM CLIENTE C
JOIN SUCURSAL_RETAIL SR ON SR.COD_REGION = C.COD_REGION
                        AND SR.COD_PROVINCIA = C.COD_PROVINCIA
                        AND SR.COD_COMUNA = C.COD_COMUNA
JOIN REGION R ON R.COD_REGION = SR.COD_REGION
WHERE EXTRACT(MONTH FROM FECHA_NACIMIENTO) = 9
--WHERE EXTRACT(MONTH FROM FECHA_NACIMIENTO) = EXTRACT(MONTH FROM SYSDATE)+1
AND C.COD_REGION = 13
ORDER BY "FECHA DE NACIMIENTO" ASC, APPATERNO;

--CASO 2
SELECT TO_CHAR(C.NUMRUN,'09G999G999')||'-'||C.DVRUN AS "RUT CLIENTE",
C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO AS "NOMBRE CLIENTE",
TO_CHAR(SUM(TTC.MONTO_TRANSACCION),'$99G999G999') AS "MONTO COMPRAS",
TO_CHAR((SUM(TTC.MONTO_TRANSACCION)/10000)*250,'$99G999G999') AS "PUNTOS"
FROM CLIENTE C
INNER JOIN TARJETA_CLIENTE TC ON TC.NUMRUN = C.NUMRUN
INNER JOIN TRANSACCION_TARJETA_CLIENTE TTC ON TTC.NRO_TARJETA = TC.NRO_TARJETA
WHERE EXTRACT(YEAR FROM TTC.FECHA_TRANSACCION) = 2021
GROUP BY C.NUMRUN,C.DVRUN,C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO
ORDER BY "MONTO COMPRAS"
;

--CASO 3
SELECT TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY') AS "FECHA TRANSACCION",
TTT.NOMBRE_TPTRAN_TARJETA AS "TIPO DE TRANSACCION",
TO_CHAR(SUM(TTC.MONTO_TOTAL_TRANSACCION),'$99G999G999') AS "MONTO TRANSACCION"
FROM TRANSACCION_TARJETA_CLIENTE TTC
JOIN TIPO_TRANSACCION_TARJETA TTT ON TTT.COD_TPTRAN_TARJETA = TTT.COD_TPTRAN_TARJETA
WHERE TTT.COD_TPTRAN_TARJETA IN (102,103)
AND EXTRACT(YEAR FROM TTC.FECHA_TRANSACCION) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY TO_CHAR(TTC.FECHA_TRANSACCION,'MMYYYY'),TTT.NOMBRE_TPTRAN_TARJETA
ORDER BY "FECHA TRANSACCION","TIPO DE TRANSACCION"