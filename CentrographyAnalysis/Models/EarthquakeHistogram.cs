using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models
{
    public class EarthquakeHistogram
    {
        public List<int> HistogramData { get; set; }
        public List<string> Labels { get; set; }

        public EarthquakeHistogram()
        {
            HistogramData = new List<int>();
            Labels = new List<string>();
        }
    }
}