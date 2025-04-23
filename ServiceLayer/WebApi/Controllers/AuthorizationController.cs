using Microsoft.AspNetCore.Mvc;
using ServiceLayer.DataContexts;
using ServiceLayer.DTOs;
using Swashbuckle.AspNetCore.Annotations;

namespace WebApi.Controllers
{
    /// <summary>
    /// Контроллер для работы с авторизацией
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [SwaggerTag("Управление авторизацией")]
    public class AuthorizationController(AppDbContext context) : ControllerBase
    {

    }
}
