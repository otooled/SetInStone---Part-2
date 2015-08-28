﻿using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Services;

namespace SetInStone.Api
{
    public class DeleteQuoteController : ApiController
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
        //[HttpDelete]
        //public HttpResponseMessage DeleteWithRequestBody(int id, [FromBody] QuoteModel model)
        //{
        //    model.Status = "Deleted";
        //    var response = Request.CreateResponse(HttpStatusCode.OK, model);
        //    return response;
        //}


        public HttpResponseMessage DeleteQuoteDetails(int qid)
        {
            Quote_Details qd = db.Quote_Details.Find(qid);
            if (qd == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
            db.Quote_Details.Remove(qd);
            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {

                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
            return Request.CreateResponse(HttpStatusCode.OK, qd);
        } 
        

        //public IEnumerable<object> Get(int id)
        //{

        //    Quote_Details qt = db.Quote_Details.Find(id);
            
        //    db.Quote_Details.Remove(qt);
        //    db.SaveChanges();
        //    return qt;
        //}
    }
}