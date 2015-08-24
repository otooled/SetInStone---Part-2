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
                if ((Session["quote"] != null))
                {
                    //Disable and enable controls for edit mode
                    lblEditTitle.Visible = true;
                    btnRetrieveQuote.Enabled = false;
                    ddlOther.Enabled = false;
                    btnCancel.Visible = true;
                    btnCancel.Enabled = true;
                }

            }
        }

        //Populate Product Dropdown menu
        private void PopulateProductMenu()
        {

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
        
        //Open Product's page when option is selected
        protected void ddlProductType_SelectedIndexChanged1(object sender, EventArgs e)
        {
            Session.Add("productOptionID", ddlProductType.SelectedValue);
            if (ddlProductType.SelectedIndex == 1)
            {
                //For edit mode.  Quote id will be sent to the product's page
                //if the quoute is being edited
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    //Edit mode
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                    Response.Redirect("PillarCap.aspx?QuoteDetailsID=" + qid.QuoteId);
                }

                else
                {
                    //Redierect to product's page if the quote is not being edited
                    Response.Redirect("PillarCap.aspx");
                }
                
            }
            else if (ddlProductType.SelectedIndex == 2)
            {
                //For edit mode.  Quote id will be sent to the product's page
                //if the quoute is being edited
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                    
                    Response.Redirect("SquarePillar.aspx?QuoteDetailsID=" + qid.QuoteId);

                }
                else
                {
                    //Redierect to product's page if the quote is not being edited
                    Response.Redirect("SquarePillar.aspx");
                }

            }
            else if (ddlProductType.SelectedIndex == 3)
            {
                //The roundpillar is not wired for calculation so there
                //is not need to send a QuoteId here.
                Response.Redirect("RoundPillar.aspx");
            }
            else if (ddlProductType.SelectedIndex == 4)
            {
                //For edit mode.  Quote id will be sent to the product's page
                //if the quoute is being edited
                if (!String.IsNullOrEmpty(Request["QuoteDetailsID"]))
                {
                    int qteID = Convert.ToInt32(Request["QuoteDetailsID"]);
                    Quote qid = db.Quotes.Where(a => a.QuoteId == qteID).FirstOrDefault();
                   
                    Response.Redirect("FirePlace.aspx?QuoteDetailsID=" + qid.QuoteId);

                }
                else
                {
                    //Redierect to product's page if the quote is not being edited
                    Response.Redirect("FirePlace.aspx");
                }
              
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

        protected void btnCancel_Click(object sender, EventArgs e)
        {

            btnCancel.Visible = false;
            btnCancel.Enabled = false;
            //Request.QueryString.Remove("QuoteDetailsID");
            Session["quote"] = null;

            //Code to clear QueryString values and revert to original page
            //Code found on StackOverflow
            var nvc = HttpUtility.ParseQueryString(Request.Url.Query);

            nvc.Remove("QuoteDetailsID");

            string url = Request.Url.AbsolutePath + "?" + nvc.ToString();

            Response.Redirect(url);
        }


    }
}