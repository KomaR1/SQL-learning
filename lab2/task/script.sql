USE [master]
GO
/****** Object:  Database [Sypachov]    Script Date: 10.04.2020 19:17:09 ******/
CREATE DATABASE [Sypachov]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Sypachov', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Sypachov.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Sypachov_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Sypachov_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Sypachov] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Sypachov].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Sypachov] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Sypachov] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Sypachov] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Sypachov] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Sypachov] SET ARITHABORT OFF 
GO
ALTER DATABASE [Sypachov] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Sypachov] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Sypachov] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Sypachov] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Sypachov] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Sypachov] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Sypachov] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Sypachov] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Sypachov] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Sypachov] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Sypachov] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Sypachov] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Sypachov] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Sypachov] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Sypachov] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Sypachov] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Sypachov] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Sypachov] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Sypachov] SET  MULTI_USER 
GO
ALTER DATABASE [Sypachov] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Sypachov] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Sypachov] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Sypachov] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Sypachov] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Sypachov', N'ON'
GO
ALTER DATABASE [Sypachov] SET QUERY_STORE = OFF
GO
USE [Sypachov]
GO
/****** Object:  UserDefinedFunction [dbo].[Avg_mark_student]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Avg_mark_student]
(
	-- Add the parameters for the function here
	@id_stud INT
)
RETURNS REAL
AS
BEGIN
	-- Declare the return variable here
	DECLARE @avg_mark REAL

	-- Add the T-SQL statements to compute the return value here
	SELECT @avg_mark = AVG(CAST(Mark AS REAL)) FROM Exam WHERE Id_Student = @id_stud

	-- Return the result of the function
	RETURN @avg_mark

END
GO
/****** Object:  UserDefinedFunction [dbo].[Fun2]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun2]
(
	-- Add the parameters for the function here
	@group VARCHAR(50)
)
RETURNS 
@res TABLE (FioStud VARCHAR(50), Avg_Mark REAL)
AS
BEGIN
	INSERT INTO @res SELECT Fio, AVG(CAST(Mark AS REAL))
	FROM Exam JOIN Student ON Exam.Id_Student = Student.Id_Student
	WHERE NameGroup = @group GROUP BY FIO
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[Func2_4]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func2_4]
(
	@group VARCHAR(50)
)
RETURNS REAL
AS

BEGIN
	DECLARE @quant REAL
	SELECT @quant = (SELECT COUNT(*) FROM Func1(@group))
	RETURN @quant

END
GO
/****** Object:  Table [dbo].[Exam]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam](
	[Id_Student] [int] NOT NULL,
	[Subject] [varchar](50) NOT NULL,
	[Mark] [smallint] NULL,
	[Exam_Date] [date] NOT NULL,
	[Id_Lect] [smallint] NOT NULL,
 CONSTRAINT [PK_Exam_1] PRIMARY KEY CLUSTERED 
(
	[Id_Student] ASC,
	[Subject] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Id_Student] [int] NOT NULL,
	[FIO] [varchar](50) NOT NULL,
	[Birthday] [date] NOT NULL,
	[Gender] [char](10) NOT NULL,
	[NameGroup] [varchar](50) NOT NULL,
	[Stip] [int] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Id_Student] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun1]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun1]
(	
	-- Add the parameters for the function here
	@group VARCHAR (20)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT Fio, AVG(CAST(Mark AS REAL)) AS [Средний балл]
	FROM Exam JOIN Student ON Exam.Id_Student = Student.Id_Student
	WHERE NameGroup = @group GROUP BY FIO
)
GO
/****** Object:  UserDefinedFunction [dbo].[Func1]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func1]
(@group VARCHAR(50))
RETURNS TABLE 
AS
RETURN 
(
	SELECT Subject FROM Exam 
	INNER JOIN Student ON Exam.Id_Student = Student.Id_Student WHERE Student.NameGroup=@group
	GROUP BY Subject
)
GO
/****** Object:  UserDefinedFunction [dbo].[IZ_5_8]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IZ_5_8]
(	
	@group VARCHAR(50)
)
RETURNS TABLE 
AS
RETURN
(
	SELECT Id_Student, FIO FROM Student WHERE Id_Student IN (SELECT Id_Student FROM Exam WHERE Exam.Mark > 4 GROUP BY Id_Student) AND NameGroup=@group
)




GO
/****** Object:  UserDefinedFunction [dbo].[IZ58]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IZ58]
(	
	@group VARCHAR(50)
)
RETURNS TABLE 
AS
RETURN
(
	SELECT Id_Student, FIO FROM Student WHERE Id_Student IN (SELECT Id_Student FROM Exam WHERE Exam.Mark > 4 GROUP BY Id_Student) AND NameGroup=@group
)




GO
/****** Object:  View [dbo].[ListOfGroup]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ListOfGroup]
AS
SELECT        TOP (100) PERCENT NameGroup AS Группа, Id_Student AS [Шифр студента], FIO AS [Фамилия студента]
FROM            dbo.Student
ORDER BY Группа, [Фамилия студента]

GO
/****** Object:  View [dbo].[Exam_A-18-06]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Exam_A-18-06]
AS
SELECT        dbo.ListOfGroup.[Фамилия студента] AS Expr1, COUNT(*) AS [Сдано экзаменов], MAX(dbo.Exam.Mark) AS [Лучшая оценка]
FROM            dbo.ListOfGroup INNER JOIN
                         dbo.Exam ON dbo.ListOfGroup.[Шифр студента] = dbo.Exam.Id_Student
WHERE        (dbo.ListOfGroup.Группа = 'А-18-06') AND (dbo.Exam.Mark > 2)
GROUP BY dbo.ListOfGroup.[Фамилия студента]

GO
/****** Object:  View [dbo].[IZ36]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IZ36]
AS
SELECT        dbo.Student.FIO AS ФИО, dbo.Exam.Id_Student AS [Номер студента], dbo.Exam.Mark AS Оценка, dbo.Student.NameGroup
FROM            dbo.Exam INNER JOIN
                         dbo.Student ON dbo.Exam.Id_Student = dbo.Student.Id_Student
WHERE        (dbo.Exam.Subject = 'Операционные системы')
GO
/****** Object:  View [dbo].[IZ36B]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IZ36B]
AS
SELECT        COUNT(Оценка) AS Expr1, NameGroup
FROM            dbo.IZ36
WHERE        (Оценка = 5)
GROUP BY NameGroup

GO
/****** Object:  Table [dbo].[Lecturer]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lecturer](
	[Id_Lect] [smallint] NOT NULL,
	[FIO] [varchar](50) NOT NULL,
	[Stage] [smallint] NULL,
	[Kafedra] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Lecturer] PRIMARY KEY CLUSTERED 
(
	[Id_Lect] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[LectExam]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LectExam] (Код, Фамилия, Стаж)
AS
SELECT Id_Lect,FIO,Stage FROM Lecturer WHERE Kafedra = 'ИС'
AND Id_Lect IN (SELECT DISTINCT Id_Lect FROM Exam)
GO
/****** Object:  Table [dbo].[ExamNew]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamNew](
	[ID_Student] [int] NOT NULL,
	[Subj] [varchar](30) NOT NULL,
	[Mark] [int] NULL,
	[Exam_Date] [date] NOT NULL,
	[ID_Lect] [int] NOT NULL,
 CONSTRAINT [PK_ExamNew] PRIMARY KEY CLUSTERED 
(
	[ID_Student] ASC,
	[Subj] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamTest]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamTest](
	[ID_Student] [int] NOT NULL,
	[Subj] [varchar](30) NOT NULL,
	[Mark] [int] NULL,
	[Exam_Date] [date] NOT NULL,
 CONSTRAINT [PK_ExamNew1] PRIMARY KEY CLUSTERED 
(
	[ID_Student] ASC,
	[Subj] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LecturerNew]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LecturerNew](
	[ID_Lect] [int] NOT NULL,
	[FIO] [varchar](30) NOT NULL,
	[Stage] [int] NULL,
	[Kafedra] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Lect] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentNew]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentNew](
	[ID_Student] [int] NOT NULL,
	[FIO] [varchar](30) NOT NULL,
	[Birthday] [date] NULL,
	[Gender] [char](1) NOT NULL,
	[NameGroup] [varchar](10) NOT NULL,
	[Stip] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Student] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudGroup]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudGroup](
	[NameGroup] [varchar](50) NOT NULL,
	[Course] [smallint] NULL,
	[Kafedra] [varchar](50) NULL,
 CONSTRAINT [PK_StudGroup] PRIMARY KEY CLUSTERED 
(
	[NameGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudGroupNew]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudGroupNew](
	[NameGroup] [varchar](10) NOT NULL,
	[Kurs] [smallint] NULL,
	[Kafedra] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[NameGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudGroupTest]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudGroupTest](
	[NameGroup] [varchar](10) NOT NULL,
	[Curator] [int] NULL,
	[Kurs] [smallint] NULL,
	[Kafedra] [varchar](10) NULL,
	[Starosta] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[NameGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectLect]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectLect](
	[ID_Lecturer] [int] NOT NULL,
	[NameSubject] [varchar](30) NOT NULL,
 CONSTRAINT [PK_SubjectLect] PRIMARY KEY CLUSTERED 
(
	[ID_Lecturer] ASC,
	[NameSubject] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117162, N'Архитектура ЭВМ', 4, CAST(N'2016-01-15' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117162, N'Операционные системы', 45, CAST(N'2020-04-09' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117162, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117163, N'Операционные системы', NULL, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117163, N'Управление Данными', 5, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117164, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117164, N'Управление Данными', 3, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117165, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117165, N'Управление Данными', 2, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117166, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117166, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117201, N'Операционные системы', 2, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117201, N'Управление Данными', NULL, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117202, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117202, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117203, N'Операционные системы', 3, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117203, N'Управление Данными', 3, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117204, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117204, N'Управление Данными', 5, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117205, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117205, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117301, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117301, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117302, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117302, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117303, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117303, N'Управление Данными', 5, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117304, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117304, N'Управление Данными', 3, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117305, N'Операционные системы', 2, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117305, N'Управление Данными', 2, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117401, N'Операционные системы', 3, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117401, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117402, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117402, N'Управление Данными', 3, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117403, N'Операционные системы', 4, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117403, N'Управление Данными', 5, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117404, N'Операционные системы', 5, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117405, N'Архитектура ЭВМ', 4, CAST(N'2016-01-15' AS Date), 13)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117405, N'Операционные системы', 3, CAST(N'2019-01-12' AS Date), 14)
INSERT [dbo].[Exam] ([Id_Student], [Subject], [Mark], [Exam_Date], [Id_Lect]) VALUES (117405, N'Управление Данными', 4, CAST(N'2019-01-11' AS Date), 13)
INSERT [dbo].[Lecturer] ([Id_Lect], [FIO], [Stage], [Kafedra]) VALUES (11, N'Никитин Эдуард Вадимович', 15, N'ПМ')
INSERT [dbo].[Lecturer] ([Id_Lect], [FIO], [Stage], [Kafedra]) VALUES (12, N'Лукашенко Эрик Иванович', 8, N'ПМ')
INSERT [dbo].[Lecturer] ([Id_Lect], [FIO], [Stage], [Kafedra]) VALUES (13, N'Шарапов Давид Дмитриевич', 10, N'ИС')
INSERT [dbo].[Lecturer] ([Id_Lect], [FIO], [Stage], [Kafedra]) VALUES (14, N'Виноградов Сергей Виталиевич', NULL, N'ИС')
INSERT [dbo].[Lecturer] ([Id_Lect], [FIO], [Stage], [Kafedra]) VALUES (15, N'Батейко Андрей Сергеевич', 9, N'Ин. Яз.')
INSERT [dbo].[LecturerNew] ([ID_Lect], [FIO], [Stage], [Kafedra]) VALUES (2, N'Вася1', 8, N'ИС')
INSERT [dbo].[LecturerNew] ([ID_Lect], [FIO], [Stage], [Kafedra]) VALUES (13, N'Вася', 10, N'ИС')
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117162, N'Сыпачев Андрей Константинович', CAST(N'1999-10-11' AS Date), N'М         ', N'ИДБ-17-06', 2400)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117163, N'Сичинава Марк Валерьянович', CAST(N'1999-05-30' AS Date), N'М         ', N'ИДБ-17-07', 2000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117164, N'Смирнов Глеб Дмитриевич', CAST(N'1999-11-18' AS Date), N'М         ', N'ИДБ-17-07', 2000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117165, N'Семенов Антон Иванович', CAST(N'1999-01-01' AS Date), N'М         ', N'ИДБ-17-07', 4000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117166, N'Дергачева Ирина Серегеевна', CAST(N'1998-07-13' AS Date), N'Ж         ', N'ИДБ-17-07', 2160)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117170, N'Путин Владимир Владимирович', CAST(N'1966-10-11' AS Date), N'М         ', N'ИДБ-17-07', 4000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117201, N'Сулоев Антон Владимирович', CAST(N'1998-07-14' AS Date), N'М         ', N'ИДБ-17-06', 2000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117202, N'Шабалин Дмитрий Иванович', CAST(N'1999-08-21' AS Date), N'М         ', N'ИДБ-17-06', 4000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117203, N'Старостина Алёна Андреевна', CAST(N'1999-05-15' AS Date), N'Ж         ', N'ИДБ-17-06', 1500)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117204, N'Пахомов Адрей Сергеевич', CAST(N'1999-01-19' AS Date), N'М         ', N'ИДБ-17-06', 2400)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117205, N'Безруков Антон Анатольевич', CAST(N'1998-02-23' AS Date), N'М         ', N'ИДБ-17-06', 4000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117301, N'Твердовская Софья Игоревна', CAST(N'1999-03-11' AS Date), N'Ж         ', N'ИДБ-17-05', 2400)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117302, N'Черникова Евгения Дмитриевна', CAST(N'1999-06-06' AS Date), N'Ж         ', N'ИДБ-17-05', 4000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117303, N'Панин Егор Владимирович', CAST(N'1999-05-17' AS Date), N'М         ', N'ИДБ-17-05', 1800)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117304, N'Козлов Илья Сергееич', CAST(N'1999-03-19' AS Date), N'М         ', N'ИДБ-17-05', 2000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117305, N'Ланге Никита Андреевич', CAST(N'1998-03-28' AS Date), N'М         ', N'ИДБ-17-05', 1500)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117401, N'Лепехин Сергей Николаевич', CAST(N'1999-06-13' AS Date), N'М         ', N'А-18-06', 2000)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117402, N'Кудрина Ксения Игоревна', CAST(N'1999-08-08' AS Date), N'Ж         ', N'А-18-06', 1500)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117403, N'Коваленок Никита Сергеевич', CAST(N'1999-09-19' AS Date), N'М         ', N'А-18-06', 2400)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117404, N'Давлюдова Екатерина Андреевна', CAST(N'1999-12-03' AS Date), N'Ж         ', N'А-18-06', 1800)
INSERT [dbo].[Student] ([Id_Student], [FIO], [Birthday], [Gender], [NameGroup], [Stip]) VALUES (117405, N'Синишин Евгений Григорьевич', CAST(N'1998-07-15' AS Date), N'М         ', N'А-18-06', 4000)
INSERT [dbo].[StudGroup] ([NameGroup], [Course], [Kafedra]) VALUES (N'А-18-06', 2, N'ПМ')
INSERT [dbo].[StudGroup] ([NameGroup], [Course], [Kafedra]) VALUES (N'ИДБ-17-05', 3, N'ИС')
INSERT [dbo].[StudGroup] ([NameGroup], [Course], [Kafedra]) VALUES (N'ИДБ-17-06', 3, N'ИС')
INSERT [dbo].[StudGroup] ([NameGroup], [Course], [Kafedra]) VALUES (N'ИДБ-17-07', 3, N'ИС')
/****** Object:  Index [UQ__ExamNew__5E3C27AA75BA09DB]    Script Date: 10.04.2020 19:17:09 ******/
ALTER TABLE [dbo].[ExamNew] ADD UNIQUE NONCLUSTERED 
(
	[ID_Student] ASC,
	[Exam_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__ExamTest__5E3C27AA08942BD6]    Script Date: 10.04.2020 19:17:09 ******/
ALTER TABLE [dbo].[ExamTest] ADD UNIQUE NONCLUSTERED 
(
	[ID_Student] ASC,
	[Exam_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Lecturer__C1BEAA5C8E9D185A]    Script Date: 10.04.2020 19:17:09 ******/
ALTER TABLE [dbo].[LecturerNew] ADD UNIQUE NONCLUSTERED 
(
	[FIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__StudentN__88E0A233691BD682]    Script Date: 10.04.2020 19:17:09 ******/
ALTER TABLE [dbo].[StudentNew] ADD UNIQUE NONCLUSTERED 
(
	[NameGroup] ASC,
	[FIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExamNew] ADD  DEFAULT ((25)) FOR [Mark]
GO
ALTER TABLE [dbo].[ExamNew] ADD  DEFAULT (getdate()) FOR [Exam_Date]
GO
ALTER TABLE [dbo].[ExamTest] ADD  DEFAULT ((25)) FOR [Mark]
GO
ALTER TABLE [dbo].[ExamTest] ADD  DEFAULT (getdate()) FOR [Exam_Date]
GO
ALTER TABLE [dbo].[StudentNew] ADD  DEFAULT ('m') FOR [Gender]
GO
ALTER TABLE [dbo].[StudGroupNew] ADD  DEFAULT ((1)) FOR [Kurs]
GO
ALTER TABLE [dbo].[StudGroupTest] ADD  DEFAULT ((1)) FOR [Kurs]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK_Exam_Lecturer] FOREIGN KEY([Id_Lect])
REFERENCES [dbo].[Lecturer] ([Id_Lect])
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK_Exam_Lecturer]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK_Exam_Student] FOREIGN KEY([Id_Student])
REFERENCES [dbo].[Student] ([Id_Student])
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK_Exam_Student]
GO
ALTER TABLE [dbo].[ExamNew]  WITH CHECK ADD FOREIGN KEY([ID_Lect])
REFERENCES [dbo].[LecturerNew] ([ID_Lect])
GO
ALTER TABLE [dbo].[ExamNew]  WITH CHECK ADD FOREIGN KEY([ID_Student])
REFERENCES [dbo].[StudentNew] ([ID_Student])
GO
ALTER TABLE [dbo].[ExamTest]  WITH CHECK ADD FOREIGN KEY([ID_Student])
REFERENCES [dbo].[StudentNew] ([ID_Student])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_StudGroup] FOREIGN KEY([NameGroup])
REFERENCES [dbo].[StudGroup] ([NameGroup])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_StudGroup]
GO
ALTER TABLE [dbo].[StudentNew]  WITH CHECK ADD FOREIGN KEY([NameGroup])
REFERENCES [dbo].[StudGroupNew] ([NameGroup])
GO
ALTER TABLE [dbo].[StudGroupTest]  WITH CHECK ADD FOREIGN KEY([Curator])
REFERENCES [dbo].[LecturerNew] ([ID_Lect])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[StudGroupTest]  WITH CHECK ADD FOREIGN KEY([Starosta])
REFERENCES [dbo].[StudentNew] ([ID_Student])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[SubjectLect]  WITH CHECK ADD FOREIGN KEY([ID_Lecturer])
REFERENCES [dbo].[LecturerNew] ([ID_Lect])
GO
ALTER TABLE [dbo].[ExamNew]  WITH CHECK ADD CHECK  (([Mark]>(24) AND [Mark]<=(100)))
GO
ALTER TABLE [dbo].[ExamTest]  WITH CHECK ADD CHECK  (([Mark]>(24) AND [Mark]<=(100)))
GO
ALTER TABLE [dbo].[LecturerNew]  WITH CHECK ADD CHECK  (([Stage]<=(80)))
GO
ALTER TABLE [dbo].[StudentNew]  WITH CHECK ADD CHECK  (([Gender]='m' OR [Gender]='f'))
GO
ALTER TABLE [dbo].[StudGroupNew]  WITH CHECK ADD CHECK  (([Kurs]>(0) AND [Kurs]<=(6)))
GO
ALTER TABLE [dbo].[StudGroupTest]  WITH CHECK ADD CHECK  (([Kurs]>(0) AND [Kurs]<=(6)))
GO
/****** Object:  StoredProcedure [dbo].[beststudents]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[beststudents]
AS 
BEGIN

DECLARE mark_cursor CURSOR LOCAL FORWARD_ONLY STATIC
    FOR SELECT Student.FIO, Student.NameGroup, AVG(Exam.mark) as avg_mark
FROM Student 
    INNER JOIN Exam ON Student.Id_Student = Exam.Id_Student
GROUP BY Student.NameGroup, Student.Id_Student, Student.FIO HAVING Student.NameGroup = 'ИДБ-17-07'
ORDER BY avg_mark DESC

OPEN mark_cursor
DECLARE @n INT, @Counter INT
SET @n = 19
SET @Counter = 0

DECLARE @TOP_STUDENTS TABLE (fio VARCHAR(40), res INT)
DECLARE @fio VARCHAR(40), @res INT, @Gr VARCHAR(40)

WHILE @Counter < @n 
BEGIN

    SET @Counter = @Counter + 1
    INSERT INTO @TOP_STUDENTS VALUES (@fio, @res)
    FETCH NEXT FROM mark_cursor INTO @fio, @Gr, @res
END
SET @counter = 0
SELECT * FROM @TOP_STUDENTS
CLOSE mark_cursor
DEALLOCATE mark_cursor

END

EXEC beststudents
GO
/****** Object:  StoredProcedure [dbo].[NewExam]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[NewExam] 
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
/****** Object:  StoredProcedure [dbo].[Result]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Result]
	@fio VARCHAR(50), @group VARCHAR(50), @mark INT, @subj VARCHAR(50), @lect VARCHAR(50), @date DATE
AS
BEGIN
	DECLARE @Id_Student INT, @id_Lect INT
	SELECT @Id_Student = Id_Student FROM Student WHERE FIO = @fio
	SELECT @id_Lect = id_Lect FROM Lecturer WHERE FIO = @lect
	IF EXISTS (SELECT * FROM Exam WHERE Subject = @subj AND Id_Student = @Id_Student)
	UPDATE Exam SET Mark=@mark, Exam_Date=@date,  @id_Lect=id_Lect WHERE Id_Student = @Id_Student AND Subject=@subj
	ELSE
	INSERT INTO Exam VALUES(@Id_Student, @subj, @mark, @date, @id_Lect)
END
GO
/****** Object:  StoredProcedure [dbo].[Take_my_money]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Take_my_money]
@Stip INT, @Perc REAL
AS
BEGIN

UPDATE Student
	SET Stip = (@Perc+100)/100*Stip WHERE Id_Student IN (SELECT DISTINCT Id_Student FROM Exam EXCEPT
	SELECT  Id_Student FROM Exam WHERE Mark < 4 OR Mark IS NULL)
UPDATE STUDENT
	SET Stip = @Stip WHERE Id_Student IN (SELECT DISTINCT Id_Student FROM Student WHERE Stip IS NULL)

END
GO
/****** Object:  StoredProcedure [dbo].[Transfer]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Transfer]
	@fio VARCHAR(50), @group VARCHAR(50), @res VARCHAR(60) OUTPUT
AS
BEGIN
	IF EXISTS (SELECT FIO FROM Student WHERE FIO=@fio)
	BEGIN
		IF EXISTS (SELECT NameGroup FROM StudGroup WHERE NameGroup=@group) 
		BEGIN
			UPDATE Student set NameGroup=@group WHERE FIO=@fio
			SET @res=('Студент переведён в группу: ') + @group
		END
		ELSE
			SET @res=('Группа не найдена')
		END
	ELSE
		SET @res=('Студент не найден')
END


GO
/****** Object:  StoredProcedure [dbo].[Transfer2]    Script Date: 10.04.2020 19:17:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Transfer2]
	@fio VARCHAR(50), @group VARCHAR(50) 
AS
BEGIN
	IF EXISTS (SELECT FIO FROM Student WHERE FIO=@fio)
	BEGIN
		IF EXISTS (SELECT NameGroup FROM StudGroup WHERE NameGroup=@group) 
		BEGIN
			UPDATE Student set NameGroup=@group WHERE FIO=@fio
			PRINT('Студент переведён в группу: ') + @group
		END
		ELSE
			PRINT('Группа не найдена')
		END
	ELSE
		PRINT('Студент не найден')
END


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ListOfGroup"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Exam"
            Begin Extent = 
               Top = 4
               Left = 308
               Bottom = 134
               Right = 482
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1155
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Exam_A-18-06'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Exam_A-18-06'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[25] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Exam"
            Begin Extent = 
               Top = 15
               Left = 43
               Bottom = 188
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Student"
            Begin Extent = 
               Top = 9
               Left = 333
               Bottom = 187
               Right = 507
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2100
         Alias = 1845
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 2055
         SortOrder = 1890
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IZ36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IZ36'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "IZ36"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IZ36B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IZ36B'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Student"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListOfGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListOfGroup'
GO
USE [master]
GO
ALTER DATABASE [Sypachov] SET  READ_WRITE 
GO
