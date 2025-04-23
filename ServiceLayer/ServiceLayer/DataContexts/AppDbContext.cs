using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using ServiceLayer.Models;

namespace ServiceLayer.DataContexts;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Assignment> Assignments { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Position> Positions { get; set; }

    public virtual DbSet<Salary> Salaries { get; set; }

    public virtual DbSet<SalaryImpact> SalaryImpacts { get; set; }

    public virtual DbSet<Shift> Shifts { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Data Source=MSI;Initial Catalog=WamsDB;User ID=hhallva;Password=123890;Trust Server Certificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Assignment>(entity =>
        {
            //entity.HasKey(e => new { e.UserId, e.ShiftId });

            entity.ToTable("Assignment");

            entity.Property(e => e.ApplicationDate)
                .HasPrecision(0)
                .HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Comment).HasMaxLength(300);
            entity.Property(e => e.Status)
                .HasMaxLength(17)
                .HasDefaultValue("Ожидает одобрения");

            entity.HasOne(d => d.Shift).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.ShiftId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Assignment_Shift");

            entity.HasOne(d => d.User).WithMany(p => p.Assignments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Assignment_User");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.ToTable("Notification");

            entity.Property(e => e.CreateDate)
                .HasPrecision(0)
                .HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Text).HasMaxLength(300);
            entity.Property(e => e.Type).HasMaxLength(19);

            entity.HasOne(d => d.User).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notification_User");
        });

        modelBuilder.Entity<Position>(entity =>
        {
            entity.ToTable("Position");

            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.Rate).HasColumnType("decimal(5, 2)");
        });

        modelBuilder.Entity<Salary>(entity =>
        {
            entity.ToTable("Salary");

            entity.Property(e => e.Amount).HasColumnType("decimal(9, 2)");
            entity.Property(e => e.EndDate).HasPrecision(0);
            entity.Property(e => e.StartDate).HasPrecision(0);

            entity.HasOne(d => d.User).WithMany(p => p.Salaries)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Salary_User");
        });

        modelBuilder.Entity<SalaryImpact>(entity =>
        {
            entity.ToTable("SalaryImpact");

            entity.Property(e => e.Amount).HasColumnType("decimal(9, 2)");
            entity.Property(e => e.AppointmentDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Description).HasMaxLength(300);
            entity.Property(e => e.Type).HasMaxLength(6);

            entity.HasOne(d => d.Salary).WithMany(p => p.SalaryImpacts)
                .HasForeignKey(d => d.SalaryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SalaryImpact_Salary");

            entity.HasOne(d => d.User).WithMany(p => p.SalaryImpacts)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SalaryImpact_User");
        });

        modelBuilder.Entity<Shift>(entity =>
        {
            entity.ToTable("Shift");

            entity.Property(e => e.Address).HasMaxLength(300);
            entity.Property(e => e.EndDate).HasPrecision(0);
            entity.Property(e => e.IsDay).HasDefaultValue(true);
            entity.Property(e => e.MaxEmployees).HasDefaultValue(1);
            entity.Property(e => e.StartDate).HasPrecision(0);
            entity.Property(e => e.Status)
                .HasMaxLength(9)
                .HasDefaultValue("Открыта");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("User");

            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.Password)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Patrionymic).HasMaxLength(100);
            entity.Property(e => e.RegistrationDate)
                .HasPrecision(0)
                .HasDefaultValueSql("(getdate())");
            entity.Property(e => e.Surname).HasMaxLength(100);

            entity.HasOne(d => d.Position).WithMany(p => p.Users)
                .HasForeignKey(d => d.PositionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_User_Position");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
