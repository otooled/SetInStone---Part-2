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
        private SetStone db = new SetStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //Create a product object that will be used in the session
        public Product prt = new Product();

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
            
        }

        private void PopulateProductMenu()
        {
            var p = from pdt in db.ProductOptions select new { pdt };
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
            if (ddlProductType.SelectedIndex == 1)
            {
                Session.Add("productOptionID",ddlProductType.SelectedValue);
                Response.Redirect("ProductPage.aspx");
                
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