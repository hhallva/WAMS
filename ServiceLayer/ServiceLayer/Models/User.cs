namespace ServiceLayer.Models;

public partial class User
{
    public int Id { get; set; }

    public int PositionId { get; set; }

    public bool IsAdmin { get; set; }

    public string Email { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string Surname { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Patrionymic { get; set; }

    public DateTime RegistrationDate { get; set; }

    public virtual ICollection<Assignment> Assignments { get; set; } = new List<Assignment>();

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

    public virtual Position Position { get; set; } = null!;

    public virtual ICollection<Salary> Salaries { get; set; } = new List<Salary>();

    public virtual ICollection<SalaryImpact> SalaryImpacts { get; set; } = new List<SalaryImpact>();
}
