using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models.PlateBoundaryModels
{
    public class PlateBoundaryData
    {
        public string type { get; set; }
        public List<Feature> features { get; set; }
    }
}