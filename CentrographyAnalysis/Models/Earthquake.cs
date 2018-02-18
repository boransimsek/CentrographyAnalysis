using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class Earthquake
    {
        public int ID { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public double Magnitude { get; set; }
        public DateTime EventDate { get; set; }
        public double Depth { get; set; }
        public string AlertType { get; set; }
        public string URL { get; set; }
        public string Title { get; set; }
    }
}