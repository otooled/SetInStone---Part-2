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
            //int sType = Convert.ToInt32( ddlStoneType.SelectedValue);

            float slabWidth = float.Parse(SlabWidth.Value);
            float slabHeight = float.Parse(SlabHeight.Value);
            float pyramidHeight = float.Parse(PryHeight.Value);
            float slabLength = float.Parse(SlabLength.Value);

            //calculations performed cost class
            var surface = CalcClasses.Cost.PyramidCutCost( CheckStoneSelection(), slabWidth, slabHeight, pyramidHeight, slabLength);
            return surface;
        }

        private int CheckStoneSelection()
        {
            return Convert.ToInt32(DisplayStoneType.Value);
            
        }

        private float CustomerSlabDetails()
        {
            //Measurements entered by the user through the slider control
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);
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
            //int sType = Convert.ToInt32(ddlStoneType.SelectedValue);

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

            //This is for editing a quote which is implemented yet
            if(Page.IsValid)
            {
                Quote qte;
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
                else // not edit mode
                {
                    if ((Session["quote"] != null))
                    {
                        qte = (Quote) Session["quote"];
                        if (qte != null)
                        {
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


                            Response.Redirect("Quote.aspx");
                        }
                    }
                    else
                    {
                        qte = new Quote() {Quote_Ref = qRef};

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


                        Response.Redirect("Quote.aspx");
                    }
                }
                
            }
        }
        

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnBack_Click(object sender, EventArgs e)
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


            }
            Response.Redirect("LandingPage.aspx");
        }

       
    }
}