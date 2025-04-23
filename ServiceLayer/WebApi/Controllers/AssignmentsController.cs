using Microsoft.AspNetCore.Mvc;
using ServiceLayer.DataContexts;
using ServiceLayer.DTOs;
using Swashbuckle.AspNetCore.Annotations;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [SwaggerTag("Управление назначениями")]
    public class AssignmentsController(AppDbContext context) : ControllerBase
    {

        [HttpPost]
        [SwaggerOperation(Summary = "Назначить сотрудника на смену.", Description = "Метод для назначения сотрудника на смену из БД.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Успешное назначение сотрудника на смену. Возврат назначения.", Type = typeof(AssignmentDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Объект не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        public async Task<ActionResult<AssignmentDto>> PostShiftAsync([SwaggerRequestBody("Объект для создания назначения", Required = true)] AssignmentUserDto assignment)
        {
            return Ok();
        }
    }
}
