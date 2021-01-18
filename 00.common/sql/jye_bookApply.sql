/*
* bookApply 5
��
1. �������̺��� ������ ������ ������ ��ȸ�ϴ� ������
   1-1. �⺻���� : ��������(�������ټҰ�), ��������, �����ο�(�ּ�,�ִ�)
   1-2. �������� : ���೯¥(������Ű��.��������), �����ο�(���������κ��� �޾ƿ�)
   1-3. ���������� : (����Ʈ������ �ϴ°��)ȸ������(�̸�, �̸���, ����ó)
   1-4. ȣ��Ʈ���� : ������ȣ��, ��ǥ�ڸ�, ������, ����ڹ�ȣ, ����ó(�̸���, �޴���, ��ǥ��ȭ)
   1-5. ���ǻ��� : ���ǻ���.���ǻ��� ����
��
1. ������������ ���� �Էµ� ���������� üũ ��ư�� ���� ���� �α����� ȸ���� ������ ����Ʈ������ �޾ƿ� �� �ֵ��� 
2. �ʼ��Է»��� ���Է�, ���� ���Ǹ� ���� ������ ���� �Ұ���
*/


--�� ����������
SELECT MEMBER_NAME, MEMBER_EMAIL, MEMBER_TEL, MEMBER_CODE, 
FROM MEMBER_PROFILE;

--�� ���������
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

--�� ������ ���ݸ�ŭ ���ϸ��� �����ִ��� ���� 


--�� ��Ű�� �ݾ� ��ȸ

--�� ���ϸ��� ������ ���� �������̺� insert
INSERT INTO BOOK_LIST (BOOK_CODE, MEMBER_CODE, APPLY_PACKAGE_CODE
, BOOK_PEOPLE, BOOK_DATE, BOOK_REQ)
VALUES(F_CODE('BC', BC_SEQ.NEXTVAL), 'M000001', 'AP000001', 3, SYSDATE, '�����ּ���');

--�� ��� �� �����ȣ ������
SELECT BOOK_CODE
FROM 
(SELECT BOOK_CODE FROM BOOK_LIST WHERE MEMBER_CODE='M000001' ORDER BY BOOK_CODE DESC)
WHERE ROWNUM=1;

--�� �ǿ����� ���̺� insert
INSERT INTO ACTUAL_BOOKER (ACTUAL_BOOKER_CODE, BOOK_CODE, ACTUAL_BOOKER
, ACTUAL_BOOKER_TEL)
VALUES(F_CODE('AB', AB_SEQ.NEXTVAL), 'BC000006', '��¥����', '010-3690-7828');


--�� ����������� ���̺� insert
INSERT INTO BOOK_PAY_LIST(BOOK_PAY_CODE, BOOK_CODE, BOOK_PAY_DATE)
VALUES(F_CODE('BP', BP_SEQ.NEXTVAL), 'BC000006', SYSDATE);


--�� ���ϸ��� ������ ������������ �̵�

select *
from apply_package;

desc book_list;