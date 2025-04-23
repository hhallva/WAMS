using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ServiceLayer.DataContexts;
using ServiceLayer.Models;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SalariesController(AppDbContext context, IMapper mapper) : ControllerBase
    {
        // GET: api/Salaries
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Salary>>> GetSalaries()
        {
            return await context.Salaries.ToListAsync();
        }

        // GET: api/Salaries/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Salary>> GetSalary(int id)
        {
            var salary = await context.Salaries.FindAsync(id);

            if (salary == null)
            {
                return NotFound();
            }

            return salary;
        }

        // PUT: api/Salaries/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSalary(int id, Salary salary)
        {
            if (id != salary.Id)
            {
                return BadRequest();
            }

            context.Entry(salary).State = EntityState.Modified;

            try
            {
                await context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SalaryExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Salaries
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Salary>> PostSalary(Salary salary)
        {
            context.Salaries.Add(salary);
            await context.SaveChangesAsync();

            return CreatedAtAction("GetSalary", new { id = salary.Id }, salary);
        }

        // DELETE: api/Salaries/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSalary(int id)
        {
            var salary = await context.Salaries.FindAsync(id);
            if (salary == null)
            {
                return NotFound();
            }

            context.Salaries.Remove(salary);
            await context.SaveChangesAsync();

            return NoContent();
        }

        private bool SalaryExists(int id)
        {
            return context.Salaries.Any(e => e.Id == id);
        }
    }
}
