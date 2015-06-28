using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SetInStone
{
    public class Pyramid
    {
        public float pHeight { get; set; }
        public float pWidth { get; set; }
        public float pLength { get; set; }
        public string stoneType { get; set; }

         //Default constructor
        public Pyramid()
        {}

        //Overload constructor
        public Pyramid(float pyrHeight,  float pyrWidth, float pyrLength, string stnTyp)
        {

            pHeight = pyrHeight;
            pWidth = pyrWidth;
            pLength = pyrLength;
            stoneType = stnTyp;

        }
    }

}