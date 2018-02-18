using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class Properties
    {
        public double mag { get; set; }
        public string place { get; set; }
        public object time { get; set; }
        public object updated { get; set; }
        public int? tz { get; set; }
        public string url { get; set; }
        public string detail { get; set; }
        public int? felt { get; set; }
        public double? cdi { get; set; }
        public double? mmi { get; set; }
        public string alert { get; set; }
        public string status { get; set; }
        public int? tsunami { get; set; }
        public int? sig { get; set; }
        public string net { get; set; }
        public string code { get; set; }
        public string ids { get; set; }
        public string sources { get; set; }
        public string types { get; set; }
        public int? nst { get; set; }
        public double? dmin { get; set; }
        public double? rms { get; set; }
        public double? gap { get; set; }
        public string magType { get; set; }
        public string type { get; set; }
        public string title { get; set; }
    }
}