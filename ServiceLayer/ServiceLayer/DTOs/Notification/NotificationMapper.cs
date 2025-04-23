using ServiceLayer.Models;

namespace ServiceLayer.DTOs
{
    public static class NotificationMapper
    {
        public static NotificationDto ToDto(this Notification notification)
        {
            if (notification == null)
                throw new ArgumentNullException(nameof(notification));

            return new NotificationDto
            {
                Id = notification.Id, 
                UserId = notification.UserId,
                Type = notification.Type,
                Text = notification.Text,
                CreateDate = notification.CreateDate,
                IsRead = notification.IsRead
            };
        }
    }
}
