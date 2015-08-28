using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        //variables for editing login details
        public string purpose = "";
        public string linkUrl = "";
        public bool userName;

        private SetInStone db = new SetInStone();

        protected void Page_Load(object sender, EventArgs e)
        {
          //Check what functionality the user selected
            purpose = Request.QueryString["purpose"];

            if (purpose == "userName" || purpose == "password")
            {
                forgotUserName.Visible = true;
                changePassword.Visible = false;
                txtEmail.Focus();
            }
            else if (purpose == "passwordChange")
            {
                
                forgotUserName.Visible = false;
                changePassword.Visible = true;
                txtFirstPassword.Focus();

            }
        }

        protected void btnSendEmail_Click(object sender, EventArgs e)
        {
            //Check what should be sent in email
            //Send change username email if selected by the user
            if (purpose == "userName")
            {
                userName = true;
                var nme = db.Employees.Where(a => a.Email == txtEmail.Text).FirstOrDefault(); 
                sendEmailUserName(nme.User_ID, userName);
            }

            //Send change password email with link if selected by user
            else if (purpose == "password")
            {
                userName = false;
                linkUrl = "http://localhost:55153/ChangePassword.aspx?Purpose=passwordChange";
                sendEmailUserName(linkUrl, userName);
                HttpCookie cookie = new HttpCookie("email");
                cookie.Expires = DateTime.Now + new TimeSpan(2, 0, 0);
                cookie.Value = txtEmail.Text;
                Response.Cookies.Add(cookie);
            }
        }

        public void sendEmailUserName(string nme, bool userName)
        {
             //create the message
            MailMessage mail = new MailMessage();
            //add the email address we will be sending the message to
            mail.To.Add(txtEmail.Text);
            //add our email here
            mail.From = new MailAddress("setinstonequote@gmail.com");
            //email's subject
            mail.Subject = "Reset your SetInStone Login details";
            //email's body, this is going to be html. note that we attach the image as using cid
           if(userName)
           {
               mail.Body = "Your User name is: " + nme; 
           }
           else
           {
               mail.Body = "Please click this link to reset your Password: " + nme;
           }
           
            //set email's body to html
            mail.IsBodyHtml = true;

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
                //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Automated email failure", "<script>alert('The automated email service failed.');</script>");

            }
            string timeGone = @"<script type='text/javascript'> if(confirm('An email has been sent with your account information!')) { document.location='Login.aspx?val=true';}</script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "timeOut", timeGone, false);
       
        }

        //Encrypt new password
        static string GetMd5Hash(string input)
        {
            string output = "";

            using (MD5 md5Hash = MD5.Create())
            {

                byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

                foreach (byte b in data)
                {
                    output = output + b.ToString("x2");
                }
            }
            return output;
        }

        //Change password and inform the user
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (txtFirstPassword.Text == txtSecondPassword.Text)
            {
                if (Request.Cookies["email"] != null)
                {
                    string email = Request.Cookies["email"].Value;
                    var cPass = db.Employees.Where(a => a.Email == email).FirstOrDefault();
                    cPass.Password = GetMd5Hash(txtSecondPassword.Text);
                    db.SaveChanges();
                    string timeGone =
                        @"<script type='text/javascript'> if(confirm('You can now log in with your new password!')) { document.location='Login.aspx?val=true';}</script>";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "timeOut", timeGone, false);
                }
                else
                {
                    string timeGone =
                        @"<script type='text/javascript'> if(confirm('Sorry, your link has expired!')) { document.location='Login.aspx?val=true';}</script>";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "timeOut", timeGone, false);
                }
            }
        }

        //Cancel changing password
        protected void btnCancelPassword_Click(object sender, EventArgs e)
        {

            if (Request.Cookies["email"] != null)
            {
                Response.Cookies["email"].Expires = DateTime.Now.AddDays(-1);
                Response.Redirect("Login.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        //Cancel changing userName
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            if (Request.Cookies["email"] != null)
            {
                Response.Cookies["email"].Expires = DateTime.Now.AddDays(-1);
                Response.Redirect("Login.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        //Dispose database connection
        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }
    }
}