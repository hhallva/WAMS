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
    [SwaggerTag("Управление сменами")]
    public class ShiftsController(AppDbContext context) : ControllerBase
    {
        [HttpGet]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение списка всех смен.", Description = "Метод для получения списка смен из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение списка. Возврат списка смен.", Type = typeof(IEnumerable<ShiftDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Смены не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<ShiftDto>>> GetShiftsAsync()
        {
            var shifts = await context.Shifts.ToListAsync();

            if (!shifts.Any())
                return NotFound(new ApiErrorDto("Смены не найдены", 2001));

            var shiftsDtos = shifts.Select(s => s.ToDto()).ToList();

            return Ok(shiftsDtos);
        }

        [HttpGet("Open")]
        #region Документация
        [SwaggerOperation(Summary = "Получение списка всех доступных смен.", Description = "Метод для получения списка всех доступных смен из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение списка. Возврат списка доступных смен.", Type = typeof(IEnumerable<ShiftDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Доступные смены не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<ShiftDto>>> GetOpenShiftsAsync()
        {
            var shifts = await context.Shifts
                .Where(s => s.Status == "Открыта")
                .ToListAsync();

            if (!shifts.Any())
                return NotFound(new ApiErrorDto("Смены не найдены", 2001));

            var shiftsDtos = shifts.Select(s => s.ToDto()).ToList();

            return Ok(shiftsDtos);
        }

        [HttpGet("{id}", Name = "GetShiftById")]
        #region Документация
        [SwaggerOperation(Summary = "Получение смены.", Description = "Метод для получения смены по Id из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение смены. Возврат объекта смены.", Type = typeof(ShiftDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Смена не найдена. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<ShiftDto>> GetShiftByIdAsync([SwaggerParameter("Id смены которую необходимо получить", Required = true)] int id)
        {
            if (id <= 0)
                return BadRequest(new ApiErrorDto("Id смены должен быть положительным числом", 2002));

            var shift = await context.Shifts.FindAsync(id);

            if (shift == null)
                return NotFound(new ApiErrorDto("Смена не найдена", 2003));

            var shiftDto = shift.ToDto();

            return Ok(shiftDto);
        }

        [HttpPost]
        #region Документация
        [SwaggerOperation(Summary = "Создание смены.", Description = "Метод для создания новой смены в БД.")]
        [SwaggerResponse(StatusCodes.Status201Created, "Успешное создание смены. Возврат созданной смены.", Type = typeof(ShiftDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<ShiftDto>> PostShiftAsync([SwaggerRequestBody("Данные смены", Required = true)] ShiftPostDto shiftDto)
        {
            try
            {
                var shift = new Shift
                {
                    StartDate = shiftDto.StartDate,
                    EndDate = shiftDto.EndDate,
                    IsDay = shiftDto.IsDay,
                    Address = shiftDto.Address,
                    MaxEmployees = shiftDto.MaxEmployees,
                };

                context.Shifts.Add(shift);
                await context.SaveChangesAsync();

                return CreatedAtAction("GetShiftById", new { id = shift.Id }, shift.ToDto());
            }
            catch
            {
                return BadRequest(new ApiErrorDto("Ошибка при создании смены", 2002));
            }
        }

        [HttpPut("{id}")]
        #region Документация
        [SwaggerOperation(Summary = "Обновление смены.", Description = "Метод для обновления смены в БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное обновление смены. Возврат обновленной смены.", Type = typeof(ShiftDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<IActionResult> PutShiftAsync([SwaggerParameter("Id смены которую необходимо обновить", Required = true)] int id,
                                                                   [SwaggerRequestBody("Обновленные данные смены", Required = true)] ShiftPutDto shiftDto)
        {
            if (id <= 0)
                return BadRequest(new ApiErrorDto("Id смены должен быть положительным числом", 2002));

            var shift = await context.Shifts.FindAsync(id);

            if (shift == null)
                return NotFound(new ApiErrorDto("Смена не найдена", 2003));

            shift.Status = shiftDto.Status;
            shift.StartDate = shiftDto.StartDate;
            shift.EndDate = shiftDto.EndDate;
            shift.Address = shiftDto.Address;
            shift.IsDay = shiftDto.IsDay;
            shift.MaxEmployees = shiftDto.MaxEmployees;

            context.Shifts.Update(shift);
            await context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        #region Документация
        [SwaggerOperation(Summary = "Удаление смены.", Description = "Метод для удаления смены из БД.")]
        [SwaggerResponse(StatusCodes.Status204NoContent, "Успешное удаление смены.")]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Смена не найдена. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Неверные параметры. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<IActionResult> DeleteShiftAsync([SwaggerParameter("Id смены которую необходимо удалить", Required = true)] int id)
        {
            if (id <= 0)
                return BadRequest(new ApiErrorDto("Id смены должен быть положительным числом", 2002));

            var shift = await context.Shifts.FindAsync(id);

            if (shift == null)
                return NotFound(new ApiErrorDto("Смена не найдена", 2003));

            context.Shifts.Remove(shift);
            await context.SaveChangesAsync();

            return NoContent();
        }
    }
}
