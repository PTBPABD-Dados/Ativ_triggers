-- verificar numero de atribuições do instructor
select a.id, b.year, b.course_id, count(*) as qtdaulas 
from instructor as a
left join teaches as b
on a.id = b.id
left join section as c
on b.course_id = c.course_id and b.year = c.year
group by  a.id, b.year, b.course_id
order by qtdaulas desc

CREATE TRIGGER dbo.trigger_prevent_assignment_teaches
ON dbo.teaches
INSTEAD OF INSERT
AS
BEGIN
    -- Verifica se algum instrutor já possui 2 ou mais atribuições no ano, somando com o novo insert
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN (
            SELECT id, course_id, year, COUNT(*) AS total
            FROM teaches
            GROUP BY id, course_id, year
        ) t ON i.id = t.id AND i.course_id = t.course_id AND i.year = t.year
        WHERE t.total >= 2
    )
    BEGIN
        RAISERROR('Instrutor já possui 2 ou mais atribuições neste ano.', 16, 1);
        ROLLBACK TRANSACTION; -- cancela a transação, cancela o insert que estava tentando adicionar 
        RETURN; -- para a execução da trigger com return
    END;

    -- Caso contrário, insere normalmente
    INSERT INTO dbo.teaches (ID, course_id, sec_id, semester, year)
    SELECT ID, course_id, sec_id, semester, year
    FROM inserted;
END;
