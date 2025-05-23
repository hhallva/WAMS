USE [WamsDB]
GO
/****** Object:  User [WamsAdmin]    Script Date: 01.05.2025 21:49:35 ******/
CREATE USER [WamsAdmin] FOR LOGIN [WamsAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [WamsAdmin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WamsAdmin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WamsAdmin]
GO
/****** Object:  Table [dbo].[Shift]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shift](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](9) NOT NULL,
	[StartDate] [datetime2](0) NOT NULL,
	[EndDate] [datetime2](0) NOT NULL,
	[IsDay] [bit] NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[MaxEmployees] [int] NOT NULL,
 CONSTRAINT [PK_Shift] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Assignment]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assignment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ShiftId] [int] NOT NULL,
	[Status] [nvarchar](17) NOT NULL,
	[ApplicationDate] [datetime2](0) NOT NULL,
	[Comment] [nvarchar](300) NULL,
 CONSTRAINT [PK_Assignment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salary]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[StartDate] [datetime2](0) NOT NULL,
	[EndDate] [datetime2](0) NOT NULL,
	[HoursCount] [int] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[IsPaid] [bit] NOT NULL,
 CONSTRAINT [PK_Salary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Surname] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Patrionymic] [nvarchar](100) NULL,
	[RegistrationDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalaryImpact]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryImpact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[SalaryId] [int] NOT NULL,
	[AppointmentDate] [datetime2](7) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Description] [nvarchar](300) NOT NULL,
	[Type] [nvarchar](6) NOT NULL,
 CONSTRAINT [PK_SalaryImpact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Rate] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllMonthsSalaryStatistic]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   VIEW [dbo].[AllMonthsSalaryStatistic]
AS
SELECT 
    u.Id AS [UserId],
    CONCAT(u.Surname, ' ', u.Name) AS [EmployeeName],
	p.Rate,
    s.StartDate AS [StartDate],
    s.EndDate AS [EndDate],
	(SELECT COUNT(*) 
     FROM Assignment a 
     JOIN Shift sh ON a.ShiftId = sh.Id
     WHERE a.UserId = u.Id 
       AND sh.Status = 'Завершена'
       AND YEAR(sh.StartDate) = YEAR(s.StartDate)
       AND MONTH(sh.StartDate) = MONTH(s.StartDate)) AS [CompletedShifts],
    s.HoursCount AS [HoursCount],
    ISNULL((SELECT SUM(Amount) 
            FROM SalaryImpact 
            WHERE UserId = u.Id AND Type = 'Аванс'
            AND YEAR(AppointmentDate) = YEAR(s.StartDate) 
            AND MONTH(AppointmentDate) = MONTH(s.StartDate)), 0) AS [Advances],
    ISNULL((SELECT SUM(Amount) 
            FROM SalaryImpact 
            WHERE UserId = u.Id AND Type = 'Штраф'
            AND YEAR(AppointmentDate) = YEAR(s.StartDate) 
            AND MONTH(AppointmentDate) = MONTH(s.StartDate)), 0) AS [Fines],
    ISNULL((SELECT SUM(Amount) 
            FROM SalaryImpact 
            WHERE UserId = u.Id AND Type = 'Премия'
            AND YEAR(AppointmentDate) = YEAR(s.StartDate) 
            AND MONTH(AppointmentDate) = MONTH(s.StartDate)), 0) AS [Bonuses],
    (s.Amount) AS [SalaryBeforeTax],
    (s.Amount * 0.87) AS [SalaryAfterTax], -- 13% НДС
    s.IsPaid
FROM 
    [User] u
JOIN 
    Position p ON u.PositionId = p.Id
JOIN 
    Salary s ON u.Id = s.UserId;
GO
/****** Object:  View [dbo].[CurrentMonthSalaryStatistic]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[CurrentMonthSalaryStatistic]
AS
SELECT * FROM dbo.AllMonthsSalaryStatistic
	WHERE YEAR([StartDate]) =  YEAR(GETDATE()) 
	  AND MONTH([StartDate]) =  MONTH(GETDATE())
GO
/****** Object:  Table [dbo].[Notification]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Type] [nvarchar](19) NOT NULL,
	[Text] [nvarchar](300) NOT NULL,
	[CreateDate] [datetime2](0) NOT NULL,
	[IsRead] [bit] NOT NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Assignment] ON 

INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (1, 1, 1, N'Ожидает одобрения', CAST(N'2024-01-27T09:00:00.0000000' AS DateTime2), N'Прошу назначить меня на эту смену')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (2, 1, 2, N'Ожидает одобрения', CAST(N'2024-01-28T10:00:00.0000000' AS DateTime2), N'Еще одна заявка')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (4, 2, 2, N'Одобрено', CAST(N'2024-01-27T11:15:00.0000000' AS DateTime2), N'Назначен на смену')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (5, 3, 3, N'Отклонено', CAST(N'2024-01-27T14:30:00.0000000' AS DateTime2), N'Недостаточно опыта')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (6, 4, 1, N'Отменено', CAST(N'2024-01-27T16:45:00.0000000' AS DateTime2), N'Пользователь отменил заявку')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (9, 1, 7, N'Одобрено', CAST(N'2025-04-19T16:45:00.0000000' AS DateTime2), N'Назначен на смену')
INSERT [dbo].[Assignment] ([Id], [UserId], [ShiftId], [Status], [ApplicationDate], [Comment]) VALUES (10, 1, 8, N'Одобрено', CAST(N'2025-04-19T16:45:00.0000000' AS DateTime2), N'Назначен на смену')
SET IDENTITY_INSERT [dbo].[Assignment] OFF
GO
SET IDENTITY_INSERT [dbo].[Notification] ON 

INSERT [dbo].[Notification] ([Id], [UserId], [Type], [Text], [CreateDate], [IsRead]) VALUES (1, 1, N'Новая смена', N'Появилась новая смена, подходящая для вас. Проверьте доступные смены.', CAST(N'2024-01-28T10:00:00.0000000' AS DateTime2), 1)
INSERT [dbo].[Notification] ([Id], [UserId], [Type], [Text], [CreateDate], [IsRead]) VALUES (2, 1, N'Статус заявки', N'Ваша заявка на смену 1 была одобрена.', CAST(N'2024-01-28T10:15:00.0000000' AS DateTime2), 1)
INSERT [dbo].[Notification] ([Id], [UserId], [Type], [Text], [CreateDate], [IsRead]) VALUES (3, 1, N'Напоминание о смене', N'Напоминаем, что у вас назначена смена сегодня в 14:00.', CAST(N'2024-01-28T15:30:00.0000000' AS DateTime2), 0)
INSERT [dbo].[Notification] ([Id], [UserId], [Type], [Text], [CreateDate], [IsRead]) VALUES (4, 1, N'Обновление зарплаты', N'Ваша зарплата за январь была начислена. Проверьте детали в личном кабинете.', CAST(N'2024-01-29T09:00:00.0000000' AS DateTime2), 0)
INSERT [dbo].[Notification] ([Id], [UserId], [Type], [Text], [CreateDate], [IsRead]) VALUES (5, 2, N'Новая смена', N'Появилась новая смена, подходящая для вас. Проверьте доступные смены.', CAST(N'2024-01-28T11:00:00.0000000' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[Notification] OFF
GO
SET IDENTITY_INSERT [dbo].[Position] ON 

INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (1, N'Менеджер', CAST(500.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (2, N'Продавец-консультант', CAST(350.50 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (3, N'Кассир', CAST(300.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (4, N'Водитель', CAST(400.75 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (5, N'Уборщик', CAST(250.25 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (6, N'Охранник', CAST(320.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (7, N'Программист', CAST(800.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (8, N'Дизайнер', CAST(650.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (9, N'Аналитик', CAST(700.00 AS Decimal(5, 2)))
INSERT [dbo].[Position] ([Id], [Name], [Rate]) VALUES (10, N'Бухгалтер', CAST(550.50 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Position] OFF
GO
SET IDENTITY_INSERT [dbo].[Salary] ON 

INSERT [dbo].[Salary] ([Id], [UserId], [StartDate], [EndDate], [HoursCount], [Amount], [IsPaid]) VALUES (10, 1, CAST(N'2025-04-01T00:00:00.0000000' AS DateTime2), CAST(N'2025-04-30T00:00:00.0000000' AS DateTime2), 21, CAST(10500.00 AS Decimal(9, 2)), 0)
INSERT [dbo].[Salary] ([Id], [UserId], [StartDate], [EndDate], [HoursCount], [Amount], [IsPaid]) VALUES (11, 2, CAST(N'2024-01-01T00:00:00.0000000' AS DateTime2), CAST(N'2024-01-31T00:00:00.0000000' AS DateTime2), 8, CAST(2804.00 AS Decimal(9, 2)), 0)
INSERT [dbo].[Salary] ([Id], [UserId], [StartDate], [EndDate], [HoursCount], [Amount], [IsPaid]) VALUES (16, 1, CAST(N'2025-05-01T00:00:00.0000000' AS DateTime2), CAST(N'2025-05-31T00:00:00.0000000' AS DateTime2), 0, CAST(0.00 AS Decimal(9, 2)), 0)
SET IDENTITY_INSERT [dbo].[Salary] OFF
GO
SET IDENTITY_INSERT [dbo].[SalaryImpact] ON 

INSERT [dbo].[SalaryImpact] ([Id], [UserId], [SalaryId], [AppointmentDate], [Amount], [Description], [Type]) VALUES (12, 1, 10, CAST(N'2025-04-30T18:54:30.1000000' AS DateTime2), CAST(100.00 AS Decimal(9, 2)), N'Опоздание', N'Штраф')
INSERT [dbo].[SalaryImpact] ([Id], [UserId], [SalaryId], [AppointmentDate], [Amount], [Description], [Type]) VALUES (13, 1, 10, CAST(N'2025-04-30T18:54:55.8300000' AS DateTime2), CAST(100.00 AS Decimal(9, 2)), N'Супер крутой сотрудник', N'Премия')
SET IDENTITY_INSERT [dbo].[SalaryImpact] OFF
GO
SET IDENTITY_INSERT [dbo].[Shift] ON 

INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (1, N'Открыта', CAST(N'2024-01-20T08:00:00.0000000' AS DateTime2), CAST(N'2024-01-20T17:00:00.0000000' AS DateTime2), 1, N'Адрес работы 1', 5)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (2, N'Назначена', CAST(N'2024-01-21T10:00:00.0000000' AS DateTime2), CAST(N'2024-01-21T18:00:00.0000000' AS DateTime2), 0, N'Адрес работы 2', 3)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (3, N'Завершена', CAST(N'2024-01-22T07:00:00.0000000' AS DateTime2), CAST(N'2024-01-22T15:00:00.0000000' AS DateTime2), 1, N'Адрес работы 3', 2)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (4, N'Открыта', CAST(N'2024-02-05T09:00:00.0000000' AS DateTime2), CAST(N'2024-02-05T18:00:00.0000000' AS DateTime2), 1, N'Адрес работы 4', 4)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (5, N'Назначена', CAST(N'2024-02-06T11:00:00.0000000' AS DateTime2), CAST(N'2024-02-06T19:00:00.0000000' AS DateTime2), 0, N'Адрес работы 5', 2)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (7, N'Завершена', CAST(N'2025-04-22T07:00:00.0000000' AS DateTime2), CAST(N'2025-04-22T15:00:00.0000000' AS DateTime2), 1, N'Адрес работы 6', 2)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (8, N'Завершена', CAST(N'2025-04-24T07:00:00.0000000' AS DateTime2), CAST(N'2025-04-24T20:00:00.0000000' AS DateTime2), 1, N'Адрес работы 3', 2)
INSERT [dbo].[Shift] ([Id], [Status], [StartDate], [EndDate], [IsDay], [Address], [MaxEmployees]) VALUES (9, N'Завершена', CAST(N'2025-04-26T07:00:00.0000000' AS DateTime2), CAST(N'2025-04-26T20:00:00.0000000' AS DateTime2), 1, N'Адрес работы 3', 2)
SET IDENTITY_INSERT [dbo].[Shift] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [PositionId], [IsAdmin], [Email], [Password], [Surname], [Name], [Patrionymic], [RegistrationDate]) VALUES (1, 1, 1, N'admin@example.com', N'password123', N'Иванов', N'Иван', N'Иванович', CAST(N'2024-01-25T10:00:00.0000000' AS DateTime2))
INSERT [dbo].[User] ([Id], [PositionId], [IsAdmin], [Email], [Password], [Surname], [Name], [Patrionymic], [RegistrationDate]) VALUES (2, 2, 0, N'user1@example.com', N'securePass', N'Петров', N'Петр', N'Петрович', CAST(N'2024-01-25T12:30:00.0000000' AS DateTime2))
INSERT [dbo].[User] ([Id], [PositionId], [IsAdmin], [Email], [Password], [Surname], [Name], [Patrionymic], [RegistrationDate]) VALUES (3, 3, 0, N'user2@example.com', N'anotherPass', N'Сидорова', N'Анна', N'Сергеевна', CAST(N'2024-01-25T15:45:00.0000000' AS DateTime2))
INSERT [dbo].[User] ([Id], [PositionId], [IsAdmin], [Email], [Password], [Surname], [Name], [Patrionymic], [RegistrationDate]) VALUES (4, 4, 0, N'driver@example.com', N'driveSafe', N'Кузнецов', N'Алексей', NULL, CAST(N'2024-01-26T09:15:00.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Position_Name]    Script Date: 01.05.2025 21:49:36 ******/
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [UQ_Position_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Position_Name]    Script Date: 01.05.2025 21:49:36 ******/
CREATE NONCLUSTERED INDEX [IX_Position_Name] ON [dbo].[Position]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Salary_IsPaid]    Script Date: 01.05.2025 21:49:36 ******/
CREATE NONCLUSTERED INDEX [IX_Salary_IsPaid] ON [dbo].[Salary]
(
	[IsPaid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Salary_UserId]    Script Date: 01.05.2025 21:49:36 ******/
CREATE NONCLUSTERED INDEX [IX_Salary_UserId] ON [dbo].[Salary]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_SalaryImpact_Type]    Script Date: 01.05.2025 21:49:36 ******/
CREATE NONCLUSTERED INDEX [IX_SalaryImpact_Type] ON [dbo].[SalaryImpact]
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SalaryImpact_UserId]    Script Date: 01.05.2025 21:49:36 ******/
CREATE NONCLUSTERED INDEX [IX_SalaryImpact_UserId] ON [dbo].[SalaryImpact]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Assignment] ADD  CONSTRAINT [DF_Assignment_Status]  DEFAULT (N'Ожидает одобрения') FOR [Status]
GO
ALTER TABLE [dbo].[Assignment] ADD  CONSTRAINT [DF_Assignment_ApplicationDate]  DEFAULT (getdate()) FOR [ApplicationDate]
GO
ALTER TABLE [dbo].[Notification] ADD  CONSTRAINT [DF_Notification_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Notification] ADD  CONSTRAINT [DF_Notification_IsRead]  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_Rate]  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [dbo].[Salary] ADD  CONSTRAINT [DF_Salary_HoursCount]  DEFAULT ((0)) FOR [HoursCount]
GO
ALTER TABLE [dbo].[Salary] ADD  CONSTRAINT [DF_Salary_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[Salary] ADD  CONSTRAINT [DF_Salary_IsPaid]  DEFAULT ((0)) FOR [IsPaid]
GO
ALTER TABLE [dbo].[SalaryImpact] ADD  CONSTRAINT [DF_SalaryImpact_AppointmentDate]  DEFAULT (getdate()) FOR [AppointmentDate]
GO
ALTER TABLE [dbo].[Shift] ADD  CONSTRAINT [DF_Shift_Status]  DEFAULT (N'Открыта') FOR [Status]
GO
ALTER TABLE [dbo].[Shift] ADD  CONSTRAINT [DF_Shift_IsDay]  DEFAULT ((1)) FOR [IsDay]
GO
ALTER TABLE [dbo].[Shift] ADD  CONSTRAINT [DF_Shift_MaxEmployees]  DEFAULT ((1)) FOR [MaxEmployees]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsAdmin]  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_RegistrationDate]  DEFAULT (getdate()) FOR [RegistrationDate]
GO
ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [FK_Assignment_Shift] FOREIGN KEY([ShiftId])
REFERENCES [dbo].[Shift] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [FK_Assignment_Shift]
GO
ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [FK_Assignment_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [FK_Assignment_User]
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD  CONSTRAINT [FK_Notification_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Notification] CHECK CONSTRAINT [FK_Notification_User]
GO
ALTER TABLE [dbo].[Salary]  WITH CHECK ADD  CONSTRAINT [FK_Salary_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Salary] CHECK CONSTRAINT [FK_Salary_User]
GO
ALTER TABLE [dbo].[SalaryImpact]  WITH CHECK ADD  CONSTRAINT [FK_SalaryImpact_Salary] FOREIGN KEY([SalaryId])
REFERENCES [dbo].[Salary] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SalaryImpact] CHECK CONSTRAINT [FK_SalaryImpact_Salary]
GO
ALTER TABLE [dbo].[SalaryImpact]  WITH CHECK ADD  CONSTRAINT [FK_SalaryImpact_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SalaryImpact] CHECK CONSTRAINT [FK_SalaryImpact_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Position] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Position]
GO
ALTER TABLE [dbo].[Assignment]  WITH CHECK ADD  CONSTRAINT [CK_Assignment_Status] CHECK  (([Status]='Отменено' OR [Status]='Отклонено' OR [Status]='Одобрено' OR [Status]='Ожидает одобрения'))
GO
ALTER TABLE [dbo].[Assignment] CHECK CONSTRAINT [CK_Assignment_Status]
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD  CONSTRAINT [CK_Notification_Type] CHECK  (([Type]='Обновление зарплаты' OR [Type]='Напоминание о смене' OR [Type]='Статус заявки' OR [Type]='Новая смена'))
GO
ALTER TABLE [dbo].[Notification] CHECK CONSTRAINT [CK_Notification_Type]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [CK_Position_Rate] CHECK  (([Rate]>=(0)))
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [CK_Position_Rate]
GO
ALTER TABLE [dbo].[Salary]  WITH CHECK ADD  CONSTRAINT [CK_Salary_Dates] CHECK  (([EndDate]>=[StartDate]))
GO
ALTER TABLE [dbo].[Salary] CHECK CONSTRAINT [CK_Salary_Dates]
GO
ALTER TABLE [dbo].[SalaryImpact]  WITH CHECK ADD  CONSTRAINT [CK_SalaryImpact_Type] CHECK  (([Type]='Премия' OR [Type]='Аванс' OR [Type]='Штраф'))
GO
ALTER TABLE [dbo].[SalaryImpact] CHECK CONSTRAINT [CK_SalaryImpact_Type]
GO
ALTER TABLE [dbo].[Shift]  WITH CHECK ADD  CONSTRAINT [CK_Shift_Status] CHECK  (([Status]='Завершена' OR [Status]='Назначена' OR [Status]='Открыта'))
GO
ALTER TABLE [dbo].[Shift] CHECK CONSTRAINT [CK_Shift_Status]
GO
/****** Object:  StoredProcedure [dbo].[CalculateEmployeeSalary]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CalculateEmployeeSalary]
    @UserId INT ,
    @Year INT,
    @Month INT
AS
BEGIN
--Обновляем или создаем запись о зарплате
	MERGE INTO [dbo].[Salary] AS target
	USING(
		SELECT 
		--UserId
				@UserId AS UserId, 

		--StartDate
				DATEFROMPARTS(@Year, @Month, 1) AS StartDate,

		--EndDate
				EOMONTH(DATEFROMPARTS(@Year, @Month, 1)) AS EndDate, 

		--HoursCount
				ISNULL(SUM(CASE WHEN a.[Status] = 'Одобрено' AND sh.[Status] = 'Завершена' 
								THEN DATEDIFF(HOUR, sh.[StartDate], sh.[EndDate]) 
								ELSE 0 END), 0) AS HoursCount,

		-- Amount: (Часы × Ставка) + Премии - Штрафы - Авансы
				--(Часы × Ставка)
				ISNULL(SUM(CASE WHEN a.[Status] = 'Одобрено' AND sh.[Status] = 'Завершена' 
								THEN DATEDIFF(HOUR, sh.[StartDate], sh.[EndDate]) * p.[Rate] 
								ELSE 0 END), 0) 
				+ --Премии
				ISNULL((SELECT SUM(Amount) FROM [dbo].[SalaryImpact] 
						WHERE UserId = @UserId 
						  AND Type = 'Премия'
						  AND YEAR(AppointmentDate) = @Year 
						  AND MONTH(AppointmentDate) = @Month), 0)
				- --Штрафы
				ISNULL((SELECT SUM(Amount) FROM [dbo].[SalaryImpact] 
						WHERE UserId = @UserId 
						  AND Type = 'Штраф'
						  AND YEAR(AppointmentDate) = @Year 
						  AND MONTH(AppointmentDate) = @Month), 0)
				- --Авансы
				ISNULL((SELECT SUM(Amount) FROM [dbo].[SalaryImpact] 
						WHERE UserId = @UserId 
						  AND Type = 'Аванс'
						  AND YEAR(AppointmentDate) = @Year 
						  AND MONTH(AppointmentDate) = @Month), 0) AS Amount,
		--IsPaid
				0 AS IsPaid

		FROM [dbo].[User] u
		JOIN [dbo].[Position] p ON u.[PositionId] = p.[Id]
		LEFT JOIN [dbo].[Assignment] a ON u.[Id] = a.[UserId]
		LEFT JOIN [dbo].[Shift] sh ON a.[ShiftId] = sh.[Id]

		AND YEAR(sh.[StartDate]) = @Year 
		AND MONTH(sh.[StartDate]) = @Month
            WHERE u.[Id] = @UserId
            GROUP BY p.[Rate]
	) AS source

	ON (target.[UserId] = source.[UserId] 
		AND YEAR(target.[StartDate]) = @Year 
		AND MONTH(target.[StartDate]) = @Month)

	--Если совпадение есть то обновление
	WHEN MATCHED THEN
		UPDATE SET 
			target.[HoursCount] = source.[HoursCount],
			target.[Amount] = source.[Amount],
			target.[EndDate] = source.[EndDate],
			target.[IsPaid] = CASE 
								WHEN target.[IsPaid] = 1 THEN 1 
								ELSE source.[IsPaid] 
							  END

	--Если совпадений нет то создание
	WHEN NOT MATCHED THEN
		INSERT ([UserId], [StartDate], [EndDate], [HoursCount], [Amount], [IsPaid])
		VALUES (source.[UserId], source.[StartDate], source.[EndDate], source.[HoursCount], source.[Amount], source.[IsPaid]);

-- 2. Возвращаем отчёт по зарплатам за указанный период у пользователя
	SELECT * FROM [dbo].[AllMonthsSalaryStatistic]
	WHERE UserId = @UserId
	  AND YEAR([StartDate]) = @Year
      AND MONTH([StartDate]) = @Month
END;
GO
/****** Object:  StoredProcedure [dbo].[CalculateMonthlySalary]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CalculateMonthlySalary]
    @Year INT,
    @Month INT
AS
BEGIN
-- 1. Создаем или обновляем записи в Salary для каждого сотрудника
	MERGE INTO [dbo].[Salary] AS target
	USING(
		SELECT 
		--UserId
				u.[Id] AS UserId,

		--StartDate
				DATEFROMPARTS(@Year, @Month, 1) AS StartDate,

		--EndDate
				EOMONTH(DATEFROMPARTS(@Year, @Month, 1)) AS EndDate,

		--HoursCount
				ISNULL(SUM(CASE WHEN a.[Status] = 'Одобрено' AND sh.[Status] = 'Завершена' 
								THEN DATEDIFF(HOUR, sh.[StartDate], sh.[EndDate]) 
								ELSE 0 END), 0) AS HoursCount,
		-- Amount: (Часы × Ставка) + Премии - Штрафы - Авансы
				--(Часы × Ставка)
				ISNULL(SUM(CASE WHEN a.[Status] = 'Одобрено' AND sh.[Status] = 'Завершена' 
								THEN DATEDIFF(HOUR, sh.[StartDate], sh.[EndDate]) * p.[Rate] 
								ELSE 0 END), 0) 

				+ --Премии
				ISNULL((SELECT SUM(si.[Amount]) FROM [dbo].[SalaryImpact] si 
						  WHERE si.[UserId] = u.[Id] 
							AND si.[Type] = 'Премия'
							AND YEAR(si.[AppointmentDate]) = @Year 
							AND MONTH(si.[AppointmentDate]) = @Month), 0)

				- --Штрафы
				ISNULL((SELECT SUM(si.[Amount]) FROM [dbo].[SalaryImpact] si 
						  WHERE si.[UserId] = u.[Id] 
							AND si.[Type] = 'Штраф'
							AND YEAR(si.[AppointmentDate]) = @Year 
							AND MONTH(si.[AppointmentDate]) = @Month), 0)
				- --Авансы
				ISNULL((SELECT SUM(si.[Amount]) FROM [dbo].[SalaryImpact] si 
						  WHERE si.[UserId] = u.[Id] 
							AND si.[Type] = 'Аванс'
							AND YEAR(si.[AppointmentDate]) = @Year 
							AND MONTH(si.[AppointmentDate]) = @Month), 0) AS Amount,
		--IsPaid
				0 AS IsPaid
		FROM [dbo].[User] u
		JOIN [dbo].[Position] p ON u.[PositionId] = p.[Id]
		LEFT JOIN [dbo].[Assignment] a ON u.[Id] = a.[UserId]
        LEFT JOIN [dbo].[Shift] sh ON a.[ShiftId] = sh.[Id]
                
		AND YEAR(sh.[StartDate]) = @Year 
		AND MONTH(sh.[StartDate]) = @Month
            GROUP BY u.[Id], p.[Rate]
	) AS source

	ON (target.[UserId] = source.[UserId] 
            AND YEAR(target.[StartDate]) = @Year 
            AND MONTH(target.[StartDate]) = @Month)

	WHEN MATCHED THEN
		UPDATE SET 
			target.[HoursCount] = source.[HoursCount],
            target.[Amount] = source.[Amount],
            target.[EndDate] = source.[EndDate],
            target.[IsPaid] = CASE 
                                WHEN target.[IsPaid] = 1 THEN 1 
                                ELSE source.[IsPaid] 
                              END
	WHEN NOT MATCHED THEN
		INSERT ([UserId], [StartDate], [EndDate], [HoursCount], [Amount], [IsPaid])
		VALUES (source.[UserId], source.[StartDate], source.[EndDate], source.[HoursCount], source.[Amount], source.[IsPaid]);

-- 2. Возвращаем отчёт по зарплатам за указанный период
	SELECT * FROM [dbo].[AllMonthsSalaryStatistic]
	WHERE YEAR([StartDate]) = @Year 
	  AND MONTH([StartDate]) = @Month;	
END;
GO
/****** Object:  Trigger [dbo].[trUpdateSalary]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trUpdateSalary]
	ON [dbo].[SalaryImpact]
	AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON; --Отключаем сообщение о количестве обработанных строк (улучшает производительность)
    
    -- Получаем текущую дату и выделяем из нее год и месяц для последующих расчетов
    DECLARE @CurrentDate DATE = GETDATE();
    DECLARE @CurrentYear INT = YEAR(@CurrentDate);
    DECLARE @CurrentMonth INT = MONTH(@CurrentDate);
    
    -- Собираем уникальных пользователей, для которых нужно обновить зарплату
    DECLARE @UsersToUpdate TABLE (UserId INT);
    
    -- Собираем UserId из ВСЕХ затронутых записей (новых, измененных и удаленных)
    INSERT INTO @UsersToUpdate (UserId)
    SELECT DISTINCT UserId FROM (
        SELECT UserId FROM inserted
        UNION
        SELECT UserId FROM deleted
    ) AS AllAffectedUsers;
    
    -- Для каждого пользователя обновляем зарплату
    DECLARE @UserId INT;
    DECLARE user_cursor CURSOR FOR
		SELECT UserId FROM @UsersToUpdate;
    
    OPEN user_cursor;
    FETCH NEXT FROM user_cursor INTO @UserId;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [dbo].[CalculateEmployeeSalary] 
            @UserId = @UserId,
            @Year = @CurrentYear,
            @Month = @CurrentMonth;
        
        FETCH NEXT FROM user_cursor INTO @UserId;
    END;
    
    CLOSE user_cursor;
    DEALLOCATE user_cursor;
END;
GO
ALTER TABLE [dbo].[SalaryImpact] ENABLE TRIGGER [trUpdateSalary]
GO
/****** Object:  Trigger [dbo].[trShiftUpdateSalary]    Script Date: 01.05.2025 21:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[trShiftUpdateSalary]
ON [dbo].[Shift]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Проверяем, что статус изменился на 'Завершена'
    IF UPDATE([Status])
    BEGIN
        DECLARE @CompletedShiftIds TABLE (Id INT);
        
        -- Находим ID завершенных смен
        INSERT INTO @CompletedShiftIds (Id)
        SELECT i.Id
        FROM inserted i
        JOIN deleted d ON i.Id = d.Id
        WHERE i.[Status] = 'Завершена' AND d.[Status] <> 'Завершена';
        
        -- Если есть завершенные смены
        IF EXISTS (SELECT 1 FROM @CompletedShiftIds)
        BEGIN
            DECLARE @CurrentDate DATE = GETDATE();
            DECLARE @CurrentYear INT = YEAR(@CurrentDate);
            DECLARE @CurrentMonth INT = MONTH(@CurrentDate);
            
            -- Для каждого сотрудника, связанного с завершенными сменами
            DECLARE @UserId INT;
            DECLARE user_cursor CURSOR FOR
            SELECT DISTINCT a.UserId
            FROM [dbo].[Assignment] a
            JOIN @CompletedShiftIds c ON a.ShiftId = c.Id
            WHERE a.[Status] = 'Одобрено';
            
            OPEN user_cursor;
            FETCH NEXT FROM user_cursor INTO @UserId;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC [dbo].[CalculateEmployeeSalary] 
                    @UserId = @UserId,
                    @Year = @CurrentYear,
                    @Month = @CurrentMonth;
                
                FETCH NEXT FROM user_cursor INTO @UserId;
            END;
            
            CLOSE user_cursor;
            DEALLOCATE user_cursor;
        END;
    END;
END;
GO
ALTER TABLE [dbo].[Shift] ENABLE TRIGGER [trShiftUpdateSalary]
GO
