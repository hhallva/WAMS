namespace ServiceLayer.Models;

public partial class Salary
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public int HoursCount { get; set; }

    public decimal Amount { get; set; }

    public bool IsPaid { get; set; }

    public virtual ICollection<SalaryImpact> SalaryImpacts { get; set; } = new List<SalaryImpact>();

    public virtual User User { get; set; } = null!;
}
