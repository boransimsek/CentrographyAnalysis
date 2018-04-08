using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxPro;
using CentrographyAnalysis.Models;

namespace CentrographyAnalysis
{
    [AjaxNamespace("CentroAjax")]
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AjaxPro.Utility.RegisterTypeForAjax(typeof(_Default));
            lblTest.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm:ss");
        }

        [AjaxMethod]
        public string GetString()
        {
            return "Hello";
        }

        [AjaxMethod]
        public string GetHtmlContent()
        {
            string urlAddress = "http://www.koeri.boun.edu.tr/scripts/lst1.asp";
            string data;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(urlAddress);
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            if (response.StatusCode == HttpStatusCode.OK)
            {
                Stream receiveStream = response.GetResponseStream();
                StreamReader readStream = null;

                if (response.CharacterSet == null)
                {
                    readStream = new StreamReader(receiveStream);
                }
                else
                {
                    readStream = new StreamReader(receiveStream, Encoding.GetEncoding(response.CharacterSet));
                }

                data = readStream.ReadToEnd();

                response.Close();
                readStream.Close();
            }
            else
            {
                data = "empty";
            }
            return data;
        }

        private void ReadJsonFromFile()
        {
            //DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(EarthquakeData));
            //using (StreamReader reader = new StreamReader("/Source/2016_2010.json"))
            //{
            //    string content = reader.ReadToEnd();
            //    serializer.ReadObject()
            //}
        }

        [AjaxMethod]
        public List<Earthquake> GetEarthquakes(string dateStart, string dateEnd, string mag, string minLat, string maxLat, string minLng, string maxLng)
        {
            string baseURL = "http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&orderby=time";
            //string parameters =
            //    "&starttime=2016-01-01&minmagnitude=3&minlatitude=35&maxlatitude=45&minlongitude=25&maxlongitude=46";
            string parameters = "&starttime=" + dateStart + "&endtime=" + dateEnd + "&minmagnitude=" + mag +
                                "&minlatitude=" + minLat + "&maxlatitude=" + maxLat
                                + "&minlongitude=" + minLng + "&maxlongitude=" + maxLng;
            var syncClient = new WebClient();
            var content = syncClient.DownloadString(baseURL + parameters);
            EarthquakeData data;

            DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(EarthquakeData));
            using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(content)))
            {
                data = (EarthquakeData)serializer.ReadObject(ms);
                return ConvertRawDataToViewModel(data);
                //long milSec = Convert.ToInt64(data.features[0].properties.time.ToString());
                //DateTime dt = new DateTime(1970, 1, 1);
                //dt = dt.AddMilliseconds(milSec);

                //return dt.ToString("dd.MM.yyyy HH:mm:ss");
            }
        }

        [AjaxMethod]
        public List<Earthquake> GetEarthquakesOffline(string dateStart, string dateEnd, string mag, string minLat,
            string maxLat, string minLng, string maxLng)
        {
            using (var context = new Context())
            {
                try
                {
                    DateTime startDate, endDate;
                    double magnitude;
                    decimal minLatitude, maxLatitude, minLongitude, maxLongitude;

                    // Start Date
                    if (String.IsNullOrEmpty(dateStart))
                    {
                        startDate = new DateTime(1970, 1, 1);
                    }
                    else
                    {
                        startDate = Convert.ToDateTime(dateStart);
                    }

                    //EndDate
                    if (String.IsNullOrEmpty(dateEnd))
                    {
                        endDate = DateTime.Now;
                    }
                    else
                    {
                        endDate = Convert.ToDateTime(dateEnd);
                    }

                    //Magnitude
                    if (String.IsNullOrEmpty(mag))
                    {
                        magnitude = 0;
                    }
                    else
                    {
                        magnitude = Convert.ToDouble(mag);
                    }

                    // minLat
                    if (String.IsNullOrEmpty(minLat))
                    {
                        minLatitude = 35;
                    }
                    else
                    {
                        minLatitude = Convert.ToDecimal(minLat);
                    }

                    // maxLat
                    if (String.IsNullOrEmpty(maxLat))
                    {
                        maxLatitude = 43;
                    }
                    else
                    {
                        maxLatitude = Convert.ToDecimal(maxLat);
                    }

                    // minLng
                    if (String.IsNullOrEmpty(minLng))
                    {
                        minLongitude = 25;
                    }
                    else
                    {
                        minLongitude = Convert.ToDecimal(minLng);
                    }

                    // maxLng
                    if (String.IsNullOrEmpty(maxLng))
                    {
                        maxLongitude = 46;
                    }
                    else
                    {
                        maxLongitude = Convert.ToDecimal(maxLng);
                    }

                    var result =
                        context.Earthquakes.Where(
                            t =>
                                t.Magnitude >= magnitude && t.Latitude >= minLatitude && t.Latitude <= maxLatitude &&
                                t.Longitude <= maxLongitude && t.Longitude >= minLongitude && t.EventDate <= endDate &&
                                t.EventDate >= startDate).ToList();
                    return result;
                }
                catch (Exception exc)
                {
                    Earthquake e = new Earthquake();
                    e.Latitude = 30;
                    e.Longitude = 30;
                    e.Magnitude = 7;
                    e.Title = exc.InnerException != null ? exc.InnerException.Message : exc.Message;
                    var res = new List<Earthquake>();
                    res.Add(e);
                    return res;
                }
            }
        }

        [AjaxMethod]
        public List<Earthquake> GetEarthquakesOfflineAll()
        {
            using (var context = new Context())
            {
                try
                {
                    return context.Earthquakes.OrderBy(t => t.Latitude).ThenBy(t => t.Longitude).ToList();
                }
                catch (Exception exc)
                {

                    return new List<Earthquake>();
                }

            }
        }

        private List<Earthquake> ConvertRawDataToViewModel(EarthquakeData data)
        {
            List<Earthquake> result = new List<Earthquake>();

            foreach (var feature in data.features)
            {
                DateTime dt = new DateTime(1970, 1, 1);
                Earthquake item = new Earthquake();
                item.AlertType = feature.properties.alert;
                item.Depth = feature.geometry.coordinates[2];
                item.Latitude = Convert.ToDecimal(feature.geometry.coordinates[1]);
                item.Longitude = Convert.ToDecimal(feature.geometry.coordinates[0]);
                item.EventDate = dt.AddMilliseconds(Convert.ToInt64(feature.properties.time.ToString()));
                item.URL = feature.properties.url;
                item.Magnitude = feature.properties.mag;
                item.Title = feature.properties.place;
                result.Add(item);
            }

            return result;
        }

        [AjaxMethod]
        public List<Earthquake> CentralizeTest(List<Earthquake> list, string stepCount)
        {

            int step = String.IsNullOrEmpty(stepCount) ? 4 : Convert.ToInt32(stepCount);
            if (step == 0)
                step = 4;
            else if (step < 0)
                step = Math.Abs(step);
                

            int minLat = (int)list.Min(t => t.Latitude) - step - 2;
            int minLng = (int)list.Min(t => t.Longitude) - step - 2;
            int maxLat = (int)list.Max(t => t.Latitude) + step + 2;
            int maxLng = (int)list.Max(t => t.Longitude) + step + 2;

            int latParts = (maxLat - minLat) / step;
            int lngParts = (maxLng - minLng) / step;


            List<Earthquake> result = new List<Earthquake>();
            for (int i = minLat; i < maxLat; i += step)
            {
                for (int j = minLng; j < maxLng; j += step)
                {
                    List<Earthquake> curList = list.Where(t => t.Latitude < (i + step) && t.Latitude >= (i) && t.Longitude < (j + step) && t.Longitude >= (j)).ToList();
                    if (curList.Count == 0 || ((1.0 * curList.Count)/list.Count) < (1.0 / (1.0 * latParts * lngParts)))
                        continue;
                    Earthquake centerEq = FindWeightedCenter(curList);
                    FindStandardDeviation(curList, centerEq);
                    centerEq.Depth = curList.Count;

                    //if(centerEq.Magnitude < 0.8)
                    //    result.Add(centerEq);
                    //if (curList.Count > step * 5 && IsCentralized(curList, centerEq))

                    if(IsCentralized(curList, centerEq))
                        result.Add(centerEq);
                    //double safeTest = (1.0 * curList.Count) / centerEq.Magnitude;
                    //if (safeTest > 0.65)
                    //    result.Add(centerEq);

                }
            }

            return result;
        }


        [AjaxMethod]
        public List<Earthquake> CentraliseRecursive(List<Earthquake> list)
        {
            List<Earthquake> result = new List<Earthquake>();

            List<Earthquake> excludedEarthquakes = new List<Earthquake>();

            int occurTime = 0;
            while (excludedEarthquakes.Count() < list.Count * 0.6)
            {
                occurTime++;
                List<Earthquake> remainingEarthquakes = list.Where(t => !excludedEarthquakes.Contains(t)).ToList();

                Earthquake centreEarthquake = CalculateCentralEarthquake(remainingEarthquakes, occurTime);
                centreEarthquake.Depth = remainingEarthquakes.Count;

                if (centreEarthquake.Magnitude <= (0.02 * GetMaximumDistance(list)))
                {
                    result.Add(centreEarthquake);
                }



                excludedEarthquakes.AddRange(remainingEarthquakes);
            }

            return result;
        }

        private double GetMaximumDistance(List<Earthquake> list)
        {
            decimal minLongitude = list.Min(t => t.Longitude);
            decimal maxLongitude = list.Max(t => t.Longitude);

            double distLng = GetDistancePerLongitude(0);
            double distance = Math.Abs((double)(maxLongitude - minLongitude)) * distLng;
            return distance;
        }

        //[AjaxMethod]
        //public List<Earthquake> CentralizeTest(List<Earthquake> list, string stepCount)
        //{

        //    //int loopMax = (int) (list.Count * Convert.ToInt32(stepCount) / 100);



        //    int step = String.IsNullOrEmpty(stepCount) ? 3 : Convert.ToInt32(stepCount);

        //    int minLat = (int)list.Min(t => t.Latitude) - step - 1;
        //    int minLng = (int)list.Min(t => t.Longitude) - step - 1;
        //    int maxLat = (int)list.Max(t => t.Latitude) + step + 1;
        //    int maxLng = (int)list.Max(t => t.Longitude) + step + 1;


        //    List<Earthquake> result = new List<Earthquake>();
        //    for (int i = minLat; i < maxLat; i += step)
        //    {
        //        for (int j = minLng; j < maxLng; j += step)
        //        {
        //            List<Earthquake> curList = list.Where(t => t.Latitude < (i + step) && t.Latitude >= (i) && t.Longitude < (j + step) && t.Longitude >= (j)).ToList();
        //            if (curList.Count == 0)
        //                continue;

        //            Earthquake centreEarthquake = CalculateCentralEarthquake(curList, 1);

        //            centreEarthquake.Depth = curList.Count;

        //            //Earthquake centerEq = FindWeightedCenter(curList);
        //            //FindStandardDeviation(curList, centerEq);
        //            //centerEq.Depth = curList.Count;

        //            //if(centerEq.Magnitude < 0.8)
        //            //    result.Add(centerEq);
        //            //if (curList.Count > step * 5 && IsCentralized(curList, centerEq))

        //            //double safeTest = (1.0 * curList.Count) / centerEq.Magnitude;
        //            //if (safeTest > 0.5)
        //            //    result.Add(centerEq);
        //            result.Add(centreEarthquake);

        //        }
        //    }

        //    return result;
        //}



        private Earthquake CalculateCentralEarthquake(List<Earthquake> list, int occurTime)
        {
            int loopMax;
            if (occurTime == 1)
                loopMax = (int)(list.Count * 0.6);
            else
                loopMax = (int)(list.Count * 0.7);

            for (int i = 0; i < loopMax; i++)
            {
                Earthquake avgEarthquakeCurrent = GetAverageEarthquakePoint(list);
                Earthquake furthestEarthquake = GetFurthestEarthquake(list, avgEarthquakeCurrent);

                list.Remove(furthestEarthquake);
            }

            Earthquake finalAverageEarthquake = GetAverageEarthquakePoint(list);
            Earthquake finalFurthestEarthquake = GetFurthestEarthquake(list, finalAverageEarthquake);

            double circleRadius = GetDistance(finalAverageEarthquake, finalFurthestEarthquake);
            finalAverageEarthquake.Magnitude = circleRadius;
            return finalAverageEarthquake;
        }

        private Earthquake GetAverageEarthquakePoint(List<Earthquake> list)
        {
            decimal latSum = 0;
            decimal lngSum = 0;
            double magnitudeSum = 0;
            for (int i = 0; i < list.Count; i++)
            {
                latSum += list[i].Latitude;
                lngSum += list[i].Longitude;
                magnitudeSum += list[i].Magnitude;
            }

            Earthquake result = new Earthquake();
            result.Latitude = latSum / list.Count;
            result.Longitude = lngSum / list.Count;
            result.Magnitude = magnitudeSum / list.Count;

            return result;
        }

        private Earthquake GetFurthestEarthquake(List<Earthquake> list, Earthquake avgEarthquake)
        {
            double distMax = 0;
            Earthquake result = list[0];

            for (int i = 0; i < list.Count; i++)
            {
                double dist = GetDistance(list[i], avgEarthquake);
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

        private void FindStandardDeviation(List<Earthquake> list, Earthquake mean)
        {
            double result = 0;
            decimal totalX = 0;
            decimal totalY = 0;
            double devX, devY;

            foreach (var eq in list)
            {
                decimal difX = eq.Latitude - mean.Latitude;
                decimal difY = eq.Longitude - mean.Longitude;
                totalX += difX * difX;
                totalY += difY * difY;
            }

            devX = Math.Sqrt((double)totalX / (1.0 * list.Count));
            devY = Math.Sqrt((double)totalY / (1.0 * list.Count));
            double distLat = 111;
            double distLng = GetDistancePerLongitude(mean.Latitude);

            result = Math.Sqrt(Math.Pow(devX * distLat, 2) + Math.Pow(devY * distLng, 2));
            mean.Magnitude = result;
            //result = Math.Sqrt(((double) (totalX + totalY))/(1.0*list.Count));
            //mean.Magnitude = result;
        }

        private double GetDistancePerLongitude(decimal latitude)
        {
            double lat1, lat2, lng1, lng2;
            lat1 = ((double)latitude) / 180.0 * Math.PI;
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

        private bool IsCentralized(List<Earthquake> list, Earthquake center)
        {
            int count = 0;
            foreach (var eq in list)
            {
                double difLat = Math.Abs((double)(eq.Latitude - center.Latitude));
                double difLng = Math.Abs((double)(eq.Longitude - center.Longitude));
                double distLat = 111;
                double distLng = GetDistancePerLongitude(eq.Latitude);
                double distance = Math.Sqrt(Math.Pow(difLat * distLat, 2) + Math.Pow(difLng * distLng, 2));
                if (distance <= center.Magnitude)
                    count++;
            }

            if (count > (0.6) * list.Count)
                return true;
            else
                return false;
        }

        private double GetDistance(Earthquake eq1, Earthquake eq2)
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