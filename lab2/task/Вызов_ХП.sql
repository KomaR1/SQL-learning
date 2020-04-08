DECLARE @res INT
EXEC NewExam 117405, 'Архитектура ЭВМ', 4, '15/01/2016', 13, @res OUTPUT
PRINT 'Сдано экзаменов - ' + CAST(@res AS CHAR(1))
