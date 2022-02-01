--FILIP SEGOTA MultipleSQLLab

--PART1
--*In the meeting table, some of the courses that I took don't have the
--same section code as I took.

--1.Display the title of each course you were enrolled in last semester
select c.cou_code, c.cou_num, c.cou_name
from course c, enroll e, student s
where s.stu_name = 'Filip Segota' and s.stu_id = e.enr_stu_id and
e.enr_sec_cou_code = c.cou_code and e.enr_sec_cou_num = c.cou_num
and e.enr_sec_session = '2019FA'
order by cou_code, cou_num;

--2.Display the student id numbers of each of the students that you
--shared a class with last semester (no duplications)
select distinct e2.enr_stu_id
from enroll e1, enroll e2, student s
where s.stu_name = 'Filip Segota' and  s.stu_id = e1.enr_stu_id and
e2.enr_stu_id != s.stu_id and
e1.enr_sec_cou_code = e2.enr_sec_cou_code and
e1.enr_sec_cou_num = e2.enr_sec_cou_num and
e1.enr_sec_num = e2.enr_sec_num and e2.enr_sec_session = '2019FA'
and e1.enr_sec_session = '2019FA'
order by enr_stu_id;

--3.Display the names of each of the students that you
--shared a class with last semester (no duplications)
select distinct s2.stu_name
from enroll e1, enroll e2, student s1, student s2
where s1.stu_name = 'Filip Segota' and  s1.stu_id = e1.enr_stu_id and
s2.stu_id = e2.enr_stu_id and
s2.stu_name != 'Filip Segota' and
e1.enr_sec_cou_code = e2.enr_sec_cou_code and
e1.enr_sec_cou_num = e2.enr_sec_cou_num and
e1.enr_sec_num = e2.enr_sec_num and e2.enr_sec_session = '2019FA'
and e1.enr_sec_session = '2019FA'
order by stu_name;

--4.Display the all the rooms associated with the classes you took last spring
select distinct m.mt_location
from meeting m, enroll e, student s
where s.stu_name = 'Filip Segota' and s.stu_id = e.enr_stu_id and
e.enr_sec_cou_code = m.mt_sec_cou_code and
e.enr_sec_cou_num = m.mt_sec_cou_num and
e.enr_sec_num = m.mt_sec_num and
m.mt_sec_session = '2019FA'
order by mt_location;

--5.Find the names of all the instructors teaching
--in the Religion and Philosophy department last year.
select distinct i.instr_name
from instructor i, teach t
where i.instr_id = t.tea_instr_id and
t.tea_sec_cou_code in ('BBST', 'BIBL', 'MIN', 'PHIL', 'THEO', 'YMN') and
t.tea_sec_session like '%2019%'
order by instr_name;

--6.Find the names of all the instructors who have taught a course with
--the same course code as anyone who taught ENGL 101 last fall.
select distinct i.instr_name, t2.tea_sec_cou_code, t2.tea_sec_cou_num
from instructor i, teach t1, teach t2
where i.instr_id = t2.tea_instr_id and
t1.tea_sec_cou_code = 'ENGL' and t1.tea_sec_cou_num = '101' and
t2.tea_sec_cou_code = t1.tea_sec_cou_code and
t2.tea_sec_cou_num = t1.tea_sec_cou_num and
t2.tea_sec_session = '2019FA'
order by instr_name;

--7.Display your schedule from last fall
select e.enr_sec_cou_code, e.enr_sec_cou_num, m.mt_days
from meeting m, student s, enroll e
where s.stu_name = 'Filip Segota' and s.stu_id = e.enr_stu_id and
e.enr_sec_cou_code = m.mt_sec_cou_code and
e.enr_sec_cou_num = m.mt_sec_cou_num and
e.enr_sec_num = m.mt_sec_num and
m.mt_sec_session = '2019FA'
order by enr_sec_cou_code, enr_sec_cou_num;

--8.Display the name, email, and major of all students currently
--majoring in one major of your choice.
select distinct s2.stu_id, s2.stu_name, s2.stu_email, m2.sm_major1,
m2.sm_major2
from student s1, student s2, stu_maj m1, stu_maj m2
where s1.stu_name = 'Filip Segota' and s2.stu_name != 'Filip Segota' and
s1.stu_id = m1.sm_stu_id and s2.stu_id = m2.sm_stu_id and
(m2.sm_major1 = m1.sm_major1 or m2.sm_major2 = m1.sm_major1)
order by stu_id;

--PART2

--1.Display the title of each course you were enrolled in last semester
select cou_code, cou_num, cou_name
from course
where cou_code||cou_num in (select enr_sec_cou_code||enr_sec_cou_num
                            from enroll
                            where enr_stu_id = (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota'))
order by cou_code, cou_num;

--2.Display the student id numbers of each of the students
--that you shared a class with last semester (no duplications)
select distinct stu_id
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019FA' and
                    enr_stu_id not in (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota') and
                    enr_sec_cou_code||enr_sec_cou_num||enr_sec_num in
                    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
                    from enroll
                    where enr_stu_id in
                    (select stu_id
                    from student
                    where stu_name = 'Filip Segota')))
order by stu_id;

--3.Display the names of each of the students
--that you shared a class with last semester (no duplications)
select distinct stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019FA' and
                    enr_stu_id not in (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota') and
                    enr_sec_cou_code||enr_sec_cou_num||enr_sec_num in
                    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
                    from enroll
                    where enr_stu_id in
                    (select stu_id
                    from student
                    where stu_name = 'Filip Segota')))
order by stu_name;

--4.Display the names of the students that shared a class with
--you last semester but have not shared a major with you.
select distinct stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019FA' and
                    enr_stu_id not in (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota') and
                    enr_sec_cou_code||enr_sec_cou_num||enr_sec_num in
                    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
                    from enroll
                    where enr_stu_id in
                    (select stu_id
                    from student
                    where stu_name = 'Filip Segota')))
and
stu_id not in (select sm_stu_id
                from stu_maj
                where sm_major1 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
and
stu_id not in (select sm_stu_id
                from stu_maj
                where sm_major2 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
order by stu_name;

--5.Display the names of the students that shared a class with you
--last semester and have shared a major with you.
select distinct stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019FA' and
                    enr_stu_id not in (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota') and
                    enr_sec_cou_code||enr_sec_cou_num||enr_sec_num in
                    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
                    from enroll
                    where enr_stu_id in
                    (select stu_id
                    from student
                    where stu_name = 'Filip Segota')))
and
(
stu_id in (select sm_stu_id
                from stu_maj
                where sm_major1 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
or
stu_id in (select sm_stu_id
                from stu_maj
                where sm_major2 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
)
order by stu_name;

--6.Display the names of the students that shared a class with you
--last semester or have shared a major with you.
select distinct stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019FA' and
                    enr_stu_id not in (select stu_id
                                        from student
                                        where stu_name = 'Filip Segota') and
                    enr_sec_cou_code||enr_sec_cou_num||enr_sec_num in
                    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
                    from enroll
                    where enr_stu_id in
                    (select stu_id
                    from student
                    where stu_name = 'Filip Segota')))
or
(
stu_id in (select sm_stu_id
                from stu_maj
                where sm_major1 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
or
stu_id in (select sm_stu_id
                from stu_maj
                where sm_major2 in
                (select sm_major1
                from stu_maj
                where sm_stu_id in
                (select stu_id
                from student
                where stu_name = 'Filip Segota')))
)
order by stu_name;

--7.Display the all the rooms associated with the
--classes you took last spring(I will put fall just so I can see some results)
select distinct mt_location
from meeting
where mt_sec_session = '2019FA' and
mt_sec_cou_code||mt_sec_cou_num||mt_sec_num in
    (select enr_sec_cou_code||enr_sec_cou_num||enr_sec_num
        from enroll
        where enr_stu_id in (select stu_id
                                from student
                                where stu_name = 'Filip Segota'))
order by mt_location;

--8.Find the names of all the instructors teaching
--in the Religion and Philosophy department last year.
select distinct instr_name
from instructor
where instr_id in (select tea_instr_id
                    from teach
                    where tea_sec_cou_code in
                    ('BBST', 'BIBL', 'MIN', 'PHIL', 'THEO', 'YMN')
                    and tea_sec_session like '%2019%')
order by instr_name;

--9.Find the names of the students that have taken every
--100 level music theory (MUTH) course offered.
select distinct stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_cou_code = 'MUTH'
                    and enr_sec_cou_num >= '100')
order by stu_name;

--PART3

--1.Display the ids of all people (students and instructors)
--associated with philosophy courses (PHIL) last semester.
select distinct enr_stu_id
from enroll
where enr_sec_cou_code = 'PHIL' and enr_sec_session = '2019FA'
union
select distinct tea_instr_id
from teach
where tea_sec_cou_code = 'PHIL' and tea_sec_session = '2019FA';

--2.Display the ids of all students who are ready of
--but have not taken ENGL 102 (i.e. have taken ENGL 101)
select distinct enr_stu_id
from enroll
where enr_sec_cou_code = 'ENGL' and enr_sec_cou_num = '101'
minus
select distinct enr_stu_id
from enroll
where enr_sec_cou_code = 'ENGL' and enr_sec_cou_num = '102';

--3.Display the ids of all students who have taken both ENGL 101 and THEO 110
select distinct enr_stu_id
from enroll
where enr_sec_cou_code = 'ENGL' and enr_sec_cou_num = '101'
intersect
select distinct enr_stu_id
from enroll
where enr_sec_cou_code = 'THEO' and enr_sec_cou_num = '110';

--PART4

--1.The names of the instructors that have taught the largest
--number of students last semester (extra credit: for each semester)
select instr_id, instr_name
from instructor
where instr_id in (select tea_instr_id
                    from teach
                    where tea_sec_session = '2019FA'
                    having count(*) in (select max(teachercount)
                                        from (select count(*) as teachercount
                                            from teach
                                            where tea_sec_session = '2019FA'
                                            group by tea_instr_id))
                    group by tea_instr_id)
order by instr_id;
                    
--2.The names of the students who have taken the largest load last spring
select stu_id, stu_name
from student
where stu_id in (select enr_stu_id
                    from enroll
                    where enr_sec_session = '2019SP'
                    having count(*) in (select max(studentcount)
                                        from(select count(*) as studentcount
                                        from enroll
                                        where enr_sec_session = '2019SP'
                                        group by enr_stu_id))
                    group by enr_stu_id)
order by stu_id;

--3.The names of the instructors who have taught less than the
--average number of classes taught by any instructor last fall
select instr_id, instr_name
from instructor
where instr_id in (select tea_instr_id
                    from teach
                    where tea_sec_session = '2019FA'
                    having count(*) < (select avg(teachercount)
                                        from (select count(*) as teachercount
                                            from teach
                                            where tea_sec_session = '2019FA'
                                            group by tea_instr_id))
                    group by tea_instr_id)
order by instr_id;