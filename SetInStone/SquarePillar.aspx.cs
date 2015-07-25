using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class SquarePillar : System.Web.UI.Page
    {
        private int sType = 0;
        //product option for session
        public Product prt = new Product();

        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //Check user is logged in
        private void Page_PreInit(object sender, System.EventArgs e)
        {
            //if ((Session["loginDetails"] == null))
            //{
            //    Response.Redirect("Login.aspx");
            //}
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                //The following commented out code will be used
                //editing a quote

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
                //}
                //Populate stone menu

                // PopulateStoneMenu();
            }

        }


        protected void btnCalculate_Click(object sender, EventArgs e)
        {

            //variables to hold cost and cutting calculation results
            float quantity = float.Parse(txtQuantity.Text);
            float slabSurfaceCost = CustomerSlabDetails();
            float pyrSurfaceArea = PyramidSurface();
            float cutCost = CalculateStraightCuts();

            float totalCap = (pyrSurfaceArea + slabSurfaceCost + cutCost);
            float totalPillar = CostOfSquarePillar();
            HF_CapTotal.Value = totalCap.ToString();
            HF_PillarTotal.Value = totalPillar.ToString();

            //Display final cost of stone work
            lblCalculateAnswer.Text = ((totalCap + totalPillar) * quantity).ToString("#.##");

        }

        private float PyramidSurface()
        {
            //Measurements entered by the user through the slider control
            //int sType = Convert.ToInt32( ddlStoneType.SelectedValue);

            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float pyramidHeight = float.Parse(PryHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var surface = CalcClasses.Cost.PyramidCutCost(CheckCapStoneSelection(), slabWidth, slabHeight, pyramidHeight, slabLength);
            return surface;
        }

        private float CostOfSquarePillar()
        {
            float pillarHeight = float.Parse(HF_PillarHeight.Value);
            float pillarWidth = float.Parse(HF_PillarWidth.Value);
            float pillarLength = float.Parse(HF_PillarLength.Value);

            int stoneId = CheckPillarStoneSelection();
            Stone stone = db.Stones.Where(a => a.StoneId == stoneId).FirstOrDefault();
            float cubedPrice = (float)stone.CostPerCube; 

            return pillarHeight*pillarWidth*pillarLength * cubedPrice;


        }

        //Check what stone type is selected for cap
        private int CheckCapStoneSelection()
        {
            return Convert.ToInt32(HF_CapStoneType.Value);
        }

        //Check pillar stone selection
        private int CheckPillarStoneSelection()
        {
         int x = Convert.ToInt32(HF_PillarStone.Value);
            return x;
        }

        private float CustomerSlabDetails()
        {
            //Measurements entered by the user through the slider control
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);
            CheckCapStoneSelection();

            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var price = CalcClasses.Cost.CalcCost(CheckCapStoneSelection(), slabWidth, slabHeight, slabLength);
            return price;
        }

        private float CalculateStraightCuts()
        {
            //Measurements entered by the user through the slider control
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);

            CheckCapStoneSelection();


            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.CalcStraightCuts(CheckCapStoneSelection(), slabWidth, slabHeight, slabLength);
            return cutCost;
        }

        //Save user inputs
        protected void btnSaveConfirm_Click(object sender, EventArgs e)
        {
            //generate a random alphanumeric string for Quote Reference
            string qRef = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
            Quote qte;
            //This is for editing a quote which is implemented yet
            if (Page.IsValid)
            {
                if ((Session["EditMode"] != null) && true)
                {
                    if ((Session["quote"] != null))
                    {
                        //Quote q = (Quote)Session["quote"];
                        //q.Product.Width = float.Parse(SlabWidth.Value);
                        ////q.Product.StoneId = Convert.ToInt32(ddlStoneType.SelectedValue);
                        //q.Product.StoneId = sType;
                        //q.Product.Height = float.Parse(SlabHeight.Value);
                        //q.Product.Length = float.Parse(SlabLength.Value);
                        //q.Product.PyrHeight = float.Parse(PryHeight.Value);
                        //db.SaveChanges();
                    }
                }

                    //This adds product deminsions into session
                //This adds product deminsions into session
                else // not edit mode
                {
                    if ((Session["quote"] != null))
                    {
                        qte = (Quote)Session["quote"];
                        if (qte != null)
                        {
                            qte.Quote_Details.Add(new Quote_Details()
                            {
                                Cap_Height = float.Parse(SlabHeight.Value),
                                Cap_Width = float.Parse(SlabWidth.Value),
                                Cap_Length = float.Parse(SlabLength.Value),
                                Cap_Point = float.Parse(PryHeight.Value),
                                Stone_ID = Convert.ToInt32(HF_CapStoneType.Value),
                                Product_Option_ID = 1,
                                Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                Quantity = Convert.ToInt16(txtQuantity.Text)
                            });
                            qte.Quote_Details.Add(new Quote_Details()
                            {
                                Pillar_Height = float.Parse(HF_PillarHeight.Value),
                                Pillar_Width = float.Parse(HF_PillarWidth.Value),
                                Pillar_Length = float.Parse(HF_PillarLength.Value),
                                Stone_ID = Convert.ToInt32(HF_PillarStone.Value),
                                Product_Option_ID = 2,
                                Item_Price = Convert.ToDecimal(HF_PillarTotal.Value),
                                Quantity = Convert.ToInt16(txtQuantity.Text)
                            });

                            Session["quote"] = qte;


                            Response.Redirect("Quote.aspx");
                        }
                    }
                    else
                    {
                        qte = new Quote() { Quote_Ref = qRef };

                        qte.Quote_Details.Add(new Quote_Details()
                        {
                            Cap_Height = float.Parse(SlabHeight.Value),
                            Cap_Width = float.Parse(SlabWidth.Value),
                            Cap_Length = float.Parse(SlabLength.Value),
                            Cap_Point = float.Parse(PryHeight.Value),
                            Stone_ID = Convert.ToInt32(HF_CapStoneType.Value),
                            Product_Option_ID = 1,
                            Item_Price = Convert.ToDecimal(HF_CapTotal.Value),
                            Quantity = Convert.ToInt16(txtQuantity.Text)
                        });
                        qte.Quote_Details.Add(new Quote_Details()
                        {
                            Pillar_Height = float.Parse(HF_PillarHeight.Value),
                            Pillar_Width = float.Parse(HF_PillarWidth.Value),
                            Pillar_Length = float.Parse(HF_PillarLength.Value),
                            Stone_ID = Convert.ToInt32(HF_PillarStone.Value),
                            Product_Option_ID = 2,
                            Item_Price = Convert.ToDecimal(HF_PillarTotal.Value),
                            Quantity = Convert.ToInt16(txtQuantity.Text)
                        });
                        Session.Add("quote", qte);


                        Response.Redirect("Quote.aspx");
                    }
                }

            }
        }
        


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnContinueOrder_Click(object sender, EventArgs e)
        {
            Quote qte;
            if ((Session["quote"] != null))
            {
                qte = (Quote)Session["quote"];
                if (qte != null)
                {
                    qte.Quote_Details.Add(new Quote_Details()
                    {
                        Cap_Height = float.Parse(SlabHeight.Value),
                        Cap_Width = float.Parse(SlabWidth.Value),
                        Cap_Length = float.Parse(SlabLength.Value),
                        Cap_Point = float.Parse(PryHeight.Value),
                        Stone_ID = Convert.ToInt32(HF_CapStoneType.Value),
                        Product_Option_ID = 1,
                        Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                        Quantity = Convert.ToInt16(txtQuantity.Text)
                    });
                    qte.Quote_Details.Add(new Quote_Details()
                    {
                        Pillar_Height = float.Parse(HF_PillarHeight.Value),
                        Pillar_Width = float.Parse(HF_PillarWidth.Value),
                        Pillar_Length = float.Parse(HF_PillarLength.Value),
                        Stone_ID = Convert.ToInt32(HF_PillarStone.Value),
                        Product_Option_ID = 2,
                        Item_Price = Convert.ToDecimal(HF_PillarTotal.Value),
                        Quantity = Convert.ToInt16(txtQuantity.Text)
                    });

                    Session["quote"] = qte;
                }
            }
            else
            {
                string qRef = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
                qte = new Quote() { Quote_Ref = qRef };

                qte.Quote_Details.Add(new Quote_Details()
                {
                    Cap_Height = float.Parse(SlabHeight.Value),
                    Cap_Width = float.Parse(SlabWidth.Value),
                    Cap_Length = float.Parse(SlabLength.Value),
                    Cap_Point = float.Parse(PryHeight.Value),
                    Stone_ID = Convert.ToInt32(HF_CapStoneType.Value),
                    Product_Option_ID = 1,
                    Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                    Quantity = Convert.ToInt16(txtQuantity.Text)
                });
                qte.Quote_Details.Add(new Quote_Details()
                {
                    Pillar_Height = float.Parse(HF_PillarHeight.Value),
                    Pillar_Width = float.Parse(HF_PillarWidth.Value),
                    Pillar_Length = float.Parse(HF_PillarLength.Value),
                    Stone_ID = Convert.ToInt32(HF_PillarStone.Value),
                    Product_Option_ID = 2,
                    Item_Price = Convert.ToDecimal(HF_PillarTotal.Value),
                    Quantity = Convert.ToInt16(txtQuantity.Text)
                });

                Session.Add("quote", qte);


            }
            Response.Redirect("LandingPage.aspx");
        }


    }
}