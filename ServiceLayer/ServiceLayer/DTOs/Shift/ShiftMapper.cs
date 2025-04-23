using ServiceLayer.Models;

namespace ServiceLayer.DTOs
{
    public static class ShiftMapper
    {
        public static ShiftDto ToDto(this Shift shift)
        {
            if (shift == null)
                throw new ArgumentNullException(nameof(shift));

            return new ShiftDto
            {
                Id = shift.Id,
                Status = shift.Status,
                StartDate = shift.StartDate,
                EndDate = shift.EndDate,
                IsDay = shift.IsDay,
                Address = shift.Address,
                MaxEmployees = shift.MaxEmployees,
            };
        }
    }
}
