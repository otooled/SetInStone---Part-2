using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class Quote1 : System.Web.UI.Page
    {
        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        //check user is logged in
        private void Page_PreInit(object sender, System.EventArgs e)
        {
            if ((Session["loginDetails"] == null))
            {
                Response.Redirect("Login.aspx");
            }
        }

        //create product for session
        public Quote qte = null;

        
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                if (Session["quote"] != null)
                {
                    qte = (Quote) Session["quote"];
                    if (qte != null)
                    {
                        //Display quote ref generated on product page
                        //string quoteRef = (string) Session["quoteRef"];
                        lblDisplayQuoteRef.Text = qte.Quote_Ref;

                        decimal totalQuote = 0;
                        //Display quote price generated on product page
                        //string quote = (string) Session["quote"];
                        foreach (var item in qte.Quote_Details)
                        {
                            totalQuote += item.Item_Price;
                        }
                        lblDisplayQuote.Text = totalQuote.ToString();
                    }
                }

                //if (Session["productID"] != null)
                //{
                    
                //    //string quote = (string)Session["quote"];

                //    //lblDisplayQuote.Text = quote;
                //}
            }
        }

        //Add the quote, customer and product to the database
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["quote"] != null)
            {
                qte = (Quote) Session["quote"];
                if (qte != null)
                {
                    Customer cust = db.Customers.Where(a => a.First_Name == txtFirstName.Text && a.Surname == txtSurname.Text).FirstOrDefault();
                    if (cust == null)
                    {
                        cust = new Customer
                                   {
                                       First_Name = txtFirstName.Text,
                                       Surname = txtSurname.Text,
                                       Address = txtAddress.Text,
                                       Phone = (txtPhoneNo.Text)
                                   };
                        db.Customers.Add(cust);
                        db.SaveChanges();
                    }
                    //var customer2 = db.Customers.Where(a => a.First_Name == txtFirstName.Text && a.Surname == txtSurname.Text).FirstOrDefault();
                    //if (Session["productOptionID"] != null)
                    //{
                    //    var id = (string)Session["productOptionID"];
                    //    pt.ProductOptionID = Convert.ToInt32(id);
                    //}
                    //db.Products.Add(pt);
                    //db.SaveChanges();

                    //Quote qute = new Quote();
                    qte.CustomerId = cust.CustomerID;
                    qte.Quote_Price = Convert.ToDecimal(lblDisplayQuote.Text);
                    //qute.Quote_Ref = lblDisplayQuoteRef.Text;

                    //qute.ProductId = pt.ProductID;
                    db.Quotes.Add(qte);

                    
                    db.SaveChanges();

                    //send user back to landing page after details are saved
                    Response.Write(
                        "<script LANGUAGE='JavaScript' >alert('Quote has been saved.');document.location='" +
                        ResolveClientUrl("~/LandingPage.aspx") + "';</script>");
                }

            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        

        

        
    }
}