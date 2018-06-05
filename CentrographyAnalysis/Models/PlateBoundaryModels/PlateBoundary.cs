using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Models.PlateBoundaryModels
{
    public class PlateBoundary
    {
        public List<Coordinate> BoundaryList { get; set; }

        public PlateBoundary()
        {
            BoundaryList = new List<Coordinate>();
        }
    }
}