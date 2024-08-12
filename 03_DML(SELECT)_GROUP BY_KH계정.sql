
/*
    < GROUP BY 절 >
    
    그룹을 묶어줄 기준을 제시할 수 있는 구문
    해장 제시된 기준별로 그룹을 묶을 수 있음
    
    GROUP BY 절을 쓰지 않을 경우 무조건 1개의 그룹으로 다 묶임
    GROUP BY 절을 쓰게 되면 내가 제시한 기준에 대한 갯수별로 
    그룹이 각각 묶임
            
*/

-- 전체 사원의 총 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE;
-- > 전체 23명의 사원들을 하나의 그룹으로 묶어서
-- 급여의 총합을 구한 결과임!!

-- 각 부서별 총 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> 부서별로 그룹을 묶어서 (총 7개의 그룹이 나옴)
-- 각 부서별로  급여의 총 합을 구한 것!!

-- 각 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> 부서별로 그룹을 묶어서 (총 7개의 그룹이 나옴)
-- 각 부서별로 사원의 수를 묶어서 구한것!!

-- 각 직급별 사원 수
SELECT JOB_CODE, COUNT(*) -- 3. SELECT 절
FROM EMPLOYEE -- 1. FROM 절
GROUP BY JOB_CODE -- 2. GROUP BY 절
ORDER BY JOB_CODE; -- 4. ORDER BY 절

-- 각 직급별 직급코드, 총 급여의 합, 사원수, 보너스를 받는 사원수, 
-- 보너스를 받는 사원수, 평균급여, 최고급여, 최소급여
SELECT JOB_CODE
     , SUM(SALARY) "급여 합"
     , COUNT(*) "사원 수"
     , COUNT(BONUS) AS "보너스를 받는 사원 수" 
     , ROUND(AVG(SALARY)) AS 평균급여
     , MAX(SALARY) AS 최고급여
     , MIN(SALARY) AS "최소급여"
     FROM EMPLOYEE
    GROUP BY JOB_CODE
    ORDER BY JOB_CODE ASC;


-- 각 부서별 부서코드, 사원수, 보너스를받는사원수.
-- 사수가 있는 사원수, 평균급여
SELECT NVL(DEPT_CODE,'미정') "부서코드"
     , COUNT(*) "사원 수"
     , COUNT(BONUS) AS "보너스를 받는 사원 수"
     , COUNT(MANAGER_ID) "사수가 있는 사원 수"
     , ROUND(AVG(SALARY)) || '원' AS 평균급여
     FROM EMPLOYEE
     GROUP BY DEPT_CODE
     ORDER BY 부서코드 ASC;
--> GROPU BY 절에서는 별칭을 사용할 수 없다!!
-- 왜? SELECT 절 보다 먼저 실행되기 때문

-- 성별 별 사원수
SELECT SUBSTR(EMP_NO, 8 ,1) "성별"
 , COUNT(*) "사원수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8 ,1);
--> GROUP BY 절에는 무조건 컬럼명만 들어가라는 법은 없다.
-- 함수식의 결과로도 그룹핑을 할 수 있음!!

SELECT DECODE(SUBSTR(EMP_NO, 8,1), '1', '남자'
                                  , '2', '여자') "성별"
    ,COUNT(*) "사원수"
    FROM EMPLOYEE
    GROUP BY SUBSTR(EMP_NO, 8 ,1);
---------------------------------------------


/*
    < HAVING 절 >
    
    그룹에 대한 조건을 제사하고 싶을 때 사용 되는 구문
    즉, 그룹함수식이 포함된 조건식을 제시하는 용도!!
    
*/

-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
   FROM EMPLOYEE
   WHERE AVG(SALARY)>= 3000000
   GROUP BY DEPT_CODE;
--> 오류 남 : WHERE 절에는 그룹함수식이 포함될 수 없음!!

-- 이 경우 사용할 수 있는게 HAVING 절임!!

SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE ASC;
-- 각 직급 별 총 급여 합이 1000만원 이상인 직급코드, 급여 합
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE ASC;

-- 각 부서 별 보너스를 받는 사원이 없는 부서만을 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

/*
    < SELCET 문의 표현법 및 실행 순서 >
    
    5. SELECT * / 조회하고자하는컬럼명 / 리터럴 / 산술연산식 / 함수식 AS "별칭"
   1.  FROM 조회하고자하는테이블명 / 가상테이블(DUAL) 
   2.  WHERE 조건식(그룹함수는 안됨)
   3.  GROUP BY 그룹기준에해당하는컬럼명 / 함수식
   4. HAVING 그룹함수식에대한조건식
   6. ORDER BY [정렬기준에해당하는컬럼명 / 별칭 / 컬럼순번] [ASC/ DESC (생략가능)][NULL FIRST / NULL LAST (생략가능)] 
    
*/

---------------------------------------------------------------------------------------------
/*
    < 집합 연산자 SET OPERATOR>
    
    여러 개의 SELECT 문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    - UNION : 하집합
               
                  두 쿼리문을 수행한 결과값을 더한 후
                  중복되는 부분을 한번 뺸것(OR 의 의미)
                
    - INTERSECT : 교집합
              
                  두 쿼리문을 수행한 결과값의 중복된 결과값 부분 (AND의 의미)
    - UNION ALL : 합집합 결과에 교집합이 더해진 개념
                    두 쿼리문을 수행한 결과값을 무조건 더함,
                    즉, 합집합에서 중복 제거를 하지 않은 개념
                    (중복된 결과가 나타날 수 있음!!)
    
    - MINUS :     차집합
                  선행 쿼리문 결과값 빼기
                  후행 쿼리문 결과값의 결과
*/

-- 1. UNION (합집합)
-- 두 쿼리문을 수행한 결과값을 더하지만 중복되는 결과는 한번만 조회
-- 부서코드가 D5 이거나 급여가 300만원 초과인 사원들 조회
-- (사번, 사원명, 부서코드, 급여)

-- 부서코드가 D5 인 사원들만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
--> 6명 조회 (김준석, 김형문, 문병곤, 박재우. 반진홍, 이유민)

-- 급여가 300만원 초과인 사원들만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;
--> 8명 조회 (김가현, 권가영, 김다훈, 김동현, 김민석, 박재우, 이유민, 정원섭)

-- 부서코드가 D5 이거나 또는 급여가 300만원 초과인 사원들 조회
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 12명 조회 (6명 + 8명 - 2명)

-- UNION 연산자 대신  OR 연산자를 이용할 수 있다.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
OR SALARY > 3000000;

-- 2. UNION ALL
-- 여러개의 쿼리 결과를 무조건 더하는 연산자
-- (중복되는 결과가 여러개 들어갈 수 있음)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--> 14명 조회 (6명 + 8명)


--> 참고)
-- UNION 연산보다 UNION ALL 연산의 속도가 더 빠르다.
-- UNION 연산은 내부적으로 UNION ALL 후 중복제거를 해서 결과를 반환

-- 3. INTERSECT (교집합)
-- 여러 쿼리문의 결과의 중복된 결과 부분을 한번만 조회
-- 부서 코드가 D5 이면서 급여까지도 300만원 초과인 사원
-- (사번, 이름, 부서코드, 급여)

-- 부서 코드가 D5 인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 급여가 300만원 초과인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALALRY > 3000000;

-- 부서코드가 D5 이면서 뿐만 아니라
-- 급여까지도 300만원 초과인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 2명 조회

-- INTERSECT 연산자 대신 AND 연산자 이용해보기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND SALARY > 3000000;


-- 4. MINUS (차집합)
-- 선행 쿼리 결과에 후행 쿼리 결과를 뺀 나머지
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 초과인 사원들을 제외하고 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--> 6명 중 겹치는 2명을 제외하고 나머지 4명 조회

-- 순서가 바뀐다면?
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' ;
-- > 8명 중 겹치는 2명을 제외하고 나머지 6명 조회

-- 굳이 MINUS 연산을 안써도 가능
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 초과인 사원들만 제외하고 조회
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 이하인 사원들만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY < 3000000;
-- 집합연산자 사용 시 주의사항
-- 합치고자 하는 SELECT 문의 SELECT 절이 모두 일치해야함!!


