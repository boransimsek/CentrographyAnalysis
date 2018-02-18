using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class Feature
    {
        public string type { get; set; }
        public Properties properties { get; set; }
        public Geometry geometry { get; set; }
        public string id { get; set; }
    }
}