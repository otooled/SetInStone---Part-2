﻿using System;
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
            //Disable Add Products button to provent the user
            //using it while in edit mode.
            btnAddProducts.Enabled = false;

                if (!Page.IsPostBack)
                {
                    
                   //Check query string status
                    if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                    {
                        //Edit mode
                        //Get quote details id of quote being edited
                        int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                        Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                        if (qid != null)
                        {
                            //Display existing quote in panel
                            pnlExistingQuote.Visible = true;

                            //Controls set for edit mode
                            btnAddProducts.Enabled = true;
                            btnSaveConfirm.Enabled = false;

                            //Set hidden field values
                            //Display the dimensions of quote
                            SlabHeight.Value = qid.Cap_Height.ToString();
                            lblCapHeightPanel.Text = qid.Cap_Height.ToString();

                            SlabWidth.Value = qid.Cap_Width.ToString();
                            lblCapWidthPanel.Text = qid.Cap_Width.ToString();

                            SlabLength.Value = qid.Cap_Length.ToString();
                            lblCapLengthPanel.Text = qid.Cap_Length.ToString();

                            PryHeight.Value = qid.Cap_Point.ToString();
                            lblCapPointPanel.Text = qid.Cap_Point.ToString();

                            DisplayStoneType.Value = qid.Stone_ID.ToString();
                            lblQuantityCaptionPanel.Text = qid.Quantity.ToString();
                         
                            lblDisplayStoneType.Text = qid.Stone.StoneType;

                            txtInvisibleTotal.Text = qid.Quote.Quote_Price.ToString();
                            
                            //If this value is null then there is no pllar car quotes in the database.
                            //This can only happen if the Quote_Details table has been cleared.
                            //The default values are then applied.
                            if (SlabHeight.Value == "")
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

        //Default dimensions of cap
        private void DefaultDemensions()
        {
            SlabWidth.Value = 800.ToString();
            SlabLength.Value = 1000.ToString();
            SlabHeight.Value = 250.ToString();

            PryHeight.Value = 200.ToString();
        }
        
        //Calculate
        protected void btnCalculate_Click(object sender, EventArgs e)
        {
           //Display quote cost panel and enable controls
            pnlQuoteCalc.Visible = true;
            btnAddProducts.Enabled = true;
            btnSaveConfirm.Enabled = true;

            txtDisplayStone.Text = hf_StoneType.Value;
          
            lblDisplayStoneType.Text = txtDisplayStone.Text;

            //variables to hold cost and cutting calculation results
            float qauntity = float.Parse(txtQuantity.Text);
            float slabSurfaceCost = CustomerSlabDetails();
            float pyrSurfaceArea = PyramidSurface();
            float cutCost = CalculateStraightCuts();
            float total = (pyrSurfaceArea + slabSurfaceCost + cutCost);

            //Display final cost of stone work
            
            lblCalculateAnswer.Text = (total * qauntity).ToString("#.##");
           
        }

        private float PyramidSurface()
        {
            //Measurements entered by the user through the slider control
           
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float pyramidHeight = float.Parse(PryHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var surface = CalcClasses.Cost.PyramidCutCost( CheckStoneSelection(), slabWidth, slabHeight, pyramidHeight, slabLength);
            return surface;
        }

        //Remove this when later on
        private int CheckStoneSelection()
        {
            return Convert.ToInt32(DisplayStoneType.Value);
        }

        private float CustomerSlabDetails()
        {
            //Measurements entered by the user through the slider control
         
            int stoneID = CheckStoneSelection();
           
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var price = CalcClasses.Cost.CalcCost( stoneID, slabWidth, slabHeight, slabLength);
            return price;
        }

        private float CalculateStraightCuts()
        {
            //Measurements entered by the user through the slider control
           
            CheckStoneSelection();
            
            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var cutCost = CalcClasses.Cost.CalcStraightCuts( CheckStoneSelection(), slabWidth, slabHeight, slabLength);
            return cutCost;
        }
        
        //Save user inputs
        protected void btnSaveConfirm_Click(object sender, EventArgs e)
        {
            //generate a random alphanumeric string for Quote Reference
            string qRef = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper();

            
            if(Page.IsValid)
            {
                Quote qte;
          
                    if ((Session["quote"] != null))
                    {
                        qte = (Quote) Session["quote"];
                        if (qte != null)
                        {
                            //Add dimensions of newly added product to session
                            qte.Quote_Details.Add(new Quote_Details()
                                                      {
                                                          Cap_Height = float.Parse(SlabHeight.Value),
                                                          Cap_Width = float.Parse(SlabWidth.Value),
                                                          Cap_Length = float.Parse(SlabLength.Value),
                                                          Cap_Point = float.Parse(PryHeight.Value),
                                                          Stone_ID = Convert.ToInt32(DisplayStoneType.Value),
                                                          Product_Option_ID = 1,
                                                          Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                                          Quantity = Convert.ToInt16(txtQuantity.Text)
                                                      });

                           
                            int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                           
                            Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                            Session["quote"] = qte;

                            //Send qoute id to quote page
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
                        qte = new Quote() {Quote_Ref = qRef};

                        //Save dimensions of cap 
                        qte.Quote_Details.Add(new Quote_Details()
                                                  {
                                                      Cap_Height = float.Parse(SlabHeight.Value),
                                                      Cap_Width = float.Parse(SlabWidth.Value),
                                                      Cap_Length = float.Parse(SlabLength.Value),
                                                      Cap_Point = float.Parse(PryHeight.Value),
                                                      Stone_ID = Convert.ToInt32(DisplayStoneType.Value),
                                                      Product_Option_ID = 1,
                                                      Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                                      Quantity = Convert.ToInt16(txtQuantity.Text)
                                                      
                                                  });
                        
                        Session.Add("quote", qte);

                        //Get quote details id and send it to quote page
                        int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                        Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                       
                        if(qid == null)
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
            Session["quote"] = null;  //Clear session
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
                    //Add dimensions when quote is edited
                    qte.Quote_Details.Add(new Quote_Details()
                                              {
                                                  Cap_Height = float.Parse(SlabHeight.Value),
                                                  Cap_Width = float.Parse(SlabWidth.Value),
                                                  Cap_Length = float.Parse(SlabLength.Value),
                                                  Cap_Point = float.Parse(PryHeight.Value),
                                                  Stone_ID = Convert.ToInt32(DisplayStoneType.Value),
                                                  Product_Option_ID = 1,
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

                //Check if quantity as a value.  If not use the value from label.  They're the same
                if (txtQuantity.Text == "")
                {
                    qte.Quote_Details.Add(new Quote_Details()

                                              {
                                                  Cap_Height = float.Parse(SlabHeight.Value),
                                                  Cap_Width = float.Parse(SlabWidth.Value),
                                                  Cap_Length = float.Parse(SlabLength.Value),
                                                  Cap_Point = float.Parse(PryHeight.Value),
                                                  Stone_ID = Convert.ToInt32(DisplayStoneType.Value),
                                                  Product_Option_ID = 1,
                                                  Item_Price = Convert.ToDecimal(txtInvisibleTotal.Text),
                                                  Quantity = Convert.ToInt16(lblQuantityCaptionPanel.Text)

                                              });

                }
                else
                {
                    //Check if text box quantity as a value. 
                    qte.Quote_Details.Add(new Quote_Details()

                                              {
                                                  Cap_Height = float.Parse(SlabHeight.Value),
                                                  Cap_Width = float.Parse(SlabWidth.Value),
                                                  Cap_Length = float.Parse(SlabLength.Value),
                                                  Cap_Point = float.Parse(PryHeight.Value),
                                                  Stone_ID = Convert.ToInt32(DisplayStoneType.Value),
                                                  Product_Option_ID = 1,
                                                  Item_Price = Convert.ToDecimal(lblCalculateAnswer.Text),
                                                  Quantity = Convert.ToInt16(txtQuantity.Text)

                                              });
                }

                Session.Add("quote", qte);

            }

            //Send quote id back to landing page.
            //This is needed so customer info can be used on quote page
            int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
            Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
            if(qid != null)
            {
                Response.Redirect("LandingPage.aspx?QuoteDetailsID=" + qid.Quote_ID);

            }
            else
            {
                Response.Redirect("LandingPage.aspx");
            }
           
        }

        protected void csvWireframe_ServerValidate(object source, ServerValidateEventArgs args)
        {
            
        }
    }
}
