namespace ServiceLayer.Models;

public partial class Position
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public decimal Rate { get; set; }

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
