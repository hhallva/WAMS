namespace ServiceLayer.Models;

public partial class Shift
{
    public int Id { get; set; }

    public string Status { get; set; } = null!;

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public bool IsDay { get; set; }

    public string Address { get; set; } = null!;

    public int MaxEmployees { get; set; }

    public virtual ICollection<Assignment> Assignments { get; set; } = new List<Assignment>();
}
