SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE NewExam 
	-- Add the parameters for the stored procedure here
	@id_stud INT, @subject VARCHAR(20), @mark INT, @ex_date DATE, @id_lect INT,
	@count_exam INT OUTPUT
AS
BEGIN
	-- Insert statements for procedure here
	INSERT INTO Exam VALUES (@id_stud, @subject, @mark, @ex_date, @id_lect)
	SELECT @count_exam = COUNT(*) FROM Exam WHERE Id_Student = @id_lect
	
END
GO
