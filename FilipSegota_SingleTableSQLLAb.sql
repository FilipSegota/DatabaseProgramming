--FILIP SEGOTA, Single Table SQL Lab
--All lines under 80

--PART1
------------------------------------------------------------------------------
--1. Display all the courses you have taken (code, number) ordered by code 
--then number
select enr_sec_cou_code as courseCode, enr_sec_cou_num as courseNumber
from enroll
where enr_stu_id = 3490
order by enr_sec_cou_code, enr_sec_cou_num;

--2. Display the courses taught by Dr. Bareiss (3429 - correction) last fall 
--or Dr. Ramos (1366) last spring
select tea_sec_cou_code as courseCode, tea_sec_cou_num as courseNumber
from teach
where (tea_instr_id = 3429 and tea_sec_session = '2019FA') or
(tea_instr_id = 1366 and tea_sec_session = '2019SP');

--3. Display the ids of students who were in a math course taught 
--by Prof. Campeau (1533) last fall (MATH 070 and MATH 111).
--Do not use an IN operator.
select enr_stu_id as studentID
from enroll
where ((enr_sec_cou_code = 'MATH' and enr_sec_cou_num = '070') or 
(enr_sec_cou_code = 'MATH' and enr_sec_cou_num = '111')) and 
enr_sec_session = '2019FA';

--4. Display the ids of students who were in a math course taught
--by Prof. Campeau last fall (MATH 070 and MATH 111).
--Use the IN operator.
select enr_stu_id as studentID
from enroll
where (enr_sec_cou_code in ('MATH') and enr_sec_cou_num in ('070', '111')) and
enr_sec_session in ('2019FA');

--5. Display all courses taught within the Religion and Philosophy department 
--that are lower level (not 300 or above).
--*I tried to get as much courses as I can. You said it was alright
select cou_code as courseCode, cou_num as courseNumber, cou_name as courseName
from course
where cou_code in ('BBST', 'BIBL', 'MIN', 'PHIL', 'THEO', 'YMN') and
cou_num < '300';

--6. Display the emails and names of all professors in one column 
--with just a space separating the two.
select instr_email || ' ' || instr_name as instructor
from instructor;

--7. Display all the courses (code, number, section, session)
--that don't have a start time
select mt_sec_cou_code as courseCode, mt_sec_cou_num as courseNumber,
mt_sec_num as sectionNumber, mt_sec_session
as sectionSession
from meeting
where mt_start is null;

--8. Display all the different unique combinations of what days courses
--have been taught at Bethel
select distinct mt_days as days
from meeting;

--9. Display the students whose email has yet to be updated from last year
select stu_name as studentName, stu_email as studentEmail
from student
where stu_email like '%bethelcollege%';

--PART2
--------------------------------------------------------------------------------------
--1. Display the courses you have taken (code, number, section, session)
--ordered by when they were taken.
--Assume that there is at least three years of data to be dealt with.
--*It's sorted the right way, even spring and summer
select enr_sec_cou_code as courseCode, enr_sec_cou_num as courseNumber,
enr_sec_num as sectionNumber, enr_sec_session
as sectionSession
from enroll
where enr_stu_id = 3490
order by substr(enr_sec_session, 1, 4), 
(case
    when substr(enr_sec_session, 5, 2)='SP' then substr(enr_sec_session, 5, 1)
end
), substr(enr_sec_session, 5, 1) DESC;

--2. Display the number of distinct Biblical literature courses taugh
--last semester.
select count(distinct sec_cou_num) as count
from section
where sec_cou_code = 'BIBL' and sec_session = '2019FA';

--3. Display the number of instructors teaching English courses last semester.
select count(distinct tea_instr_id) as count
from teach
where tea_sec_cou_code = 'ENGL' and tea_sec_session = '2019FA';

--4. Display the number of instructors teaching English courses
--each semester that is in the database ordered by when they were taught.
--Don't worry if the summer session is out of order->extra credit to fix that!
--*Everything ordered correctly for that extra credit
select tea_sec_session as semester, count(distinct tea_instr_id) as count
from teach
where tea_sec_cou_code = 'ENGL'
group by tea_sec_session
order by substr(tea_sec_session, 1, 4), 
(case
    when substr(tea_sec_session, 5, 2)='SP' then substr(tea_sec_session, 5, 1)
end
), substr(tea_sec_session, 5, 1) DESC;

--5. Display the time of day (military time) that each
--sociology course was taught last semester
select mt_sec_cou_code as courseCode, mt_sec_cou_num as courseNumber,
to_char(mt_start, 'HH24:MI') as startTime
from meeting
where mt_sec_cou_code = 'SOC' and mt_sec_session = '2019FA' and
mt_start is not null;

--6. Display the max course number and min course number
--offered by each "code" last semester
select cou_code as courseCode, min(cou_min) as minCourseNumber,
max(cou_max) as maxCourseNumber
from course
group by cou_code
order by cou_code;

--7. Display the number of times each student has changed his/her major.
--There's no student that changed major in database,
--they are only changing their instructors
select sm_stu_id as studentID, count(sm_stu_id)-1 as count
from stu_maj
group by sm_stu_id
order by sm_stu_id;

--8. For each student, classify them based upon
--how often they changed their major:
--0 -> stable, 1-2 -> typical, 3-4 -> searching, >= 5 -> unsure
select sm_stu_id as studentID, (case
    when count(sm_stu_id)-1 = 0 then 'stable'
    when count(sm_stu_id)-1 = 1 or count(sm_stu_id)-1 = 2 then 'typical'
    when count(sm_stu_id)-1 = 3 or count(sm_stu_id)-1 = 4 then 'searching'
    else 'unsure'
end) as classify 
from stu_maj
group by sm_stu_id
order by sm_stu_id;

--9. List the codes for the courses that have at least one class
--with an enrollment greater than 100 last semester
select enr_sec_cou_code as courseCode, count(enr_sec_cou_num) as count
from enroll
where enr_sec_session = '2019FA'
group by enr_sec_cou_code
having count(enr_sec_cou_num) > 100;

--10. Display all students names sorted alphabetically
--by last name then first name
--You may assume that each student only has two names listed.
select stu_name
from student
order by substr(stu_name, instr(stu_name, ' ')+1),
substr(stu_name, 1, instr(stu_name, ' ')-1);