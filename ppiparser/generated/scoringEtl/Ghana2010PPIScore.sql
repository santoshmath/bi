select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Seven or more' then 0
when answers.Q1='Six' then 6
when answers.Q1='Five' then 8
when answers.Q1='Four' then 11
when answers.Q1='Three' then 15
when answers.Q1='Two' then 23
when answers.Q1='One' then 31
end +
case
when answers.Q2='No' then 0
when answers.Q2='Yes, or no children ages 5 to 12' then 4
end +
case
when answers.Q3='No female head/spouse' then 0
when answers.Q3='None or pre-school' then 4
when answers.Q3='Primary or middle' then 7
when answers.Q3='Any JSS, SSS, S, L, U, or higher' then 10
end +
case
when answers.Q4='Male head/spouse has no job' then 0
when answers.Q4='Yes, main job is in agriculture' then 8
when answers.Q4='No, main job is not in agriculture' then 10
when answers.Q4='No male head/spouse' then 10
end +
case
when answers.Q5='Palm leaves/raffia/thatch, wood, mud bricks/earth, bamboo, or other' then 0
when answers.Q5='Corrugated iron sheets, cement/concrete, asbestos/slate, or roofing tiles' then 3
end +
case
when answers.Q6='Not electricity (mains)' then 0
when answers.Q6='Electricity (mains)' then 5
end +
case
when answers.Q7='Borehole, well (with pump or not, protected or not), or other' then 0
when answers.Q7='River/stream, rain water/spring, or dugout/pond/lake/dam' then 5
when answers.Q7='Indoor plumbing, inside standpipe, sachet/bottled water,  standpipe/tap (public or private outside), pipe in neighbors, water truck/tanker, or water vendor' then 7
end +
case
when answers.Q8='No' then 0
when answers.Q8='Yes' then 10
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 6
end +
case
when answers.Q10='None' then 0
when answers.Q10='Only radio' then 2
when answers.Q10='Radio cassette but no record player nor 3-in-1 (regardless of radio)' then 6
when answers.Q10='Record player but no 3-in-1 (regardless of radio or cassette)' then 9
when answers.Q10='3-in-1 radio system (regardless of any others)' then 14
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_family_members', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_all_family_members_5_to_12_in_school', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_female_head_highest_grade', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_male_head_agriculture_job', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_house_roof', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_house_lighting', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_water_source', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_owns_stove', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_owns_iron', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_ghana_2010_owns_radio', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Ghana 2010" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers