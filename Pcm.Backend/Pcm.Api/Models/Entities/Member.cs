using Pcm.Api.Models;

namespace Pcm.Api.Models.Entities
{
    public class Member
    {
        public int Id { get; set; }
        public string UserId { get; set; } = null!;   
        public ApplicationUser User { get; set; } = null!; 
        public string FullName { get; set; } = null!;

        public string Email { get; set; } = null!;

        public decimal Balance { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
