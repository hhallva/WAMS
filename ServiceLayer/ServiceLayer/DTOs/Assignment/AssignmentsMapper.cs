using ServiceLayer.Models;

namespace ServiceLayer.DTOs
{
    public static class AssignmentsMapper
    {
        public static AssignmentDto ToDto(this Assignment assignment)
        {
            if (assignment == null)
                throw new ArgumentNullException(nameof(assignment));

            return new AssignmentDto
            {
                Id = assignment.Id, 
                UserId = assignment.UserId,
                ShiftId = assignment.ShiftId,
                Status = assignment.Status,
                Comment = assignment.Comment,
                ApplicationDate = assignment.ApplicationDate
            };
        }
    }
}
