using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SetInStone
{
    public partial class NewEmployee : System.Web.UI.Page
    {
        //Database connection
        private SetStone db = new SetStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }
        private void Page_PreInit(object sender, System.EventArgs e)
        {
           //Check user is logged in
            if ((Session["loginDetails"] == null))
            {
                Response.Redirect("Login.aspx");
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //Encryption for password creation
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

        //Add new employee to database
        protected void btnAddEmployee_Click(object sender, EventArgs e)
        {
            Employee emp = new Employee()
                               {
                                   User_ID = txtUserName.Text,
                                   First_name = txtFirstName.Text,
                                   Surname = txtSurname.Text,
                                   Password = GetMd5Hash(txtConfirmPassword.Text),

                               };
            db.Employees.Add(emp);
            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {


            }

            finally
            {

                string timeGone = @"<script type='text/javascript'> if(confirm('You can now log in with your chosen username and password.')) { document.location='LandingPage.aspx?val=true';}</script>";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "timeOut", timeGone, false);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }
    }
}