using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.Models.Entities;
using System.Security.Claims;

namespace Pcm.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BookingController : ControllerBase
    {
        private readonly ApplicationDbContext _db;

        public BookingController(ApplicationDbContext db)
        {
            _db = db;
        }

        [Authorize(Roles = "Member")]
        [HttpPost]
        public async Task<IActionResult> CreateBooking(CreateBookingRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var member = await _db.Members
                .FirstOrDefaultAsync(x => x.UserId == userId);

            if (member == null)
                return BadRequest("Member not found");

            var court = await _db.Courts.FindAsync(request.CourtId);
            if (court == null)
                return BadRequest("Court not found");

            var hasOverlap = await _db.Bookings.AnyAsync(b =>
                b.CourtId == request.CourtId &&
                b.StartTime < request.EndTime &&
                request.StartTime < b.EndTime);

            if (hasOverlap)
                return BadRequest("Court already booked for this time");

            var hours = (decimal)(request.EndTime - request.StartTime).TotalHours;
            var amount = hours * court.PricePerHour;

            if (member.Balance < amount)
                return BadRequest("Insufficient balance");

            member.Balance -= amount;

            var booking = new Booking
            {
                CourtId = request.CourtId,
                MemberId = member.Id,
                StartTime = request.StartTime,
                EndTime = request.EndTime,
                Status = BookingStatus.Confirmed
            };

            var tx = new WalletTransaction
            {
                MemberId = member.Id,
                Amount = -amount,
                CreatedAt = DateTime.UtcNow,
                Description = $"Booking court {court.Name}"
            };

            _db.Bookings.Add(booking);
            _db.WalletTransactions.Add(tx);

            await _db.SaveChangesAsync();

            return Ok(booking);
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetBookings()
        {
            var list = await _db.Bookings
                .Include(b => b.Court)
                .Include(b => b.Member)
                .ToListAsync();

            return Ok(list);
        }
    }

    public record CreateBookingRequest(
        int CourtId,
        DateTime StartTime,
        DateTime EndTime
    );
}
