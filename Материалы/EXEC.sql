--ћетод дл€ подсчета зарплаты всех сотрудников которые работали в определЄнном мес€це
EXEC [dbo].[CalculateMonthlySalary] @Year = 2025, @Month = 4

--ћетод дл€ подсчета зарплаты конкретного сотрудника в определЄнном мес€це
EXEC [dbo].[CalculateEmployeeSalary] @UserId = 1, @Year = 2025, @Month = 4
