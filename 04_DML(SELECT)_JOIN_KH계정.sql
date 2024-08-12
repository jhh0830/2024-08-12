
/*
   
       < JOIN >
    
    두 개 이상의 테이블에서
    데이터를 함께 "조회" 하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물 (RESULT SET) 으로 나옴
    
    * 관계형 데이터베이스에서는 
      "최소한" 의 데이터로 각가의 테이블에 데이터를 "쪼개서" 보관하고 있음
      > 데이터의 "중복" 을 최소화 하기 위해서 최대한 쪼개는것!!
        (정규화 작업)
      
    * 즉, JOIN 구문을 통해서 여러개의 테이블 간 "관계" 를 맺어서
      같이 조회해야 함!!
      단, 무작정 JOIN 을 해서 조회를 하는건 아니고
      테이블 간의 "연결고리" 에 해당하는 컬럼을 매칭시켜서 조회해야함!!
      (외래키) 
      
    * JOIN 은 크게 "오라클 전용 구문" 과 "ANSI (미국국립표준협회) 구문"
      으로 문법이 나뉜다.
      
            오라클 전용 구문        |     ANSI 구문
======================================================================
               등가조인            |       내부조인
            (EQUAL JOIN)          |    (INNER JOIN)
-------------------------------------------------------------------------------
               포괄조인             |     외부조인  
             (LEFT JOIN)           |      (LEFT OUTER JOIN)
             (RIGHT JOIN)          |     (RIGHT OUTER JOIN)
                                   |       (FULL OUTER JOIN)
                                   |  => 오라클 전용구문에서는 불가
--------------------------------------------------------------------
            카테이산 곱              |           교차조인
        (CARTESIAN PRODUCT)        |          (CROSS JOIN)
--------------------------------------------------------------------------
                            자체조인 (SELF JOIN)
                            비등가조인 (NON EQUAL JOIN)


*/

-- EMPLOYEE 테이블로부터 전체 사원들의
-- 사번, 사원명 ,부서코드, 부서명까지 알아내고 싶다면?
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
--> EMPLOYEE 테이브의 DEPT_CODE
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;
--> DEPARTMENT 테이블의 DEPT_ID

-- EMPLOYEE 테이블로부터 전체 사원들의
-- 사번, 사원명, 직급코드, 직급명까지 알아내고자 한다면?

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;
--> EMPLOYEE 테이블의 JOB_CODE

SELECT JOB_CODE, JOB_NAME
FROM JOB;
--> JOB 테이블의 JOB_CODE

--> JOIN 을 통해서 "연결고리" 에 해당되는 컬럼을
-- 제대로 매칭시키면 마치 하나의 결과물로 조히 가능해짐!!


--------------------------------------------------------------------------------

/*
    1. 등가조인 (EQUAL JOIN) / 내부조인 (INNER JOIN)
    
    연결고리 컬럼값이 "일치" 하는 행들만 조인되서 조회하겠다.
    즉, 일치하지 않는 값들은 조회에서 제외하겠다.
    
*/

-->> 오라클 전용 구문
--  FROM 절에 조회하고자 하는 테이블명들을 나열 (,로)
--  WHERE 절에 매칭시킬 컬럼명 (연결고리) 에 대한 조건 기술

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 같이 조회
-- 1) 연결고리 컬러명이 서로 다른 경우 
-- EMPLOYEE 테이블의 DEPT_CODE / DEPARTMENT 테이블의 DEPT_ID
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--> 일치하지 않는 값은 조회에서 제외된 것 확인 가능 
-- (DEPT_CODE 가 NULL 이였던 2명의 사원데이터는
-- 조회가 안됨)
-- (DEPT_ID 가 D3, D4, D7 인 부서명 정보 또한 조회가 안됨)

-- 사번, 사원명, 직급코드, 직급명
-- 2) 연결 할 두 컬럼명이 같을 경우
-- EMPLOYEE 테이블의 JOB_CODE / JOB 테이블의 JOB_CODE
/*
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE,JOB
WHERE JOB_CODE = JOB_CODE;
*/
--> 오류 발생
-- AMBIGUOUSLY : 애매모호한
-- 확실히 어떤 테이블의 컬럼명인지 다 명시해야 해결 가능!!

-- 방법1. 테이블명을 이용하는 방법
-- 테이블명.컬럼명
SELECT EMP_ID, EMP_NAME,EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법2. 테이블에 별칭 부여 후 별칭을 이용하는 방법
-- (사실 테이블에도 별칭을 붙일 수 있음!!)
-- 별칭.컬럼명
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-->> ANSI 구문
--  FROM 절에 기준 테이블명을 하나만 기술한 뒤
--  그 뒤에 JOIN 절에서 같이 조회하고자 하는 테이블명을 기술
--  또한 매칭시킬 컬럼에 대한 조건도 JOIN 절에 같이 기술
--  (USING 구문 / ON 구문)


-- 사번, 사원명, 부서코드, 부서명
-- 1) 연결고리 컬러명이 다를 경우
-- EMPLOYEE = DEPT_CODE / DEPARTMENT = DEPT_ID
-- => 무조건 ON 구문만 사용 가능!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/* INNER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--> INNER 생략 가능

-- 사번, 사원명, 직급코드, 직급명
-- 2) 연결 할 두 컬럼명이 같은 경우
-- EMPLOYEE - JOB_CODE/ JOB - JOB_CODE
-- => ON 구문, USING 구문 모두 사용 가능
-- 2_1) ON 구문 이용
-- AMBIGUOUSLY 가 발생할 수 있기 때문에
-- 테이블명이든 별치이든 간에 확실하게 명시해야 한다!!
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 2_2) USING 구문 이용
-- ON 구문은 연결고리에 대한 조건식을 내가 직접 기술,
-- USING 구문은 내부족으로 "동등비교" 를 수행해주는 구문임
-- => 동일한 컬럼명 하나만 써주면 알아서 매칭시켜줌
--   AMBIGUOUSL 발생X
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 참고)
-- 연결고리 컬러명이 돌일한 경우는 NATIRAL JOIN 도 가능
-- NATURAL JOIN : 자연 조인
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

--> 두개의 테이블명만 제시하고, 연결고리에 대한 조건은 기술 X
--  운 좋게도 두개의 테이블에 일치하는 컬럼이 유일하게 한개씩 존재하기 때문


-- 연결고리에 대한 조건 뿐만 나이라
-- 추가적인 조건도 제시 가능!!

-- 직급이 "대리" 인 사원들의 사번,이름, 급여, 직급명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
    AND JOB_NAME = '대리'; -- 추가적인 조건식
    
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
 FROM EMPLOYEE E
  -- JOIN JOB USING (JOB_CODE)
 JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
 WHERE JOB_NAME = '대리';
 
----- < 실습문제 > ------
-- 1. 부서가 "인사관리부" 인 사원들의 사번,사원명, 보너스 조회
-->> 오라클 전용구문
SELECT EMP_ID, EMP_NAME, BONUS , DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID 
 AND DEPT_TITLE = '인사관리부';
-->> ANSI 구문

SELECT EMP_ID, EMP_NAME, BONUS ,DEPT_TITLE
FROM EMPLOYEE E JOIN DEPARTMENT D ON(
 E.DEPT_CODE = D.DEPT_ID )
WHERE DEPT_TITLE = '인사관리부';

-- 2. 부서가 "총무부"가 아닌 사원들의 사원명, 급여, 입사일 조회
-->> 오라클 전용구문
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID 
 --AND NOT (DEPT_TITLE = '총무부');
AND DEPT_TITLE !='총무부'
UNION
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL;
-->> ANSI 구문
SELECT  EMP_NAME, SALARY , HIRE_DATE
FROM EMPLOYEE E JOIN  DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
--WHERE NOT (DEPT_TITLE = '총무부');
WHERE DEPT_TITLE != '총무부'
UNION
SELECT EMP_NAME, SALARY ,  HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL;

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스 , 부서명 조회
-->> 오라클 전용구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E , DEPARTMENT D
WHERE E.DEPT_CODE=D.DEPT_ID AND  BONUS IS NOT  NULL
ORDER BY EMP_ID ASC;
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
WHERE  BONUS IS NOT NULL
ORDER BY EMP_ID ASC;


-- 4. 아래의 두 테이블을 참고해서 부서코드, 부서명 ,지역코드, 지역명 조회

SELECT * FROM DEPARTMENT;-- DEPT_ID, DEPT_TITLE , LOCATION_ID
SELECT * FROM LOCATION;  -- LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME
-->> 오라클 전용구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D , LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;
-->> ANSI 구문
SELECT  DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 위의 4번문제에서..
-- 아시아 지역에 위치한 부서만 보고싶다면?
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D , LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE AND LOCAL_NAME LIKE 'ASIA%';

SELECT  DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE  LOCAL_NAME LIKE 'ASIA%';

-- > 등가 조인 / 내부 조인
-- : "일치" 하는 행들만 조회하는 개념
-- 일치하지 않는 행들은 애초에 조회되지 않음!!
