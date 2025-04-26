namespace ServiceLayer.DTOs
{
    public class SalaryDto
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public int HoursCount { get; set; }

        public decimal Amount { get; set; }

        public bool IsPaid { get; set; }
    }
}
