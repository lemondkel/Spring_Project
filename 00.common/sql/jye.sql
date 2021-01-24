------------------------------------------------------------------------------------------------? DELETEMEMBER
/*
deleteAccount(?Έ?€?Έ, ?΄?©? ??Ό) 1

?΄?©?
0. ?λ‘ν? λ³΄μ? ??μ½λ ??Έ
1. ??½?΄?­ ?¨???Όλ©? ??΄ λΆκ?
2. / λ§μΌλ¦¬μ? ?¨???Όλ©? ??΄ λΆκ??₯
3. ?? κ³μ’ ??΄λΈμ? ?΄?Ή κ³μ’λ²νΈλ‘? ?΄λ£¨μ΄μ§? κ²λ€ ?­? 
4. μΆ©μ ? μ²?κ³μ’?? ?΄?Ήκ³μ’λ²νΈλ‘? ?΄λ£¨μ΄μ§κ²?€ 
   μ°Ύμ? ?­? 
5. κ³μ’λ²νΈ ??΄λΈμ? κ³μ’ ?­? 
6. ?λ‘ν? λ³΄μ? ??μ½λ μ°Ύμ ?­? 
7. ??΄?? ??΄λΈ? insert
*/

--?? ?΄?©? ?­?  ?? 
-- ? ?λ‘ν? λ³΄μ? ??μ½λ ??Έ
SELECT MEMBER_CODE
FROM MEMBER_PROFILE
WHERE MEMBER_NICKNAME='κΉ?κ°μ';
-->
SELECT MEMBER_CODE FROM MEMBER_PROFILE WHERE MEMBER_NICKNAME='κΉ?κ°μ'
;
SELECT * FROM MEMBER_BANK_INFO;

--? λ©€λ²?λ‘ν ??΄λΈμ ??μ§? ??Έ ? ??Όλ©? ?±λ‘νμ§? ??? λ©€λ²
SELECT COUNT(*) AS COUNT
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000009';
-->
SELECT COUNT(*) AS COUNT FROM MEMBER_PROFILE WHERE MEMBER_CODE = 'M000009'
;

--? ??½?΄?­ ??μ§? ??Έ 
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


--------------------------------------------------------------------- λ§μΌλ¦¬μ?
--? λ§μΌλ¦¬μ? ?΄?­ ??Έ λ°©λ² 
-- μΆ©μ μ²λ¦¬?΄?­(μ²λ¦¬?κ²λ§) μ‘°μΈ / μΆ©μ μ²λ¦¬μ½λ LOAD_TYPE_CODE='LT000001'
-- - ??½κ²°μ ?΄?­ μ°¨κ°
-- + ?΄?©?κ°? μ·¨μ? ??½ ?λΆ? ?΄?­
-- + ?Έ?€?Έκ°? μ·¨μ? ??½ ?λΆ? ?΄?­
-- - ?΄?©? ??  κΈμ‘
-------------------------------------------


-- λ§μΌλ¦¬μ? μΆ©μ  ?΄?­
SELECT NVL(SUM(LR.LOAD_AMOUNT), 0)
FROM LOAD_PROC LP
JOIN LOAD_REG LR
ON LP.LOAD_REG_CODE = LR.LOAD_REG_CODE
WHERE LP.LOAD_TYPE_CODE='LT000001' AND LR.MEMBER_CODE='M000003';

-- ??½ κ²°μ  ?΄?­
SELECT NVL(SUM(P.PACKAGE_PRICE), 0)
FROM BOOK_PAY_LIST BP
JOIN BOOK_LIST B
ON BP.BOOK_CODE = B.BOOK_CODE
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P 
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
WHERE B.MEMBER_CODE='M000002';

          
-- ?Έ?€?Έκ°? μ·¨μ? ??½? κ²½μ°        
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

-- ?΄?©?κ°? μ·¨μ? ??½? κ²½μ°
-- ?΄?©? μ·¨μ? 7?Ό?  - 100% ?λΆ?, 6~1?Ό?  - 50% ?λΆ?
SELECT NVL(SUM
(CASE WHEN (TO_DATE(AP.APPLY_DATE, 'YYYY-MM-DD') - TO_DATE(MC.MEMBER_CANCEL_DATE, 'YYYY-MM-DD')) < 7 
      THEN TRUNC(P.PACKAGE_PRICE * 0.5, -1) -- ?΄?©? μ·¨μ?Ό?κ°? ?¨?€μ§? ? ?©?Ό 6?Ό ? ?Ό κ²½μ° 50?λ‘?
      ELSE TRUNC(P.PACKAGE_PRICE * 1, -1)   -- ??κ²½μ° 100?λ‘? ?λΆ?, ?λ¨Έμ? ??Έ??©?? ?Ή?? μ²λ¦¬
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

-- ?΄?©?κ°? ?? ? κΈμ‘
SELECT NVL(SUM(MEMBER_EXCHANGE_AMOUNT), 0)
FROM MEMBER_EXCHANGE_LIST
WHERE MEMBER_CODE = 'M000002';

--? λ§μΌλ¦¬μ? ?λ‘μ??
VARIABLE V_CHANGE NUMBER;

CALL PRC_MEMBER_MILEAGE('M000005', :V_CHANGE);

-- κ³μ’? λ³? ??μ§? ??Έ (MEMBER_BANK_INFO)
SELECT MEMBER_BANK_NUMBER
FROM MEMBER_BANK_INFO
WHERE MEMBER_CODE='M000003';
--> 
SELECT MEMBER_BANK_NUMBER, MEMBER_CODE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000001'
;

--? MEMBER_EXCHANGE_BANK_INFO?? κ³μ’? λ³? ?­?  
DELETE MEMBER_EXCHANGE_BANK_INFO
WHERE MEMBER_BANK_NUMBER 
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
--> 
DELETE MEMBER_EXCHANGE_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;

--? μΆ©μ ? μ²?κ³μ’?? ?΄?Ήκ³μ’λ²νΈλ‘? ?΄λ£¨μ΄μ§κ²?€ μ°Ύμ? ?­? 
DELETE LOAD_REG_BANK_INFO
WHERE MEMBER_BANK_NUMBER
IN ( SELECT MEMBER_BANK_NUMBER
     FROM MEMBER_BANK_INFO
     WHERE MEMBER_CODE='M000003');
-->
DELETE LOAD_REG_BANK_INFO WHERE MEMBER_BANK_NUMBER IN ( SELECT MEMBER_BANK_NUMBER FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003')
;

--? λ©€λ²κ³μ’? λ³΄μ? ?΄?Ήκ³μ’λ²νΈ μ°Ύμ ?­? 
DELETE FROM MEMBER_BANK_INFO WHERE MEMBER_CODE='M000003';

--? λ©€λ²?λ‘ν?? ?΄?Ήλ©€λ² ?­? 
DELETE FROM MEMBER_PROFILE WHERE MEMBER_CODE='M000003';

--? ??΄ ??΄λΈ? INSERT 
INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) 
VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003' ,SYSDATE);
;
--> ?μ€?
INSERT INTO MEMBER_WITHDRAW(MEMBER_WITHDRAW_CODE, MEMBER_CODE, MEMBER_WITHDRAW_DATE) VALUES(F_CODE('MW', MW_SEQ.NEXTVAL), 'M000003',SYSDATE)
;

----------------------------------------------------------------------------------------------
--? DELETEHOST

/*
?Έ?€?Έ

0. ?λ‘ν? λ³΄μ? ??μ½λ ??Έ
1. ??½?΄?­ ??Όλ©? ??΄ λΆκ??₯
2. λ§μΌλ¦¬μ? ?¨???Όλ©? ??΄ λΆκ??₯ 
3. LOC_CONTACT?? ?°?½μ²? ?­? 
4. BIZ_INFO?? ?¬??? λ³? ?­? 
5. LOC_REMOVE(LRM)? ?­? ? κ³΅κ°?Όλ‘? INSERT
6. ?? κ³μ’?? ?΄?Ή κ³μ’? λ³? DELETE
7. HOST_BANK_INFO?? ?΄?Ή ??μ½λ? κ³μ’? λ³? DELETE
8. HOST_PROFILE?? ?΄?Ή ??μ½λ?Έ ??? λ³? DELETE
9. HOST_WITHDRAW(HW) ? ?΄?Ή ??μ½λ ?? INSERT

*/

--? ?Έ?€?Έ ?­?  ??

--? ?΄?Ή κ³΅κ°? ??½?΄?­ ??Έ
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

-- λ§μΌλ¦¬μ? ?΄?­ ??Έ
/*
?΄?©?κ°? ??½? μ·¨μ?  κ²½μ°, ?΄?Ή ?Ό?Ό?Έλ§νΌ μ°¨κ°? κ°?κ²©μ΄
?Έ?€?Έ?κ²? ?€?΄?¨?€. [? ?° ?΄?­ ??΄λΈμ? κ·? ?Ό?Ό?Έλ₯? ?΄λ―? μ°¨κ°? κΈμ‘?.] 

------------------------------
    ? ?° ?΄?­(?Έ?€?Έ)           CAL ??΄λΈ? 
-   λ§μΌλ¦¬μ? ??  ?΄?­(?Έ?€?Έ)  HOST_EXCHANGE_LIST ??΄λΈ? HE
-----------------------------------
*/

-- ?Έ?€?Έ ? ?° ?΄?­?? κ°?κ²? κ°?? Έ?€κΈ?
SELECT NVL(SUM(P.PACKAGE_PRICE), 0) AS PACKAGE_PRICE
FROM CAL C 
JOIN BOOK_LIST B
ON C.BOOK_CODE = B.BOOK_CODE
JOIN APPLY_PACKAGE AP
ON B.APPLY_PACKAGE_CODE = AP.APPLY_PACKAGE_CODE
JOIN PACKAGE P
ON AP.PACKAGE_CODE = P.PACKAGE_CODE
WHERE HOST_CODE='H000001';


-- ??  ?΄?­ 
SELECT NVL(SUM(HOST_EXCHANGE_AMOUNT), 0) AS HOST_EXCHANGE_AMOUNT
FROM HOST_EXCHANGE_LIST
WHERE HOST_CODE='H000001';

--? ?Έ?€?Έ λ§μΌλ¦¬μ? ??‘ κ΅¬νκΈ?
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

--? λ©€λ²?λ‘ν ??΄λΈμ ??μ§? ??Έ ? ??Όλ©? ?±λ‘νμ§? ??? λ©€λ²
SELECT COUNT(*) AS COUNT
FROM HOST_PROFILE
WHERE HOST_CODE = 'H000009';
-->
SELECT COUNT(*) AS COUNT FROM HOST_PROFILE WHERE HOST_CODE = 'H000009'
;

-- !! ?¬?¬κ°?] LOC ??΄λΈμ? ?΄?Ή ??μ½λ? κ³΅κ°μ½λ μ°ΎκΈ°
SELECT LOC_CODE
FROM LOC
WHERE HOST_CODE = 'H000006';
-->
SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004'
;

--? λ°μ?¨ κ³΅κ°μ½λ?€λ‘? LOC_CONTACT?? ?°?½μ²? ?­? 
DELETE LOC_CONTACT WHERE LOC_CODE IN (SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004')
;

--? λ°μ?¨ κ³΅κ°μ½λ?€λ‘? BIZ_INFO?? ?¬??? λ³? ?­? 
DELETE BIZ_INFO WHERE LOC_CODE IN (SELECT LOC_CODE FROM LOC WHERE HOST_CODE = 'H000004')
;

--? LOC_REMOVE(LRM)? ?­? ? κ³΅κ°?Όλ‘? INSERT (?¬?¬λ²? ?΄μ€μΌ?¨ )
CALL PRC_DEL_LOC_INSERT('H000006')
;
--INSERT INTO LOC_REMOVE(LOC_REMOVE_CODE, LOC_CODE, LOC_REMOVE_DATE)
--VALUES(F_CODE('LRM', LRM_SEQ.NEXTVAL), 'L000001', SYSDATE);


-- !! ?¬?¬κ°?] κ³μ’? λ³? ??μ§? ??Έ (HOST_BANK_INFO)
SELECT HOST_BANK_NUMBER, HOST_CODE
FROM HOST_BANK_INFO
WHERE HOST_CODE='H000004';
--> 
SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000004'
;
-- ?¬κΈ°μ HOST_BANK_NUMBER λ°μ?΄

--? ?? κ³μ’?? ?΄?Ή κ³μ’? λ³? DELETE
DELETE 
FROM HOST_EXCHANGE_BANK_INFO
WHERE HOST_BANK_NUMBER IN (SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000001');
-->
DELETE FROM HOST_EXCHANGE_BANK_INFO WHERE HOST_BANK_NUMBER IN (SELECT HOST_BANK_NUMBER FROM HOST_BANK_INFO WHERE HOST_CODE='H000001')
;

--? HOST_BANK_INFO?? κ³μ’λ²νΈ ?­? 
DELETE FROM HOST_BANK_INFO WHERE HOST_CODE='H000004';

--? HOST_PROFILE?? ?Έ?€?Έλ²νΈ ?­?  
DELETE FROM HOST_PROFILE WHERE HOST_CODE='H000004';

--? ??΄ ??΄λΈ? INSERT 
INSERT INTO HOST_WITHDRAW(HOST_WITHDRAW_CODE, HOST_CODE, HOST_WITHDRAW_DATE) 
VALUES(F_CODE('HW', HW_SEQ.NEXTVAL), 'H000002' ,SYSDATE);
--> ?μ€?
INSERT INTO HOST_WITHDRAW(HOST_WITHDRAW_CODE, HOST_CODE, HOST_WITHDRAW_DATE) VALUES(F_CODE('HW', HW_SEQ.NEXTVAL), 'H000002' ,SYSDATE)
;

----------------------------------------------------------------------------------------------
/*
*locationDetail 3
?
1. κ³΅κ°??΄λΈμ? ??½?  κ³΅κ°? ? λ³΄λ?? μ‘°ν?? μΏΌλ¦¬λ¬?
   1-1. κ³΅κ°?κ°? : (?΄?©??΄??΄λΈ?) ???κ°?, ? κΈ°ν΄λ¬΄μΌ, μ§?? ?΄λ¬΄μΌ
   1-2. ??€??΄ : (??€??΄??΄λΈ?) ??€??΄?΄?©
   1-3. μ£Όμ?¬?­ : μ£Όμ?¬?­.μ£Όμ?¬?­ ?΄?©
   1-4. ?¨?€μ§? : ??¬ ? ?©? ?¨?€μ§? μ’λ₯, μ’λ₯??°?Ό ? ?©? ? μ§?
2. ?΄?Ή κ³΅κ°? λ¦¬λ·°λ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   (?? , λ¦¬λ·°?΄?©, λ¦¬λ·°??±?Ό?, ??€?, [??μ½λ])
   2-1. ?΄λ―Έμ?κ°? ?? κ²½μ° ?΄λ―Έμ???΄λΈμ ?΅?΄ μ‘°ν
   2-2. ?­? ?΄?­?΄ ?? κ²½μ° ?­? ? κ²μλ¬Όλ‘ ??΄?? λΈλΌ?Έ? μ²λ¦¬
3. ?΄?Ή κ³΅κ°? Q&Aλ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   3-1. ?­? ?΄?­?΄ ?? κ²½μ° ?­? ? κ²μλ¬Όλ‘ ??΄?? λΈλΌ?Έ? μ²λ¦¬	
4. ?΄?Ή λ¦¬λ·°? λ¦¬λ·°?΅κΈ?? μ‘°ν?? μΏΌλ¦¬λ¬?
   4-1. ?­? ?΄?­?΄ ?? κ²½μ° ?­? ? κ²μλ¬Όλ‘ ??΄?? λΈλΌ?Έ? μ²λ¦¬
5. ?΄?Ή Q&A? Q&A?΅κΈ?? μ‘°ν?? μΏΌλ¦¬λ¬? 
   5-1. ?­? ?΄?­?΄ ?? κ²½μ° ?­? ? κ²μλ¬Όλ‘ ??΄?? λΈλΌ?Έ? μ²λ¦¬

?₯
1. ?΅κΈ??΄ μ‘΄μ¬?? κ²½μ° κ·? ?΅κΈ??΄ μ°Έμ‘°?κ³? ?? λ¦¬λ·°, Q&A λ°μ ?¬ ? ??λ‘? ??€.
2. μ§?? API
3. λ¦¬λ·°, Q&A λͺ©λ‘ ??±? ??¬ ?Έ?? ?? μ½λκ°? κ°μ κ²½μ° ??  λ°? ?­?  λ²νΌ? ??±? ??¨?€.
4. λ¦¬λ·°? ?λ²λ§ ??±?΄ κ°??₯??€. ??¬ ?Έ?κ³? κ°μ? ??μ½λ? λ¦¬λ·°κ°? μ‘΄μ¬?? κ²½μ°? 
?΄λ―? ??±? ?΄? ₯?΄ ??€? κ²μΌλ‘? ?κΈ? ??±?΄ λΆκ??₯??€.  
5. ??½? ??? ? μ§λ?? ?λ₯΄λ©΄(?¨?€μ§? ? ?©? ? μ§λ§ ??±?) ?΄?Ή ? μ§μ 
?? ?¨?€μ§??€?΄ ?Ό??€ λ°μ€ ???Όλ‘? λ³΄μ¬μ§?κ³? ?Ό??€ λ²νΌ? ?΄λ¦??λ©? κ²°μ κ°? κ°??₯
*/

SELECT *
FROM LOC_BASIC_INFO;

--? κΈ°λ³Έ? λ³? -- ?±λ‘μλ£λ κ³΅κ°?€?΄ ? ?Ό?¨
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
--> λ·°λ‘ ??
SELECT LOC_NAME, LOC_TYPE, LOC_SHORT_INTRO, LOC_INTRO
, LOC_ADDR, LOC_DETAIL_ADDR, MIN_PEOPLE, MAX_PEOPLE
, LOC_REG_DATE, HOST_NICKNAME, HOST_CODE
FROM VIEW_BASIC_INFO
WHERE LOC_CODE = 'L000001';

SELECT *
FROM LOC;

SELECT *
FROM LOC_DETAIL_INFO;







--? κ³΅κ°?κ°? 
SELECT LOC_USE_HOUR, LOC_USE_DAY_OFF, LOC_USE_APPOINT_DAY_OFF
FROM LOC_USE_INFO
WHERE LOC_CODE='L000001';
--> 
SELECT LOC_USE_HOUR, LOC_USE_DAY_OFF, LOC_USE_APPOINT_DAY_OFF, LOC_CODE
FROM VIEW_USING_HOUR
WHERE LOC_CODE='L000001';

--? ??€??΄
SELECT F.FACILITY_CODE, F.LOC_BASIC_INFO_CODE, F.FACILITY_CONTENT
, L.LOC_CODE 
FROM FACILITY_INFO F
JOIN LOC_BASIC_INFO L
ON F.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE
WHERE LOC_CODE='L000001';
--> λ·?
SELECT FACILITY_CONTENT FROM VIEW_FACILITY_INFO WHERE LOC_CODE='L000001'
;


--? μ£Όμ?¬?­
SELECT CAUTION_CONTENT
FROM CAUTION C
JOIN LOC_BASIC_INFO L
ON C.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE
WHERE LOC_CODE='L000001';
--> λ·?
SELECT CAUTION_CONTENT FROM VIEW_CAUTION_CONTENT 
WHERE LOC_CODE='L000001'
;

--? ?΄?Ή κ³΅κ°? ? ?©? ?¨?€μ§? 
--> λ·? ??±
SELECT LOC_CODE, PACKAGE_NAME, PACKAGE_START, PACKAGE_END
, PACKAGE_PRICE, APPLY_DATE, APPLY_PACKAGE_CODE
, COUNT
FROM VIEW_APPLY_PACKAGE_INFO;
WHERE LOC_CODE = 'L000006' AND APPLY_DATE='2021-02-02' AND COUNT=0;

--? ?¬??? λ³?
SELECT BIZ_NAME, BIZ_CEO, BIZ_CEO_TYPE,
BIZ_MAIN_TYPE, BIZ_SUB_TYPE, BIZ_LICENSE_NUMBER
FROM BIZ_INFO B
WHERE LOC_CODE='L000001';
    



--? QNA μ‘°ν
SELECT Q.LOC_CODE, Q.QNA_CODE, Q.MEMBER_CODE, Q.QNA_CONTENT, Q.QNA_DATE
, NVL(M.MEMBER_NICKNAME, '(????)') AS MEMBER_NICKNAME
, (SELECT COUNT(*) FROM QNA_REPLY QR WHERE Q.QNA_CODE=QR.QNA_CODE) AS REPLYCOUNT
, (SELECT COUNT(*) FROM QNA_REMOVE QRM WHERE Q.QNA_CODE=QRM.QNA_CODE) AS QNAREMOVECOUNT
, (SELECT COUNT(*) FROM QNA_REPLY_REMOVE QRM WHERE QR.QNA_REPLY_CODE=QRM.QNA_REPLY_CODE) AS QNAREPLYREMOVECOUNT
, L.HOST_CODE, QR.QNA_REPLY_CONTENT, QR.QNA_REPLY_DATE, L.HOST_CODE, QR.QNA_REPLY_CODE
FROM QNA Q
LEFT JOIN MEMBER_PROFILE M      -- LEFT μ‘°μΈ ?΄?Ό ??΄???΄λ¦? ??κ°??₯
ON Q.MEMBER_CODE = M.MEMBER_CODE
    LEFT JOIN QNA_REPLY QR
    ON Q.QNA_CODE = QR.QNA_CODE
        JOIN LOC L
        ON Q.LOC_CODE = L.LOC_CODE;
--> λ·? λ§λ€κΈ?
SELECT QNA_CODE, MEMBER_NICKNAME, QNA_CONTENT, QNA_DATE, MEMBER_CODE, REPLYCOUNT
, QNAREMOVECOUNT, QNAREPLYREMOVECOUNT
, HOST_CODE, QNA_REPLY_CONTENT, QNA_REPLY_DATE, QNA_REPLY_CODE
FROM VIEW_QNA
WHERE LOC_CODE='L000001';


--? ?΄?Ή κ³΅κ°? q&a κ°??
SELECT COUNT(*) AS COUNT FROM VIEW_QNA WHERE LOC_CODE='L000001'
;


--? QNA ?΅κΈ? μ‘°ν
SELECT QNA_REPLY_CONTENT, QNA_REPLY_DATE
FROM QNA_REPLY QR;

--? λ¦¬λ·° μ‘°ν
SELECT R.REVIEW_CODE, NVL(M.MEMBER_NICKNAME, '(????)') AS MEMBER_NICKNAME
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
-->λ·?
SELECT REVIEW_CODE, MEMBER_NICKNAME, REVIEW_RATE, REVIEW_CONTENT, REVIEW_DATE
, REVIEW_IMG_URL, RVIMGCOUNT, REVIEWREMOVECOUNT, REPLYCOUNT, REPLYREMOVECOUNT
, MEMBER_CODE, REVIEW_REPLY_CONTENT, REVIEW_REPLY_DATE, HOST_CODE, REVIEW_REPLY_CODE
FROM VIEW_REVIEW WHERE LOC_CODE='L000003'
;


--? ?΄?Ή κ³΅κ°? λ¦¬λ·° κ°??
SELECT * FROM VIEW_REVIEW WHERE LOC_CODE='L000001'
;

--? ?΄?©? : QnA ??±
INSERT INTO QNA(QNA_CODE, LOC_CODE, MEMBER_CODE, QNA_CONTENT, QNA_DATE)
VALUES(F_CODE('Q', Q_SEQ.NEXTVAL), 'L000001' ,'M000001', '?? ₯λ°μ? ?΄?© ?κΈ°κΈ°', SYSDATE)
;

--? ?΄?©? : QnA ?? ?  ?΄?© κ°?? Έ?€κΈ?
SELECT QNA_CODE, LOC_CODE, QNA_CONTENT
FROM QNA
WHERE QNA_CODE='Q000024';


--? ?΄?©? : QnA ?? 
UPDATE QNA SET QNA_CONTENT = '?? ? μ½νμΈ μ??€.', QNA_DATE=SYSDATE WHERE QNA_CODE = 'Q000001';
;

--? ?΄?©? : QnA ?­? 
INSERT INTO QNA_REMOVE (QNA_REMOVE_CODE, QNA_CODE, QNA_REMOVE_DATE) VALUES(F_CODE('QRM', QRM_SEQ.NEXTVAL), 'Q000001', SYSDATE)
;

--? ?΄?©? ?΄?©?΄?­?¬λΆ? ??Έ(?κΈ°μ?± λ²νΌ μΆλ ₯?¬λΆ?)
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
-- λ·? ??Έ
SELECT COUNT(*) AS COUNT
FROM VIEW_MEMBER_BOOK
WHERE MEMBER_CODE='M000001';

SELECT BOOK_CODE
FROM MEMBER_CANCEL_LIST;


-- 1. ?΄?Ή κ³΅κ°? ???΄ μ·¨μ?μ§? ??? ??½ ??κ°?... 1 ?΄??΄κ³? 
-- 2. ?΄?Ή κ³΅κ°? ???΄ ??±? λ¦¬λ·°κ°μκ°? ??½??λ³΄λ€ ??Όλ©?...!

----------------------------------------------------------------------------------------------
/*
* bookApply 5
?
1. κ³΅κ°??΄λΈμ? ??½?  κ³΅κ°? ? λ³΄λ?? μ‘°ν?? μΏΌλ¦¬λ¬?
   1-1. κΈ°λ³Έ?€λͺ? : κ³΅κ°?€λͺ?(κ³΅κ°?μ€μκ°?), κ³΅κ°? ?, ??½?Έ?(μ΅μ,μ΅λ?)
   1-2. ??½? λ³? : ??½? μ§?(? ?©?¨?€μ§?.? ?©?Ό?), ??½?Έ?(? ??΄μ§?λ‘λ??° λ°μ?΄)
   1-3. ??½?? λ³? : (??΄?Έκ°μΌλ‘? ??κ²½μ°)??? λ³?(?΄λ¦?, ?΄λ©μΌ, ?°?½μ²?)
   1-4. ?Έ?€?Έ? λ³? : κ³΅κ°??Έλͺ?, ????λͺ?, ??¬μ§?, ?¬??λ²νΈ, ?°?½μ²?(?΄λ©μΌ, ?΄???°, ???? ?)
   1-5. μ£Όμ?¬?­ : μ£Όμ?¬?­.μ£Όμ?¬?­ ?΄?©
?₯
1. ??½?? λ³΄λ μ§μ  ?? ₯? κ°??₯?μ§?λ§? μ²΄ν¬ λ²νΌ? ?΅?΄ ??¬ λ‘κ·Έ?Έ? ??? ? λ³΄λ?? ??΄?Έκ°μΌλ‘? λ°μ?¬ ? ??λ‘? 
2. ???? ₯?¬?­ λ―Έμ? ₯, ?λΉμ€ ??λ₯? ?μ§? ??Όλ©? κ²°μ  λΆκ??₯
*/


--? ??½?? λ³?
SELECT MEMBER_NAME, MEMBER_EMAIL, MEMBER_TEL, MEMBER_CODE, 
FROM MEMBER_PROFILE;

--? ?¬??? λ³?
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

--? λ©€λ² ?λ‘ν κ°?? Έ?€κΈ?
SELECT MEMBER_CODE, MEMBER_NAME, MEMBER_TEL
FROM MEMBER_PROFILE
WHERE MEMBER_CODE='M000004';


--? ? ?? ?¨?€μ§? ? λ³? μ‘°ν(?¨?€μ§?μ½λ ?? ₯? ??Έκ°??₯)
SELECT PF.LOC_CODE, P.PACKAGE_CODE, P.PACKAGE_FORM_CODE, P.PACKAGE_NAME
, P.PACKAGE_START, P.PACKAGE_END, P.PACKAGE_PRICE, AP.APPLY_DATE, AP.APPLY_PACKAGE_CODE
FROM PACKAGE P
JOIN PACKAGE_FORM PF
ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
    JOIN APPLY_PACKAGE AP
    ON P.PACKAGE_CODE = AP.PACKAGE_CODE;
--> λ·°λ‘ λ³΄κΈ°
SELECT PACKAGE_NAME, APPLY_PACKAGE_CODE
, PACKAGE_START, PACKAGE_END, PACKAGE_PRICE, APPLY_DATE
, NVL(PACKAGE_END, 0) - NVL(PACKAGE_START, 0) AS HOURS
FROM VIEW_APPLY_PACKAGE_INFO
WHERE APPLY_PACKAGE_CODE = 'AP000004';


--? λ§μΌλ¦¬μ? ??Όλ©? ??½ ?΄?­??΄λΈ? insert
INSERT INTO BOOK_LIST (BOOK_CODE, MEMBER_CODE, APPLY_PACKAGE_CODE
, BOOK_PEOPLE, BOOK_DATE, BOOK_REQ)
VALUES(F_CODE('BC', BC_SEQ.NEXTVAL), 'M000001', 'AP000001', 3, SYSDATE, '??΄μ£ΌμΈ?');

--? λ°©κΈ ? ??½λ²νΈ κ°?? Έ?΄
SELECT BOOK_CODE
FROM 
(SELECT BOOK_CODE FROM BOOK_LIST WHERE MEMBER_CODE='M000001' ORDER BY BOOK_CODE DESC)
WHERE ROWNUM=1;

--? ?€??½? ??΄λΈ? insert
INSERT INTO ACTUAL_BOOKER (ACTUAL_BOOKER_CODE, BOOK_CODE, ACTUAL_BOOKER
, ACTUAL_BOOKER_TEL)
VALUES(F_CODE('AB', AB_SEQ.NEXTVAL), 'BC000006', 'μ§μ§???', '010-3690-7828');


--? ??½κ²°μ ?΄?­ ??΄λΈ? insert
INSERT INTO BOOK_PAY_LIST(BOOK_PAY_CODE, BOOK_CODE, BOOK_PAY_DATE)
VALUES(F_CODE('BP', BP_SEQ.NEXTVAL), 'BC000006', SYSDATE);


--? λ§μΌλ¦¬μ? ??Όλ©? κ²°μ ??΄μ§?λ‘? ?΄?

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

EXEC PRC_BOOK_CODE_INSERT('M000002', 'κΉ??λ¬΄κ°', '010-3690-7828');


--------------------------------------------------------------------------------
--?? BookApplyNotice.jsp
/*
κ²°μ ?΄?­ ??Έ
??½?λͺ?
μ§μ??
?°?½μ²?
010-1234-1234
?΄λ©μΌ
papajon@lookation.com
?Έ??
3λͺ?
?μ²??¬?­
κ³ ν΅? λ©μΆ°μ£ΌμΈ?
κ²°μ κΈμ‘
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
?
1. ??½ ??΄λΈ? ? λ³΄λ?? μ‘°ν?? μΏΌλ¦¬λ¬?
   (??½μ½λ, ??½?λͺ?, κ³΅κ°λͺ?, ?Ό?, ?Έ??, κ°?κ²?, ?μ²??¬?­, ??)
2. ??½μ·¨μ ?΄λ¦?? ??½μ·¨μ ??΄λΈμ ?°?΄?° INSERT μΏΌλ¦¬λ¬? 
?₯
1. κ²???? ? ?? ??
2. μ΅μ  ??Όλ‘? ? ? ¬ ??.
3. κ³΅κ°λͺμ ??€κ²? ?κ³? ??Έλ³΄κΈ° ???Όλ‘?(??½?Έ??, ?μ²??¬?­, κ°?κ²?)
   ?λ¨Έμ?(??½μ½λ, ??½?λͺ?, ??½??©, ??½μ·¨μ)? λ¦¬μ€?Έλ‘? λ³΄μ¬μ€?
4. μ·¨μ ?΄λ¦?? μ·¨μ?¬? λ₯? ?? ₯?κΈ? ?? ??μ°½μ΄ ??


*/

-- ??½?΄?©(?¨?€μ§? ? μ§?, ?κ°? μ΄? λͺμκ°?) κ³΅κ°λͺ? ??½??©, 
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
--? ?΄?©λ³΄κΈ°
SELECT BOOK_CODE, MEMBER_CODE, APPLY_PACKAGE_CODE, LOC_CODE
, APPLY_DATE, PACKAGE_CODE, PACKAGE_NAME
, PACKAGE_START, PACKAGE_END
, BOOK_HOUR, HOST_CANCEL, MEMBER_CANCEL, REFUND, LOC_NAME
FROM VIEW_BOOKLIST
WHERE MEMBER_CODE = 'M000001'
ORDER BY APPLY_DATE;


--? ??½??Έ
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



--? ?λΆκ³?°
/*
?΄?©???Ό? 4?Ό ? ?΄λ―?λ‘?
??½ κ°?κ²©μ 50%?Έ 100,000??΄ λ§μΌλ¦¬μ?λ‘? ?λΆλ©??€.
*/
--? μ·¨μ?? ?λΆ? κ³μ°
SELECT BOOK_CODE, BOOK_HOUR, LOC_NAME
, APPLY_DATE, PACKAGE_START, PACKAGE_END
, PACKAGE_PRICE
, TO_DATE(APPLY_DATE, 'YYYY-MM-DD')- TRUNC(TO_DATE(SYSDATE, 'YYYY-MM-DD')) AS DAYS --0 ?΄λ©? ?Ή?Ό// μ·¨μλ²νΌ λΉν
FROM VIEW_BOOKLIST;
WHERE BOOK_CODE = 'BC000001';

--? μ·¨μλ²νΌ ?΄λ¦?? μ·¨μ?΄?­ μΆκ?
INSERT INTO MEMBER_CANCEL_LIST (MEMBER_CANCEL_CODE, BOOK_CODE, MEMBER_CANCEL_REASON, MEMBER_CANCEL_DATE)
VALUES(F_CODE('MC', MC_SEQ.NEXTVAL), 'BC000003', '??€?΄? ?κ°λ??€', SYSDATE);

--? ??½ ?λΆ? ?΄?­ μΆκ? 
INSERT INTO BOOK_REFUND_LIST (BOOK_REFUND_CODE, BOOK_CODE, BOOK_REFUND_DATE)
VALUES(F_CODE('BRF', BRF_SEQ.NEXTVAL), 'BC000003', SYSDATE);

--? ??€? κ²??
SELECT MEMBER_NICKNAME
FROM MEMBER_PROFILE
WHERE MEMBER_CODE='M000002';


--------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--? userReviewList

SELECT *
FROM REVIEW;

--? ?΄?©? : λ¦¬λ·° ??±
INSERT INTO REVIEW(REVIEW_CODE, LOC_CODE, MEMBER_CODE, REVIEW_RATE, REVIEW_CONTENT, REVIEW_DATE)
VALUES(F_CODE('RV', RV_SEQ.NEXTVAL), 'L000003', 'M000005', 3, '?°?΄?°λ² μ΄?€λ‘? λ¦¬λ·°λ₯? ?¨λ΄λ?€... ?°??', SYSDATE);


--? ?΄?©? : λ¦¬λ·° ?? ?Ό ?΄?© κ°?? Έ?€κΈ?
SELECT REVIEW_CODE, LOC_CODE, REVIEW_CONTENT, REVIEW_RATE
FROM REVIEW
WHERE REVIEW_CODE='RV000001';

--? ?΄?©? : λ¦¬λ·° ?? 
UPDATE REVIEW
SET REVIEW_RATE=4, REVIEW_CONTENT='?΄? κ²?', REVIEW_DATE=SYSDATE
WHERE REVIEW_CODE = 'RV000001';

--? ?΄?©? : λ¦¬λ·° ?­? 
INSERT INTO REVIEW_REMOVE(REVIEW_REMOVE_CODE, REVIEW_CODE, REVIEW_REMOVE_DATE)
VALUES(F_CODE('RVRM', RV_SEQ.NEXTVAL), 'RV000010', SYSDATE);


--? ?Έ?€?Έ : λ¦¬λ·° ?΅κΈ? ??±
INSERT INTO REVIEW_REPLY (REVIEW_REPLY_CODE, REVIEW_CODE, REVIEW_REPLY_CONTENT, REVIEW_REPLY_DATE)
VALUES(F_CODE('RVRE', RVRE_SEQ.NEXTVAL), 'RV000006', 'μ»¨νμΈ?', SYSDATE);

--? ?Έ?€?Έ : λ¦¬λ·° ?? ?Ό λΆλ¬?€κΈ?
SELECT REVIEW_REPLY_CODE, REVIEW_REPLY_CONTENT
FROM REVIEW_REPLY
WHERE REVIEW_REPLY_CODE='RVRE000001';

--? ?Έ?€?Έ : λ¦¬λ·° ?΅κΈ? ?? 
UPDATE REVIEW_REPLY
SET REVIEW_REPLY_CONTENT='?΄? κ²?', REVIEW_REPLY_DATE=SYSDATE
WHERE REVIEW_REPLY_CODE='RVRE000001';


--? ?Έ?€?Έ : λ¦¬λ·°?΅κΈ? ?­? ?
INSERT INTO REVIEW_REPLY_REMOVE (REVIEW_REPLY_REMOVE_CODE, REVIEW_REPLY_CODE, REVIEW_REPLY_REMOVE_DATE)
VALUES(F_CODE('RVRERM', RVRERM_SEQ.NEXTVAL), 'RVRE000004', SYSDATE);


--? ?Έ?€?Έ : QNA ?΅κΈ? ??±
INSERT INTO QNA_REPLY (QNA_REPLY_CODE, QNA_CODE, QNA_REPLY_CONTENT, QNA_REPLY_DATE)
VALUES(F_CODE('QRE', QRE_SEQ.NEXTVAL), 'Q000001', '?΅κΈ? ?΅??€.', SYSDATE);


--? ?Έ?€?Έ : QNA ?? ?Ό λΆλ¬?€κΈ?
SELECT QNA_REPLY_CODE, QNA_REPLY_CONTENT
FROM QNA_REPLY
WHERE QNA_REPLY_CODE ='QRE000001';

--? ?Έ?€?Έ : QNA ?΅κΈ? ?? 
UPDATE QNA_REPLY
SET QNA_REPLY_CONTENT='??', QNA_REPLY_DATE=SYSDATE
WHERE QNA_REPLY_CODE='QRE000001';


--? ?Έ?€?Έ : QNA ?΅κΈ? ?­? 
INSERT INTO QNA_REPLY_REMOVE(QNA_REPLY_REMOVE_CODE, QNA_REPLY_CODE, QNA_REPLY_REMOVE_DATE)
VALUES(F_CODE('QRERM', QRERM_SEQ.NEXTVAL), 'QRE000001', SYSDATE); 


--? λ¦¬λ·° ?κ·? λ³μ  κ΅¬νκΈ?
SELECT ROUND(AVG(NVL(REVIEW_RATE, 0)), 2) AS AVGSTAR
FROM REVIEW
WHERE LOC_CODE='L000007';

SELECT *
FROM REVIEW;

--------------------------------------------------------------------------------
/*
*userQnaList 6(X)
?
1. ?΄?©?κ°? ??±? QnAλ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
    (Q&Aμ½λ, ?΄?Ήκ³΅κ°λͺ?, ?΄?©, ??±?Ό)
   1-1. ?­? ? QnA?? μ‘°μΈ??¬ ?­? ?¬λΆ?λ₯? ?? ?κ²?
2. ?­? λ²νΌ ?΄λ¦?? ?­? ?΄?­? ?΄?Ή QnAμ½λλ₯? μ°Έμ‘°?? ?°?΄?°λ₯? INSERT
?₯
1. ?­? ? Q&A κ²½μ°?? λ³΄μ¬μ£Όμ? ???€.
2. ?­? ??? ?λ¦?
*/

--? ?΄?©?κ°? ??±? QnA
SELECT Q.QNA_CODE, Q.LOC_CODE, Q.MEMBER_CODE
, Q.QNA_CONTENT, Q.QNA_DATE, LBIF.LOC_NAME
, (SELECT COUNT(*) FROM QNA_REMOVE QRM WHERE Q.QNA_CODE = QRM.QNA_CODE) AS REMOVECOUNT
FROM QNA Q
JOIN LOC L
ON Q.LOC_CODE = L.LOC_CODE
    JOIN LOC_BASIC_INFO LBIF
    ON L.LOC_CODE = LBIF.LOC_CODE;
    
-- λ·°μ?
SELECT QNA_CODE, LOC_CODE, MEMBER_CODE
, QNA_CONTENT, QNA_DATE, LOC_NAME
, REMOVECOUNT
FROM VIEW_USER_QNA
WHERE MEMBER_CODE='M000002'
ORDER BY QNA_CODE DESC;

--? ?­? λ²νΌ ?΄λ¦?? QNA REMOVE
INSERT INTO QNA_REMOVE (QNA_REMOVE_CODE, QNA_CODE, QNA_REMOVE_DATE)
VALUES(F_CODE('QRM', QRM_SEQ.NEXTVAL), 'Q000001', SYSDATE);

--? ? ?? ??€? κ²??
SELECT MEMBER_NICKNAME
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000002';


--? ?΄?©?κ°? ??±? λ¦¬λ·°
SELECT R.REVIEW_CODE, R.MEMBER_CODE
, R.REVIEW_CONTENT, R.REVIEW_RATE, R.REVIEW_DATE, LBIF.LOC_NAME
, (SELECT COUNT(*) FROM REVIEW_REMOVE RVRM WHERE R.REVIEW_CODE = RVRM.REVIEW_CODE) AS REMOVECOUNT
FROM REVIEW R
JOIN LOC L
ON R.LOC_CODE = L.LOC_CODE
    JOIN LOC_BASIC_INFO LBIF
    ON L.LOC_CODE = LBIF.LOC_CODE;
-- λ·? ??±
SELECT REVIEW_CODE, MEMBER_CODE
, REVIEW_CONTENT, REVIEW_RATE, REVIEW_DATE, LOC_NAME
, REMOVECOUNT
FROM VIEW_USER_REVIEW
WHERE MEMBER_CODE = 'M000001';

----------------------------------------------------------------------------------------------

/*

* hostAccountManager(?Έ?€?Έ??κ΄?λ¦?) 7
?
1. ?Έ?€?Έ ??΄λΈλ‘ λΆ??° ?°?΄?°λ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   (??μ½λ, ??΄?, ??€?, λΈλ?¬λΆ?, [λΈλμ²λ¦¬?¬? ])
   1-1. λΈλλ¦¬μ€?Έ ??΄λΈμ ?΅?΄ λΈλλ¦¬μ€?Έ ?¬λΆ? ??Έ ??
2. λΈλλ¦¬μ€?Έ ?€? ? λΈλλ¦¬μ€?Έ ??΄λΈμ INSERT?? μΏΌλ¦¬λ¬?
3. λΈλλ¦¬μ€?Έ ?΄? ? λΈλλ¦¬μ€?Έ ??΄λΈμ? DELETE?? μΏΌλ¦¬λ¬?
4. ? κ³ λ΄?­(κ³΅κ°) ??΄λΈλ‘ λΆ??° ?°?΄?°λ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   (? κ³ μΌ?, ? κ³ μ¬? , ? κ³ μ²λ¦¬μ?, ? κ³ μ ?) 

?₯
1. ? κ³ λ΄?­ λ²νΌ?λ₯΄λ©΄ λͺ¨λ  ? κ³ λ΄?­?΄ ??μ°½μΌλ‘? ????Ό?¨.
2. λΈλλ¦¬μ€?Έ ?€? ? ??μ°½μΌλ‘? ?¬? λ₯? ? ? ? ?κ²?, ?΄? ??? ?λ¦ΌμΌλ‘? ?€??λ²? ??Έ
*/

--? ?Έ?€?Έ λΈλλ¦¬μ€?Έ ??Έ?? μΏΌλ¦¬
SELECT H.HOST_EMAIL, H.HOST_NICKNAME
, HB.HOST_BLACKLIST_REASON
, (SELECT COUNT(*) FROM HOST_BLACKLIST HB 
    WHERE H.HOST_EMAIL=HB.HOST_EMAIL) AS YESBLACK
FROM HOST_PROFILE H
    LEFT JOIN HOST_BLACKLIST HB
    ON H.HOST_EMAIL = HB.HOST_EMAIL;
-- λ·?
SELECT HOST_CODE, HOST_EMAIL, HOST_NICKNAME
, HOST_BLACKLIST_REASON, YESBLACK
FROM VIEW_HOSTBLACKLIST;


--? ?Έ?€?Έ λΈλλ¦¬μ€?Έ ?€? ? λΈλλ¦¬μ€?Έ ??΄λΈ? INSERT
SELECT HOST_EMAIL
FROM HOST_PROFILE
WHERE HOST_CODE = 'H000001';

INSERT INTO HOST_BLACKLIST(HOST_EMAIL, HOST_BLACKLIST_REASON, HOST_BLACKLIST_DATE)
VALUES('good1@test.com', '?¬? ?Ό?Έ', SYSDATE);

-- ? λΈλλ¦¬μ€?Έ ?΄? ? DELETE
DELETE 
FROM HOST_BLACKLIST
WHERE HOST_EMAIL = 'good1@test.com';


--? ?Έ?€?Έ ? κ³ λ΄?­ ??
-- ? κ³ ν?, ??μ½λ, ? κ³ μ½?, ? κ³ μ ?,? κ³ μ¬? ,? κ³ μΌ?
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

-- λ·?
SELECT HOST_CODE, LOC_CODE, LOC_REPORT_CODE
, LOC_REPORT_REASON, LOC_REPORT_DATE
, LOC_REPORT_TYPE, REPORT_PROC_TYPE
FROM VIEW_HOST_REPORTDETAILS
WHERE HOST_CODE ='H000007';
/*

* userAccountManager(?΄?©???κ΄?λ¦?) 7
?
1. ?΄?©? ??΄λΈλ‘ λΆ??° ?°?΄?°λ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   (??μ½λ, ??΄?, ??€?, λΈλ?¬λΆ?, [λΈλμ²λ¦¬?¬? ])
   1-1. λΈλλ¦¬μ€?Έ ??΄λΈμ ?΅?΄ λΈλλ¦¬μ€?Έ ?¬λΆ? ??Έ ??
2. λΈλλ¦¬μ€?Έ ?€? ? λΈλλ¦¬μ€?Έ ??΄λΈμ INSERT?? μΏΌλ¦¬λ¬?
3. λΈλλ¦¬μ€?Έ ?΄? ? λΈλλ¦¬μ€?Έ ??΄λΈμ? DELETE?? μΏΌλ¦¬λ¬?
4. ? κ³ λ΄?­(??½) ??΄λΈλ‘ λΆ??° ?°?΄?°λ₯? μ‘°ν?? μΏΌλ¦¬λ¬?
   (? κ³ μΌ?, ? κ³ μ¬? , ? κ³ μ²λ¦¬μ?, ? κ³ μ ?) 

?₯
1. ? κ³ λ΄?­ λ²νΌ?λ₯΄λ©΄ λͺ¨λ  ? κ³ λ΄?­?΄ ??μ°½μΌλ‘? ????Ό?¨.
2. λΈλλ¦¬μ€?Έ ?€? ? ??μ°½μΌλ‘? ?¬? λ₯? ? ? ? ?κ²?, ?΄? ??? ?λ¦ΌμΌλ‘? ?€??λ²? ??Έ

* blacklistPopup.jsp 7

* reportDetailPopupHost.jsp 7
* reportDetailPopupUser.jsp 7

*/

--? ?΄?©? λΈλλ¦¬μ€?Έ ?¬λΆ? ??Έ?? μΏΌλ¦¬
SELECT M.MEMBER_CODE, M.MEMBER_EMAIL, M.MEMBER_NICKNAME
, MB.MEMBER_BLACKLIST_REASON
, (SELECT COUNT(*) FROM MEMBER_BLACKLIST MB 
    WHERE M.MEMBER_EMAIL=MB.MEMBER_EMAIL) AS YESBLACK
FROM MEMBER_PROFILE M
    LEFT JOIN MEMBER_BLACKLIST MB
    ON M.MEMBER_EMAIL = MB.MEMBER_EMAIL;
-- λ·?
SELECT MEMBER_CODE, MEMBER_EMAIL, MEMBER_NICKNAME
, MEMBER_BLACKLIST_REASON, YESBLACK
FROM VIEW_MEMBERBLACKLIST;




--? λ©€λ² λΈλλ¦¬μ€?Έ ?€? ? λΈλλ¦¬μ€?Έ ??΄λΈ? INSERT
SELECT MEMBER_EMAIL
FROM MEMBER_PROFILE
WHERE MEMBER_CODE = 'M000001';

INSERT INTO MEMBER_BLACKLIST(MEMBER_EMAIL, MEMBER_BLACKLIST_REASON, MEMBER_BLACKLIST_DATE)
VALUES('test2@test.com', '?¬? ?Ό?Έ', SYSDATE);

-- ? λΈλλ¦¬μ€?Έ ?΄? ? DELETE
DELETE 
FROM MEMBER_BLACKLIST
WHERE MEMBER_EMAIL = 'test2@test.com';


--? ?΄?©? ? κ³ λ΄?­ ??
-- ??μ½λ, ? κ³ μ½?, ? κ³ μ ?,? κ³ μ¬? ,? κ³ μΌ?
SELECT B.BOOK_REPORT_CODE, B.BOOK_CODE, BR.BOOK_REPORT_TYPE
, B.BOOK_REPORT_REASON, B.BOOK_REPORT_DATE, BL.MEMBER_CODE
FROM BOOK_REPORT B
JOIN BOOK_REPORT_TYPE BR
ON B.BOOK_REPORT_TYPE_CODE = BR.BOOK_REPORT_TYPE_CODE
    LEFT JOIN BOOK_REPORT_PROC BRP
    ON B.BOOK_REPORT_CODE = BRP.BOOK_REPORT_CODE
        JOIN BOOK_LIST BL
        ON B.BOOK_CODE = BL.BOOK_CODE;

-- λ·?
SELECT BOOK_REPORT_CODE, BOOK_CODE, BOOK_REPORT_TYPE
, BOOK_REPORT_REASON, BOOK_REPORT_DATE, MEMBER_CODE
FROM VIEW_MEMBER_REPORTDETAILS
WHERE MEMBER_CODE = 'M000001';


----------------------------------------------------------------------------------------------
SELECT *
FROM HOST_MSG_INFO;

-- ?Έ?€?Έ λ©μ ?? μ‘°ν
SELECT DISTINCT H.HOST_MSG_INFO_CODE, H.MSG_CODE
, H.HOST_MSG_CONTENT, H.HOST_MSG_DATE
, M.BOOK_CODE
, AP.APPLY_DATE
, B.MEMBER_CODE -- ?? ?
, M.MEMBER_NICKNAME
, HP.HOST_CODE
, HP.HOST_NICKNAME -- ?‘? ?
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
                                JOIN MEMBER_PROFILE M  -- λ©€λ²??΄? ?λ³΄μ
                                ON B.MEMBER_CODE = M.MEMBER_CODE
                                    LEFT JOIN HOST_MSG_IMG HI
                                    ON H.HOST_MSG_INFO_CODE = HI.HOST_MSG_INFO_CODE;



-- λ·? ??±
SELECT HOST_MSG_INFO_CODE, MSG_CODE
, HOST_MSG_CONTENT, HOST_MSG_DATE
, HOST_CODE, HOST_NICKNAME
, BOOK_CODE, APPLY_DATE
, MEMBER_CODE, MEMBER_NICKNAME
, H_IMGCOUNT, HOST_MSG_IMG_URL
FROM VIEW_HOST_MESSENGER;


-- λ©€λ² ??₯?? λ©μμ§? μ‘°ν 
SELECT MM.MEMBER_MSG_INFO_CODE, MM.MSG_CODE
, MM.MEMBER_MSG_CONTENT, MM.MEMBER_MSG_DATE
, M.BOOK_CODE
, AP.APPLY_DATE
, B.MEMBER_CODE -- ?‘? ?
, M.MEMBER_NICKNAME
, HP.HOST_CODE
, HP.HOST_NICKNAME -- ?‘? ?
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
                                JOIN MEMBER_PROFILE M  -- λ©€λ²??΄? ?λ³΄μ
                                ON B.MEMBER_CODE = M.MEMBER_CODE
                                    LEFT JOIN MEMBER_MSG_IMG MI
                                    ON MM.MEMBER_MSG_INFO_CODE = MI.MEMBER_MSG_INFO_CODE;

--? λ©μμ§? ? μ²? ?€ λ³΄λ λ·?
SELECT MSG_CODE, MSG_CONTENT, MSG_DATE
, SENDER_CODE, SENDER
, IMGCOUNT, MSG_IMG_URL
, BOOK_CODE, APPLY_DATE, HORM
FROM VIEW_MESSENGER;

--? ?Έ?€?Έ ??€? μ°ΎκΈ°
--??½μ½λλ‘? ?λ‘? ? μ°Ύμλ³΄κΈ° 
SELECT HOST_NICKNAME
FROM VIEW_BOOK_NICKNAME
WHERE BOOK_CODE='BC000001';

--? λ©μ ??μ½λ κ²??
SELECT MSG_CODE FROM ( SELECT ROWNUM, MSG_CODE
FROM VIEW_MESSENGER
WHERE BOOK_CODE='BC000001')
WHERE ROWNUM <= 1;

--? ?΄?©?κ°? λ©μμ§? ? ?‘?? κ²½μ°
INSERT INTO MEMBER_MSG_INFO(MEMBER_MSG_INFO_CODE, MSG_CODE, MEMBER_MSG_CONTENT, MEMBER_MSG_DATE)
VALUES(F_CODE('MMIF', MMIF_SEQ.NEXTVAL), 'MSG000001', '?΄μ§Έμ!!', SYSDATE);

--? ?΄?©?κ°? ?΄λ―Έμ? ? ?‘?? κ²½μ°
-- ?λ‘μ?? 
CALL PRC_M_MSG_IMG('BC000001', '??₯');

--------------------------------------------------------------------------------
--? ?Έ?€?Έ 
--? ???λ°? ??€? μ°ΎκΈ°
SELECT MEMBER_NICKNAME
FROM VIEW_BOOK_NICKNAME
WHERE BOOK_CODE='BC000001';

--? λ©μ ??μ½λ κ²??
SELECT MSG_CODE FROM ( SELECT ROWNUM, MSG_CODE
FROM VIEW_MESSENGER
WHERE BOOK_CODE='BC000001')
WHERE ROWNUM <= 1;

--? ?Έ?€?Έκ°? λ©μμ§? ? ?‘?? κ²½μ°
INSERT INTO HOST_MSG_INFO(HOST_MSG_INFO_CODE, MSG_CODE, HOST_MSG_CONTENT, HOST_MSG_DATE)
VALUES(F_CODE('HMIF', HMIF_SEQ.NEXTVAL), 'MSG000001', '?΄μ§Έμ!!', SYSDATE);


select *
from view_messenger
where book_code='BC000001';

--? ?Έ?€?Έκ°? ?΄λ―Έμ? ? ?‘?? κ²½μ°
-- ?λ‘μ?? 
CALL PRC_H_MSG_IMG('BC000001', '?΄κ±? ?΄λ―Έμ? μ£Όμ?!');

SELECT * FROM MSG;

SELECT * FROM REVIEW_IMG;


INSERT INTO REVIEW_IMG(REVIEW_IMG_CODE, REVIEW_CODE, REVIEW_IMG_URL)
VALUES(F_CODE('RVIMG', RVIMG_SEQ.NEXTVAL), 'RV000085', 'ΉΉ½Γ±β');

ROLLBACK;
SELECT REVIEW_CODE
    FROM
    (SELECT A.REVIEW_CODE, A.MEMBER_CODE
    FROM REVIEW A
    ORDER BY A.REVIEW_DATE DESC)
    WHERE ROWNUM = 1 AND MEMBER_CODE='M000001';


EXEC PRC_REVIEW_IMG('L000001', 'M000002', 4, 'ΎΘ³ηΗΟΌΌΏλ', 'too.png');