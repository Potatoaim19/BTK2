namespace Pcm.Api.Models.Entities
{
    public class Court
    {
        public int Id { get; set; }

        public string Name { get; set; } = null!;

        public decimal PricePerHour { get; set; }

        public bool IsActive { get; set; } = true;
    }
}
