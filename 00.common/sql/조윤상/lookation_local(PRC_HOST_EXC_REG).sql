-- 환전 신청시 충전신청내역 테이블과 충전신청계좌정보 테이블에 데이터가 추가되어야 한다.
-- 호스트 환전 신청 프로시저
CREATE OR REPLACE PROCEDURE PRC_HOST_EXC_REG
( V_HOST_CODE         IN  VARCHAR
, V_HOST_BANK_NUMBER  IN  VARCHAR
, V_EXCHANGE_AMOUNT         IN  NUMBER
)
IS

V_HE_SEQ VARCHAR2(20) := F_CODE('HE', HE_SEQ.NEXTVAL);

BEGIN

INSERT INTO HOST_EXCHANGE_LIST(HOST_EXCHANGE_CODE, HOST_CODE, HOST_EXCHANGE_AMOUNT, HOST_EXCHANGE_DATE)
VALUES(V_HE_SEQ, V_HOST_CODE, V_EXCHANGE_AMOUNT, SYSDATE);

INSERT INTO HOST_EXCHANGE_BANK_INFO (HOST_EXCHANGE_BANK_INFO_CODE, HOST_EXCHANGE_CODE, HOST_BANK_NUMBER) 
VALUES (F_CODE('HEBIF', HEBIF_SEQ.NEXTVAL), V_HE_SEQ, V_HOST_BANK_NUMBER);

-- 커밋
COMMIT;

END;




SELECT *
FROM HOST_EXCHANGE_BANK_INFO;