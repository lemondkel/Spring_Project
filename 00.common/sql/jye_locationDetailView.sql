--�� ���� �⺻���� ��
CREATE OR REPLACE VIEW VIEW_BASIC_INFO
AS      
SELECT LB.LOC_CODE, LB.LOC_NAME, LT.LOC_TYPE
, LB.LOC_SHORT_INTRO, LB.LOC_INTRO
, LB.LOC_ADDR, LB.LOC_DETAIL_ADDR
, LD.MIN_PEOPLE, LD.MAX_PEOPLE
, L.LOC_REG_DATE, H.HOST_NICKNAME, H.HOST_CODE
FROM LOC_BASIC_INFO LB
JOIN LOC_TYPE LT 
ON LB.LOC_TYPE_CODE = LT.LOC_TYPE_CODE
    JOIN LOC_DETAIL_INFO LD
    ON LB.LOC_CODE = LD.LOC_CODE
        JOIN LOC L
        ON LB.LOC_CODE = L.LOC_CODE
            JOIN HOST_PROFILE H
            ON L.HOST_CODE = H.HOST_CODE;
--==>> View VIEW_BASIC_INFO��(��) �����Ǿ����ϴ�.

--�� �����Ұ� (�̿�ð� �ȳ�)
CREATE OR REPLACE VIEW VIEW_USING_HOUR
AS
SELECT LOC_USE_HOUR, LOC_USE_DAY_OFF, LOC_USE_APPOINT_DAY_OFF, LOC_CODE
FROM LOC_USE_INFO;
--==>> View VIEW_USING_HOUR��(��) �����Ǿ����ϴ�.


--�� �ش� ������ ����� ��Ű��
CREATE OR REPLACE VIEW VIEW_APPLY_PACKAGE_INFO
AS
SELECT PF.LOC_CODE, P.PACKAGE_CODE, P.PACKAGE_FORM_CODE, P.PACKAGE_NAME
, P.PACKAGE_START, P.PACKAGE_END, P.PACKAGE_PRICE, AP.APPLY_DATE
FROM PACKAGE P
JOIN PACKAGE_FORM PF
ON P.PACKAGE_FORM_CODE = PF.PACKAGE_FORM_CODE
    JOIN APPLY_PACKAGE AP
    ON P.PACKAGE_CODE = AP.PACKAGE_CODE;
--==>> View VIEW_APPLY_PACKAGE_INFO��(��) �����Ǿ����ϴ�.


CREATE OR REPLACE VIEW VIEW_FACILITY_INFO
AS
SELECT F.FACILITY_CODE, F.LOC_BASIC_INFO_CODE, F.FACILITY_CONTENT
, L.LOC_CODE 
FROM FACILITY_INFO F
JOIN LOC_BASIC_INFO L
ON F.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE;
--==>> View VIEW_FACILITY_INFO��(��) �����Ǿ����ϴ�.

--�� ���ǻ��� ��
CREATE OR REPLACE VIEW VIEW_CAUTION_CONTENT
AS
SELECT C.CAUTION_CONTENT, L.LOC_CODE
FROM CAUTION C
JOIN LOC_BASIC_INFO L
ON C.LOC_BASIC_INFO_CODE = L.LOC_BASIC_INFO_CODE;
--==>> View VIEW_CAUTION_CONTENT��(��) �����Ǿ����ϴ�.


--�� QNA
CREATE OR REPLACE VIEW VIEW_QNA
AS
SELECT Q.LOC_CODE, Q.QNA_CODE, Q.MEMBER_CODE, Q.QNA_CONTENT, Q.QNA_DATE
, NVL(M.MEMBER_NICKNAME, '(�˼�����)') AS MEMBER_NICKNAME
, (SELECT COUNT(*) FROM QNA_REPLY QR WHERE Q.QNA_CODE=QR.QNA_CODE) AS REPLYCOUNT
, (SELECT COUNT(*) FROM QNA_REMOVE QRM WHERE Q.QNA_CODE=QRM.QNA_CODE) AS QNAREMOVECOUNT
, (SELECT COUNT(*) FROM QNA_REPLY_REMOVE QRM WHERE QR.QNA_REPLY_CODE=QRM.QNA_REPLY_CODE) AS QNAREPLYREMOVECOUNT
, L.HOST_CODE, QR.QNA_REPLY_CONTENT, QR.QNA_REPLY_DATE, QR.QNA_REPLY_CODE
FROM QNA Q
LEFT JOIN MEMBER_PROFILE M      -- LEFT ���� �ؾ� Ż��ȸ���̸� ǥ�ð���
ON Q.MEMBER_CODE = M.MEMBER_CODE
    LEFT JOIN QNA_REPLY QR
    ON Q.QNA_CODE = QR.QNA_CODE
        LEFT JOIN LOC L
        ON Q.LOC_CODE = L.LOC_CODE
ORDER BY Q.QNA_CODE DESC;


--�� ����
CREATE OR REPLACE VIEW VIEW_REVIEW
AS
SELECT R.REVIEW_CODE, NVL(M.MEMBER_NICKNAME, '(�˼�����)') AS MEMBER_NICKNAME
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
ORDER BY R.REVIEW_CODE DESC;
--==>> View VIEW_REVIEW��(��) �����Ǿ����ϴ�.



--�� �̿��� �̿볻������ Ȯ��
CREATE OR REPLACE VIEW VIEW_MEMBER_BOOK
AS
SELECT B.MEMBER_CODE, A.APPLY_PACKAGE_CODE, F.LOC_CODE
, A.APPLY_DATE
FROM BOOK_LIST B
JOIN APPLY_PACKAGE A
ON B.APPLY_PACKAGE_CODE = A.APPLY_PACKAGE_CODE
    JOIN PACKAGE P
    ON A.PACKAGE_CODE = P.PACKAGE_CODE
        JOIN PACKAGE_FORM F
        ON P.PACKAGE_FORM_CODE = F.PACKAGE_FORM_CODE;
            JOIN REVIEW R
            ON B.MEMBER_CODE = R.MEMBER_CODE;
--==>> View VIEW_MEMBER_BOOK��(��) �����Ǿ����ϴ�.


--------------------------------------------------------------------------------
--�� BOOKAPPLY.JSP

--�� ����� ���� + ����ó ��
CREATE OR REPLACE VIEW VIEW_BIZ_CONTACT
AS
SELECT B.BIZ_NAME, B.BIZ_CEO, B.BIZ_CEO_TYPE,
B.BIZ_MAIN_TYPE, B.BIZ_SUB_TYPE, B.BIZ_LICENSE_NUMBER
, LC.LOC_EMAIL, LC.LOC_TEL, LC.LOC_MAIN_TEL
, B.BIZ_ADDR, B.LOC_CODE
FROM BIZ_INFO B
    JOIN LOC_CONTACT LC
    ON B.LOC_CODE = LC.LOC_CODE;
--> View VIEW_BIZ_CONTACT��(��) �����Ǿ����ϴ�.
    
--------------------------------------------------------------------------------
--�� BOOKLIST.JSP

CREATE OR REPLACE VIEW VIEW_BOOKLIST
AS
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

COMMIT;