--�� ���� ���� (���ν���)
CREATE OR REPLACE PROCEDURE PRC_BANKINFO_DELETE
( V_IDENTIFY    IN VARCHAR2
, BANK_INFO     IN VARCHAR2
)
IS
    -- �����
    
BEGIN
    -- �����
    
    IF(V_IDENTIFY = 'member')
        THEN    
            DELETE 
            FROM MEMBER_EXCHANGE_BANK_INFO
            WHERE MEMBER_BANK_NUMBER = BANK_INFO;
        
            DELETE 
            FROM LOAD_REG_BANK_INFO
            WHERE MEMBER_BANK_NUMBER = BANK_INFO;
            
            DELETE 
            FROM MEMBER_BANK_INFO
            WHERE MEMBER_BANK_NUMBER = BANK_INFO;
            
            -- Ŀ��
            COMMIT;
            
    ELSIF(V_IDENTIFY = 'host')
        THEN
            DELETE
            FROM HOST_EXCHANGE_BANK_INFO
            WHERE HOST_BANK_NUMBER = BANK_INFO;
            
            DELETE
            FROM HOST_BANK_INFO
            WHERE HOST_BANK_NUMBER = BANK_INFO;
            
            -- Ŀ��
            COMMIT;
    ELSE    
        -- ���� ó��
        ROLLBACK;
   END IF;     

    
END;