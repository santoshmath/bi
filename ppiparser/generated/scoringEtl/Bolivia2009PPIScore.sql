select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Seven or more' then 0
when answers.Q1='Six' then 7
when answers.Q1='Five' then 11
when answers.Q1='Four' then 16
when answers.Q1='Three' then 17
when answers.Q1='Two' then 26
when answers.Q1='One' then 35
end +
case
when answers.Q2='Not all' then 0
when answers.Q2='All' then 2
when answers.Q2='No children ages 6 to 17' then 4
end +
case
when answers.Q3='Earth, bricks, or other' then 0
when answers.Q3='Wooden planks, cement, hardwood floors, parquet, rugs or carpets' then 4
when answers.Q3='Tile (mosaic, stone, or ceramic)' then 10
end +
case
when answers.Q4='Firewood, dung/manure, kerosene, LPG in a cylinder, or other' then 0
when answers.Q4='Piped-in natural gas, electricity, or does not cook' then 7
end +
case
when answers.Q5='No' then 0
when answers.Q5='Yes' then 5
end +
case
when answers.Q6='No' then 0
when answers.Q6='Yes' then 5
end +
case
when answers.Q7='No' then 0
when answers.Q7='Yes' then 10
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
when answers.Q10='Yes' then 13
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_family_members', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_family_members_6_10_17_in_school', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_house_floors', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_cooking_fuel', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_has_refrigerator_or_freezer', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_has_dining_table_and_chairs', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_has_television', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_has_vcr_or_dvd', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_has_stereo', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_bolivia_2009_blue_or_white_collar_job', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Bolivia 2009" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers