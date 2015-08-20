using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SetInStone.Api
{
    public class DeleteQuote : ApiController
    {
        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }
        //public IEnumerable<object> Get(int id)
        //{

        //    Quote_Details quote = db.Quote_Details.Find(id);
            
        //    db.Quote_Details.Remove(quote);
        //    db.SaveChanges();
        //    return 
        //}
    }
}