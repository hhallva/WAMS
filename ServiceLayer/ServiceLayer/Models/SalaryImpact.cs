namespace ServiceLayer.Models;

public partial class SalaryImpact
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public int SalaryId { get; set; }

    public DateTime AppointmentDate { get; set; }

    public decimal Amount { get; set; }

    public string Description { get; set; } = null!;

    public string Type { get; set; } = null!;

    public virtual Salary Salary { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
