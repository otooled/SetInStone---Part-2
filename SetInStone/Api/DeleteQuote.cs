using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Services;

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


        public class QuoteModel
        {
            public string QuoteID { get; set; }

            public string Status { get; set; }
        }


        // DELETE api/values/5
        [HttpDelete]
        public HttpResponseMessage DeleteWithRequestBody(int id, [FromBody] QuoteModel model)
        {
            model.Status = "Deleted";
            var response = Request.CreateResponse(HttpStatusCode.OK, model);
            return response;
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