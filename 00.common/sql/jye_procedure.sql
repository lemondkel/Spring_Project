CREATE OR REPLACE PROCEDURE PRC_DEL_LOC_INSERT
(
    V_HOST_CODE IN LOC.HOST_CODE%TYPE
)
IS
    V_LOC_CODE LOC_REMOVE.LOC_CODE%TYPE;
    
    CURSOR C1 
    IS
        SELECT LOC_CODE
        FROM LOC 
        WHERE HOST_CODE = V_HOST_CODE;
BEGIN
    OPEN C1;
    
    LOOP
        FETCH C1 INTO V_LOC_CODE;
        EXIT WHEN C1%NOTFOUND;
    
    -- 해당 공간코드만큼 LOC테이블에 INSERT 
        INSERT INTO LOC_REMOVE(LOC_REMOVE_CODE, LOC_CODE, LOC_REMOVE_DATE)
        VALUES(F_CODE('LRM', LRM_SEQ.NEXTVAL), V_LOC_CODE, SYSDATE);
    
    END LOOP;
    
    CLOSE C1;
END;


