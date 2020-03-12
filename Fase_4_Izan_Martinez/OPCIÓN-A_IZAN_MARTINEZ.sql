SET SERVEROUTPUT ON;
SET VERIFY OFF;
/*El informe es un ejercicio que utiliza un cursor. 
Lee por parametro un numero introducido que será el ID_CIR
y muestra a continuación todos los datos del cirujano. 
Para probar el cursor hay que seleccionar el codigo
 y darle a correr puesto que no se usa en ningun procedimiento o función.*/

/* INTRODUCE NOMBRE POR TECLADO Y MUESTRA DATOS SOBRE CIRUJANO    */
DECLARE
    
    CURSOR C1 (NOMBRE_CIRUJANO VARCHAR2)IS 
        SELECT ID_CIR, NOMBRE, DIRECCION
        FROM CIRUJANOS WHERE ID_CIR = (SELECT ID_CIR FROM CIRUJANOS
                                     WHERE NOMBRE=NOMBRE_CIRUJANO);

        CIR_NOMBRE_LEIDA CIRUJANOS.NOMBRE%TYPE;
        REG_CIRUJANOS CIRUJANOS%ROWTYPE;
        REGCIR C1%ROWTYPE;
        

BEGIN
    CIR_NOMBRE_LEIDA:='&nombre_ciru';
    SELECT * INTO REG_CIRUJANOS FROM CIRUJANOS WHERE NOMBRE=CIR_NOMBRE_LEIDA;

    DBMS_OUTPUT.PUT_LINE('CIRUJANO: '||CIR_NOMBRE_LEIDA);
    DBMS_OUTPUT.PUT_LINE('ID_CIR     NOMBRE     DIRECCIÓN');
    DBMS_OUTPUT.PUT_LINE('------- ----------- -------------- ');

    OPEN C1(CIR_NOMBRE_LEIDA);
    LOOP
        FETCH C1 INTO REGCIR;
        IF C1%NOTFOUND THEN 
            EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE(RPAD(TO_CHAR(REGCIR.ID_CIR),8,' ')||
                             RPAD(REGCIR.NOMBRE,12,' ') || 
                             RPAD(REGCIR.DIRECCION,17,' '));
    END LOOP;
    CLOSE C1;
END;

/*--------------------------------------------------------------
FUNCION QUE LEE POR PARAMETRO UNA HABITACIÓN Y MUESTRA SI ESTÁ 
O NO ESTÁ OCUPADA
---------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION 
    HABITACION_OCUPADA(ID_HABITACION HABITACIONES.ID_HAB%TYPE)
            RETURN BOOLEAN IS CONT NUMBER(1):=0;
BEGIN
    SELECT OCUPADA INTO CONT FROM HABITACIONES WHERE ID_HABITACION=ID_HAB;
    IF CONT>0 THEN 
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END;

/*--------------------------------------------------------------
IMPLEMENTACIÓN DE LA FUNCIÓN EN BLOQUE PLSQL
---------------------------------------------------------------*/
DECLARE
BEGIN
    IF HABITACION_OCUPADA(1) THEN
       DBMS_OUTPUT.PUT_LINE('OCUPADA');
    ELSE 
       DBMS_OUTPUT.PUT_LINE('NO ESTÁ OCUPADA');
    END IF;
END;