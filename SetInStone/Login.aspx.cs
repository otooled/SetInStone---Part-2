using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

namespace SetInStone
{
    public partial class Login : System.Web.UI.Page
    {
        private SetStone db = new SetStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }

        
        protected void Page_Load(object sender, EventArgs e)
        {
            //The system crashes if the user presses back afte logging in.
            //This should prevent that
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now); 

            //Highlight username textbox
            txtStaffID.Focus();
            

            if (!IsPostBack)
            {
                //Create session
                if (Session["loginDetails"] != null)
                {
                    Employee values = (Employee)Session["userDetails"];
                    txtStaffID.Text = values.User_ID;

                    txtPassword.Text = values.Password;
                }
            }
        }

        //Check login details with detail in database
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Employee details;
            if (IsValid)
            {
                //Add session
                details = new Employee { User_ID= txtStaffID.Text, Password = txtPassword.Text };
                Session.Add("loginDetails", details);

            }

            //Encryption for password checking
            string hash = GetMd5Hash(txtPassword.Text);

            var logDet = db.Employees.Where(a => a.User_ID == txtStaffID.Text && a.Password == hash).FirstOrDefault();
            if (logDet != null)
            {
                if (Session["loginDetails"] != null)
                {
                    Employee emp = (Employee)Session["loginDetails"];
                    emp.User_ID = logDet.User_ID;
                }
                Response.Redirect("LandingPage.aspx");
            }
            else
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "Incorrect Login details", "<script>alert('Your username/password is incorrect.');</script>");
            }
        }


        //Encryption for password checking
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
    }
}