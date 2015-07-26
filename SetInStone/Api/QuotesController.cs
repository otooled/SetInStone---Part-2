using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SetInStone.Api
{
    public class QuotesController : ApiController
    {
        //database connection
        private SetInStone db = new SetInStone();

        protected void Dispose(bool disposing)
        {
            db.Dispose();
        }
        // GET api/<controller>
        public IEnumerable<object> Get(int id)
        {
            var quote = (from q in db.Quotes
                        where  q.CustomerId == id
                        select new
                        {
                            q.Quote_Ref,
                            q.Quote_Price,
                            q.QuoteId,
                            q.Quote_Date
                            
                        }).OrderByDescending(qt=>qt.Quote_Date).AsEnumerable();
            return quote;
        }

       
    }
}