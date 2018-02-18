using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class RootObject
    {
        public string type { get; set; }
        public Metadata metadata { get; set; }
        public List<Feature> features { get; set; }
        public List<double> bbox { get; set; }
    }
}