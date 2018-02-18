using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using CentrographyAnalysis.Models;

namespace CentrographyAnalysis
{
    public class Context : DbContext
    {
        public Context() : base("Name=Default")
        {

        }

        public DbSet<Earthquake> Earthquakes { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            Database.SetInitializer<Context>(null);
            modelBuilder.Configurations.Add(new EarthquakeMap());
        }
    }
}