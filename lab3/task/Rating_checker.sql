USE [Sypachov]
GO
/****** Object:  Trigger [dbo].[Rating_checker]    Script Date: 13.04.2020 19:56:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[Rating_checker]
   ON  [dbo].[Exam]
   AFTER INSERT
AS 
BEGIN
	DECLARE @avg REAL, @id_stud INT, @counter INT
	SELECT @counter = COUNT(*) FROM inserted
	IF @counter > 1
	BEGIN
		PRINT 'Введено больше одного значения'
		RETURN
	END
	SELECT @id_stud = Id_Student FROM inserted
	SELECT @avg = AVG(mark) FROM Exam WHERE Id_Student = @id_stud GROUP BY Id_Student
	IF @id_stud IN (SELECT Id_Student FROM Rating)
	UPDATE Rating SET avg_mark = @avg WHERE Id_Student = @id_stud
	ELSE
	INSERT INTO Rating VALUES (@id_stud, @avg)
END
