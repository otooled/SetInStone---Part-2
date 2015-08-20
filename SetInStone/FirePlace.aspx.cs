using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class FirePlace : System.Web.UI.Page
    {


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

            btnContinue.Enabled = false;

            if (!Page.IsPostBack)
            {

                //The following commented out code will be used
                //editing a quote

                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    //Edit mode
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                    if (qid != null)//new
                    {
                        pnlExistingQuote.Visible = true;
                        btnContinue.Enabled = true;
                        btnSaveConfirm.Enabled = false;


                        BaseWidth.Value = qid.Fireplace_Base_Width.ToString();
                        lblBaseWidthPanel.Text = qid.Fireplace_Base_Width.ToString();

                        BaseHeight.Value = qid.Fireplace_Base_Height.ToString();
                        lblBaseHeightPanel.Text = qid.Fireplace_Base_Height.ToString();


                        TopHeight.Value = qid.Fireplace_Top_Height.ToString();
                        lblTopHeightPanel.Text = qid.Fireplace_Top_Height.ToString();

                        TopWidth.Value = qid.Fireplace_Top_Width.ToString();
                        lblTopWidthPanel.Text = qid.Fireplace_Top_Width.ToString();

                        Depth.Value = qid.Fireplace_Depth.ToString();
                        lblDepthPanel.Text = qid.Fireplace_Depth.ToString();

                        // hf_StoneType.Value 
                        HF_MarbleSelection.Value = qid.Stone_ID.ToString();

                        lblFirePQuantityPanel.Text = qid.Quantity.ToString();
                        lblDisplayStoneType.Text = qid.Stone.StoneType;
                        lblExistingTotal.Text = qid.Quote.Quote_Price.ToString();

                        txtInvisibleTotal.Text = qid.Quote.Quote_Price.ToString();

                        //lblCalculateAnswer.Text = "";

                        //txtDisplayStone.Text = qid.Stone.StoneType;
                        //lblCalculateAnswer.Text = qid.Quote.Quote_Price.ToString(); 

                        //If this value is null then there is no fireplace quotes in the database.
                        //This can only happen if the Quote_Details table has been cleared.
                        //The default values are then applied.
                        if (BaseWidth.Value == "")
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
            BaseWidth.Value = 400.ToString();
            BaseHeight.Value = 250.ToString();

            TopHeight.Value = 120.ToString();
            TopWidth.Value = 400.ToString();
            Depth.Value = 60.ToString();
        }

        //Check what stone type is selected for cap
        private int CheckStoneSelection()
        {
            return Convert.ToInt32(HF_MarbleSelection.Value);
        }
        
        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            pnlQuoteCalc.Visible = true;
            btnContinue.Enabled = true;
            btnSaveConfirm.Enabled = true;

            txtDisplayStone.Text = hf_StoneType.Value;

            //variables to hold cost and cutting calculation results
            float qauntity = float.Parse(txtQuantity.Text);
            float slabCost = CustomerFirePlaceMeasurements();
            float baseCuts = CalculateBaseCuts();
            float topCuts = CalculateTopCuts();
            float total = (slabCost + baseCuts + topCuts);

            //Display final cost of stone work
            lblCalculateAnswer.Text = (total * qauntity).ToString("#.##");
        }
        private float CustomerFirePlaceMeasurements()
        {
            //Measurements entered by the user through the slider control

            int stoneID = CheckStoneSelection();

            float baseSlabWidth = float.Parse(BaseWidth.Value);
            float baseSlabHeight = float.Parse(BaseHeight.Value);
            float depth = float.Parse(Depth.Value);

            float topHeight = float.Parse(TopHeight.Value);
            float topWidth = float.Parse(TopWidth.Value);

            //calculations performed cost class
            var price = CalcClasses.Cost.FirplaceCalcCost(stoneID, baseSlabWidth, baseSlabHeight, depth, topHeight, topWidth);
            return price;
        }

        private float CalculateBaseCuts()
        {
            //Measurements entered by the user through the slider control

            int stoneID = CheckStoneSelection();

            float baseSlabWidth = float.Parse(BaseWidth.Value);
            float baseSlabHeight = float.Parse(BaseHeight.Value);
            float depth = float.Parse(Depth.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.baseFireplaceStraightCuts(stoneID, baseSlabWidth, baseSlabHeight, depth);
            return cutCost;
        }

        private float CalculateTopCuts()
        {
            //Measurements entered by the user through the slider control


            int stoneID = CheckStoneSelection();

            float topHeight = float.Parse(TopHeight.Value);
            float topWidth = float.Parse(TopWidth.Value);
            float depth = float.Parse(Depth.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.topFireplaceStraightCuts(stoneID, topHeight, topWidth, depth);
            return cutCost;
        }
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
                                                      Fireplace_Base_Height = float.Parse(BaseHeight.Value),
                                                      Fireplace_Base_Width = float.Parse(BaseWidth.Value),

                                                      Fireplace_Top_Height = float.Parse(TopHeight.Value),
                                                      Fireplace_Top_Width = float.Parse(TopWidth.Value),
                                                      Stone_ID = Convert.ToInt32(HF_MarbleSelection.Value),

                                                      Fireplace_Depth = float.Parse(Depth.Value),
                                                      Product_Option_ID = 4,
                                                      Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
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
                                                  Fireplace_Base_Height = float.Parse(BaseHeight.Value),
                                                  Fireplace_Base_Width = float.Parse(BaseWidth.Value),

                                                  Fireplace_Top_Height = float.Parse(TopHeight.Value),
                                                  Fireplace_Top_Width = float.Parse(TopWidth.Value),
                                                  Fireplace_Depth = float.Parse(Depth.Value),
                                                  Stone_ID = Convert.ToInt32(HF_MarbleSelection.Value),

                                                  Product_Option_ID = 4,
                                                  Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
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


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Session["quote"] = null;
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            Quote qte;
            if ((Session["quote"] != null))
            {
                qte = (Quote)Session["quote"];
                if (qte != null)
                {
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Fireplace_Base_Height = float.Parse(BaseHeight.Value),
                                                  Fireplace_Base_Width = float.Parse(BaseWidth.Value),

                                                  Fireplace_Top_Height = float.Parse(TopHeight.Value),
                                                  Fireplace_Top_Width = float.Parse(TopWidth.Value),
                                                  Fireplace_Depth = float.Parse(Depth.Value),
                                                  Stone_ID = Convert.ToInt32(HF_MarbleSelection.Value),
                                                  Product_Option_ID = 4,
                                                  Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                                  Quantity = Convert.ToInt16(txtQuantity.Text)
                                              });


                    Session["quote"] = qte;
                }
            }
            else
            {
                string qRef = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();
                qte = new Quote() { Quote_Ref = qRef };
                float x = float.Parse(BaseHeight.Value);

                if (txtQuantity.Text == "")
                {
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Fireplace_Base_Height = float.Parse(BaseHeight.Value),
                                                  Fireplace_Base_Width = float.Parse(BaseWidth.Value),

                                                  Fireplace_Top_Height = float.Parse(TopHeight.Value),
                                                  Fireplace_Top_Width = float.Parse(TopWidth.Value),

                                                  Fireplace_Depth = float.Parse(Depth.Value),
                                                  Stone_ID = Convert.ToInt32(HF_MarbleSelection.Value),
                                                  Product_Option_ID = 4,
                                                  Item_Price = Convert.ToDecimal(txtInvisibleTotal.Text),
                                                  Quantity = Convert.ToInt16(lblFirePQuantityPanel.Text) //changing

                                              });
                }
                else
                {
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Fireplace_Base_Height = float.Parse(BaseHeight.Value),
                                                  Fireplace_Base_Width = float.Parse(BaseWidth.Value),

                                                  Fireplace_Top_Height = float.Parse(TopHeight.Value),
                                                  Fireplace_Top_Width = float.Parse(TopWidth.Value),

                                                  Fireplace_Depth = float.Parse(Depth.Value),
                                                  Stone_ID = Convert.ToInt32(HF_MarbleSelection.Value),
                                                  Product_Option_ID = 4,
                                                  Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                                  Quantity = Convert.ToInt16(txtQuantity.Text) //changing

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
