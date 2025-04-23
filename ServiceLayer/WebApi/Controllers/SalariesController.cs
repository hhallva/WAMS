using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ServiceLayer.DataContexts;
using ServiceLayer.DTOs;
using ServiceLayer.Models;
using Swashbuckle.AspNetCore.Annotations;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [SwaggerTag("Управление зарплатами")]
    public class SalariesController(AppDbContext context) : ControllerBase
    {
        [HttpGet("{userId}/Current")]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение текущей зарплаты.", Description = "Метод для получения текущей зарплаты сотрудника из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение зарплаты. Возврат объекта зарплаты.", Type = typeof(SalaryDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Зарплата не найдена. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<SalaryDto>> GetCurrentSalaryAsync([SwaggerParameter("Id пользователя у которого хотим получить зарплату", Required = true)] int userId)
        {
            return Ok();
        }

        [HttpGet("{userId}/Month")]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение зарплаты за месяц.", Description = "Метод для получения зарплаты сотрудника за месяц из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение зарплаты. Возврат объекта зарплаты.", Type = typeof(SalaryDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Зарплата не найдена. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<SalaryDto>> GetSalaryByMonthAsync([SwaggerParameter("Id пользователя у которого хотим получить зарплату", Required = true)] int userId)
        {
            return Ok();
        }

        [HttpGet("{userId}")]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение зарплаты сотрудника.", Description = "Метод для получения зарплаты сотрудника из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение зарплаты. Возврат объекта зарплаты.", Type = typeof(SalaryDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Зарплата не найдена. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<SalaryDto>> GetSalaryByUserAsync([SwaggerParameter("Id пользователя у которого хотим получить зарплату", Required = true)] int userId)
        {
            return Ok();
        }
    }
}
