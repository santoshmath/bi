select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Six or more' then 0
when answers.Q1='Five' then 10
when answers.Q1='Four' then 20
when answers.Q1='Three' then 28
when answers.Q1='Two or one' then 45
end +
case
when answers.Q2='No' then 0
when answers.Q2='Yes' then 1
when answers.Q2='No children ages 6 to 12' then 3
end +
case
when answers.Q3='One' then 0
when answers.Q3='Two' then 1
when answers.Q3='Three or more' then 5
end +
case
when answers.Q4='Wood and grass, mud and stone, or other' then 0
when answers.Q4='Wood and mud, reeds and bamboo, cement and stone, hollow blocks, or bricks' then 5
end +
case
when answers.Q5='Pit latrine (shared), field/forest, container (household utensils), or other' then 0
when answers.Q5='Pit latrine (private)' then 4
when answers.Q5='Flush toilet (private or shared)' then 9
end +
case
when answers.Q6='Mainly firewood (purchase or collected), animal dung, or other' then 0
when answers.Q6='Crop residue' then 3
when answers.Q6='Charcoal, kerosene, butane gas, electricity, or does not use fuel' then 5
end +
case
when answers.Q7='No' then 0
when answers.Q7='Yes' then 5
end +
case
when answers.Q8='No' then 0
when answers.Q8='Yes' then 6
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 5
end +
case
when answers.Q10='No' then 0
when answers.Q10='Yes' then 10
end +
case
when answers.Q11='No' then 0
when answers.Q11='Yes' then 2
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_family_members', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_all_family_members_6_to_12_in_school', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_rooms_in_house', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_house_walls', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_toilet_type', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_cooking_fuel', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_owns_mattress_or_bed', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_owns_radio', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_owns_watches_or_clocks', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_owns_cattle_sheep_goats', qgr.response, NULL)) AS 'Q10',
GROUP_CONCAT(if(q.nickname = 'ppi_ethiopia_2009_owns_jewelry', qgr.response, NULL)) AS 'Q11'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Ethiopia 2009" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers