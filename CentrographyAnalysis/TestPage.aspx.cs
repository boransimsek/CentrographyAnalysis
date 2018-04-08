using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxPro;
using CentrographyAnalysis.Models;

namespace CentrographyAnalysis
{
    [AjaxNamespace("TestAjax")]
    public partial class TestPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AjaxPro.Utility.RegisterTypeForAjax(typeof(TestPage));
            lblTest.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
        }

        [AjaxMethod]
        public string GetResponseFromService()
        {
            return DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
        }

        [AjaxMethod]
        public List<TestObject> GetEarthquakes()
        {
            List<TestObject> result = TestTools.TestGenerator.GenerateTestObjects(20);

            return result;
        }

        [AjaxMethod]
        public TestObject CentralizeTest(List<TestObject> list, string stepCount)
        {
            int loopMax = (int)(list.Count * Convert.ToInt32(stepCount) / 100);
            for (int i = 0; i < loopMax; i++)
            {
                TestObject avgCur = GetAverage(list);
                TestObject furthestCur = GetFurthestObject(list, avgCur);

                list.Remove(furthestCur);
            }

            TestObject avgFinal = GetAverage(list);
            TestObject furthestFinal = GetFurthestObject(list, avgFinal);


            double circleRadius = GetDistance(avgFinal, furthestFinal);
            avgFinal.Magnitude = circleRadius;
            return avgFinal;
            
            //int step = String.IsNullOrEmpty(stepCount) ? 4 : Convert.ToInt32(stepCount);
            //if (step == 0)
            //    step = 4;
            //else if (step < 0)
            //    step = Math.Abs(step);


            //int minLat = (int)list.Min(t => t.Latitude) - step - 2;
            //int minLng = (int)list.Min(t => t.Longitude) - step - 2;
            //int maxLat = (int)list.Max(t => t.Latitude) + step + 2;
            //int maxLng = (int)list.Max(t => t.Longitude) + step + 2;

            //int latParts = (maxLat - minLat) / step;
            //int lngParts = (maxLng - minLng) / step;


            //List<Earthquake> result = new List<Earthquake>();
            //for (int i = minLat; i < maxLat; i += step)
            //{
            //    for (int j = minLng; j < maxLng; j += step)
            //    {
            //        List<Earthquake> curList = list.Where(t => t.Latitude < (i + step) && t.Latitude >= (i) && t.Longitude < (j + step) && t.Longitude >= (j)).ToList();
            //        if (curList.Count == 0 || ((1.0 * curList.Count) / list.Count) < (1.0 / (1.0 * latParts * lngParts)))
            //            continue;
            //        Earthquake centerEq = FindWeightedCenter(curList);
            //        FindStandardDeviation(curList, centerEq);
            //        centerEq.Depth = curList.Count;

            //        //if(centerEq.Magnitude < 0.8)
            //        //    result.Add(centerEq);
            //        //if (curList.Count > step * 5 && IsCentralized(curList, centerEq))

            //        if (IsCentralized(curList, centerEq))
            //            result.Add(centerEq);
            //        //double safeTest = (1.0 * curList.Count) / centerEq.Magnitude;
            //        //if (safeTest > 0.65)
            //        //    result.Add(centerEq);

            //    }
            //}

            //return result;

            //return new List<TestObject>();
        }

        public TestObject GetAverage(List<TestObject> list)
        {
            double latSum = 0;
            double lngSum = 0;
            for (int i = 0; i < list.Count; i++)
            {
                latSum += list[i].Latitude;
                lngSum += list[i].Longitude;
            }

            TestObject result = new TestObject();
            result.Latitude = latSum / list.Count;
            result.Longitude = lngSum / list.Count;
            result.Magnitude = 7;

            return result;
        }

        public TestObject GetFurthestObject(List<TestObject> list, TestObject avgObject)
        {
            double distMax = 0;
            TestObject result = list[0];

            for (int i = 0; i < list.Count; i++)
            {
                //double deltaLat = Math.Abs(list[i].Latitude - avgObject.Latitude);
                //double deltaLng = Math.Abs(list[i].Longitude - avgObject.Longitude);

                //double dist = Math.Sqrt(Math.Pow(deltaLat, 2) + Math.Pow(deltaLng, 2));
                double dist = GetDistance(list[i], avgObject);
                if (dist > distMax)
                {
                    distMax = dist;
                    result = list[i];
                }
            }

            return result;
        }


        //, decimal minLat, decimal maxLat, decimal minLng, decimal maxLng
        private Earthquake FindWeightedCenter(List<Earthquake> list)
        {
            Earthquake result = new Earthquake();
            decimal meanLat = 0;
            decimal meanLng = 0;
            decimal totalLat = 0;
            decimal totalLng = 0;
            double totalWeight = 0;


            foreach (var eq in list)
            {
                totalLat += eq.Latitude * (decimal)eq.Magnitude;
                totalLng += eq.Longitude * (decimal)eq.Magnitude;
                totalWeight += eq.Magnitude;
            }

            meanLat = totalLat / (decimal)totalWeight;
            meanLng = totalLng / (decimal)totalWeight;
            result.Magnitude = list.Count;
            result.Latitude = meanLat;
            result.Longitude = meanLng;

            return result;
        }

        //private void FindStandardDeviation(List<Earthquake> list, Earthquake mean)
        //{
        //    double result = 0;
        //    decimal totalX = 0;
        //    decimal totalY = 0;
        //    double devX, devY;

        //    foreach (var eq in list)
        //    {
        //        decimal difX = eq.Latitude - mean.Latitude;
        //        decimal difY = eq.Longitude - mean.Longitude;
        //        totalX += difX * difX;
        //        totalY += difY * difY;
        //    }

        //    devX = Math.Sqrt((double)totalX / (1.0 * list.Count));
        //    devY = Math.Sqrt((double)totalY / (1.0 * list.Count));
        //    double distLat = 111;
        //    double distLng = GetDistancePerLongitude(mean.Latitude);

        //    result = Math.Sqrt(Math.Pow(devX * distLat, 2) + Math.Pow(devY * distLng, 2));
        //    mean.Magnitude = result;
        //    //result = Math.Sqrt(((double) (totalX + totalY))/(1.0*list.Count));
        //    //mean.Magnitude = result;
        //}

        private double GetDistancePerLongitude(double latitude)
        {
            double lat1, lat2, lng1, lng2;
            lat1 = (latitude) / 180.0 * Math.PI;
            lat2 = lat1;
            lng1 = 0;
            lng2 = (lng1 + 1) / 180.0 * Math.PI;

            double dLng = lng2 - lng1;
            double dLat = lat2 - lat1;


            double a = Math.Pow(Math.Sin(dLat / 2), 2) + Math.Cos(lat1) * Math.Cos(lat2) * Math.Pow(Math.Sin(dLng / 2), 2);
            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            double R = 6371;
            double result = R * c;
            return result;
        }

        //private bool IsCentralized(List<Earthquake> list, Earthquake center)
        //{
        //    int insideCircleCount = 0;

        //    foreach (var eq in list)
        //    {
        //        double dist = GetDistance(eq, center);
        //        if (dist <= center.Magnitude)
        //        {
        //            insideCircleCount++;
        //        }
        //    }

        //    if ((1.0 * insideCircleCount) / (1.0 * list.Count) > 0.6)
        //    {
        //        return true;
        //    }
        //    return false;

        //    //int count = 0;
        //    //foreach (var eq in list)
        //    //{
        //    //    double difLat = Math.Abs((double)(eq.Latitude - center.Latitude));
        //    //    double difLng = Math.Abs((double)(eq.Longitude - center.Longitude));
        //    //    double distLat = 111;
        //    //    double distLng = GetDistancePerLongitude(eq.Latitude);
        //    //    double distance = Math.Sqrt(Math.Pow(difLat * distLat, 2) + Math.Pow(difLng * distLng, 2));
        //    //    if (distance <= center.Magnitude)
        //    //        count++;
        //    //}

        //    //if (count > (0.6) * list.Count)
        //    //    return true;
        //    //else
        //    //    return false;
        //}

        private double GetDistance(TestObject eq1, TestObject eq2)
        {
            double difLat = Math.Abs((double)(eq1.Latitude - eq2.Latitude));
            double difLng = Math.Abs((double)(eq1.Longitude - eq2.Longitude));
            double distLat = 111;
            double distLng = GetDistancePerLongitude(eq1.Latitude);
            double distance = Math.Sqrt(Math.Pow(difLat * distLat, 2) + Math.Pow(difLng * distLng, 2));
            return distance;
        }
    }
}