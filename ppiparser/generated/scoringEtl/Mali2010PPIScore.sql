select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Five or more' then 0
when answers.Q1='Four' then 10
when answers.Q1='Three' then 13
when answers.Q1='Two' then 15
when answers.Q1='One' then 17
when answers.Q1='None' then 25
end +
case
when answers.Q2='Three or more' then 0
when answers.Q2='Two' then 7
when answers.Q2='One or none' then 14
end +
case
when answers.Q3='Tile or thatch' then 0
when answers.Q3='Mud, corrugated metal sheets, concrete, or other' then 12
end +
case
when answers.Q4='Partly cement or others' then 0
when answers.Q4='Cement' then 7
end +
case
when answers.Q5='Surface water, non-modern well, drilled well, or others' then 0
when answers.Q5='Modern well' then 3
when answers.Q5='Public pump' then 6
when answers.Q5='Faucet tap' then 11
end +
case
when answers.Q6='Others' then 0
when answers.Q6='Latrine (private or shared with other households) or flush toilet (private inside, private outside, or shared with other households)' then 7
end +
case
when answers.Q7='No' then 0
when answers.Q7='Yes' then 6
end +
case
when answers.Q8='No' then 0
when answers.Q8='Yes' then 7
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 5
end +
case
when answers.Q10='No' then 0
when answers.Q10='Yes' then 6
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_family_members_0_to_11', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_employed_in_agricuture_animals', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_house_roof', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_house_walls', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_water_source', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_toilet_type', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_owns_television', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_owns_radio', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_owns_iron', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_mali_2010_owns_motorbike', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Mali 2010" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers