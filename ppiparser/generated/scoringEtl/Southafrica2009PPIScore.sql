select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Seven or more' then 0
when answers.Q1='Six' then 7
when answers.Q1='Five' then 10
when answers.Q1='Four' then 14
when answers.Q1='Three' then 19
when answers.Q1='Two' then 27
when answers.Q1='One' then 37
end +
case
when answers.Q2='None' then 0
when answers.Q2='One' then 5
when answers.Q2='Two or more' then 10
end +
case
when answers.Q3='Four or less' then 0
when answers.Q3='Five or six' then 4
when answers.Q3='Seven or more' then 8
end +
case
when answers.Q4='Bricks, cement block/concrete, corrugated iron/zinc, wood, plastic, cardboard, mixture of mud and cement, wattle and daub, mud, thatching, asbestos, or other' then 0
when answers.Q4='Tile' then 7
end +
case
when answers.Q5='Pit latrine off-site with or without ventilation pipe, bucket toilet off-site, none, or other' then 0
when answers.Q5='Pit latrine on-site with or without ventilation pipe, or bucket toilet on-site' then 4
when answers.Q5='Flush toilet in dwelling/on-site/off-site with off-site/on-site disposal (septic tank), or chemical toilet on-site or off-site' then 7
end +
case
when answers.Q6='Paraffin, coal, wood, animal dung, none, or other' then 0
when answers.Q6='Electricity from mains/generator/solar, or gas' then 5
end +
case
when answers.Q7='No' then 0
when answers.Q7='Yes' then 9
end +
case
when answers.Q8='No' then 0
when answers.Q8='Yes' then 7
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 6
end +
case
when answers.Q10='No' then 0
when answers.Q10='Yes' then 4
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_family_members', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_wage_earners', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_house_rooms', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_house_roof', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_toilet_type', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_cooking_fuel', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_owns_washing_machine', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_owns_VCR_DVD', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_owns_microwave', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_southafrica_2009_owns_refrigerator', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Southafrica 2009" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers