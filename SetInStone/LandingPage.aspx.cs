using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class LandingPage : System.Web.UI.Page
    {
        //Make database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //Create a product object that will be used in the session
        //public Product prt = new Product();

        //Ensure user is logged in with session
        private void Page_PreInit(object sender, System.EventArgs e)
        {
            PopulateProductMenu();

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

               // int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);

            }
        }

        private void PopulateProductMenu()
        {
            //var p = from pdt in db.ProductOptions select new { pdt };
            var pp = db.ProductOptions;
            ddlProductType.DataSource = pp.ToList();
            ddlProductType.DataValueField = "ProductOptionID";
            ddlProductType.DataTextField = "ProductOption1";
            ddlProductType.DataBind();
            ddlProductType.Items.Insert(0, "Select Product");

        }
        
        //Open Retrieve quote page if clicked
        protected void btnRetrieveQuote_Click(object sender, EventArgs e)
        {
            
            Response.Redirect("RetrieveQuote.aspx");
        }

        //Open Product page when option is selected
        protected void ddlProductType_SelectedIndexChanged1(object sender, EventArgs e)
        {
            Session.Add("productOptionID", ddlProductType.SelectedValue);
            if (ddlProductType.SelectedIndex == 1)
            {
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    //Edit mode
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    //Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                    Response.Redirect("PillarCap.aspx?QuoteDetailsID=" + qid.QuoteId);
                   
                }
                else
                {
                    Response.Redirect("PillarCap.aspx");
                }
                //Session.Add("productOptionID", ddlProductType.SelectedValue);
               // Response.Redirect("PillarCap.aspx");
            }
            else if (ddlProductType.SelectedIndex == 2)
            {
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                //Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
               // Response.Redirect("PillarCap.aspx
                    Session.Add("productOptionID", ddlProductType.SelectedValue);
                    Response.Redirect("SquarePillar.aspx?QuoteDetailsID=" + qid.QuoteId);

                }
                else
                {
                    Response.Redirect("SquarePillar.aspx");
                }

            }
            else if (ddlProductType.SelectedIndex == 3)
            {
                Session.Add("productOptionID", ddlProductType.SelectedValue);
                Response.Redirect("RoundPillar.aspx");
            }
            else if (ddlProductType.SelectedIndex == 4)
            {
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    //Quote_Details qid = db.Quote_Details.Where(a => a.Quote_Details_ID == qteID).FirstOrDefault();
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                    // Response.Redirect("PillarCap.aspx
                    Session.Add("productOptionID", ddlProductType.SelectedValue);
                    Response.Redirect("FirePlace.aspx?QuoteDetailsID=" + qid.QuoteId);

                }
                else
                {
                    Response.Redirect("FirePlace.aspx");
                }
                
                //Response.Redirect("FirePlace.aspx");
            }
            
        }

        //Log user out and clear session
        protected void btnLogOut_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        //Open New employee or Update stock page if selected
        protected void ddlOther_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlOther.SelectedIndex == 1)
            {
                Response.Redirect("NewEmployee.aspx");
            }
        }


    }
}