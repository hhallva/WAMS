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
    [SwaggerTag("Управление назначениями")]
    public class AssignmentsController(AppDbContext context) : ControllerBase
    {
        [HttpGet]
        #region Документация
        [SwaggerOperation(Summary = "Получение списка назначений.", Description = "Метод для получения списка всех назначений из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение списка. Возврат списка назначений.", Type = typeof(IEnumerable<AssignmentDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Назначения не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<AssignmentDto>>> GetAssignmentsAsync()
        {
            var assignments = await context.Assignments.ToListAsync();

            if (!assignments.Any())
                return NotFound(new ApiErrorDto("Назначения не найдены", 2001));

            var assignmentsDtos = assignments.Select(s => s.ToDto()).ToList();

            return Ok(assignmentsDtos);
        }

        [HttpGet("Wait")]
        #region Документация
        [SwaggerOperation(Summary = "Получение списка назначений которые ждут одобрения.", Description = "Метод для получения списка назначений которые ждут одобрения из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение списка. Возврат списка назначений.", Type = typeof(IEnumerable<AssignmentDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Назначения не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<AssignmentDto>>> GetWaitAssignmentsAsync()
        {
            var assignments = await context.Assignments
                .Where(s => s.Status == "Ожидает одобрения")
                .ToListAsync();

            if (!assignments.Any())
                return NotFound(new ApiErrorDto("Назначения не найдены", 2001));

            var assignmentsDtos = assignments.Select(s => s.ToDto()).ToList();

            return Ok(assignmentsDtos);
        }

        [HttpPost]
        #region Документация
        [SwaggerOperation(Summary = "Назначить сотрудника на смену.", Description = "Метод для назначения сотрудника на смену из БД.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Успешное назначение сотрудника на смену. Возврат назначения.", Type = typeof(AssignmentDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Объект не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<AssignmentDto>> PostAssignmentAsync([SwaggerRequestBody("Объект для создания назначения", Required = true)] AssignmentUserDto assignmentDto)
        {
            if (await context.Users.FindAsync(assignmentDto.UserId) == null)
                return NotFound(new ApiErrorDto("Пользователь не найден", 2001));
            if (await context.Shifts.FindAsync(assignmentDto.ShiftId) == null)
                return NotFound(new ApiErrorDto("Смена не найдена", 2001));
            if (await context.Assignments.SingleOrDefaultAsync(a => a.UserId == assignmentDto.UserId && a.ShiftId == assignmentDto.ShiftId) != null)
                return NotFound(new ApiErrorDto("Такое назначение уже существует", 2001));

            try
            {
                var assignment = new Assignment
                {
                    UserId = assignmentDto.UserId,
                    ShiftId = assignmentDto.ShiftId,
                    Comment = assignmentDto.Comment,
                };

                await context.Assignments.AddAsync(assignment);
                await context.SaveChangesAsync();

                return Created("", assignment.ToDto());
            }
            catch
            {
                return BadRequest(new ApiErrorDto("Ошибка при создании назначения", 2002));
            }
        }

        [HttpPatch("{id}/Approve")]
        #region Документация
        [SwaggerOperation(Summary = "Одобрить назначение.", Description = "Метод для одобрения назначения в БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное одобрение назначения. Возврат назначения.", Type = typeof(AssignmentDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Объект не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<AssignmentDto>> ApproveAssignmentAsync([SwaggerParameter("Id одобряемого назначения", Required = true)] int id)
        {
            var assignment = await context.Assignments.SingleOrDefaultAsync(a => a.Id == id);

            if (assignment == null)
                return NotFound(new ApiErrorDto("Назначение не найдено", 2001));

            assignment.Status = "Одобрено";

            context.Assignments.Update(assignment);
            await context.SaveChangesAsync();

            var assignmentDto = assignment.ToDto();

            return Ok(assignmentDto);
        }

        [HttpPatch("{id}/Reject")]
        #region Документация
        [SwaggerOperation(Summary = "Отклонить назначение.", Description = "Метод для отклонения назначения в БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное отклонение назначения. Возврат назначения.", Type = typeof(AssignmentDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Объект не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<AssignmentDto>> RejectAssignmentAsync([SwaggerParameter("Id отклоняемого назначения", Required = true)] int id)
        {
            var assignment = await context.Assignments.SingleOrDefaultAsync(a => a.Id == id);

            if (assignment == null)
                return NotFound(new ApiErrorDto("Назначение не найдено", 2001));

            assignment.Status = "Отклонено";

            context.Assignments.Update(assignment);
            await context.SaveChangesAsync();

            var assignmentDto = assignment.ToDto();

            return Ok(assignmentDto);
        }

        [HttpPatch("{id}/Cancel")]
        #region Документация
        [SwaggerOperation(Summary = "Отменить назначение.", Description = "Метод для отмены назначения в БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешная отмена назначения. Возврат назначения.", Type = typeof(AssignmentDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Объект не найден. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<AssignmentDto>> CancelAssignmentAsync([SwaggerParameter("Id отменяемого назначения", Required = true)] int id)
        {
            var assignment = await context.Assignments.SingleOrDefaultAsync(a => a.Id == id);

            if (assignment == null)
                return NotFound(new ApiErrorDto("Назначение не найдено", 2001));

            assignment.Status = "Отменено";

            context.Assignments.Update(assignment);
            await context.SaveChangesAsync();

            var assignmentDto = assignment.ToDto();

            return Ok(assignmentDto);
        }
    }
}