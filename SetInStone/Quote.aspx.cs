using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Text;
using System.Net;

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

            }
        }

        //Add the quote, customer and product to the database
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //create the message
            MailMessage mail = new MailMessage();
            //add the email address we will be sending the message to
            mail.To.Add(txtEmail.Text);
            //add our email here
            mail.From = new MailAddress("setinstonequote@gmail.com");
            //email's subject
            mail.Subject = "Your quote from SetInStone";
            //email's body, this is going to be html. note that we attach the image as using cid
            mail.Body = "Dear " + txtFirstName.Text + Environment.NewLine +
                        "Your quote price for quote reference: " + lblDisplayQuoteRef.Text + "is €" +
                        lblDisplayQuote.Text
                        + Environment.NewLine +
                        "Please refer to the quote reference if you need to contact us."
                        + Environment.NewLine +
                        "Regards" + Environment.NewLine + "The SetInStoneTeam"; 
            
            //set email's body to html
            mail.IsBodyHtml = true;

            ////add our attachment
            //Attachment imgAtt = new Attachment(Server.MapPath("tmpImage.gif"));
            ////give it a content id that corresponds to the src we added in the body img tag
            //imgAtt.ContentId = "tmpImage.gif";
            ////add the attachment to the email
            //mail.Attachments.Add(imgAtt);

            //setup our smtp client, these are Gmail specific settings
            SmtpClient client = new SmtpClient("smtp.gmail.com", 587);
            client.EnableSsl = true; //ssl must be enabled for Gmail
            //our Gmail account credentials
            NetworkCredential credentials = new NetworkCredential("setinstonequote@gmail.com", "project400");
            //add credentials to our smtp client
            client.Credentials = credentials;

            try
            {
                //try to send the mail message
                client.Send(mail);
            }
            catch
            {
                //some feedback if it does not work
                txtFirstName.Text = "fail";
            }
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
                                       Email = txtEmail.Text,
                                       Phone = (txtPhoneNo.Text)

                                   };
                        db.Customers.Add(cust);
                        db.SaveChanges();
                    }
                    
                    qte.CustomerId = cust.CustomerID;

                    ///////////////////
                    //decimal totalQuote = 0;
                    ////Display quote price generated on product page
                    ////string quote = (string) Session["quote"];
                    //foreach (var item in qte.Quote_Details)
                    //{
                    //    totalQuote += item.Item_Price;
                    //}
                    ////lblDisplayQuote.Text = totalQuote.ToString();
                    //////////////

                    qte.Quote_Price = Convert.ToDecimal(lblDisplayQuote.Text);
                    
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