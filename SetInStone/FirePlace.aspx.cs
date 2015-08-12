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

                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    //Edit mode
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();

                    BaseWidth.Value = qid.Fireplace_Base_Width.ToString();
                    BaseHeight.Value = qid.Fireplace_Base_Height.ToString();
                    TopHeight.Value = qid.Fireplace_Top_Height.ToString();
                    TopWidth.Value = qid.Fireplace_Top_Width.ToString();
                    Depth.Value = qid.Fireplace_Depth.ToString();

                    lblPreviousDetails.Text = ("Existing Quote");
                    lblDisplayTotalCost.Text = ("Total Cost: ");
                    lblFireplaceStoneCaption.Text = ("Marble Type: ");
                    lblFireplaceStone.Text = qid.Stone.StoneType;
                    lblCalculateAnswer.Text = "";
                    //txtDisplayStone.Text = "";
                    txtDisplayStone.Text = qid.Stone.StoneType;
                    lblCalculateAnswer.Text = qid.Quote.Quote_Price.ToString();
                }
                else
                {
                    BaseWidth.Value = 400.ToString();
                    BaseHeight.Value = 250.ToString();

                    TopHeight.Value = 120.ToString();
                    TopWidth.Value = 400.ToString();
                    Depth.Value = 60.ToString();
                }
            }
        }
        //Check what stone type is selected for cap
        private int CheckStoneSelection()
        {
            return Convert.ToInt32(HF_MarbleSelection.Value);
        }


       

        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            lblPreviousDetails.Text = ("Current Quote:");
            lblDisplayTotalCost.Text = ("Total Cost: ");
            lblFireplaceStoneCaption.Text = ("Marble Type: ");
            txtDisplayStone.Text = hf_StoneType.Value;
            //ViewState["sTypes"] = txtDisplayStone.Text;
            lblFireplaceStone.Text = txtDisplayStone.Text;

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
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);
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
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);

            //CheckStoneSelection();

            int stoneID = CheckStoneSelection();

            float baseSlabWidth = float.Parse(BaseWidth.Value);
            float baseSlabHeight = float.Parse(BaseHeight.Value);
            float depth = float.Parse(Depth.Value);

            //float topHeight = float.Parse(TopHeight.Value);
            //float topWidth = float.Parse(TopWidth.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.baseFireplaceStraightCuts(stoneID, baseSlabWidth, baseSlabHeight, depth);
            return cutCost;
        }

        private float CalculateTopCuts()
        {
            //Measurements entered by the user through the slider control
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);

            //CheckStoneSelection();

            int stoneID = CheckStoneSelection();

            //float baseSlabWidth = float.Parse(BaseWidth.Value);
            //float baseSlabHeight = float.Parse(BaseHeight.Value);
            

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
                //if ((Session["EditMode"] != null) && true)
                //{
                //    if ((Session["quote"] != null))
                //    {
                //        //Quote q = (Quote)Session["quote"];
                //        //q.Product.Width = float.Parse(SlabWidth.Value);
                //        ////q.Product.StoneId = Convert.ToInt32(ddlStoneType.SelectedValue);
                //        //q.Product.StoneId = sType;
                //        //q.Product.Height = float.Parse(SlabHeight.Value);
                //        //q.Product.Length = float.Parse(SlabLength.Value);
                //        //q.Product.PyrHeight = float.Parse(PryHeight.Value);
                //        //db.SaveChanges();
                //    }
                //}

                //    //This adds product deminsions into session
                //else // not edit mode
                //{
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

                            Session["quote"] = qte;


                            Response.Redirect("Quote.aspx");
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


                        Response.Redirect("Quote.aspx");
                    }
                }

            }
        

        protected void btnCancel_Click(object sender, EventArgs e)
        {
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


            }
            Response.Redirect("LandingPage.aspx");
        }


    }
}
