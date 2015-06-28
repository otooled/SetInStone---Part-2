using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

namespace SetInStone.App_Start
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jQuery").Include(
                "~/Scripts/bootstrap.js",
                "~/Scripts/dat.gui.min.js",
                "~/Scripts/Detector.js",
                "~/Scripts/jquery-1.9.1.intellesense.js",
                "~/Scripts/jquery-1.9.1.js",
                 "~/Scripts/stats.min.js",
                 "~/Scripts/three.min.js",
                 "~/Scripts/TrackballControls.js",
                 "~/Scripts/TGALoader.js",
                 "~/Scripts/grayscale.js",
                 "~/Scripts/jquery-ui.js"
                 ));

            BundleTable.EnableOptimizations = true;
        }
    }
}