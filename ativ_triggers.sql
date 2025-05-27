-- criando trigger para subtrair o valor do crédito de um curso, após a exclusão dele, do total de créditos na tabela student
CREATE TRIGGER dbo.lost_credits
ON dbo.takes
AFTER DELETE-- depois que um delete em um registro ocorrer na tabela takes
AS
BEGIN -- faça
UPDATE s -- atualiza a tabela student, atualiza os créditos dos alunos que perderam cursos
SET s.tot_cred = s.tot_cred - c.credits -- o total de creditos vai ser total de credito menos o Nnumero de creditos do curso deletado
FROM dbo.student as s
JOIN deleted as d ON s.id = d.ID -- da tabela deleted que que guarda o ultimo registro deletado, conecta pelo id
JOIN dbo.course as c --busca o credito do curso na tabela course
ON d.course_id = c.course_id; -- conecta a tabela deleted com a tabela course pelo id para trazer numero de creditos
END;

-- tabela com total de creditos
SELECT ID, name, dept_name, tot_cred FROM student WHERE ID = '30299';

-- tabela de cursos onde tem o valor de crédito de cada curso
select course_id, title, credits from course

-- deletando registro do curso '105' que possui 3 créditos do aluno do id '30299'
delete from takes where id ='30299' and course_id = 105

-- verificando total de creditos do aluno.
--Como a trigger está ativada, 
--foi subtraido 3 créditos dos créditos totais após a exclusão do curso '105'
select * from takes where id = '30299'
