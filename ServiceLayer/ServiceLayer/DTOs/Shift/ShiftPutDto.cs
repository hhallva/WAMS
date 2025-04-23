namespace ServiceLayer.DTOs
{
    public class ShiftPutDto
    {
        public string Status { get; set; } = null!;

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsDay { get; set; }

        public string Address { get; set; } = null!;

        public int MaxEmployees { get; set; }
    }
}
