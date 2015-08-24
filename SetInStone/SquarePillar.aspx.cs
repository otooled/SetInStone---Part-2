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
        //private int sType = 0;
        //product option for session
        //public Product prt = new Product();

        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //Check user is logged in
        private void Page_PreInit(object sender, System.EventArgs e)
        {
            if ((Session["loginDetails"] == null))
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            btnAddProducts.Enabled = false;
            if (!Page.IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    //Edit mode
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                    Quote_Details q = db.Quote_Details.Where(a => a.Quote_ID == qteID).FirstOrDefault();
                    if (qid != null && q != null)//new
                    {

                        pnlExistingQuote.Visible = true;
                        btnAddProducts.Enabled = true;
                        btnSaveConfirm.Enabled = false;
                        
                        SlabWidth.Value = q.Cap_Width.ToString();
                        lblCapWidthPanel.Text = q.Cap_Width.ToString();

                        SlabHeight.Value = q.Cap_Height.ToString();
                        lblCapHeightPanel.Text = q.Cap_Height.ToString();

                        SlabLength.Value = q.Cap_Length.ToString();
                        lblCapLengthPanel.Text = q.Cap_Length.ToString();

                        PryHeight.Value = q.Cap_Point.ToString();
                        lblCapPointPanel.Text = q.Cap_Point.ToString();

                        //Cap deminsions from quote_details table
                        HF_PillarHeight.Value = qid.Pillar_Height.ToString();
                        lblPillHeightPanel.Text = qid.Pillar_Height.ToString();

                        HF_PillarLength.Value = qid.Pillar_Length.ToString();
                        lblPillLengthPanel.Text = qid.Pillar_Length.ToString();

                        HF_PillarWidth.Value = qid.Pillar_Width.ToString();
                        lblPillarWidthPanel.Text = qid.Pillar_Width.ToString();

                        HF_CapStoneType.Value = q.Stone_ID.ToString();
                        HF_PillarStone.Value = qid.Stone_ID.ToString();

                        lblPillCapQuantityPanel.Text = qid.Quantity.ToString();

                        //lblExistingTotal.Text = qid.Quote.Quote_Price.ToString();

                        lblPillTypePanel.Text = qid.Stone.StoneType;
                        lblCapTypePanel.Text = q.Stone.StoneType;

                        txtInvisibleTotal.Text = qid.Quote.Quote_Price.ToString();

                        //If this value is null then there is no pillar quotes in the database.
                        //This can only happen if the Quote_Details table has been cleared.
                        //The default values are then applied.
                        if(HF_PillarHeight.Value == "")
                        {
                            DefaultDemensions();

                        }

                    }
                    else
                    {
                        DefaultDemensions();

                    }
                }
                else
                {
                    DefaultDemensions();

                }
            }

        }

        private void DefaultDemensions()
        {
            //Default values for product
            //Slab & Pyramid
            SlabWidth.Value = 900.ToString();
            SlabLength.Value = 1100.ToString();
            SlabHeight.Value = 150.ToString();


            PryHeight.Value = 200.ToString();

            //Pillar
            HF_PillarLength.Value = 1000.ToString();
            HF_PillarWidth.Value = 800.ToString();
            HF_PillarHeight.Value = 1250.ToString();
        }

        

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            pnlQuoteCalc.Visible = true;
            btnAddProducts.Enabled = true;
            btnSaveConfirm.Enabled = true;
         
            txtDisplayCapStone.Text = hf_DisplayCapType.Value;
            txtDisplayPillarStone.Text = hf_DisplayPillarType.Value;

            lblPillarStone.Text = txtDisplayPillarStone.Text;
            
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

            float slabWidth = float.Parse(HF_PillarWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float pyramidHeight = float.Parse(PryHeight.Value);
            float slabLength = float.Parse(HF_PillarLength.Value);

            //calculations performed cost class
            var surface = CalcClasses.Cost.PyramidCutCost(CheckCapStoneSelection(), slabWidth, slabHeight, pyramidHeight, slabLength);
            return surface;
        }

        private float CostOfSquarePillar()
        {
            float pillarHeight = float.Parse(HF_PillarHeight.Value) / 1000;
            float pillarWidth = float.Parse(HF_PillarWidth.Value) / 1000;
            float pillarLength = float.Parse(HF_PillarLength.Value) / 1000;

            int stoneId = CheckPillarStoneSelection();
            Stone stone = db.Stones.Where(a => a.StoneId == stoneId).FirstOrDefault();
            float cubedPrice = (float)stone.CostPerCube; 

            return (pillarHeight)*(pillarWidth)*(pillarLength) * cubedPrice;


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
            CheckCapStoneSelection();

            float slabWidth = float.Parse(HF_PillarWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(HF_PillarLength.Value);

            //calculations performed cost class
            var price = CalcClasses.Cost.CalcCost(CheckCapStoneSelection(), slabWidth, slabHeight, slabLength);
            return price;
        }

        private float CalculateStraightCuts()
        {
            //Measurements entered by the user through the slider control
            CheckCapStoneSelection();

            float slabWidth = float.Parse(HF_PillarWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(HF_PillarLength.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.CalcStraightCuts(CheckCapStoneSelection(), slabWidth, slabHeight, slabLength);
            return cutCost;
        }

        //Save user inputs
        protected void btnSaveConfirm_Click(object sender, EventArgs e)
        {
            //generate a random alphanumeric string for Quote Reference
            string qRef = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
           
            //This is for editing a quote which is implemented yet
            if (Page.IsValid)
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

                            int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);

                            Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                           

                            Session["quote"] = qte;
                            if (qid != null)
                            {
                                Response.Redirect("Quote.aspx?QuoteDetailsID=" + qid.QuoteId);

                            }
                            else
                            {
                                Response.Redirect("Quote.aspx");
                            }

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
                        int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                        Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();

                        if (qid == null)
                        {
                            Response.Redirect("Quote.aspx");
                        }
                        else
                        {
                            Response.Redirect("Quote.aspx?QuoteDetailsID=" + qid.Quote_ID);
                        }

                    }
                }

            }
        //}
        


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Session["quote"] = null;
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnAddProducts_Click(object sender, EventArgs e)
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
                qte = new Quote() {Quote_Ref = qRef};

                if (txtQuantity.Text == "")
                {
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Cap_Height = float.Parse(SlabHeight.Value),
                                                  Cap_Width = float.Parse(SlabWidth.Value),
                                                  Cap_Length = float.Parse(SlabLength.Value),
                                                  Cap_Point = float.Parse(PryHeight.Value),
                                                  Stone_ID = Convert.ToInt32(HF_CapStoneType.Value),
                                                  Product_Option_ID = 1,
                                                  Item_Price = Convert.ToDecimal(txtInvisibleTotal.Text),
                                                  Quantity = Convert.ToInt16(lblPillCapQuantityPanel.Text)
                                              });
                }
                else
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
                }
                if (txtQuantity.Text == "")
                {
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Pillar_Height = float.Parse(HF_PillarHeight.Value),
                                                  Pillar_Width = float.Parse(HF_PillarWidth.Value),
                                                  Pillar_Length = float.Parse(HF_PillarLength.Value),
                                                  Stone_ID = Convert.ToInt32(HF_PillarStone.Value),
                                                  Product_Option_ID = 2,
                                                  Item_Price = Convert.ToDecimal(txtInvisibleTotal.Text),
                                                  Quantity = Convert.ToInt16(lblPillCapQuantityPanel.Text)
                                                  
                                              });
                }
                else
                {
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
                }

                Session.Add("quote", qte);


            }
            int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
            Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
            if (qid != null)
            {
                Response.Redirect("LandingPage.aspx?QuoteDetailsID=" + qid.Quote_ID);

            }
            else
            {
                Response.Redirect("LandingPage.aspx");
            }
       
        }


    }
}