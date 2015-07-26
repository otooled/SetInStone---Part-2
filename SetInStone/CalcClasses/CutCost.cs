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

           surfaceArea = slLength/1000*slWidth/1000;
           sideArea = (slLength/1000*slWidth/1000)*2;
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

            var volume = slHeight / 1000 * slWidth / 1000 * slLength / 1000;

            Stone stoneCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();
            cost = volume*(float)stoneCost.CostPerCube;

            return cost;
        }
        //calculate base fireplace stone cost
        public static float FirplaceCalcCost(int sType, float bWidth, float blHeight, float fDepth, float tHeight, float tWidth)
        {
            float bCost = 0;
            float tCost = 0;
            float total = 0;

            var baseVolume = (bWidth / 1000 * blHeight / 1000 * fDepth / 1000) * 2;
            var topVolume = tHeight / 1000 * tWidth / 1000 * fDepth / 1000;

            Stone stoneCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();
            bCost = baseVolume * (float)stoneCost.CostPerCube;
            tCost = topVolume * (float)stoneCost.CostPerCube;
            total = bCost + tCost;

            return total;
        }

        public static float baseFireplaceStraightCuts(int sType, float bWidth, float bHeight, float bDepth)
        {
            float totalCutArea = 0;
          
            float smallSideArea = 0;
            float largeSideArea = 0;
            float totalSurfaceArea = 0;

            smallSideArea = ((bWidth / 1000) * (bDepth / 1000)) * 4;
            largeSideArea = ((bHeight / 1000) * (bDepth / 1000)) * 4;
            totalSurfaceArea = smallSideArea + largeSideArea;


            List<Slab> slabs = db.Slabs.ToList();

            var heightOk = slabs.Where(a => a.Thickness > bHeight);
            var pickSlab = heightOk.OrderBy(a => a.Thickness).Take(1);
            var slabCutCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();

            totalCutArea = totalSurfaceArea * (float)slabCutCost.CutCost;
            return totalCutArea;

            //if (slHeight != float(pickSlab))
            //{
            //    totalCutArea = surfaceArea * (float)slabCutCost.CutCost;
            //    return totalCutArea;
            //}

        }

        public static float topFireplaceStraightCuts(int sType, float tWidth, float tHeight, float tDepth)
        {
            float totalCutArea = 0;

            float smallSideArea = 0;
            float largeSideArea = 0;
            float totalSurfaceArea = 0;

            smallSideArea = (tWidth /1000)*( tDepth /1000)* 2;
            largeSideArea = (tHeight /1000) * (tDepth/1000) * 2;
            totalSurfaceArea  = smallSideArea + largeSideArea;


            List<Slab> slabs = db.Slabs.ToList();

            var heightOk = slabs.Where(a => a.Thickness > tHeight);
            var pickSlab = heightOk.OrderBy(a => a.Thickness).Take(1);
            var slabCutCost = db.Stones.Where(a => a.StoneId == sType).FirstOrDefault();

            totalCutArea = totalSurfaceArea * (float)slabCutCost.CutCost;
            return totalCutArea;

            //if (slHeight != float(pickSlab))
            //{
            //    totalCutArea = surfaceArea * (float)slabCutCost.CutCost;
            //    return totalCutArea;
            //}

        }

        //calculate pyramid cost
        ////Pyramid surface area - formula A = lw+l.√(w2/2)²+h²+w.√(l/2)²+h²
        //decimal surfaceAreaOfPyramid = fPart1*sqrtOfPart2*sqrtOfPart3;
        public static float PyramidCutCost(int sType, float slWidth, float slHeight, float pyrHeight, float slLength)
        {
            float totalPyramidCost = 0;

            float baseArea = slLength / 1000 * slWidth / 1000;
            ////step one of formula (L)(W)+(L)
            float fPart1 = baseArea + slLength / 1000;

            //step two of formula (w/2)²+h²+w - not getting the square root yet
            float fPart2 = (slWidth / 2000) * (slWidth / 2000) + (pyrHeight / 1000 * pyrHeight / 1000) + slWidth / 1000;

            //step three of formula (l/2)²+h² - not getting the square root yet

            float fPart3 = (slLength / 2000) * (slLength / 2000) + (pyrHeight / 1000 * pyrHeight / 1000);

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