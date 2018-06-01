using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class MahalanobisEarthquake
    {
        public Earthquake Earthquake { get; set; }
        public double Distance { get; set; }
    }
}