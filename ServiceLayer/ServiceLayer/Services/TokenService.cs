using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using ServiceLayer.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ServiceLayer.Services
{
    public class TokenService(IConfiguration config)
    {
        public string GenerateToken(User user)
        {
            var key = Encoding.UTF8.GetBytes(config["JWT:Key"]);
            var credentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature);
            var claims = new List<Claim>()
            {
                new(ClaimTypes.NameIdentifier, user.Email),
                new(JwtRegisteredClaimNames.Iss, config["JWT:Issuer"]),
                new(JwtRegisteredClaimNames.Aud, config["JWT:Audience"])
            };

            var token = new JwtSecurityToken(
                claims: claims,
                signingCredentials: credentials,
                expires: DateTime.Now.AddHours(1));
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
