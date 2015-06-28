using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class RetrieveQuote : System.Web.UI.Page
    {
        //database connection
        private SetStone db = new SetStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //create a product for session
        //public Product pdct = new Product();

        private void Page_PreInit(object sender, System.EventArgs e)
        {
            if ((Session["loginDetails"] == null))
            {
                Response.Redirect("Login.aspx");
            }
        }

        //Don't have edit and order visible until quote ref has been verified
        protected void Page_Load(object sender, EventArgs e)
        {
            btnEditQuote.Visible = false;
            btnPlaceOrder.Visible = false;

        }

        //verify if quote exists
        protected void btnRetrieveQuote_Click(object sender, EventArgs e)
        {
            
            try
            {
                var q = db.Quotes.Where(a => a.Quote_Ref == txtQuoteRef.Text.ToUpper()).FirstOrDefault();
                lblFirstName.Text = q.Customer.First_Name;
                lblSurname.Text = q.Customer.Surname;
                lblAddress.Text = q.Customer.Address;
                lblPhoneNo.Text = q.Customer.Phone;
                lblProduct.Text = q.Product.ProductOption.ProductOption1;
                lblStone.Text = db.Stones.Where(a => a.StoneId == q.Product.StoneId).FirstOrDefault().StoneType;
                lblPrice.Text = q.Price.ToString();

                if (q.Quote_Ref == txtQuoteRef.Text)
                {
                    btnEditQuote.Visible = true;
                    btnPlaceOrder.Visible = true;
                }
                

            }

            //inform the user if the quote doesn't exist
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Quote Retrieval Error", "alert('This quote does not exist');", true);
                
            }
            
        }

        //this will allow the user to edit the quote when it's all implemented
        protected void btnEditQuote_Click(object sender, EventArgs e)
        {
            try
            {
                var q = db.Quotes.Where(a => a.Quote_Ref == txtQuoteRef.Text.ToUpper()).FirstOrDefault();
            
                if(Page.IsValid)
                {
                    Session.Add("quote",q);
                    Session.Add("EditMode", true);
                    Response.Redirect("ProductPage.aspx");
                }
            }
            catch (Exception)
            {
                
                throw;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");

        }
    }
}