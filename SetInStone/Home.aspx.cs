using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity;
using System.Windows.Forms;

namespace SetInStone
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        
        public Product prt = new Product();
 
       // private SetInStoneEntities4  db = new SetInStoneEntities4();
        private SetStone db = new SetStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        private void Page_PreInit(object sender, System.EventArgs e)
        {
            if ((Session["loginDetails"] == null))
            {
                Response.Redirect("Login.aspx");
            }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {
       
            if (!Page.IsPostBack)
            {
                //if ((Session["EditMode"] != null) && true)
                //{
                //    if ((Session["quote"] != null))
                //    {
                //        Quote q = (Quote)Session["quote"];
                        
                //    }
                //}
                //else
                //{
                    //ddlStoneType.Attributes.Add("onchange", "stoneTexture();");

                    //Populate menus on page load
                    PopulateStoneMenu();

                    //PopulateProductMenu();


                    //Forces the user to select a stone type
                    if (ddlStoneType.SelectedIndex == 0)
                    {
                        //btnCalculate.Enabled = false;
                        btnCalculate.ToolTip = "Please choose a Product & Stone Type";
                    }
                //}
                
            }

        }
        

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
           
                float slabSurfaceCost = CustomerSlabDetails();
                float pyrSurfaceArea = PyramidSurface();
                float cutCost = CalculateStraightCuts();

                //float custSlabHeight = DetermineSlab();
                //float slabcost = DetermineLStoneSlabCost();

                ////Display final cost of stone work
                lblCalculateAnswer.Text = (pyrSurfaceArea + slabSurfaceCost + cutCost).ToString("0.##");//"c2"
                //lblCalculateAnswer.Text = cutCost.ToString(); //"c2"

                
            
        }

        private float PyramidSurface()
        {
            //Measurements entered by the user through the slider control
            int sType = Convert.ToInt32( ddlStoneType.SelectedValue);
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float pyramidHeight = float.Parse(PryHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            var surface = CalcClasses.Cost.PyramidCutCost(sType, slabWidth, slabHeight, pyramidHeight, slabLength);
            return surface;
        }

        private float CustomerSlabDetails()
        {
            //Measurements entered by the user through the slider control
            int sType = Convert.ToInt32(ddlStoneType.SelectedValue);
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            //float pyramidHeight = float.Parse(PryHeight.Value);
            
            float slabLength = float.Parse(SlabLength.Value);

           var price = CalcClasses.Cost.CalcCost(sType, slabWidth, slabHeight, slabLength);
            return price;
        }

        private float CalculateStraightCuts()
        {
            int sType = Convert.ToInt32(ddlStoneType.SelectedValue);
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            var cutCost = CalcClasses.Cost.CalcStraightCuts(sType, slabWidth, slabHeight, slabLength);
            return cutCost;
        }
        

        private void PopulateStoneMenu()
        {
            var stone = from s in db.Stones select new { s.StoneType};
            var stonee = db.Stones.ToList();
            ddlStoneType.DataSource = stonee;//.ToList();
            ddlStoneType.DataValueField = "StoneId";
            ddlStoneType.DataTextField = "StoneType";
            ddlStoneType.DataBind();
            ddlStoneType.Items.Insert(0, "Select Stone Type");
        }
       
        //private  void PopulateProductMenu()
        //{
        //    var p = from pdt in db.ProductOptions select new {pdt};
        //    var pp = db.ProductOptions;
        //    ddlProductType.DataSource = pp.ToList();
        //    ddlProductType.DataValueField = "ProductOptionID";
        //    ddlProductType.DataTextField = "ProductOption1";
        //    ddlProductType.DataBind();
        //    ddlProductType.Items.Insert(0, "Select Product");

        //}

        protected void ddlStoneType_SelectedIndexChanged(object sender, EventArgs e)
        {
            btnCalculate.Enabled = true;
            btnCalculate.ToolTip = "Calculate";

            if (ddlStoneType.SelectedIndex == 1)
            {
                //stoneTextureHF.Value = "Textures/Granite.jpg";
                //lblCalculateAnswer.Text = "hello";
            }
        }

        protected void btnSaveConfirm_Click(object sender, EventArgs e)
        {
            if(Page.IsValid)
            {
                if ((Session["EditMode"] != null) && true)
                {
                    if ((Session["quote"] != null))
                    {
                        Quote q = (Quote)Session["quote"];
                        q.Product.Width = float.Parse(SlabWidth.Value);
                        q.Product.StoneId = Convert.ToInt32(ddlStoneType.SelectedValue);

                        q.Product.Height = float.Parse(SlabHeight.Value);
                        q.Product.Length = float.Parse(SlabLength.Value);
                        q.Product.PyrHeight = float.Parse(PryHeight.Value);
                        db.SaveChanges();
                    }
                }
                else
                {
                    //prt.ProductOptionID = Convert.ToInt32(ddlProductType.SelectedValue);
                    prt.Width = float.Parse(SlabWidth.Value);
                    prt.StoneId = Convert.ToInt32(ddlStoneType.SelectedValue);

                    prt.Height = float.Parse(SlabHeight.Value);
                    prt.Length = float.Parse(SlabLength.Value);
                    prt.PyrHeight = float.Parse(PryHeight.Value);
                    Session.Add("quote", lblCalculateAnswer.Text);
                    Session.Add("product", prt);

                    //Response.Write("<script language=javascript>child=window.open('Quote.aspx');</script>");
                    Response.Redirect("Quote.aspx");
                }
                
            }
        }

    }
}