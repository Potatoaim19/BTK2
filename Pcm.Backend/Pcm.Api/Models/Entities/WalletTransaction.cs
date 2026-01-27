using System;

namespace Pcm.Api.Models.Entities
{
    public class WalletTransaction
    {
        public int Id { get; set; }

        public int MemberId { get; set; }
        public Member Member { get; set; } = null!;

        public decimal Amount { get; set; }

        public string Type { get; set; } = null!; // TopUp / Payment / Refund
        public string Description { get; set; } = null!; 
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
