USE [Sypachov]
GO
/****** Object:  Trigger [dbo].[Checker]    Script Date: 13.04.2020 20:01:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[Checker]
   ON  [dbo].[Student]
   INSTEAD OF INSERT, UPDATE 
AS 
BEGIN
	DECLARE @group VARCHAR(25), @counter INT
	SELECT @group = NameGroup, @counter = COUNT(*) FROM inserted GROUP BY inserted.NameGroup
	IF @counter > 1
		BEGIN
			PRINT 'Ввели больше одного человека'
			RETURN
		END
	IF @group NOT IN (SELECT NameGroup FROM StudGroup)
	BEGIN
		PRINT 'Нет такой группы'
		RETURN
	END
	SELECT @counter = COUNT(*) FROM deleted
	IF @counter = 0
		INSERT INTO Student SELECT * FROM inserted 
	IF @counter = 1
		UPDATE Student SET
		Birthday = (SELECT Birthday FROM inserted),
		FIO = (SELECT FIO FROM inserted),
		Gender = (SELECT Gender FROM inserted),
		NameGroup = (SELECT NameGroup FROM inserted),
		Stip = (SELECT Stip FROM inserted) 
		WHERE Id_Student = (SELECT Id_Student FROM inserted) 
END
