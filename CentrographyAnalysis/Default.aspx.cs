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
using CentrographyAnalysis.Helpers;
using CentrographyAnalysis.Models;
using CentrographyAnalysis.Models.HistogramModels;
using CentrographyAnalysis.Models.PlateBoundaryModels;
using MathNet.Numerics;
using MathNet.Numerics.LinearRegression;

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
        public List<Earthquake> GetEarthquakes(string dateStart, string dateEnd, string mag, string maxMag, string minLat, string maxLat, string minLng, string maxLng, string minDepth, string maxDepth)
        {
            string baseURL = "http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&orderby=time";
            //string parameters =
            //    "&starttime=2016-01-01&minmagnitude=3&minlatitude=35&maxlatitude=45&minlongitude=25&maxlongitude=46";
            string parameters = "&starttime=" + dateStart + "&endtime=" + dateEnd + "&minmagnitude=" + mag 
                                + "&maxmagnitude=" + maxMag + "&mindepth=" + minDepth + "&maxdepth=" + maxDepth
                                + "&minlatitude=" + minLat + "&maxlatitude=" + maxLat
                                + "&minlongitude=" + minLng + "&maxlongitude=" + maxLng;
            var syncClient = new WebClient();
            var content = syncClient.DownloadString(baseURL + parameters);
            EarthquakeData data;
            content = content.Replace("\"mag\":null", "\"mag\":0.01");
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
        public List<Earthquake> GetEarthquakesOffline(string dateStart, string dateEnd, string mag, string maxMag, string minLat,
            string maxLat, string minLng, string maxLng, string minDepth, string maxDepth)
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
        public List<Earthquake> CentraliseRecursive(List<Earthquake> list, bool isMahalanobis)
        {
            List<Earthquake> result = new List<Earthquake>();

            List<Earthquake> excludedEarthquakes = new List<Earthquake>();
            bool isWeighted = true;

            int occurTime = 0;
            double distanceRange = GetMaximumDistance(list);
            double loopCoef = GetIterationCoefByMaxDistance(distanceRange);
            while (excludedEarthquakes.Count() < list.Count * loopCoef)
            {
                occurTime++;
                List<Earthquake> remainingEarthquakes = list.Where(t => !excludedEarthquakes.Contains(t)).ToList();

                Earthquake centreEarthquake = CalculateCentralEarthquake(remainingEarthquakes, occurTime, isWeighted, isMahalanobis);
                centreEarthquake.Depth = remainingEarthquakes.Count;
                centreEarthquake.EventDate = DateTime.Today;
                
                if (centreEarthquake.Magnitude <= (GetDistanceCoefficientByMaxDistance(distanceRange, isToVerify: true) * distanceRange))
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



        private Earthquake CalculateCentralEarthquake(List<Earthquake> list, int occurTime, bool isWeighted, bool isMahalanobis)
        {
            int loopMax;
            if (occurTime == 1)
                loopMax = (int)(list.Count * 0.6);
            else
                loopMax = (int)(list.Count * 0.7);

            double distanceRange = GetMaximumDistance(list);
            double distCoef = GetDistanceCoefficientByMaxDistance(distanceRange, isToVerify: false);

            for (int i = 0; i < loopMax; i++)
            {
                Earthquake avgEarthquakeCurrent;
                if(isWeighted)
                    avgEarthquakeCurrent = GetWeightedAverageEarthquakePoint(list);
                else
                    avgEarthquakeCurrent = GetAverageEarthquakePoint(list);

                Earthquake furthestEarthquake;
                if (isMahalanobis)
                {
                    furthestEarthquake = GetFurthestByMahalanobis(list);
                }
                else
                {
                    furthestEarthquake = GetFurthestEarthquake(list, avgEarthquakeCurrent);
                }


                double distanceFurthest = GetDistance(furthestEarthquake, avgEarthquakeCurrent);
                if (distanceFurthest <= ( distCoef * distanceRange))
                    break;

                list.Remove(furthestEarthquake);
            }

            Earthquake finalAverageEarthquake;
            
            
            Earthquake finalFurthestEarthquake;
            if (isMahalanobis)
            {
                finalAverageEarthquake = GetAverageEarthquakePoint(list);
                finalFurthestEarthquake = GetFurthestByMahalanobis(list);
            }
            else
            {
                finalAverageEarthquake = isWeighted ? GetWeightedAverageEarthquakePoint(list) : GetAverageEarthquakePoint(list);
                finalFurthestEarthquake = GetFurthestEarthquake(list, finalAverageEarthquake);
            }

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

        private Earthquake GetWeightedAverageEarthquakePoint(List<Earthquake> list)
        {
            decimal latSum = 0;
            decimal lngSum = 0;
            double magnitudeSum = 0;
            for (int i = 0; i < list.Count; i++)
            {
                latSum += list[i].Latitude * (decimal)list[i].Magnitude;
                lngSum += list[i].Longitude * (decimal)list[i].Magnitude;
                magnitudeSum += list[i].Magnitude;
            }

            Earthquake result = new Earthquake();
            result.Latitude = latSum / (decimal)magnitudeSum;
            result.Longitude = lngSum / (decimal)magnitudeSum;
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

        private double GetDistanceCoefficientByMaxDistance(double maxDistance, bool isToVerify)
        {
            double result = 0.02;
            if (maxDistance < 3000)
            {
                result = 0.12;
            }
            else if (maxDistance < 6000)
            {
                result = 0.06;
            }
            else if (maxDistance < 12000)
            {
                if (isToVerify)
                    result = 0.05;
                else
                    result = 0.04;
            }
            else if (maxDistance < 20000)
            {
                if (isToVerify)
                    result = 0.04;
                else
                    result = 0.03;
            }
            else
            {
                if (isToVerify)
                    result = 0.03;
                else
                    result = 0.02;
            }

            return result;
        }

        private double GetIterationCoefByMaxDistance(double maxDistance)
        {
            double result = 0.7;

            if (maxDistance < 10000)
            {
                result = 0.65;
            }
            else
            {
                result = 0.78;
            }

            return result;
        }

        [AjaxMethod]
        public List<int> GetEarthquakeHistogram()
        {
            List<int> result = new List<int>();
            result.Add(24);
            result.Add(12);
            result.Add(15);
            result.Add(7);
            result.Add(3);

            return result;
        }

        [AjaxMethod]
        public EarthquakeHistogram GetHistogram(Earthquake centralPoint, List<Earthquake> eqList)
        {
            EarthquakeHistogram result = new EarthquakeHistogram();
            double histRange = GetMaximumDistance(eqList);
            double histStep = histRange / 10;
            //result.Labels.Add("0");

            for (int i = 0; i < 10; i++)
            {
                double distanceRangeMin = (histStep * i);
                double distanceRangeMax = (histStep * (i + 1));
                int amount = eqList.Count(t => GetDistance(t, centralPoint) >= distanceRangeMin && GetDistance(t, centralPoint) < distanceRangeMax);
                result.HistogramData.Add(amount);
                result.Labels.Add(((int)distanceRangeMin).ToString() + " - " + ((int)distanceRangeMax).ToString());
            }

            return result;
        }

        [AjaxMethod]
        public List<ScatterModel> GetScatterData(Earthquake centralPoint, List<Earthquake> eqList)
        {
            List<ScatterModel> result = new List<ScatterModel>();
            foreach (Earthquake eq in eqList)
            {
                ScatterModel scatter = new ScatterModel();
                scatter.x = (double)(eq.Latitude - centralPoint.Latitude);
                if (scatter.x > 90)
                    scatter.x -= 90;
                else if (scatter.x < -90)
                    scatter.x += 90;

                scatter.y = (double) (eq.Longitude - centralPoint.Longitude);

                if (scatter.y > 180)
                {
                    scatter.y -= 180;
                }
                else if (scatter.y < -180)
                {
                    scatter.y += 180;
                }

                result.Add(scatter);
            }

            return result;
        }

        [AjaxMethod]
        public List<BubbleModel> GetBubbleData(Earthquake centralPoint, List<Earthquake> eqList)
        {
            List<BubbleModel> result = new List<BubbleModel>();
            //FitPolynomial(eqList, 3);
            foreach (Earthquake eq in eqList)
            {
                BubbleModel bubble = new BubbleModel();
                bubble.x = (double)(eq.Latitude - centralPoint.Latitude);
                if (bubble.x > 90)
                    bubble.x -= 90;
                else if (bubble.x < -90)
                    bubble.x += 90;

                bubble.y = (double)(eq.Longitude - centralPoint.Longitude);

                if (bubble.y > 180)
                {
                    bubble.y -= 180;
                }
                else if (bubble.y < -180)
                {
                    bubble.y += 180;
                }

                bubble.r = GetBubbleRadius(eq.Magnitude);
                result.Add(bubble);
            }

            return result;
        }

        private int GetBubbleRadius(double magnitude)
        {
            return 5; //((int) magnitude)*3;
        }

        [AjaxMethod]
        public List<Earthquake> GetCurveData(List<Earthquake> eqList, int region)
        {
            int order = 5;

            int regionAmerica = 1;
            int regionAsia = 2;
            //double[] coef = Fit.Polynomial(eqList.Where(t=> t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125).Select(t => (double) t.Latitude).ToArray(), eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125).Select(t => (double) t.Longitude).ToArray(), order);
            double[] coef;

            if(region == regionAmerica)
                coef = Fit.Polynomial(eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125).Select(t => (double)t.Latitude).ToArray(), eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125).Select(t => (double)t.Longitude).ToArray(), order);
            else
                coef = Fit.Polynomial(eqList.Where(t => t.Latitude < 55 && t.Latitude > -55 && t.Longitude < 170 && t.Longitude > 75).Select(t => (double)t.Latitude).ToArray(), eqList.Where(t => t.Latitude < 55 && t.Latitude > -55 && t.Longitude < 170 && t.Longitude > 75).Select(t => (double)t.Longitude).ToArray(), order);

            //Tuple<double, double> coefExpo = Fit.Exponential(
            //    eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125)
            //        .Select(t => (double) t.Latitude)
            //        .ToArray(),
            //    eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < -70 && t.Longitude > -125)
            //        .Select(t => (double) t.Longitude)
            //        .ToArray(), DirectRegressionMethod.QR);





            List<Earthquake> result = new List<Earthquake>();

            double minLat;
            if (region == regionAmerica)
                minLat =
                    (double) eqList.Where(t => t.Latitude < 70 && t.Latitude > -70 && t.Longitude < -70 && t.Longitude > -125).Min(t => t.Latitude);
            else
                minLat = (double) eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < 180 && t.Longitude > 85).Min(t => t.Latitude);


            double maxLat;
            if(region == regionAmerica)
                maxLat = (double) eqList.Where(t => t.Latitude < 70 && t.Latitude > -70 && t.Longitude < -70 && t.Longitude > -125).Max(t => t.Latitude);
            else
                maxLat = (double) eqList.Where(t => t.Latitude < 50 && t.Latitude > -50 && t.Longitude < 180 && t.Longitude > 85).Max(t => t.Latitude);

            while (minLat < maxLat)
            {
                double lon = 0;
                for (int i = 0; i <= order; i++)
                {
                    lon += Math.Pow(minLat, i)*coef[i]; // + Math.Pow(minLat, 2)*coef[2] + minLat*coef[1] + coef[0];
                }
                Earthquake eq = new Earthquake();
                eq.EventDate = DateTime.Now;
                eq.Latitude = (decimal)minLat;
                eq.Longitude = (decimal)lon;
                result.Add(eq);
                minLat += 0.1;
            }

            return result;
        }

        [AjaxMethod]
        public List<PlateBoundary> BindPlateBoundaries()
        {
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(PlateBoundaryData));
            string dir = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            using (StreamReader reader = new StreamReader(AppDomain.CurrentDomain.BaseDirectory + @"/Source/plateBoundaries.json"))
            {
                string content = reader.ReadToEnd();
                using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(content)))
                {
                    var data = (PlateBoundaryData)serializer.ReadObject(ms);
                    return ConvertBoundaryDataToList(data);
                    //long milSec = Convert.ToInt64(data.features[0].properties.time.ToString());
                    //DateTime dt = new DateTime(1970, 1, 1);
                    //dt = dt.AddMilliseconds(milSec);

                    //return dt.ToString("dd.MM.yyyy HH:mm:ss");
                }
            }

            
            
        }

        public List<PlateBoundary> ConvertBoundaryDataToList(PlateBoundaryData data)
        {
            List<PlateBoundary> result = new List<PlateBoundary>();

            foreach (var feature in data.features)
            {
                PlateBoundary item = new PlateBoundary();
                foreach (List<double> geometryCoordinate in feature.geometry.coordinates)
                {
                    Coordinate coordinate = new Coordinate()
                    {
                        Latitude = geometryCoordinate[0],
                        Longitude = geometryCoordinate[1]
                    };
                    item.BoundaryList.Add(coordinate);
                }

                result.Add(item);
            }

            return result;
        }

        private Earthquake GetFurthestByMahalanobis(List<Earthquake> eqList)
        {
            List<MahalanobisEarthquake> mahEqList = new List<MahalanobisEarthquake>();

            double[,] coordinates = new double[eqList.Count, 2];

            for (int i = 0; i < eqList.Count; i++)
            {
                coordinates[i, 0] = (double) eqList[i].Latitude;
                coordinates[i, 1] = (double) eqList[i].Longitude;
            }



            double[,] distanceMatrix = MatrixHelper.GetMahalanobisMatrix(coordinates);
            int furthestIndex = GetIndexOfMaximumDistance(distanceMatrix);

            return eqList[furthestIndex];
        }

        private int GetIndexOfMaximumDistance(double[,] distMatrix)
        {
            int result = 0;

            for (int i = 1; i < Math.Sqrt(distMatrix.Length); i++)
            {
                if (distMatrix[i, i] > distMatrix[result, result])
                {
                    result = i;
                }
            }

            return result;
        }

        private Earthquake GetFurthestEarthquake2(List<Earthquake> list, Earthquake avgEarthquake)
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
    }
}