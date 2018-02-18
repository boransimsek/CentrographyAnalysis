using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace CentrographyAnalysis.Models
{
    [DataContract]
    public class EarthquakeData
    {
        [DataMember]
        public string type { get; set; }

        [DataMember]
        public Metadata metadata { get; set; }

        [DataMember]
        public List<Feature> features { get; set; }

        [DataMember]
        public List<double> bbox { get; set; }

        
    }
}