namespace ServiceLayer.Models;

public partial class Assignment
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public int ShiftId { get; set; }

    public string Status { get; set; } = null!;

    public DateTime ApplicationDate { get; set; }

    public string? Comment { get; set; }

    public virtual Shift Shift { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
