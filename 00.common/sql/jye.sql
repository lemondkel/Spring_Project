------------------------------------------------------------------------------------------------?�� DELETEMEMBER
/*
deleteAccount(?��?��?��, ?��?��?�� ?��?��) 1

?��?��?��
0. ?��로필?��보에?�� ?��?��코드 ?��?��
1. ?��?��?��?�� ?��?��?��?���? ?��?�� 불�?
2. / 마일리�? ?��?��?��?���? ?��?�� 불�??��
3. ?��?��계좌 ?��?��블에?�� ?��?�� 계좌번호�? ?��루어�? 것들 ?��?��
4. 충전?���?계좌?��?�� ?��?��계좌번호�? ?��루어진것?�� 
   찾아?�� ?��?��
5. 계좌번호 ?��?��블에?�� 계좌 ?��?��
6. ?��로필?��보에?�� ?��?��코드 찾아 ?��?��
7. ?��?��?��?�� ?��?���? insert
*/

--?? ?��?��?�� ?��?�� ?��?�� 
-- ?�� ?��로필?��보에?�� ?��?��코드 ?��?��
SELECT MEMBER_CODE
FROM MEMBER_PROFILE
WHERE MEMBER_NICKNAME='�?감자';
-->
SELECT MEMBER_CODE FROM MEMBER_PROFILE WHERE MEMBER_NICKNAME='�?감자'
;
SELECT * FROM MEMBER_BANK_INFO;

--?�� 멤버?��로필 ?��?��블에 ?��?���? ?��?�� ?�� ?��?���? ?��록하�? ?��?? 멤버
SELECT COUNT(*) AS COUNT
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000009';
-->
SELECT COUNT(*) AS COUNT FROM MEMBER_PROFILE WHERE MEMBER_CODE = 'M000009'
;

--?�� ?��?��?��?�� ?��?���? ?��?�� 
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


--------------------------------------------------------------------- 마일리�?
--?�� 마일리�? ?��?�� ?��?�� 방법 
-- 충전처리?��?��(처리?��것만) 조인 / 충전처리코드 LOAD_TYPE_CODE='LT000001'
-- - ?��?��결제?��?�� 차감
-- + ?��?��?���? 취소?�� ?��?�� ?���? ?��?��
-- + ?��?��?���? 취소?�� ?��?�� ?���? ?��?��
-- - ?��?��?�� ?��?�� 금액
-------------------------------------------


-- 마일리�? 충전 ?��?��
SELECT NVL(SUM(LR.LOAD_AMOUNT), 0)
FROM LOAD_PROC LP
JOIN LOAD_REG LR
ON LP.LOAD_REG_CODE = LR.LOAD_REG_CODE
WHERE LP.LOAD_TYPE_CODE='LT000001' AND LR.MEMBER_CODE='M000003';

-- ?��?�� 결제 ?��?��
SELECT NVL(SUM(P.PACKAGE_PRICE), 0)
FROM BOOK_PAY_LIST BP
JOIN BOOK_LIST B
ON BP.BOOK_CODE = B.BOOK_CODE
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P 
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
WHERE B.MEMBER_CODE='M000002';

          
-- ?��?��?���? 취소?�� ?��?��?�� 경우        
SELECT NVL(SUM(P.PACKAGE_PRICE), 0) AS HOST_CANCEL
FROM HOST_CANCEL_LIST HC
JOIN BOOK_REFUND_LIST BR
ON HC.BOOK_CODE = BR.BOOK_CODE
    JOIN BOOK_LIST B
    ON BR.BOOK_CODE = B.BOOK_CODE
        JOIN APPLY_PACKAGE AP
        ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
            JOIN PACKAGE P
            ON AP.PACKAGE_CODE = P.PACKAGE_CODE
            WHERE B.MEMBER_CODE = 'M000002';

-- ?��?��?���? 취소?�� ?��?��?�� 경우
-- ?��?��?�� 취소?�� 7?��?�� - 100% ?���?, 6~1?��?�� - 50% ?���?
SELECT NVL(SUM
(CASE WHEN (TO_DATE(AP.APPLY_DATE, 'YYYY-MM-DD') - TO_DATE(MC.MEMBER_CANCEL_DATE, 'YYYY-MM-DD')) < 7 
      THEN TRUNC(P.PACKAGE_PRICE * 0.5, -1) -- ?��?��?�� 취소?��?���? ?��?���? ?��?��?�� 6?�� ?��?�� 경우 50?���?
      ELSE TRUNC(P.PACKAGE_PRICE * 1, -1)   -- ?��?��경우 100?���? ?���?, ?��머�? ?��?��?��?��?? ?��?��?�� 처리
      END), 0) AS MEMBER_CANCEL
FROM MEMBER_CANCEL_LIST MC
JOIN BOOK_REFUND_LIST BR
ON MC.BOOK_CODE = BR.BOOK_CODE
    JOIN BOOK_LIST B
    ON BR.BOOK_CODE = B.BOOK_CODE
        JOIN APPLY_PACKAGE AP
        ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
            JOIN PACKAGE P
            ON AP.PACKAGE_CODE = P.PACKAGE_CODE;
            --WHERE B.MEMBER_CODE = 'M000002';

-- ?��?��?���? ?��?��?�� 금액
SELECT NVL(SUM(MEMBER_EXCHANGE_AMOUNT), 0)
FROM MEMBER_EXCHANGE_LIST
WHERE MEMBER_CODE = 'M000002';

--?�� 마일리�? ?��로시??
VARIABLE V_CHANGE NUMBER;

CALL PRC_MEMBER_MILEAGE('M000005', :V_CHANGE);

-- 계좌?���? ?��?���? ?��?�� (MEMBER_BANK_INFO)
SELECT MEMBER_BANK_NUMBER
FROM MEMBER_BANK_INFO
WHERE MEMBER_CODE='M000003';
--> 
SELECT MEMBER_BANK_NUMBER, MEMBER_CODE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000001'
;

--?�� MEMBER_EXCHANGE_BANK_INFO?��?�� 계좌?���? ?��?�� 
DELETE MEMBER_EXCHANGE_BANK_INFO
WHERE MEMBER_BANK_NUMBER 
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
--> 
DELETE MEMBER_EXCHANGE_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;

--?�� 충전?���?계좌?��?�� ?��?��계좌번호�? ?��루어진것?�� 찾아?�� ?��?��
DELETE LOAD_REG_BANK_INFO
WHERE MEMBER_BANK_NUMBER
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
-->
DELETE LOAD_REG_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;

--?�� 멤버계좌?��보에?�� ?��?��계좌번호 찾아 ?��?��
DELETE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003';

--?�� 멤버?��로필?��?�� ?��?��멤버 ?��?��
DELETE FROM MEMBER_PROFILE WHERE MEMBER_CODE='M000003';

--?�� ?��?�� ?��?���? INSERT 
INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) 
VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003' ,SYSDATE);
;
--> ?���?
INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003',SYSDATE)
;

----------------------------------------------------------------------------------------------
--?�� DELETEHOST

/*
?��?��?��

0. ?��로필?��보에?�� ?��?��코드 ?��?��
1. ?��?��?��?�� ?��?���? ?��?�� 불�??��
2. 마일리�? ?��?��?��?���? ?��?�� 불�??�� 
3. LOC_CONTACT?��?�� ?��?���? ?��?��
4. BIZ_INFO?��?�� ?��?��?��?���? ?��?��
5. LOC_REMOVE(LRM)?�� ?��?��?�� 공간?���? INSERT
6. ?��?��계좌?��?�� ?��?�� 계좌?���? DELETE
7. HOST_BANK_INFO?��?�� ?��?�� ?��?��코드?�� 계좌?���? DELETE
8. HOST_PROFILE?��?�� ?��?�� ?��?��코드?�� ?��?��?���? DELETE
9. HOST_WITHDRAW(HW) ?�� ?��?�� ?��?��코드 ?��?�� INSERT

*/

--?�� ?��?��?�� ?��?�� ?��?��

--?�� ?��?�� 공간?�� ?��?��?��?�� ?��?��
SELECT B.BOOK_CODE, AP.APPLY_PACKAGE_CODE, AP.APPLY_DATE
, P.PACKAGE_CODE, PF.LOC_CODE, L.HOST_CODE
FROM BOOK_LIST B
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
JOIN PACKAGE_FORM PF
ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
JOIN LOC L
ON PF.LOC_CODE = L.LOC_CODE
WHERE AP.APPLY_DATE > SYSDATE AND L.HOST_CODE='H000003';
-->
SELECT COUNT(*) AS COUNT FROM BOOK_LIST B JOIN APPLY_PACKAGE AP ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE JOIN PACKAGE P ON AP.PACKAGE_CODE = P.PACKAGE_CODE JOIN PACKAGE_FORM PF ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE JOIN LOC L ON PF.LOC_CODE = L.LOC_CODE WHERE AP.APPLY_DATE > SYSDATE AND L.HOST_CODE='H000001'
;

-- 마일리�? ?��?�� ?��?��
/*
?��?��?���? ?��?��?�� 취소?�� 경우, ?��?�� ?��?��?��만큼 차감?�� �?격이
?��?��?��?���? ?��?��?��?��. [?��?�� ?��?�� ?��?��블�? �? ?��?��?���? ?���? 차감?�� 금액?��.] 

------------------------------
    ?��?�� ?��?��(?��?��?��)           CAL ?��?���? 
-   마일리�? ?��?�� ?��?��(?��?��?��)  HOST_EXCHANGE_LIST ?��?���? HE
-----------------------------------
*/

-- ?��?��?�� ?��?�� ?��?��?��?�� �?�? �??��?���?
SELECT NVL(SUM(P.PACKAGE_PRICE), 0) AS PACKAGE_PRICE
FROM CAL C 
JOIN BOOK_LIST B
ON C.BOOK_CODE = B.BOOK_CODE
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
WHERE HOST_CODE='H000001';


-- ?��?�� ?��?�� 
SELECT NVL(SUM(HOST_EXCHANGE_AMOUNT), 0) AS HOST_EXCHANGE_AMOUNT
FROM HOST_EXCHANGE_LIST
WHERE HOST_CODE='H000001';

--?�� ?��?��?�� 마일리�? ?��?�� 구하�?
SELECT
(SELECT NVL(SUM(P.PACKAGE_PRICE), 0)
FROM CAL C 
JOIN BOOK_LIST B
ON C.BOOK_CODE = B.BOOK_CODE
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
WHERE HOST_CODE='H000003'
)
-
(SELECT NVL(SUM(HOST_EXCHANGE_AMOUNT), 0)
FROM HOST_EXCHANGE_LIST
WHERE HOST_CODE='H000003'
) AS MILEAGE
FROM DUAL;

--?�� 멤버?��로필 ?��?��블에 ?��?���? ?��?�� ?�� ?��?���? ?��록하�? ?��?? 멤버
SELECT COUNT(*) AS COUNT
FROM HOST_PROFILE
WHERE HOST_CODE = 'H000009';
-->
SELECT COUNT(*) AS COUNT FROM HOST_PROFILE WHERE HOST_CODE = 'H000009'
;

-- !! ?��?���?] LOC ?��?��블에?�� ?��?�� ?��?��코드?�� 공간코드 찾기
SELECT LOC_CODE
FROM LOC
WHERE HOST_CODE = 'H000006';
-->
SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004'
;

--?�� 받아?�� 공간코드?���? LOC_CONTACT?��?�� ?��?���? ?��?��
DELETE LOC_CONTACT WHERE LOC_CODE IN (SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004')
;

--?�� 받아?�� 공간코드?���? BIZ_INFO?��?�� ?��?��?��?���? ?��?��
DELETE BIZ_INFO WHERE LOC_CODE IN (SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004')
;

--?�� LOC_REMOVE(LRM)?�� ?��?��?�� 공간?���? INSERT (?��?���? ?��줘야?�� )
CALL PRC_DEL_LOC_INSERT('H000006')
;
--INSERT INTO LOC_REMOVE(LOC_REMOVE_CODE, LOC_CODE, LOC_REMOVE_DATE)
--VALUES(F_CODE('LRM', LRM_SEQ.NEXTVAL), 'L000001', SYSDATE);


-- !! ?��?���?] 계좌?���? ?��?���? ?��?�� (HOST_BANK_INFO)
SELECT HOST_BANK_NUMBER, HOST_CODE
FROM HOST_BANK_INFO
WHERE HOST_CODE='H000004';
--> 
SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000004'
;
-- ?��기서 HOST_BANK_NUMBER 받아?��

--?�� ?��?��계좌?��?�� ?��?�� 계좌?���? DELETE
DELETE 
FROM HOST_EXCHANGE_BANK_INFO
WHERE HOST_BANK_NUMBER IN (SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000001');
-->
DELETE FROM HOST_EXCHANGE_BANK_INFO WHERE HOST_BANK_NUMBER IN (SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000001')
;

--?�� HOST_BANK_INFO?��?�� 계좌번호 ?��?��
DELETE FROM HOST_BANK_INFO WHERE HOST_CODE='H000004';

--?�� HOST_PROFILE?��?�� ?��?��?��번호 ?��?�� 
DELETE FROM HOST_PROFILE WHERE HOST_CODE='H000004';

--?�� ?��?�� ?��?���? INSERT 
INSERT INTO HOST_WITHDRAW(HOST_WITHDRAW_CODE, HOST_CODE, HOST_WITHDRAW_DATE) 
VALUES(F_CODE('HW', HW_SEQ.NEXTVAL), 'H000002' ,SYSDATE);
--> ?���?
INSERT INTO HOST_WITHDRAW(HOST_WITHDRAW_CODE, HOST_CODE, HOST_WITHDRAW_DATE) VALUES(F_CODE('HW', HW_SEQ.NEXTVAL), 'H000002' ,SYSDATE)
;

----------------------------------------------------------------------------------------------
/*
*locationDetail 3
?��
1. 공간?��?��블에?�� ?��?��?�� 공간?�� ?��보�?? 조회?��?�� 쿼리�?
   1-1. 공간?���? : (?��?��?��?��?��?���?) ?��?��?���?, ?��기휴무일, �??��?��무일
   1-2. ?��?��?��?�� : (?��?��?��?��?��?���?) ?��?��?��?��?��?��
   1-3. 주의?��?�� : 주의?��?��.주의?��?�� ?��?��
   1-4. ?��?���? : ?��?�� ?��?��?�� ?��?���? 종류, 종류?��?��?�� ?��?��?�� ?���?
2. ?��?�� 공간?�� 리뷰�? 조회?��?�� 쿼리�?
   (?��?��, 리뷰?��?��, 리뷰?��?��?��?��, ?��?��?��, [?��?��코드])
   2-1. ?��미�?�? ?��?�� 경우 ?��미�??��?��블을 ?��?�� 조회
   2-2. ?��?��?��?��?�� ?��?�� 경우 ?��?��?�� 게시물로 ?��?��?��?�� 블라?��?�� 처리
3. ?��?�� 공간?�� Q&A�? 조회?��?�� 쿼리�?
   3-1. ?��?��?��?��?�� ?��?�� 경우 ?��?��?�� 게시물로 ?��?��?��?�� 블라?��?�� 처리	
4. ?��?�� 리뷰?�� 리뷰?���??�� 조회?��?�� 쿼리�?
   4-1. ?��?��?��?��?�� ?��?�� 경우 ?��?��?�� 게시물로 ?��?��?��?�� 블라?��?�� 처리
5. ?��?�� Q&A?�� Q&A?���??�� 조회?��?�� 쿼리�? 
   5-1. ?��?��?��?��?�� ?��?�� 경우 ?��?��?�� 게시물로 ?��?��?��?�� 블라?��?�� 처리

?��
1. ?���??�� 존재?��?�� 경우 �? ?���??�� 참조?���? ?��?�� 리뷰, Q&A 밑에 ?�� ?�� ?��?���? ?��?��.
2. �??�� API
3. 리뷰, Q&A 목록 ?��?��?�� ?��?�� ?��?��?�� ?��?�� 코드�? 같을 경우 ?��?�� �? ?��?�� 버튼?�� ?��?��?�� ?��?��?��.
4. 리뷰?�� ?��번만 ?��?��?�� �??��?��?��. ?��?�� ?��?���? 같�? ?��?��코드?�� 리뷰�? 존재?��?�� 경우?�� 
?���? ?��?��?�� ?��?��?�� ?��?��?�� 것으�? ?���? ?��?��?�� 불�??��?��?��.  
5. ?��?��?��?��?��?�� ?��짜�?? ?��르면(?��?���? ?��?��?�� ?��짜만 ?��?��?��) ?��?�� ?��짜에 
?��?�� ?��?���??��?�� ?��?��?�� 박스 ?��?��?���? 보여�?�? ?��?��?�� 버튼?�� ?���??���? 결제�? �??��
*/

SELECT *
FROM LOC_BASIC_INFO;

--?�� 기본?���? -- ?��록완료된 공간?��?�� ?��?��?��
SELECT LB.LOC_NAME, LT.LOC_TYPE
, LB.LOC_SHORT_INTRO, LB.LOC_INTRO
, LB.LOC_ADDR, LB.LOC_DETAIL_ADDR
, LD.MIN_PEOPLE, LD.MAX_PEOPLE
, L.LOC_REG_DATE, H.HOST_NICKNAME
FROM LOC_BASIC_INFO LB
JOIN LOC_TYPE LT 
ON LB.LOC_TYPE_CODE = LT.LOC_TYPE_CODE
    JOIN LOC_DETAIL_INFO LD
    ON LB.LOC_CODE = LD.LOC_CODE
        JOIN LOC L
        ON LB.LOC_CODE = L.LOC_CODE
            JOIN HOST_PROFILE H
            ON L.HOST_CODE = H.HOST_CODE;
--> 뷰로 ?��?��
SELECT LOC_NAME, LOC_TYPE, LOC_SHORT_INTRO, LOC_INTRO
, LOC_ADDR, LOC_DETAIL_ADDR, MIN_PEOPLE, MAX_PEOPLE
, LOC_REG_DATE, HOST_NICKNAME, HOST_CODE
FROM VIEW_BASIC_INFO
WHERE LOC_CODE = 'L000001';

SELECT *
FROM LOC;

SELECT *
FROM LOC_DETAIL_INFO;







--?�� 공간?���? 
SELECT LOC_USE_HOUR, LOC_USE_DAY_OFF, LOC_USE_APPOINT_DAY_OFF
FROM LOC_USE_INFO
WHERE LOC_CODE='L000001';
--> 
SELECT LOC_USE_HOUR, LOC_USE_DAY_OFF, LOC_USE_APPOINT_DAY_OFF, LOC_CODE
FROM VIEW_USING_HOUR
WHERE LOC_CODE='L000001';

--?�� ?��?��?��?��
SELECT F.FACILITY_CODE, F.LOC_BASIC_INFO_CODE, F.FACILITY_CONTENT
, L.LOC_CODE 
FROM FACILITY_INFO F
JOIN LOC_BASIC_INFO L
ON F.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE
WHERE LOC_CODE='L000001';
--> �?
SELECT FACILITY_CONTENT FROM VIEW_FACILITY_INFO WHERE LOC_CODE='L000001'
;


--?�� 주의?��?��
SELECT CAUTION_CONTENT
FROM CAUTION C
JOIN LOC_BASIC_INFO L
ON C.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE
WHERE LOC_CODE='L000001';
--> �?
SELECT CAUTION_CONTENT FROM VIEW_CAUTION_CONTENT 
WHERE LOC_CODE='L000001'
;

--?�� ?��?�� 공간?�� ?��?��?�� ?��?���? 
--> �? ?��?��
SELECT LOC_CODE, PACKAGE_NAME, PACKAGE_START, PACKAGE_END
, PACKAGE_PRICE, APPLY_DATE, APPLY_PACKAGE_CODE
, COUNT
FROM VIEW_APPLY_PACKAGE_INFO;
WHERE LOC_CODE = 'L000006' AND APPLY_DATE='2021-02-02' AND COUNT=0;

--?�� ?��?��?��?���?
SELECT BIZ_NAME, BIZ_CEO, BIZ_CEO_TYPE,
BIZ_MAIN_TYPE, BIZ_SUB_TYPE, BIZ_LICENSE_NUMBER
FROM BIZ_INFO B
WHERE LOC_CODE='L000001';
    



--?�� QNA 조회
SELECT Q.LOC_CODE, Q.QNA_CODE, Q.MEMBER_CODE, Q.QNA_CONTENT, Q.QNA_DATE
, NVL(M.MEMBER_NICKNAME, '(?��?��?��?��)') AS MEMBER_NICKNAME
, (SELECT COUNT(*) FROM QNA_REPLY QR WHERE Q.QNA_CODE=QR.QNA_CODE) AS REPLYCOUNT
, (SELECT COUNT(*) FROM QNA_REMOVE QRM WHERE Q.QNA_CODE=QRM.QNA_CODE) AS QNAREMOVECOUNT
, (SELECT COUNT(*) FROM QNA_REPLY_REMOVE QRM WHERE QR.QNA_REPLY_CODE=QRM.QNA_REPLY_CODE) AS QNAREPLYREMOVECOUNT
, L.HOST_CODE, QR.QNA_REPLY_CONTENT, QR.QNA_REPLY_DATE, L.HOST_CODE, QR.QNA_REPLY_CODE
FROM QNA Q
LEFT JOIN MEMBER_PROFILE M      -- LEFT 조인 ?��?�� ?��?��?��?��?���? ?��?���??��
ON Q.MEMBER_CODE = M.MEMBER_CODE
    LEFT JOIN QNA_REPLY QR
    ON Q.QNA_CODE = QR.QNA_CODE
        JOIN LOC L
        ON Q.LOC_CODE = L.LOC_CODE;
--> �? 만들�?
SELECT QNA_CODE, MEMBER_NICKNAME, QNA_CONTENT, QNA_DATE, MEMBER_CODE, REPLYCOUNT
, QNAREMOVECOUNT, QNAREPLYREMOVECOUNT
, HOST_CODE, QNA_REPLY_CONTENT, QNA_REPLY_DATE, QNA_REPLY_CODE
FROM VIEW_QNA
WHERE LOC_CODE='L000001';


--?�� ?��?�� 공간?�� q&a �??��
SELECT COUNT(*) AS COUNT FROM VIEW_QNA WHERE LOC_CODE='L000001'
;


--?�� QNA ?���? 조회
SELECT QNA_REPLY_CONTENT, QNA_REPLY_DATE
FROM QNA_REPLY QR;

--?�� 리뷰 조회
SELECT R.REVIEW_CODE, NVL(M.MEMBER_NICKNAME, '(?��?��?��?��)') AS MEMBER_NICKNAME
, R.LOC_CODE, R.REVIEW_RATE, R.REVIEW_CONTENT, R.REVIEW_DATE
, RVIMG.REVIEW_IMG_URL
, (SELECT COUNT(*) FROM REVIEW_IMG RVIMG
    WHERE R.REVIEW_CODE=RVIMG.REVIEW_CODE) AS RVIMGCOUNT
, (SELECT COUNT(*) FROM REVIEW_REMOVE RVRM 
    WHERE R.REVIEW_CODE=RVRM.REVIEW_CODE) AS REVIEWREMOVECOUNT
, (SELECT COUNT(*) FROM REVIEW_REPLY RR 
    WHERE R.REVIEW_CODE=RR.REVIEW_CODE) AS REPLYCOUNT
, (SELECT COUNT(*) FROM REVIEW_REPLY_REMOVE RRM 
    WHERE RR.REVIEW_REPLY_CODE=RRM.REVIEW_REPLY_CODE) AS REPLYREMOVECOUNT
, M.MEMBER_CODE, RR.REVIEW_REPLY_CONTENT, RR.REVIEW_REPLY_DATE, L.HOST_CODE
, RR.REVIEW_REPLY_CODE
FROM REVIEW R
LEFT JOIN MEMBER_PROFILE M
ON R.MEMBER_CODE = M.MEMBER_CODE
    LEFT JOIN REVIEW_IMG RVIMG
    ON R.REVIEW_CODE = RVIMG.REVIEW_CODE
        LEFT JOIN REVIEW_REPLY RR
        ON R.REVIEW_CODE = RR.REVIEW_CODE
            JOIN LOC L
            ON R.LOC_CODE = L.LOC_CODE
ORDER BY R.REVIEW_DATE DESC;
-->�?
SELECT REVIEW_CODE, MEMBER_NICKNAME, REVIEW_RATE, REVIEW_CONTENT, REVIEW_DATE
, REVIEW_IMG_URL, RVIMGCOUNT, REVIEWREMOVECOUNT, REPLYCOUNT, REPLYREMOVECOUNT
, MEMBER_CODE, REVIEW_REPLY_CONTENT, REVIEW_REPLY_DATE, HOST_CODE, REVIEW_REPLY_CODE
FROM VIEW_REVIEW WHERE LOC_CODE='L000003'
;


--?�� ?��?�� 공간?�� 리뷰 �??��
SELECT * FROM VIEW_REVIEW WHERE LOC_CODE='L000001'
;

--?�� ?��?��?�� : QnA ?��?��
INSERT INTO QNA(QNA_CODE, LOC_CODE, MEMBER_CODE, QNA_CONTENT, QNA_DATE)
VALUES(F_CODE('Q', Q_SEQ.NEXTVAL), 'L000001' ,'M000001', '?��?��받�? ?��?�� ?��기기', SYSDATE)
;

--?�� ?��?��?�� : QnA ?��?��?�� ?��?�� �??��?���?
SELECT QNA_CODE, LOC_CODE, QNA_CONTENT
FROM QNA
WHERE QNA_CODE='Q000024';


--?�� ?��?��?�� : QnA ?��?��
UPDATE QNA SET QNA_CONTENT = '?��?��?�� 콘텐츠입?��?��.', QNA_DATE=SYSDATE WHERE QNA_CODE = 'Q000001';
;

--?�� ?��?��?�� : QnA ?��?��
INSERT INTO QNA_REMOVE (QNA_REMOVE_CODE, QNA_CODE, QNA_REMOVE_DATE) VALUES(F_CODE('QRM', QRM_SEQ.NEXTVAL), 'Q000001', SYSDATE)
;

--?�� ?��?��?�� ?��?��?��?��?���? ?��?��(?��기작?�� 버튼 출력?���?)
SELECT B.MEMBER_CODE, A.APPLY_PACKAGE_CODE, F.LOC_CODE
, A.APPLY_DATE
FROM BOOK_LIST B
JOIN APPLY_PACKAGE A
ON B.APPLY_PACKAGE_CODE = A.APPLY_PACKAGE_CODE
    JOIN PACKAGE P
    ON A.PACKAGE_CODE = P.PACKAGE_CODE
        JOIN PACKAGE_FORM F
        ON P.PACKAGE_FORM_CODE = F.PACKAGE_FORM_CODE
WHERE NOT EXISTS (SELECT MCL.BOOK_CODE FROM MEMBER_CANCEL_LIST MCL);
-- �? ?��?��
SELECT COUNT(*) AS COUNT
FROM VIEW_MEMBER_BOOK
WHERE MEMBER_CODE='M000001';

SELECT BOOK_CODE
FROM MEMBER_CANCEL_LIST;


-- 1. ?��?�� 공간?�� ???�� 취소?���? ?��?? ?��?�� ?��?���?... 1 ?��?��?���? 
-- 2. ?��?�� 공간?�� ???�� ?��?��?�� 리뷰개수�? ?��?��?��?��보다 ?��?���?...!

----------------------------------------------------------------------------------------------
/*
* bookApply 5
?��
1. 공간?��?��블에?�� ?��?��?�� 공간?�� ?��보�?? 조회?��?�� 쿼리�?
   1-1. 기본?���? : 공간?���?(공간?��줄소�?), 공간?��?��, ?��?��?��?��(최소,최�?)
   1-2. ?��?��?���? : ?��?��?���?(?��?��?��?���?.?��?��?��?��), ?��?��?��?��(?��?��?���?로�??�� 받아?��)
   1-3. ?��?��?��?���? : (?��?��?��값으�? ?��?��경우)?��?��?���?(?���?, ?��메일, ?��?���?)
   1-4. ?��?��?��?���? : 공간?��?���?, ???��?���?, ?��?���?, ?��?��?��번호, ?��?���?(?��메일, ?��???��, ???��?��?��)
   1-5. 주의?��?�� : 주의?��?��.주의?��?�� ?��?��
?��
1. ?��?��?��?��보는 직접 ?��?��?�� �??��?���?�? 체크 버튼?�� ?��?�� ?��?�� 로그?��?�� ?��?��?�� ?��보�?? ?��?��?��값으�? 받아?�� ?�� ?��?���? 
2. ?��?��?��?��?��?�� 미입?��, ?��비스 ?��?���? ?���? ?��?���? 결제 불�??��
*/


--?�� ?��?��?��?���?
SELECT MEMBER_NAME, MEMBER_EMAIL, MEMBER_TEL, MEMBER_CODE, 
FROM MEMBER_PROFILE;

--?�� ?��?��?��?���?
SELECT B.BIZ_NAME, B.BIZ_CEO, B.BIZ_CEO_TYPE,
B.BIZ_MAIN_TYPE, B.BIZ_SUB_TYPE, B.BIZ_LICENSE_NUMBER
, LC.LOC_EMAIL, LC.LOC_TEL, LC.LOC_MAIN_TEL
, B.BIZ_ADDR, B.LOC_CODE
FROM BIZ_INFO B
    JOIN LOC_CONTACT LC
    ON B.LOC_CODE = LC.LOC_CODE
WHERE B.LOC_CODE='L000001';
--
SELECT LOC_CODE, BIZ_NAME, BIZ_CEO, BIZ_LICENSE_NUMBER
, BIZ_ADDR, LOC_EMAIL, LOC_TEL, LOC_MAIN_TEL 
FROM VIEW_BIZ_CONTACT
WHERE LOC_CODE = 'L000001';

--?�� 멤버 ?��로필 �??��?���?
SELECT MEMBER_CODE, MEMBER_NAME, MEMBER_TEL
FROM MEMBER_PROFILE
WHERE MEMBER_CODE='M000004';


--?�� ?��?��?�� ?��?���? ?���? 조회(?��?���?코드 ?��?��?�� ?��?���??��)
SELECT PF.LOC_CODE, P.PACKAGE_CODE, P.PACKAGE_FORM_CODE, P.PACKAGE_NAME
, P.PACKAGE_START, P.PACKAGE_END, P.PACKAGE_PRICE, AP.APPLY_DATE, AP.APPLY_PACKAGE_CODE
FROM PACKAGE P
JOIN PACKAGE_FORM PF
ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
    JOIN APPLY_PACKAGE AP
    ON P.PACKAGE_CODE = AP.PACKAGE_CODE;
--> 뷰로 보기
SELECT PACKAGE_NAME, APPLY_PACKAGE_CODE
, PACKAGE_START, PACKAGE_END, PACKAGE_PRICE, APPLY_DATE
, NVL(PACKAGE_END, 0) - NVL(PACKAGE_START, 0) AS HOURS
FROM VIEW_APPLY_PACKAGE_INFO
WHERE APPLY_PACKAGE_CODE = 'AP000004';


--?�� 마일리�? ?��?���? ?��?�� ?��?��?��?���? insert
INSERT INTO BOOK_LIST (BOOK_CODE, MEMBER_CODE, APPLY_PACKAGE_CODE
, BOOK_PEOPLE, BOOK_DATE, BOOK_REQ)
VALUES(F_CODE('BC', BC_SEQ.NEXTVAL), 'M000001', 'AP000001', 3, SYSDATE, '?��?��주세?��');

--?�� 방금 ?�� ?��?��번호 �??��?��
SELECT BOOK_CODE
FROM 
(SELECT BOOK_CODE FROM BOOK_LIST WHERE MEMBER_CODE='M000001' ORDER BY BOOK_CODE DESC)
WHERE ROWNUM=1;

--?�� ?��?��?��?�� ?��?���? insert
INSERT INTO ACTUAL_BOOKER (ACTUAL_BOOKER_CODE, BOOK_CODE, ACTUAL_BOOKER
, ACTUAL_BOOKER_TEL)
VALUES(F_CODE('AB', AB_SEQ.NEXTVAL), 'BC000006', '진짜?��??', '010-3690-7828');


--?�� ?��?��결제?��?�� ?��?���? insert
INSERT INTO BOOK_PAY_LIST(BOOK_PAY_CODE, BOOK_CODE, BOOK_PAY_DATE)
VALUES(F_CODE('BP', BP_SEQ.NEXTVAL), 'BC000006', SYSDATE);


--?�� 마일리�? ?��?���? 결제?��?���?�? ?��?��

insert into load_reg(load_reg_code, member_code, load_amount, load_reg_date)
values(F_CODE('LR',LR_SEQ.NEXTVAL), 'M000002', '500000', SYSDATE);

COMMIT;

INSERT INTO LOAD_PROC(LOAD_PROC_CODE, LOAD_REG_CODE, LOAD_TYPE_CODE, LOAD_PROC_DATE)
VALUES(F_CODE('LP', LP_SEQ.NEXTVAL), 'LR000008', 'LT000001', SYSDATE);

update apply_package
set 
apply_date = to_date('2021-02-02', 'yyyy-mm-dd')
where apply_package_code='AP000004';

select *
from book_list;

EXEC PRC_BOOK_CODE_INSERT('M000002', '�??��무개', '010-3690-7828');


--------------------------------------------------------------------------------
--?? BookApplyNotice.jsp
/*
결제?��?�� ?��?��
?��?��?���?
진영??
?��?���?
010-1234-1234
?��메일
papajon@lookation.com
?��?��?��
3�?
?���??��?��
고통?�� 멈춰주세?��
결제금액
200,000

*/
SELECT A.ACTUAL_BOOKER, A.ACTUAL_BOOKER_TEL, B.BOOK_PEOPLE, B.BOOK_DATE, B.BOOK_REQ
, AP.APPLY_DATE, P.PACKAGE_NAME, P.PACKAGE_START, P.PACKAGE_END
, P.PACKAGE_PRICE
FROM BOOK_LIST B
    JOIN ACTUAL_BOOKER A
    ON B.BOOK_CODE = A.BOOK_CODE
        JOIN APPLY_PACKAGE AP
        ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
            LEFT JOIN PACKAGE P
            ON AP.PACKAGE_CODE = P.PACKAGE_CODE;

SELECT BOOK_CODE, ACTUAL_BOOKER, ACTUAL_BOOKER_TEL, BOOK_PEOPLE, BOOK_REQ
, APPLY_DATE, PACKAGE_NAME, PACKAGE_START, PACKAGE_END
, PACKAGE_PRICE
FROM VIEW_BOOKAPPLYNOTICE
WHERE BOOK_CODE = (SELECT BOOK_CODE
                     FROM 
                    (SELECT BOOK_CODE 
                       FROM BOOK_LIST 
                      WHERE MEMBER_CODE='M000005' 
                   ORDER BY BOOK_CODE DESC)
                   WHERE ROWNUM=1);
                   
                   
/*
* bookList 5
?��
1. ?��?�� ?��?���? ?��보�?? 조회?��?�� 쿼리�?
   (?��?��코드, ?��?��?���?, 공간�?, ?��?��, ?��?��?��, �?�?, ?���??��?��, ?��?��)
2. ?��?��취소 ?���??�� ?��?��취소 ?��?��블에 ?��?��?�� INSERT 쿼리�? 
?��
1. �??��?? ?��?��?�� ?��?��
2. 최신 ?��?���? ?��?�� ?��?��.
3. 공간명을 ?��?���? ?���? ?��?��보기 ?��?��?���?(?��?��?��?��?��, ?���??��?��, �?�?)
   ?��머�?(?��?��코드, ?��?��?���?, ?��?��?��?��, ?��?��취소)?�� 리스?���? 보여�?
4. 취소 ?���??�� 취소?��?���? ?��?��?���? ?��?�� ?��?��창이 ?��?��


*/

-- ?��?��?��?��(?��?���? ?���?, ?���? �? 몇시�?) 공간�? ?��?��?��?��, 
SELECT DISTINCT B.BOOK_CODE, B.MEMBER_CODE, A.APPLY_PACKAGE_CODE, F.LOC_CODE
, TO_DATE(A.APPLY_DATE,'YYYY-MM-DD') AS APPLY_DATE, P.PACKAGE_CODE, P.PACKAGE_NAME
, P.PACKAGE_START, P.PACKAGE_END
, NVL(P.PACKAGE_END, 0) - NVL(P.PACKAGE_START, 0) AS BOOK_HOUR
, (SELECT COUNT(*) FROM HOST_CANCEL_LIST HC WHERE B.BOOK_CODE = HC.BOOK_CODE) AS HOST_CANCEL
, (SELECT COUNT(*) FROM MEMBER_CANCEL_LIST MC WHERE B.BOOK_CODE = MC.BOOK_CODE) AS MEMBER_CANCEL
, (SELECT COUNT(*) FROM BOOK_REFUND_LIST BRF WHERE B.BOOK_CODE = BRF.BOOK_CODE) AS REFUND
, LBIF.LOC_NAME, AB.ACTUAL_BOOKER, AB.ACTUAL_BOOKER_TEL
, B.BOOK_PEOPLE, BOOK_DATE, BOOK_REQ, P.PACKAGE_PRICE
, BZ.BIZ_NAME, BZ.BIZ_CEO, BIZ_LICENSE_NUMBER
, MC.MEMBER_CANCEL_REASON, HC.HOST_CANCEL_REASON
, MP.MEMBER_EMAIL, LBIF.LOC_ADDR, LBIF.LOC_DETAIL_ADDR
, MP.MEMBER_NICKNAME
FROM BOOK_LIST B
JOIN APPLY_PACKAGE A
ON B.APPLY_PACKAGE_CODE = A.APPLY_PACKAGE_CODE
    JOIN PACKAGE P
    ON A.PACKAGE_CODE = P.PACKAGE_CODE
        JOIN PACKAGE_FORM F
        ON P.PACKAGE_FORM_CODE = F.PACKAGE_FORM_CODE
            JOIN REVIEW R
            ON B.MEMBER_CODE = R.MEMBER_CODE
                JOIN LOC_BASIC_INFO LBIF
                ON F.LOC_CODE = LBIF.LOC_CODE
                    JOIN ACTUAL_BOOKER AB
                    ON B.BOOK_CODE=AB.BOOK_CODE
                        JOIN BIZ_INFO BZ
                        ON F.LOC_CODE = BZ.LOC_CODE
                            LEFT JOIN HOST_CANCEL_LIST HC
                            ON B.BOOK_CODE = HC.BOOK_CODE
                                LEFT JOIN MEMBER_CANCEL_LIST MC
                                ON B.BOOK_CODE = MC.BOOK_CODE
                                    JOIN MEMBER_PROFILE MP
                                    ON B.MEMBER_CODE = MP.MEMBER_CODE;
--?�� ?��?��보기
SELECT BOOK_CODE, MEMBER_CODE, APPLY_PACKAGE_CODE, LOC_CODE
, APPLY_DATE, PACKAGE_CODE, PACKAGE_NAME
, PACKAGE_START, PACKAGE_END
, BOOK_HOUR, HOST_CANCEL, MEMBER_CANCEL, REFUND, LOC_NAME
FROM VIEW_BOOKLIST
WHERE MEMBER_CODE = 'M000001'
ORDER BY APPLY_DATE;


--?�� ?��?��?��?��
SELECT BOOK_CODE, MEMBER_CODE
, APPLY_DATE, PACKAGE_NAME
, PACKAGE_START, PACKAGE_END
, BOOK_HOUR, HOST_CANCEL, MEMBER_CANCEL, REFUND, LOC_NAME
, ACTUAL_BOOKER, ACTUAL_BOOKER_TEL
, BOOK_PEOPLE, BOOK_DATE, BOOK_REQ, PACKAGE_PRICE
, BIZ_NAME, BIZ_CEO, BIZ_LICENSE_NUMBER
, MEMBER_CANCEL_REASON, HOST_CANCEL_REASON
, MEMBER_EMAIL, LOC_ADDR, LOC_DETAIL_ADDR
, MEMBER_NICKNAME
FROM VIEW_BOOKLIST
WHERE BOOK_CODE = 'BC000001';



--?�� ?��불계?��
/*
?��?��?��?��?��?�� 4?�� ?��?���?�?
?��?�� �?격의 50%?�� 100,000?��?�� 마일리�?�? ?��불됩?��?��.
*/
--?�� 취소?��?�� ?���? 계산
SELECT BOOK_CODE, BOOK_HOUR, LOC_NAME
, APPLY_DATE, PACKAGE_START, PACKAGE_END
, PACKAGE_PRICE
, TO_DATE(APPLY_DATE, 'YYYY-MM-DD')- TRUNC(TO_DATE(SYSDATE, 'YYYY-MM-DD')) AS DAYS --0 ?���? ?��?��// 취소버튼 비활
FROM VIEW_BOOKLIST;
WHERE BOOK_CODE = 'BC000001';

--?�� 취소버튼 ?���??�� 취소?��?�� 추�?
INSERT INTO MEMBER_CANCEL_LIST (MEMBER_CANCEL_CODE, BOOK_CODE, MEMBER_CANCEL_REASON, MEMBER_CANCEL_DATE)
VALUES(F_CODE('MC', MC_SEQ.NEXTVAL), 'BC000003', '?��?��?��?�� ?��갈랍?��?��', SYSDATE);

--?�� ?��?�� ?���? ?��?�� 추�? 
INSERT INTO BOOK_REFUND_LIST (BOOK_REFUND_CODE, BOOK_CODE, BOOK_REFUND_DATE)
VALUES(F_CODE('BRF', BRF_SEQ.NEXTVAL), 'BC000003', SYSDATE);

--?�� ?��?��?�� �??��
SELECT MEMBER_NICKNAME
FROM MEMBER_PROFILE
WHERE MEMBER_CODE='M000002';


--------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--?�� userReviewList

SELECT *
FROM REVIEW;

--?�� ?��?��?�� : 리뷰 ?��?��
INSERT INTO REVIEW(REVIEW_CODE, LOC_CODE, MEMBER_CODE, REVIEW_RATE, REVIEW_CONTENT, REVIEW_DATE)
VALUES(F_CODE('RV', RV_SEQ.NEXTVAL), 'L000003', 'M000005', 3, '?��?��?��베이?���? 리뷰�? ?��봅니?��... ?��?��?��', SYSDATE);


--?�� ?��?��?�� : 리뷰 ?��?��?�� ?��?�� �??��?���?
SELECT REVIEW_CODE, LOC_CODE, REVIEW_CONTENT, REVIEW_RATE
FROM REVIEW
WHERE REVIEW_CODE='RV000001';

--?�� ?��?��?�� : 리뷰 ?��?��
UPDATE REVIEW
SET REVIEW_RATE=4, REVIEW_CONTENT='?��?���?', REVIEW_DATE=SYSDATE
WHERE REVIEW_CODE = 'RV000001';

--?�� ?��?��?�� : 리뷰 ?��?��
INSERT INTO REVIEW_REMOVE(REVIEW_REMOVE_CODE, REVIEW_CODE, REVIEW_REMOVE_DATE)
VALUES(F_CODE('RVRM', RV_SEQ.NEXTVAL), 'RV000010', SYSDATE);


--?�� ?��?��?�� : 리뷰 ?���? ?��?��
INSERT INTO REVIEW_REPLY (REVIEW_REPLY_CODE, REVIEW_CODE, REVIEW_REPLY_CONTENT, REVIEW_REPLY_DATE)
VALUES(F_CODE('RVRE', RVRE_SEQ.NEXTVAL), 'RV000006', '컨텐�?', SYSDATE);

--?�� ?��?��?�� : 리뷰 ?��?��?�� 불러?���?
SELECT REVIEW_REPLY_CODE, REVIEW_REPLY_CONTENT
FROM REVIEW_REPLY
WHERE REVIEW_REPLY_CODE='RVRE000001';

--?�� ?��?��?�� : 리뷰 ?���? ?��?��
UPDATE REVIEW_REPLY
SET REVIEW_REPLY_CONTENT='?��?���?', REVIEW_REPLY_DATE=SYSDATE
WHERE REVIEW_REPLY_CODE='RVRE000001';


--?�� ?��?��?�� : 리뷰?���? ?��?��?��
INSERT INTO REVIEW_REPLY_REMOVE (REVIEW_REPLY_REMOVE_CODE, REVIEW_REPLY_CODE, REVIEW_REPLY_REMOVE_DATE)
VALUES(F_CODE('RVRERM', RVRERM_SEQ.NEXTVAL), 'RVRE000004', SYSDATE);


--?�� ?��?��?�� : QNA ?���? ?��?��
INSERT INTO QNA_REPLY (QNA_REPLY_CODE, QNA_CODE, QNA_REPLY_CONTENT, QNA_REPLY_DATE)
VALUES(F_CODE('QRE', QRE_SEQ.NEXTVAL), 'Q000001', '?���? ?��?��?��.', SYSDATE);


--?�� ?��?��?�� : QNA ?��?��?�� 불러?���?
SELECT QNA_REPLY_CODE, QNA_REPLY_CONTENT
FROM QNA_REPLY
WHERE QNA_REPLY_CODE ='QRE000001';

--?�� ?��?��?�� : QNA ?���? ?��?��
UPDATE QNA_REPLY
SET QNA_REPLY_CONTENT='?��?��', QNA_REPLY_DATE=SYSDATE
WHERE QNA_REPLY_CODE='QRE000001';


--?�� ?��?��?�� : QNA ?���? ?��?��
INSERT INTO QNA_REPLY_REMOVE(QNA_REPLY_REMOVE_CODE, QNA_REPLY_CODE, QNA_REPLY_REMOVE_DATE)
VALUES(F_CODE('QRERM', QRERM_SEQ.NEXTVAL), 'QRE000001', SYSDATE); 


--?�� 리뷰 ?���? 별점 구하�?
SELECT ROUND(AVG(NVL(REVIEW_RATE, 0)), 2) AS AVGSTAR
FROM REVIEW
WHERE LOC_CODE='L000007';

SELECT *
FROM REVIEW;

--------------------------------------------------------------------------------
/*
*userQnaList 6(X)
?��
1. ?��?��?���? ?��?��?�� QnA�? 조회?��?�� 쿼리�?
    (Q&A코드, ?��?��공간�?, ?��?��, ?��?��?��)
   1-1. ?��?��?�� QnA?? 조인?��?�� ?��?��?���?�? ?��?�� ?���?
2. ?��?��버튼 ?���??�� ?��?��?��?��?�� ?��?�� QnA코드�? 참조?��?�� ?��?��?���? INSERT
?��
1. ?��?��?�� Q&A 경우?��?�� 보여주�? ?��?��?��.
2. ?��?��?��?��?�� ?���?
*/

--?�� ?��?��?���? ?��?��?�� QnA
SELECT Q.QNA_CODE, Q.LOC_CODE, Q.MEMBER_CODE
, Q.QNA_CONTENT, Q.QNA_DATE, LBIF.LOC_NAME
, (SELECT COUNT(*) FROM QNA_REMOVE QRM WHERE Q.QNA_CODE = QRM.QNA_CODE) AS REMOVECOUNT
FROM QNA Q
JOIN LOC L
ON Q.LOC_CODE = L.LOC_CODE
    JOIN LOC_BASIC_INFO LBIF
    ON L.LOC_CODE = LBIF.LOC_CODE;
    
-- 뷰에?��
SELECT QNA_CODE, LOC_CODE, MEMBER_CODE
, QNA_CONTENT, QNA_DATE, LOC_NAME
, REMOVECOUNT
FROM VIEW_USER_QNA
WHERE MEMBER_CODE='M000002'
ORDER BY QNA_CODE DESC;

--?�� ?��?��버튼 ?���??�� QNA REMOVE
INSERT INTO QNA_REMOVE (QNA_REMOVE_CODE, QNA_CODE, QNA_REMOVE_DATE)
VALUES(F_CODE('QRM', QRM_SEQ.NEXTVAL), 'Q000001', SYSDATE);

--?�� ?��?? ?��?��?�� �??��
SELECT MEMBER_NICKNAME
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000002';


--?�� ?��?��?���? ?��?��?�� 리뷰
SELECT R.REVIEW_CODE, R.MEMBER_CODE
, R.REVIEW_CONTENT, R.REVIEW_RATE, R.REVIEW_DATE, LBIF.LOC_NAME
, (SELECT COUNT(*) FROM REVIEW_REMOVE RVRM WHERE R.REVIEW_CODE = RVRM.REVIEW_CODE) AS REMOVECOUNT
FROM REVIEW R
JOIN LOC L
ON R.LOC_CODE = L.LOC_CODE
    JOIN LOC_BASIC_INFO LBIF
    ON L.LOC_CODE = LBIF.LOC_CODE;
-- �? ?��?��
SELECT REVIEW_CODE, MEMBER_CODE
, REVIEW_CONTENT, REVIEW_RATE, REVIEW_DATE, LOC_NAME
, REMOVECOUNT
FROM VIEW_USER_REVIEW
WHERE MEMBER_CODE = 'M000001';

----------------------------------------------------------------------------------------------

/*

* hostAccountManager(?��?��?��?��?���?�?) 7
?��
1. ?��?��?�� ?��?��블로 �??�� ?��?��?���? 조회?��?�� 쿼리�?
   (?��?��코드, ?��?��?��, ?��?��?��, 블랙?���?, [블랙처리?��?��])
   1-1. 블랙리스?�� ?��?��블을 ?��?�� 블랙리스?�� ?���? ?��?�� ?��?��
2. 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?��블에 INSERT?��?�� 쿼리�?
3. 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?��블에?�� DELETE?��?�� 쿼리�?
4. ?��고내?��(공간) ?��?��블로 �??�� ?��?��?���? 조회?��?�� 쿼리�?
   (?��고일?��, ?��고사?��, ?��고처리상?��, ?��고유?��) 

?��
1. ?��고내?�� 버튼?��르면 모든 ?��고내?��?�� ?��?��창으�? ?��???��?��.
2. 블랙리스?�� ?��?��?�� ?��?��창으�? ?��?���? ?��?�� ?�� ?���?, ?��?��?��?��?�� ?��림으�? ?��?��?���? ?��?��
*/

--?�� ?��?��?�� 블랙리스?�� ?��?��?��?�� 쿼리
SELECT H.HOST_EMAIL, H.HOST_NICKNAME
, HB.HOST_BLACKLIST_REASON
, (SELECT COUNT(*) FROM HOST_BLACKLIST HB 
    WHERE H.HOST_EMAIL=HB.HOST_EMAIL) AS YESBLACK
FROM HOST_PROFILE H
    LEFT JOIN HOST_BLACKLIST HB
    ON H.HOST_EMAIL = HB.HOST_EMAIL;
-- �?
SELECT HOST_CODE, HOST_EMAIL, HOST_NICKNAME
, HOST_BLACKLIST_REASON, YESBLACK
FROM VIEW_HOSTBLACKLIST;


--?�� ?��?��?�� 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?���? INSERT
SELECT HOST_EMAIL
FROM HOST_PROFILE
WHERE HOST_CODE = 'H000001';

INSERT INTO HOST_BLACKLIST(HOST_EMAIL, HOST_BLACKLIST_REASON, HOST_BLACKLIST_DATE)
VALUES('good1@test.com', '?��?��?��?��', SYSDATE);

-- ?�� 블랙리스?�� ?��?��?�� DELETE
DELETE 
FROM HOST_BLACKLIST
WHERE HOST_EMAIL = 'good1@test.com';


--?�� ?��?��?�� ?��고내?�� ?��?��
-- ?��고횟?��, ?��?��코드, ?��고코?��, ?��고유?��,?��고사?��,?��고일?��
SELECT H.HOST_CODE, L.LOC_CODE, LR.LOC_REPORT_CODE
, LR.MEMBER_CODE, LR.LOC_REPORT_REASON, LR.LOC_REPORT_DATE
, LRPT.LOC_REPORT_TYPE, RPPT.REPORT_PROC_TYPE
FROM HOST H
LEFT JOIN LOC L
ON H.HOST_CODE = L.HOST_CODE
    JOIN LOC_REPORT LR
    ON L.LOC_CODE = LR.LOC_CODE
        JOIN LOC_REPORT_TYPE LRPT
        ON LR.LOC_REPORT_TYPE_CODE=LRPT.LOC_REPORT_TYPE_CODE
            LEFT JOIN LOC_REPORT_PROC LRPP
            ON LR.LOC_REPORT_CODE=LRPP.LOC_REPORT_CODE
                LEFT JOIN REPORT_PROC_TYPE RPPT
                ON LRPP.REPORT_PROC_TYPE_CODE=RPPT.REPORT_PROC_TYPE_CODE;

-- �?
SELECT HOST_CODE, LOC_CODE, LOC_REPORT_CODE
, LOC_REPORT_REASON, LOC_REPORT_DATE
, LOC_REPORT_TYPE, REPORT_PROC_TYPE
FROM VIEW_HOST_REPORTDETAILS
WHERE HOST_CODE ='H000007';
/*

* userAccountManager(?��?��?��?��?���?�?) 7
?��
1. ?��?��?�� ?��?��블로 �??�� ?��?��?���? 조회?��?�� 쿼리�?
   (?��?��코드, ?��?��?��, ?��?��?��, 블랙?���?, [블랙처리?��?��])
   1-1. 블랙리스?�� ?��?��블을 ?��?�� 블랙리스?�� ?���? ?��?�� ?��?��
2. 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?��블에 INSERT?��?�� 쿼리�?
3. 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?��블에?�� DELETE?��?�� 쿼리�?
4. ?��고내?��(?��?��) ?��?��블로 �??�� ?��?��?���? 조회?��?�� 쿼리�?
   (?��고일?��, ?��고사?��, ?��고처리상?��, ?��고유?��) 

?��
1. ?��고내?�� 버튼?��르면 모든 ?��고내?��?�� ?��?��창으�? ?��???��?��.
2. 블랙리스?�� ?��?��?�� ?��?��창으�? ?��?���? ?��?�� ?�� ?���?, ?��?��?��?��?�� ?��림으�? ?��?��?���? ?��?��

* blacklistPopup.jsp 7

* reportDetailPopupHost.jsp 7
* reportDetailPopupUser.jsp 7

*/

--?�� ?��?��?�� 블랙리스?�� ?���? ?��?��?��?�� 쿼리
SELECT M.MEMBER_CODE, M.MEMBER_EMAIL, M.MEMBER_NICKNAME
, MB.MEMBER_BLACKLIST_REASON
, (SELECT COUNT(*) FROM MEMBER_BLACKLIST MB 
    WHERE M.MEMBER_EMAIL=MB.MEMBER_EMAIL) AS YESBLACK
FROM MEMBER_PROFILE M
    LEFT JOIN MEMBER_BLACKLIST MB
    ON M.MEMBER_EMAIL = MB.MEMBER_EMAIL;
-- �?
SELECT MEMBER_CODE, MEMBER_EMAIL, MEMBER_NICKNAME
, MEMBER_BLACKLIST_REASON, YESBLACK
FROM VIEW_MEMBERBLACKLIST;




--?�� 멤버 블랙리스?�� ?��?��?�� 블랙리스?�� ?��?���? INSERT
SELECT MEMBER_EMAIL
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000001';

INSERT INTO MEMBER_BLACKLIST(MEMBER_EMAIL, MEMBER_BLACKLIST_REASON, MEMBER_BLACKLIST_DATE)
VALUES('test2@test.com', '?��?��?��?��', SYSDATE);

-- ?�� 블랙리스?�� ?��?��?�� DELETE
DELETE 
FROM MEMBER_BLACKLIST
WHERE MEMBER_EMAIL = 'test2@test.com';


--?�� ?��?��?�� ?��고내?�� ?��?��
-- ?��?��코드, ?��고코?��, ?��고유?��,?��고사?��,?��고일?��
SELECT B.BOOK_REPORT_CODE, B.BOOK_CODE, BR.BOOK_REPORT_TYPE
, B.BOOK_REPORT_REASON, B.BOOK_REPORT_DATE, BL.MEMBER_CODE
FROM BOOK_REPORT B
JOIN BOOK_REPORT_TYPE BR
ON B.BOOK_REPORT_TYPE_CODE = BR.BOOK_REPORT_TYPE_CODE
    LEFT JOIN BOOK_REPORT_PROC BRP
    ON B.BOOK_REPORT_CODE = BRP.BOOK_REPORT_CODE
        JOIN BOOK_LIST BL
        ON B.BOOK_CODE = BL.BOOK_CODE;

-- �?
SELECT BOOK_REPORT_CODE, BOOK_CODE, BOOK_REPORT_TYPE
, BOOK_REPORT_REASON, BOOK_REPORT_DATE, MEMBER_CODE
FROM VIEW_MEMBER_REPORTDETAILS
WHERE MEMBER_CODE = 'M000001';


----------------------------------------------------------------------------------------------
SELECT *
FROM HOST_MSG_INFO;

-- ?��?��?�� 메신?? 조회
SELECT DISTINCT H.HOST_MSG_INFO_CODE, H.MSG_CODE
, H.HOST_MSG_CONTENT, H.HOST_MSG_DATE
, M.BOOK_CODE
, AP.APPLY_DATE
, B.MEMBER_CODE -- ?��?��?��
, M.MEMBER_NICKNAME
, HP.HOST_CODE
, HP.HOST_NICKNAME -- ?��?��?��
, (SELECT COUNT(*) FROM HOST_MSG_IMG HI
    WHERE H.HOST_MSG_INFO_CODE = HI.HOST_MSG_INFO_CODE) AS H_IMGCOUNT
, HI.HOST_MSG_IMG_URL
FROM MSG M
    JOIN HOST_MSG_INFO H
    ON M.MSG_CODE = H.MSG_CODE
        JOIN BOOK_LIST B
        ON M.BOOK_CODE = B.BOOK_CODE
            JOIN APPLY_PACKAGE AP
            ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
                JOIN PACKAGE P
                ON AP.PACKAGE_CODE = P.PACKAGE_CODE
                    JOIN PACKAGE_FORM PF
                    ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
                        JOIN LOC L
                        ON PF.LOC_CODE = L.LOC_CODE
                            JOIN HOST_PROFILE HP
                            ON L.HOST_CODE = HP.HOST_CODE
                                JOIN MEMBER_PROFILE M  -- 멤버?��?��?�� ?��보임
                                ON B.MEMBER_CODE = M.MEMBER_CODE
                                    LEFT JOIN HOST_MSG_IMG HI
                                    ON H.HOST_MSG_INFO_CODE = HI.HOST_MSG_INFO_CODE;



-- �? ?��?��
SELECT HOST_MSG_INFO_CODE, MSG_CODE
, HOST_MSG_CONTENT, HOST_MSG_DATE
, HOST_CODE, HOST_NICKNAME
, BOOK_CODE, APPLY_DATE
, MEMBER_CODE, MEMBER_NICKNAME
, H_IMGCOUNT, HOST_MSG_IMG_URL
FROM VIEW_HOST_MESSENGER;


-- 멤버 ?��?��?��?�� 메시�? 조회 
SELECT MM.MEMBER_MSG_INFO_CODE, MM.MSG_CODE
, MM.MEMBER_MSG_CONTENT, MM.MEMBER_MSG_DATE
, M.BOOK_CODE
, AP.APPLY_DATE
, B.MEMBER_CODE -- ?��?��?��
, M.MEMBER_NICKNAME
, HP.HOST_CODE
, HP.HOST_NICKNAME -- ?��?��?��
, (SELECT COUNT(*) FROM MEMBER_MSG_IMG MI
    WHERE MM.MEMBER_MSG_INFO_CODE = MI.MEMBER_MSG_INFO_CODE) AS M_IMGCOUNT
, MI.MEMBER_MSG_IMG_URL
FROM MEMBER_MSG_INFO MM
    JOIN MSG M
    ON MM.MSG_CODE = M.MSG_CODE
        JOIN BOOK_LIST B
        ON M.BOOK_CODE = B.BOOK_CODE
            JOIN APPLY_PACKAGE AP
            ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
                JOIN PACKAGE P
                ON AP.PACKAGE_CODE = P.PACKAGE_CODE
                    JOIN PACKAGE_FORM PF
                    ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
                        JOIN LOC L
                        ON PF.LOC_CODE = L.LOC_CODE
                            JOIN HOST_PROFILE HP
                            ON L.HOST_CODE = HP.HOST_CODE
                                JOIN MEMBER_PROFILE M  -- 멤버?��?��?�� ?��보임
                                ON B.MEMBER_CODE = M.MEMBER_CODE
                                    LEFT JOIN MEMBER_MSG_IMG MI
                                    ON MM.MEMBER_MSG_INFO_CODE = MI.MEMBER_MSG_INFO_CODE;

--?�� 메시�? ?���? ?�� 보는 �?
SELECT MSG_CODE, MSG_CONTENT, MSG_DATE
, SENDER_CODE, SENDER
, IMGCOUNT, MSG_IMG_URL
, BOOK_CODE, APPLY_DATE, HORM
FROM VIEW_MESSENGER;

--?�� ?��?��?�� ?��?��?�� 찾기
--?��?��코드�? ?���? ?�� 찾아보기 
SELECT HOST_NICKNAME
FROM VIEW_BOOK_NICKNAME
WHERE BOOK_CODE='BC000001';

--?�� 메신??코드 �??��
SELECT MSG_CODE FROM ( SELECT ROWNUM, MSG_CODE
FROM VIEW_MESSENGER
WHERE BOOK_CODE='BC000001')
WHERE ROWNUM <= 1;

--?�� ?��?��?���? 메시�? ?��?��?��?�� 경우
INSERT INTO MEMBER_MSG_INFO(MEMBER_MSG_INFO_CODE, MSG_CODE, MEMBER_MSG_CONTENT, MEMBER_MSG_DATE)
VALUES(F_CODE('MMIF', MMIF_SEQ.NEXTVAL), 'MSG000001', '?��째서!!', SYSDATE);

--?�� ?��?��?���? ?��미�? ?��?��?��?�� 경우
-- ?��로시?? 
CALL PRC_M_MSG_IMG('BC000001', '?��?��');

--------------------------------------------------------------------------------
--?�� ?��?��?�� 
--?�� ?��??�? ?��?��?�� 찾기
SELECT MEMBER_NICKNAME
FROM VIEW_BOOK_NICKNAME
WHERE BOOK_CODE='BC000001';

--?�� 메신??코드 �??��
SELECT MSG_CODE FROM ( SELECT ROWNUM, MSG_CODE
FROM VIEW_MESSENGER
WHERE BOOK_CODE='BC000001')
WHERE ROWNUM <= 1;

--?�� ?��?��?���? 메시�? ?��?��?��?�� 경우
INSERT INTO HOST_MSG_INFO(HOST_MSG_INFO_CODE, MSG_CODE, HOST_MSG_CONTENT, HOST_MSG_DATE)
VALUES(F_CODE('HMIF', HMIF_SEQ.NEXTVAL), 'MSG000001', '?��째서!!', SYSDATE);


select *
from view_messenger
where book_code='BC000001';

--?�� ?��?��?���? ?��미�? ?��?��?��?�� 경우
-- ?��로시?? 
CALL PRC_H_MSG_IMG('BC000001', '?���? ?��미�? 주소?��!');

SELECT * FROM MSG;

SELECT * FROM REVIEW_IMG;


INSERT INTO REVIEW_IMG(REVIEW_IMG_CODE, REVIEW_CODE, REVIEW_IMG_URL)
VALUES(F_CODE('RVIMG', RVIMG_SEQ.NEXTVAL), 'RV000085', '���ñ�');

ROLLBACK;
SELECT REVIEW_CODE
    FROM
    (SELECT A.REVIEW_CODE, A.MEMBER_CODE
    FROM REVIEW A
    ORDER BY A.REVIEW_DATE DESC)
    WHERE ROWNUM = 1 AND MEMBER_CODE='M000001';


EXEC PRC_REVIEW_IMG('L000001', 'M000002', 4, '�ȳ��ϼ���', 'too.png');