using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SetInStone.Api
{
    public class QuoteDetailsController : ApiController
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
            var query = db.Quote_Details.Where(det => det.Quote.QuoteId == id).
                    Select(d => new
                    {
                        ProdOption = d.ProductOption.ProductOption1,
                        d.ProductOption.ProductOptionID,
                        d.Quote_Details_ID,
                        d.Stone.StoneType,
                        d.Quantity,
                        Item_Price = d.Item_Price / d.Quantity,
                        Item_Total = d.Quantity * (d.Item_Price / d.Quantity)
                    }).ToList();

            return query;
        }
        
    }
}