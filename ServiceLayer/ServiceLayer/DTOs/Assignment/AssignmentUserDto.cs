using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.DTOs
{
    public class AssignmentUserDto
    {
        public int UserId { get; set; }
        public int ShiftId { get; set; }
        public string? Comment { get; set; }
    }
}
