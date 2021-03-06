SELECT USER
FROM DUAL;

SELECT *
FROM DBA_USERS;

-- 계정 생성
CREATE USER LOOKATION IDENTIFIED BY java006$;
--==>> User LOOKATION이(가) 생성되었습니다.

-- 접속 DBA 권한 부여
GRANT CONNECT, RESOURCE, DBA TO LOOKATION;
--==>> Grant을(를) 성공했습니다.

-- 프로시저 생성 권한 부여
GRANT CREATE PROCEDURE TO LOOKATION;
--==>> Grant을(를) 성공했습니다.

-- 뷰 생성 권한 부여
GRANT CREATE VIEW TO LOOKATION;
--==>> Grant을(를) 성공했습니다.

-- 트리거 생성 권한 부여
GRANT CREATE TRIGGER TO LOOKATION;
--==>> Grant을(를) 성공했습니다.

-- 테이블 스페이스 권한 부여
GRANT CREATE TABLESPACE TO LOOKATION;
--==>> Grant을(를) 성공했습니다.

/*
-- 암호화 패키지 설치
@E:\oracleexe\app\oracle\product\11.2.0\server\rdbms\admin\dbmsobtk.sql
@E:\oracleexe\app\oracle\product\11.2.0\server\rdbms\admin\prvtobtk.plb

-- 암호화 패키지 사용 권한 부여
GRANT EXECUTE ON DBMS_OBFUSCATION_TOOLKIT TO LOOKATION;
--==>> Grant을(를) 성공했습니다.
*/
