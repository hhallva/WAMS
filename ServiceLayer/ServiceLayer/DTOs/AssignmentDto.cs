namespace ServiceLayer.DTOs
{
    public class AssignmentDto
    {
        public int UserId { get; set; }

        public int ShiftId { get; set; }

        public string Status { get; set; } = null!;

        public DateTime ApplicationDate { get; set; }

        public string? Comment { get; set; }

    }
}
