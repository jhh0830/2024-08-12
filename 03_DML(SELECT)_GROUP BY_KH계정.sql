
/*
    < GROUP BY �� >
    
    �׷��� ������ ������ ������ �� �ִ� ����
    ���� ���õ� ���غ��� �׷��� ���� �� ����
    
    GROUP BY ���� ���� ���� ��� ������ 1���� �׷����� �� ����
    GROUP BY ���� ���� �Ǹ� ���� ������ ���ؿ� ���� �������� 
    �׷��� ���� ����
            
*/

-- ��ü ����� �� �޿� ��
SELECT SUM(SALARY)
FROM EMPLOYEE;
-- > ��ü 23���� ������� �ϳ��� �׷����� ���
-- �޿��� ������ ���� �����!!

-- �� �μ��� �� �޿� ��
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> �μ����� �׷��� ��� (�� 7���� �׷��� ����)
-- �� �μ�����  �޿��� �� ���� ���� ��!!

-- �� �μ��� ��� ��
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> �μ����� �׷��� ��� (�� 7���� �׷��� ����)
-- �� �μ����� ����� ���� ��� ���Ѱ�!!

-- �� ���޺� ��� ��
SELECT JOB_CODE, COUNT(*) -- 3. SELECT ��
FROM EMPLOYEE -- 1. FROM ��
GROUP BY JOB_CODE -- 2. GROUP BY ��
ORDER BY JOB_CODE; -- 4. ORDER BY ��

-- �� ���޺� �����ڵ�, �� �޿��� ��, �����, ���ʽ��� �޴� �����, 
-- ���ʽ��� �޴� �����, ��ձ޿�, �ְ�޿�, �ּұ޿�
SELECT JOB_CODE
     , SUM(SALARY) "�޿� ��"
     , COUNT(*) "��� ��"
     , COUNT(BONUS) AS "���ʽ��� �޴� ��� ��" 
     , ROUND(AVG(SALARY)) AS ��ձ޿�
     , MAX(SALARY) AS �ְ�޿�
     , MIN(SALARY) AS "�ּұ޿�"
     FROM EMPLOYEE
    GROUP BY JOB_CODE
    ORDER BY JOB_CODE ASC;


-- �� �μ��� �μ��ڵ�, �����, ���ʽ����޴»����.
-- ����� �ִ� �����, ��ձ޿�
SELECT NVL(DEPT_CODE,'����') "�μ��ڵ�"
     , COUNT(*) "��� ��"
     , COUNT(BONUS) AS "���ʽ��� �޴� ��� ��"
     , COUNT(MANAGER_ID) "����� �ִ� ��� ��"
     , ROUND(AVG(SALARY)) || '��' AS ��ձ޿�
     FROM EMPLOYEE
     GROUP BY DEPT_CODE
     ORDER BY �μ��ڵ� ASC;
--> GROPU BY �������� ��Ī�� ����� �� ����!!
-- ��? SELECT �� ���� ���� ����Ǳ� ����

-- ���� �� �����
SELECT SUBSTR(EMP_NO, 8 ,1) "����"
 , COUNT(*) "�����"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8 ,1);
--> GROUP BY ������ ������ �÷��� ����� ���� ����.
-- �Լ����� ����ε� �׷����� �� �� ����!!

SELECT DECODE(SUBSTR(EMP_NO, 8,1), '1', '����'
                                  , '2', '����') "����"
    ,COUNT(*) "�����"
    FROM EMPLOYEE
    GROUP BY SUBSTR(EMP_NO, 8 ,1);
---------------------------------------------


/*
    < HAVING �� >
    
    �׷쿡 ���� ������ �����ϰ� ���� �� ��� �Ǵ� ����
    ��, �׷��Լ����� ���Ե� ���ǽ��� �����ϴ� �뵵!!
    
*/

-- �� �μ��� ��� �޿��� 300���� �̻��� �μ��鸸 ��ȸ
SELECT DEPT_CODE, ROUND(AVG(SALARY))
   FROM EMPLOYEE
   WHERE AVG(SALARY)>= 3000000
   GROUP BY DEPT_CODE;
--> ���� �� : WHERE ������ �׷��Լ����� ���Ե� �� ����!!

-- �� ��� ����� �� �ִ°� HAVING ����!!

SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE ASC;
-- �� ���� �� �� �޿� ���� 1000���� �̻��� �����ڵ�, �޿� ��
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE ASC;

-- �� �μ� �� ���ʽ��� �޴� ����� ���� �μ����� ��ȸ
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

/*
    < SELCET ���� ǥ���� �� ���� ���� >
    
    5. SELECT * / ��ȸ�ϰ����ϴ��÷��� / ���ͷ� / �������� / �Լ��� AS "��Ī"
   1.  FROM ��ȸ�ϰ����ϴ����̺�� / �������̺�(DUAL) 
   2.  WHERE ���ǽ�(�׷��Լ��� �ȵ�)
   3.  GROUP BY �׷���ؿ��ش��ϴ��÷��� / �Լ���
   4. HAVING �׷��Լ��Ŀ��������ǽ�
   6. ORDER BY [���ı��ؿ��ش��ϴ��÷��� / ��Ī / �÷�����] [ASC/ DESC (��������)][NULL FIRST / NULL LAST (��������)] 
    
*/

---------------------------------------------------------------------------------------------
/*
    < ���� ������ SET OPERATOR>
    
    ���� ���� SELECT ���� ������ �ϳ��� ���������� ����� ������
    
    - UNION : ������
               
                  �� �������� ������ ������� ���� ��
                  �ߺ��Ǵ� �κ��� �ѹ� �A��(OR �� �ǹ�)
                
    - INTERSECT : ������
              
                  �� �������� ������ ������� �ߺ��� ����� �κ� (AND�� �ǹ�)
    - UNION ALL : ������ ����� �������� ������ ����
                    �� �������� ������ ������� ������ ����,
                    ��, �����տ��� �ߺ� ���Ÿ� ���� ���� ����
                    (�ߺ��� ����� ��Ÿ�� �� ����!!)
    
    - MINUS :     ������
                  ���� ������ ����� ����
                  ���� ������ ������� ���
*/

-- 1. UNION (������)
-- �� �������� ������ ������� �������� �ߺ��Ǵ� ����� �ѹ��� ��ȸ
-- �μ��ڵ尡 D5 �̰ų� �޿��� 300���� �ʰ��� ����� ��ȸ
-- (���, �����, �μ��ڵ�, �޿�)

-- �μ��ڵ尡 D5 �� ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
--> 6�� ��ȸ (���ؼ�, ������, ������, �����. ����ȫ, ������)

-- �޿��� 300���� �ʰ��� ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;
--> 8�� ��ȸ (�谡��, �ǰ���, �����, �赿��, ��μ�, �����, ������, ������)

-- �μ��ڵ尡 D5 �̰ų� �Ǵ� �޿��� 300���� �ʰ��� ����� ��ȸ
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 12�� ��ȸ (6�� + 8�� - 2��)

-- UNION ������ ���  OR �����ڸ� �̿��� �� �ִ�.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
OR SALARY > 3000000;

-- 2. UNION ALL
-- �������� ���� ����� ������ ���ϴ� ������
-- (�ߺ��Ǵ� ����� ������ �� �� ����)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--> 14�� ��ȸ (6�� + 8��)


--> ����)
-- UNION ���꺸�� UNION ALL ������ �ӵ��� �� ������.
-- UNION ������ ���������� UNION ALL �� �ߺ����Ÿ� �ؼ� ����� ��ȯ

-- 3. INTERSECT (������)
-- ���� �������� ����� �ߺ��� ��� �κ��� �ѹ��� ��ȸ
-- �μ� �ڵ尡 D5 �̸鼭 �޿������� 300���� �ʰ��� ���
-- (���, �̸�, �μ��ڵ�, �޿�)

-- �μ� �ڵ尡 D5 �� �����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- �޿��� 300���� �ʰ��� �����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALALRY > 3000000;

-- �μ��ڵ尡 D5 �̸鼭 �Ӹ� �ƴ϶�
-- �޿������� 300���� �ʰ��� �����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 2�� ��ȸ

-- INTERSECT ������ ��� AND ������ �̿��غ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND SALARY > 3000000;


-- 4. MINUS (������)
-- ���� ���� ����� ���� ���� ����� �� ������
-- �μ� �ڵ尡 D5 �� ����� �� �޿��� 300���� �ʰ��� ������� �����ϰ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 6�� �� ��ġ�� 2���� �����ϰ� ������ 4�� ��ȸ

-- ������ �ٲ�ٸ�?
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' ;
-- > 8�� �� ��ġ�� 2���� �����ϰ� ������ 6�� ��ȸ

-- ���� MINUS ������ �Ƚᵵ ����
-- �μ� �ڵ尡 D5 �� ����� �� �޿��� 300���� �ʰ��� ����鸸 �����ϰ� ��ȸ
-- �μ� �ڵ尡 D5 �� ����� �� �޿��� 300���� ������ ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY < 3000000;
-- ���տ����� ��� �� ���ǻ���
-- ��ġ���� �ϴ� SELECT ���� SELECT ���� ��� ��ġ�ؾ���!!


