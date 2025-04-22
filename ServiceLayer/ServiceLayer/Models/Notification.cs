namespace ServiceLayer.Models;

public partial class Notification
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public string Type { get; set; } = null!;

    public string Text { get; set; } = null!;

    public DateTime CreateDate { get; set; }

    public bool IsRead { get; set; }

    public virtual User User { get; set; } = null!;
}
