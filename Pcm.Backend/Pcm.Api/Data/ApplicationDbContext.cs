using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Models;
using Pcm.Api.Models.Entities;

namespace Pcm.Api.Data
{
    public class ApplicationDbContext
        : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Member> Members => Set<Member>();
        public DbSet<Court> Courts => Set<Court>();
        public DbSet<Booking> Bookings => Set<Booking>();
        public DbSet<WalletTransaction> WalletTransactions => Set<WalletTransaction>();

        protected override void OnModelCreating(ModelBuilder builder)
{
    base.OnModelCreating(builder);

    builder.Entity<Court>()
        .Property(x => x.PricePerHour)
        .HasColumnType("numeric(18,2)");

    builder.Entity<Member>()
        .Property(x => x.Balance)
        .HasColumnType("numeric(18,2)");

    builder.Entity<WalletTransaction>()
        .Property(x => x.Amount)
        .HasColumnType("numeric(18,2)");
}

    }
}
