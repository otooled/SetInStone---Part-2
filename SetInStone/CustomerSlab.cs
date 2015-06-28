using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SetInStone
{
    public class CustomerSlab
    {
        public float sHeight { get; set; }
        public float sWidth { get; set; }
        public float sLength { get; set; }
        public float pyrHeight { get; set; }
        public string stoneType { get; set; }
        

        //Default constructor
        public CustomerSlab()
        {}

        //Overload constructor
        public CustomerSlab(float slHeight, float pHeight, float slWidth, float slLength, string stnTyp)
        {
            sHeight = slHeight;
            pyrHeight = pHeight;
            sWidth = slWidth;
            sLength = slLength;
            stoneType = stnTyp;
           

        }
        public float CalcSurfaceArea()
        {
            return sWidth*sLength;
        }

        public float CalcTotalSlabHeight()
        {
            return sHeight + pyrHeight;
        }
        public  float CalcSlabSideArea()
        {
            float slabLengthSideArea = (sHeight*sLength)*2;
            float slabWidthhSideArea = (sHeight*sWidth)*2;
            float slabSideAreaTotal = slabLengthSideArea + slabWidthhSideArea;
            return slabSideAreaTotal;
        }
    }


}