using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.DTOs
{
    public class ShiftPostDto
    {
        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsDay { get; set; }

        public string Address { get; set; } = null!;

        public int MaxEmployees { get; set; }
    }
}
