/*
deleteAccount(호스트, 이용자 동일) 1
-----------
MEMBER_WITHDRAW(MW) 에서 해당 회원코드 회원 INSERT
LOAD_PROC(LP) 충전처리내역 DELETE
(충전처리코드, 충전신청코드, 마일리지충전분류코드, 충전처리일자 )
LOAD_REG(LR) 마일리지 충전신청내역(이용자) DELETE
(충전신청코드, 계좌번호, 충전신청액수, 충전신청일자) DELTE 
MEMBER_EXCHANGE_LIST(ME) 마일리지환전내역 DELETE
(환전내역코드, 계좌번호, 환전액수, 환전일자)
MEMBER_BANK_INFO에서 해당 회원코드의 계좌정보 DELETE
(계좌번호, 회원코드, 은행명, 예금주)
MEMBER_PROFILE에서 해당 회원코드인 회원정보 DELETE
(가입 이메일, 회원코드, 비밀번호, 닉네임, 이름, 연락처)

이용자
0. 프로필정보에서 회원코드 확인
1-1. 예약내역 남아있으면 탈퇴 불가
1-2. / 마일리지 남아있으면 탈퇴 불가능
2. 계좌정보에서 계좌번호 확인(여러개) 
3. 환전계좌 테이블에서 해당 계좌번호로 이루어진 것들 삭제
4. 충전신청계좌에서 해당계좌번호로 이루어진것들 
   찾아서 삭제
5. 계좌번호 테이블에서 계좌 삭제
6. 프로필정보에서 회원코드 찾아 삭제
7. 탈퇴회원 테이블 insert
*/

SELECT *
FROM MEMBER_PROFILE;

--※ 이용자 삭제 순서 

-- ○ 프로필정보에서 회원코드 확인
SELECT MEMBER_CODE
FROM MEMBER_PROFILE
WHERE MEMBER_NICKNAME='김감자';
-->
SELECT MEMBER_CODE FROM MEMBER_PROFILE WHERE MEMBER_NICKNAME='김감자'
;
SELECT * FROM MEMBER_BANK_INFO;

--○ 탈퇴내역에서 해당멤버 있는지 확인
SELECT COUNT(*) AS COUNT
FROM MEMBER_WITHDRAW
WHERE MEMBER_CODE = 'M000004'
;
SELECT COUNT(*) AS COUNT FROM MEMBER_WITHDRAW WHERE MEMBER_CODE = 'M000004'
;


--○ 예약내역 있는지 확인 
SELECT B.BOOK_CODE, B.MEMBER_CODE, AP.APPLY_PACKAGE_CODE, AP.APPLY_DATE
, P.PACKAGE_CODE, PF.LOC_CODE
FROM BOOK_LIST B
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
JOIN PACKAGE_FORM PF
ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
WHERE AP.APPLY_DATE > SYSDATE AND B.MEMBER_CODE='M000002';
-->
SELECT COUNT(*) AS COUNT FROM BOOK_LIST B JOIN APPLY_PACKAGE AP ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE JOIN PACKAGE P ON AP.PACKAGE_CODE = P.PACKAGE_CODE JOIN PACKAGE_FORM PF ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE WHERE AP.APPLY_DATE > SYSDATE AND B.MEMBER_CODE='M000002'
;

--○ 마일리지 내역 확인
-- 마일리지 환불비율
-- 


-- !! 여러개] 계좌정보 있는지 확인 (MEMBER_BANK_INFO)
SELECT MEMBER_BANK_NUMBER
FROM MEMBER_BANK_INFO
WHERE MEMBER_CODE='M000003';
--> 
SELECT MEMBER_BANK_NUMBER, MEMBER_CODE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000001'
;
-- 여기서 MEMBER_BANK_NUMBER 받아옴

--○ MEMBER_EXCHANGE_BANK_INFO에서 계좌정보 삭제 
DELETE MEMBER_EXCHANGE_BANK_INFO
WHERE MEMBER_BANK_NUMBER 
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
--> 
DELETE MEMBER_EXCHANGE_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;

--○ 충전신청계좌에서 해당계좌번호로 이루어진것들 찾아서 삭제
DELETE LOAD_REG_BANK_INFO
WHERE MEMBER_BANK_NUMBER
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
-->
DELETE LOAD_REG_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;


--○ 멤버계좌정보에서 해당계좌번호 찾아 삭제
DELETE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003';


--○ 멤버프로필에서 해당멤버 삭제
DELETE FROM MEMBER_PROFILE WHERE MEMBER_CODE='M000003';


--○ 탈퇴 테이블 INSERT 

SELECT *
FROM MEMBER_WITHDRAW;

INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) 
VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003' ,SYSDATE);
;
--> 한줄
INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003',SYSDATE)
;
