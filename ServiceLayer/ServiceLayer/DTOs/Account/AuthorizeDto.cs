using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ServiceLayer.DTOs
{
    public class AuthorizeDto
    {
        [Required(ErrorMessage = "Email обязателен")]
        [EmailAddress(ErrorMessage = "Некорректный формат Email")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Пароль обязателен")]
        [StringLength(50, MinimumLength = 8, ErrorMessage = "Пароль должен быть от 8 до 50 символов")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z\p{Zs}\t\r\n]).{8,}$",ErrorMessage = "Пароль должен содержать: 1 цифру, 1 заглавную букву, 1 строчную букву, 1 спецсимвол (без пробелов)")]
        public string Password { get; set; } = null!;
    }
}
