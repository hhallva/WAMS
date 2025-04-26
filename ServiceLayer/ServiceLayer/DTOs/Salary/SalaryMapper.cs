using ServiceLayer.Models;

namespace ServiceLayer.DTOs
{
    public static class SalaryMapper
    {
        public static SalaryDto ToDto(this Salary salary)
        {
            if (salary == null)
                throw new ArgumentNullException(nameof(salary));

            return new SalaryDto
            {
                Id = salary.Id,
                UserId = salary.UserId,
                StartDate = salary.StartDate,
                EndDate = salary.EndDate,
                HoursCount = salary.HoursCount,
                Amount = salary.Amount,
                IsPaid = salary.IsPaid,
            };
        }
    }
}
