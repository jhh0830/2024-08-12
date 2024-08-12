
/*
   
       < JOIN >
    
    �� �� �̻��� ���̺���
    �����͸� �Բ� "��ȸ" �ϰ��� �� �� ���Ǵ� ����
    ��ȸ ����� �ϳ��� ����� (RESULT SET) ���� ����
    
    * ������ �����ͺ��̽������� 
      "�ּ���" �� �����ͷ� ������ ���̺� �����͸� "�ɰ���" �����ϰ� ����
      > �������� "�ߺ�" �� �ּ�ȭ �ϱ� ���ؼ� �ִ��� �ɰ��°�!!
        (����ȭ �۾�)
      
    * ��, JOIN ������ ���ؼ� �������� ���̺� �� "����" �� �ξ
      ���� ��ȸ�ؾ� ��!!
      ��, ������ JOIN �� �ؼ� ��ȸ�� �ϴ°� �ƴϰ�
      ���̺� ���� "�����" �� �ش��ϴ� �÷��� ��Ī���Ѽ� ��ȸ�ؾ���!!
      (�ܷ�Ű) 
      
    * JOIN �� ũ�� "����Ŭ ���� ����" �� "ANSI (�̱�����ǥ����ȸ) ����"
      ���� ������ ������.
      
            ����Ŭ ���� ����        |     ANSI ����
======================================================================
               �����            |       ��������
            (EQUAL JOIN)          |    (INNER JOIN)
-------------------------------------------------------------------------------
               ��������             |     �ܺ�����  
             (LEFT JOIN)           |      (LEFT OUTER JOIN)
             (RIGHT JOIN)          |     (RIGHT OUTER JOIN)
                                   |       (FULL OUTER JOIN)
                                   |  => ����Ŭ ���뱸�������� �Ұ�
--------------------------------------------------------------------
            ī���̻� ��              |           ��������
        (CARTESIAN PRODUCT)        |          (CROSS JOIN)
--------------------------------------------------------------------------
                            ��ü���� (SELF JOIN)
                            ������ (NON EQUAL JOIN)


*/

-- EMPLOYEE ���̺�κ��� ��ü �������
-- ���, ����� ,�μ��ڵ�, �μ������ �˾Ƴ��� �ʹٸ�?
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
--> EMPLOYEE ���̺��� DEPT_CODE
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;
--> DEPARTMENT ���̺��� DEPT_ID

-- EMPLOYEE ���̺�κ��� ��ü �������
-- ���, �����, �����ڵ�, ���޸���� �˾Ƴ����� �Ѵٸ�?

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;
--> EMPLOYEE ���̺��� JOB_CODE

SELECT JOB_CODE, JOB_NAME
FROM JOB;
--> JOB ���̺��� JOB_CODE

--> JOIN �� ���ؼ� "�����" �� �ش�Ǵ� �÷���
-- ����� ��Ī��Ű�� ��ġ �ϳ��� ������� ���� ��������!!


--------------------------------------------------------------------------------

/*
    1. ����� (EQUAL JOIN) / �������� (INNER JOIN)
    
    ����� �÷����� "��ġ" �ϴ� ��鸸 ���εǼ� ��ȸ�ϰڴ�.
    ��, ��ġ���� �ʴ� ������ ��ȸ���� �����ϰڴ�.
    
*/

-->> ����Ŭ ���� ����
--  FROM ���� ��ȸ�ϰ��� �ϴ� ���̺����� ���� (,��)
--  WHERE ���� ��Ī��ų �÷��� (�����) �� ���� ���� ���

-- ��ü ������� ���, �����, �μ��ڵ�, �μ����� ���� ��ȸ
-- 1) ����� �÷����� ���� �ٸ� ��� 
-- EMPLOYEE ���̺��� DEPT_CODE / DEPARTMENT ���̺��� DEPT_ID
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--> ��ġ���� �ʴ� ���� ��ȸ���� ���ܵ� �� Ȯ�� ���� 
-- (DEPT_CODE �� NULL �̿��� 2���� ��������ʹ�
-- ��ȸ�� �ȵ�)
-- (DEPT_ID �� D3, D4, D7 �� �μ��� ���� ���� ��ȸ�� �ȵ�)

-- ���, �����, �����ڵ�, ���޸�
-- 2) ���� �� �� �÷����� ���� ���
-- EMPLOYEE ���̺��� JOB_CODE / JOB ���̺��� JOB_CODE
/*
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE,JOB
WHERE JOB_CODE = JOB_CODE;
*/
--> ���� �߻�
-- AMBIGUOUSLY : �ָŸ�ȣ��
-- Ȯ���� � ���̺��� �÷������� �� ����ؾ� �ذ� ����!!

-- ���1. ���̺���� �̿��ϴ� ���
-- ���̺��.�÷���
SELECT EMP_ID, EMP_NAME,EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- ���2. ���̺� ��Ī �ο� �� ��Ī�� �̿��ϴ� ���
-- (��� ���̺��� ��Ī�� ���� �� ����!!)
-- ��Ī.�÷���
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-->> ANSI ����
--  FROM ���� ���� ���̺���� �ϳ��� ����� ��
--  �� �ڿ� JOIN ������ ���� ��ȸ�ϰ��� �ϴ� ���̺���� ���
--  ���� ��Ī��ų �÷��� ���� ���ǵ� JOIN ���� ���� ���
--  (USING ���� / ON ����)


-- ���, �����, �μ��ڵ�, �μ���
-- 1) ����� �÷����� �ٸ� ���
-- EMPLOYEE = DEPT_CODE / DEPARTMENT = DEPT_ID
-- => ������ ON ������ ��� ����!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/* INNER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--> INNER ���� ����

-- ���, �����, �����ڵ�, ���޸�
-- 2) ���� �� �� �÷����� ���� ���
-- EMPLOYEE - JOB_CODE/ JOB - JOB_CODE
-- => ON ����, USING ���� ��� ��� ����
-- 2_1) ON ���� �̿�
-- AMBIGUOUSLY �� �߻��� �� �ֱ� ������
-- ���̺���̵� ��ġ�̵� ���� Ȯ���ϰ� ����ؾ� �Ѵ�!!
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 2_2) USING ���� �̿�
-- ON ������ ������� ���� ���ǽ��� ���� ���� ���,
-- USING ������ ���������� "�����" �� �������ִ� ������
-- => ������ �÷��� �ϳ��� ���ָ� �˾Ƽ� ��Ī������
--   AMBIGUOUSL �߻�X
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- ����)
-- ����� �÷����� ������ ���� NATIRAL JOIN �� ����
-- NATURAL JOIN : �ڿ� ����
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

--> �ΰ��� ���̺�� �����ϰ�, ������� ���� ������ ��� X
--  �� ���Ե� �ΰ��� ���̺� ��ġ�ϴ� �÷��� �����ϰ� �Ѱ��� �����ϱ� ����


-- ������� ���� ���� �Ӹ� ���̶�
-- �߰����� ���ǵ� ���� ����!!

-- ������ "�븮" �� ������� ���,�̸�, �޿�, ���޸� ��ȸ
-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- ������� ���� ����
    AND JOB_NAME = '�븮'; -- �߰����� ���ǽ�
    
-->> ANSI ����
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
 FROM EMPLOYEE E
  -- JOIN JOB USING (JOB_CODE)
 JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
 WHERE JOB_NAME = '�븮';
 
----- < �ǽ����� > ------
-- 1. �μ��� "�λ������" �� ������� ���,�����, ���ʽ� ��ȸ
-->> ����Ŭ ���뱸��
SELECT EMP_ID, EMP_NAME, BONUS , DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID 
 AND DEPT_TITLE = '�λ������';
-->> ANSI ����

SELECT EMP_ID, EMP_NAME, BONUS ,DEPT_TITLE
FROM EMPLOYEE E JOIN DEPARTMENT D ON(
 E.DEPT_CODE = D.DEPT_ID )
WHERE DEPT_TITLE = '�λ������';

-- 2. �μ��� "�ѹ���"�� �ƴ� ������� �����, �޿�, �Ի��� ��ȸ
-->> ����Ŭ ���뱸��
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID 
 --AND NOT (DEPT_TITLE = '�ѹ���');
AND DEPT_TITLE !='�ѹ���'
UNION
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL;
-->> ANSI ����
SELECT  EMP_NAME, SALARY , HIRE_DATE
FROM EMPLOYEE E JOIN  DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
--WHERE NOT (DEPT_TITLE = '�ѹ���');
WHERE DEPT_TITLE != '�ѹ���'
UNION
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL;

-- 3. ���ʽ��� �޴� ������� ���, �����, ���ʽ� , �μ��� ��ȸ
-->> ����Ŭ ���뱸��
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E , DEPARTMENT D
WHERE E.DEPT_CODE=D.DEPT_ID AND  BONUS IS NOT  NULL
ORDER BY EMP_ID ASC;
-->> ANSI ����
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
WHERE  BONUS IS NOT NULL
ORDER BY EMP_ID ASC;


-- 4. �Ʒ��� �� ���̺��� �����ؼ� �μ��ڵ�, �μ��� ,�����ڵ�, ������ ��ȸ

SELECT * FROM DEPARTMENT;-- DEPT_ID, DEPT_TITLE , LOCATION_ID
SELECT * FROM LOCATION;  -- LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME
-->> ����Ŭ ���뱸��
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D , LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;
-->> ANSI ����
SELECT  DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- ���� 4����������..
-- �ƽþ� ������ ��ġ�� �μ��� ����ʹٸ�?
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D , LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE AND LOCAL_NAME LIKE 'ASIA%';

SELECT  DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE  LOCAL_NAME LIKE 'ASIA%';

-- > � ���� / ���� ����
-- : "��ġ" �ϴ� ��鸸 ��ȸ�ϴ� ����
-- ��ġ���� �ʴ� ����� ���ʿ� ��ȸ���� ����!!
