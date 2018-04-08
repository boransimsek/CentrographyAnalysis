using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CentrographyAnalysis.Models;

namespace CentrographyAnalysis.TestTools
{
    public class TestGenerator
    {
        private static readonly Random random = new Random();
        private static readonly object syncLock = new object();

        public static List<TestObject> GenerateTestObjects(int amount)
        {
            List<TestObject> result = new List<TestObject>();

            for (int i = 0; i < amount; i++)
            {
                TestObject coordinate = new TestObject();
                coordinate.Latitude = GenerateLatLong();
                coordinate.Longitude = GenerateLatLong();
                coordinate.Magnitude = GenerateMagnitude();

                result.Add(coordinate);
            }
            
            return result;
        }

        public static double GenerateLatLong()
        {
            lock (syncLock)
            {
                return 30 + random.NextDouble() * 3;
            }
        }

        public static double GenerateMagnitude()
        {
            lock (syncLock)
            {
                return 3 + random.NextDouble() * 4;
            }
        }
    }
}