using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ServiceLayer.DataContexts;
using ServiceLayer.DTOs;
using ServiceLayer.DTOs.Account;
using ServiceLayer.Models;
using ServiceLayer.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace WebApi.Controllers
{
    /// <summary>
    /// Контроллер для работы с аккаунтом
    /// </summary>
    [Route("api/")]
    [ApiController]
    [SwaggerTag("Управление аккаунтом")]
    public class AccountController(AppDbContext context, TokenService service) : ControllerBase
    {
        [HttpPost("SignIn")]
        #region Документация        
        [SwaggerOperation(Summary = "Авторизация пользователя", Description = "Метод для генерации JWT-токена, принимает учетные данные пользователя, при успешной авторизации возварщает JWT-токен.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Успешная авторизация. Возврат JWT-токена.", Type = typeof(string))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Пользователь не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status403Forbidden, "Доступ запрещен. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<IActionResult> PostAuthorizeAsync([SwaggerRequestBody("Учетные данные пользователя для автризации", Required = true)] AuthorizeDto user)
        {
            var dbUser = await context.Users.FirstOrDefaultAsync(u => u.Email == user.Email);
            if (dbUser == null || dbUser.Password != user.Password)
                return StatusCode(403, new ApiErrorDto("Неверный логин или пароль", 1003));
            return Ok(service.GenerateToken(dbUser));
        }

        [HttpPost("SungUp")]
        #region Документация        
        [SwaggerOperation(Summary = "Регистрация пользователя", Description = "Метод для регистрации пользоветля, принимает учетные данные пользователя, при успешной регистрации возвращает сообщение об успешной регистрации.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Успешная регистрация. Возврат сообщения об успешой регистации.", Type = typeof(string))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status409Conflict, "Конфликт записей. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<IActionResult> PostRegistrationAsync([SwaggerRequestBody("Учетные данные пользователя для регистарции", Required = true)] RegistrationDto userDto)
        {
            if (await context.Users.AnyAsync(u => u.Email == userDto.Email))
                return Conflict(new ApiErrorDto("Email уже занят", 409));

            try
            {
                var user = new User
                {
                    PositionId = userDto.PositionId,
                    Surname = userDto.Surname,
                    Name = userDto.Name,
                    Patrionymic = userDto.Patrionymic,
                    Email = userDto.Email,
                    Password = userDto.Password,
                };

                await context.Users.AddAsync(user);
                await context.SaveChangesAsync();
            }
            catch
            {
                return BadRequest(new ApiErrorDto("Неверные параметры", 400));
            }
            return Created("", "Пользователь успешно зарегистрирован");
        }
    }
}
