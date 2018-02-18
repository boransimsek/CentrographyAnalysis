using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class Geometry
    {
        public string type { get; set; }
        public List<double> coordinates { get; set; }
    }
}