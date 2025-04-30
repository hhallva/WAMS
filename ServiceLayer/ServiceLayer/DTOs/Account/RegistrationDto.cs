using System.ComponentModel.DataAnnotations;

namespace ServiceLayer.DTOs.Account
{
    public class RegistrationDto
    {
        [Required(ErrorMessage = "Должность обязательна")]
        public int PositionId { get; set; }

        [Required(ErrorMessage = "Фамилия обязательна")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Фамилия должна быть от 2 до 100 символов")]
        public string Surname { get; set; } = null!;

        [Required(ErrorMessage = "Имя обязательно")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Имя должна быть от 2 до 100 символов")]
        public string Name { get; set; } = null!;

        [StringLength(100, MinimumLength = 2, ErrorMessage = "Отчество должно быть от 2 до 100 символов")]
        public string? Patrionymic { get; set; }

        [Required(ErrorMessage = "Email обязателен")]
        [EmailAddress(ErrorMessage = "Некорректный формат Email")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Пароль обязателен")]
        [StringLength(50, MinimumLength = 8, ErrorMessage = "Пароль должен быть от 8 до 50 символов")]
        public string Password { get; set; } = null!;

        [Required(ErrorMessage = "Подтверждение пароля обязательно")]
        [Compare(nameof(Password), ErrorMessage = "Пароли не совпадают")]
        public string ConfirmPassword { get; set; } = null!;
    }
}
