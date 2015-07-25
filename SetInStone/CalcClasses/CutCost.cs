using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SetInStone.CalcClasses
{
    public static class Cost
    {
        //database connection
        private static SetInStone db = new SetInStone();
        static void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //calculate straight cuts
       public static float CalcStraightCuts(int sType, float slWidth, float slHeight, float slLength)
       {
           float totalCutArea = 0;
           float surfaceArea = 0;
           float sideArea = 0;
           float totalSlabHeight = 0;

           surfaceArea = slLength*slWidth;
           sideArea = (slLength*slWidth)*2;
           totalCutArea = surfaceArea + sideArea;


           List<Slab> slabs = db.Slabs.ToList();

           var heightOk = slabs.Where(a => a.Thickness > slHeight);
           var pickSlab = heightOk.OrderBy(a => a.Thickness).Take(1);
           var slabCutCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();

           totalCutArea = surfaceArea*(float) slabCutCost.CutCost;
           return totalCutArea;

           //if (slHeight != float(pickSlab))
           //{
           //    totalCutArea = surfaceArea * (float)slabCutCost.CutCost;
           //    return totalCutArea;
           //}

       }
        //calculate stone cost
        public static float CalcCost(int sType, float slWidth, float slHeight, float slLength)
        {
            float cost = 0;

            var volume = slHeight*slWidth*slLength;

            Stone stoneCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();
            cost = volume*(float)stoneCost.CostPerCube;

            return cost;
        }

        //calculate pyramid cost
        ////Pyramid surface area - formula A = lw+l.√(w2/2)²+h²+w.√(l/2)²+h²
        //decimal surfaceAreaOfPyramid = fPart1*sqrtOfPart2*sqrtOfPart3;
        public static float PyramidCutCost(int sType, float slWidth, float slHeight, float pyrHeight, float slLength)
        {
            float totalPyramidCost = 0;

            float baseArea = slLength*slWidth;
            ////step one of formula (L)(W)+(L)
            float fPart1 = baseArea + slLength;

            //step two of formula (w/2)²+h²+w - not getting the square root yet
            float fPart2 = (slWidth/2)*(slWidth/2) + (pyrHeight*pyrHeight) + slWidth;

            //step three of formula (l/2)²+h² - not getting the square root yet

            float fPart3 = (slLength/2)*(slLength/2) + (pyrHeight*pyrHeight);

            //step four of formula - get square root of part 2 and part 3

            float sqrtOfPart2 = (float) Math.Sqrt(Convert.ToDouble(fPart2));
            float sqrtOfPart3 = (float) Math.Sqrt(Convert.ToDouble(fPart3));
            var surfaceArea = fPart1 * sqrtOfPart2 * sqrtOfPart3;


            Stone pyramidCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();
            totalPyramidCost = surfaceArea*(float) pyramidCost.CutCost;
            return totalPyramidCost;
        }
    }
}