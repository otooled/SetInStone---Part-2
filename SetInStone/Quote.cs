//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SetInStone
{
    using System;
    using System.Collections.Generic;
    
    public partial class Quote
    {
        public Quote()
        {
            this.Orders = new HashSet<Order>();
            this.Quote_Details = new HashSet<Quote_Details>();
        }
    
        public int QuoteId { get; set; }
        public string Quote_Ref { get; set; }
        public Nullable<int> CustomerId { get; set; }
        public Nullable<int> EmployeeId { get; set; }
        public Nullable<decimal> Quote_Price { get; set; }
    
        public virtual Customer Customer { get; set; }
        public virtual Employee Employee { get; set; }
        public virtual ICollection<Order> Orders { get; set; }
        public virtual ICollection<Quote_Details> Quote_Details { get; set; }
    }
}
