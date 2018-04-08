using System;
using System.Collections.Generic;
using System.Data.Entity.ModelConfiguration;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class EarthquakeMap : EntityTypeConfiguration<Earthquake>
    {
        public EarthquakeMap()
        {
            this.HasKey(t => t.ID);

            this.Property(t => t.AlertType)
                .HasColumnName("AlertType");
            this.Property(t => t.Depth)
                .HasColumnName("Depth");
            this.Property(t => t.EventDate)
                .HasColumnName("EventDate");
            this.Property(t => t.Latitude)
                .HasColumnName("Latitude");
            this.Property(t => t.Longitude)
                .HasColumnName("Longitude");
            this.Property(t => t.Magnitude)
                .HasColumnName("Magnitude");
            this.Property(t => t.Title)
                .HasColumnName("Title");
            this.Property(t => t.URL)
                .HasColumnName("URL");

            this.ToTable("dbo.Earthquake");
        }
    }
}