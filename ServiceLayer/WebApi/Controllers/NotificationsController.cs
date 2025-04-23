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
    public class NotificationsController(AppDbContext context) : ControllerBase
    {

        [HttpGet("{userId}")]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение всех уведомлений.", Description = "Метод для получения уведомлений сотрудника из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение уведомлений. Возврат списка уведомлений.", Type = typeof(IEnumerable<NotificationDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Уведомления не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<NotificationDto>>> GetNotificationsAsync([SwaggerParameter("Id пользователя у которого хотим получить уведомления", Required = true)] int userId)
        {
            var notifications = await context.Notifications
                .Where(n => n.UserId == userId)
                .ToListAsync();

            if (!notifications.Any())
                return NotFound(new ApiErrorDto("Уведомления не найдены", 2001));

            var notificationsDtos = notifications.Select(n => n.ToDto()).ToList();

            return Ok(notificationsDtos);
        }

        [HttpGet("{userId}/NoRead")]
        #region Докуметация
        [SwaggerOperation(Summary = "Получение всех непрочитанных уведомлений.", Description = "Метод для получения непрочитанных уведомлений сотрудника из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное получение непрочитанных уведомлений. Возврат списка уведомлений.", Type = typeof(IEnumerable<NotificationDto>))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Уведомления не найдены. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<IEnumerable<NotificationDto>>> GetNoReadNotificationsAsync([SwaggerParameter("Id пользователя у которого хотим получить уведомления", Required = true)] int userId)
        {
            var notifications = await context.Notifications
                .Where(n => n.UserId == userId)
                .Where(n => n.IsRead == false)
                .ToListAsync();

            if (!notifications.Any())
                return NotFound(new ApiErrorDto("Уведомления не найдены", 2001));

            var notificationsDtos = notifications.Select(n => n.ToDto()).ToList();

            return Ok(notificationsDtos);
        }

        [HttpPatch("{id}/Read")]
        #region Докуметация
        [SwaggerOperation(Summary = "Отметить уведомление прочитанным.", Description = "Метод для прочтения уведомления сотрудника из БД.")]
        [SwaggerResponse(StatusCodes.Status200OK, "Успешное прочтение уведомления. Возврат прочетнного уведомления.", Type = typeof(NotificationDto))]
        [SwaggerResponse(StatusCodes.Status404NotFound, "Уведомление не найдено. Возврат сообщения об ошибке.", Type = typeof(ApiErrorDto))]
        #endregion
        public async Task<ActionResult<NotificationDto>> PatchNotificationsAsync([SwaggerParameter("Id уведомления которое хотим отметить прочитанным", Required = true)] int id)
        {
            var notification = await context.Notifications.FindAsync(id);

            if (notification == null)
                return NotFound(new ApiErrorDto("Уведомление не найдено", 2001));

            if (notification.IsRead == true)
                return NotFound(new ApiErrorDto("Уведомления уже прочитано", 2001));

            notification.IsRead = true;
            context.Notifications.Update(notification);
            await context.SaveChangesAsync();

            var notificationDto = notification.ToDto();

            return Ok(notificationDto);
        }
    }
}
