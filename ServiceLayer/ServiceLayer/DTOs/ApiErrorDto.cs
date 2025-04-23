namespace ServiceLayer.DTOs
{
    public class ApiErrorDto
    {
        public long Timestamp { get; }

        public string Message { get; }

        public int ErrorCode { get; }

        public ApiErrorDto(long timestamp, string message, int errorCode)
        {
            Timestamp = timestamp;
            Message = message;
            ErrorCode = errorCode;
        }

        public ApiErrorDto(string message, int errorCode) :
            this(DateTimeOffset.UtcNow.ToUnixTimeSeconds(), message, errorCode)
        {
        }
    }
}