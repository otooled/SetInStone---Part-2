using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SetInStone.Api
{
    public class CustomersController : ApiController
    {

        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }
        // GET api/<controller>
        public IEnumerable<object> Get()
        {
            var cust = (from c in db.Customers
                       select new
                                  {
                                      c.CustomerID,
                                      FullName = c.First_Name + " " + c.Surname
                                  }).AsEnumerable();
            return cust;
        }

    }
}