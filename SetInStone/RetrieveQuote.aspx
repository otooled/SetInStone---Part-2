<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrieveQuote.aspx.cs" Inherits="SetInStone.RetrieveQuote" %>
<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/RetrieveQuote.css") %> 
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
    
    <link rel="stylesheet" href="http://cdn.kendostatic.com/2015.2.624/styles/kendo.common-material.min.css" />
    <link rel="stylesheet" href="http://cdn.kendostatic.com/2015.2.624/styles/kendo.material.min.css" />

    <script src="http://cdn.kendostatic.com/2015.2.624/js/kendo.all.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <br/>
    <br/>
        <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <div id="divRetrieve">
    <br/>
    <%--<br/>
        <asp:Label ID="lblInstructions" runat="server" ForeColor="white" Text="Enter quote reference below and click Retrieve Quote" ></asp:Label>
        <br/>
        <asp:TextBox ID="txtQuoteRef" runat="server" CssClass="TextBoxes"
            placeholder="Quote Ref"></asp:TextBox>

    <asp:Button ID="btnRetrieveQuote" runat="server" Text="Retrieve Quote" 
            OnClick="btnRetrieveQuote_Click" CssClass="Buttons" />--%>
<%--        <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" OnClick="btnCancel_Click"/>--%>
        <br />
       <%-- <asp:Label ID="lblFirstName" runat="server" CssClass="Labels" ></asp:Label>

        <br />
        <asp:Label ID="lblSurname" runat="server" CssClass="Labels" placeholder="Surame"></asp:Label>
        <br />
        <asp:Label ID="lblAddress" runat="server" CssClass="Labels" placeholder="Address"></asp:Label>
        <br />
        <asp:Label ID="lblPhoneNo" runat="server" CssClass="Labels" placeholder="Phone Number"></asp:Label>
        <br />
        <asp:Label ID="lblProduct" runat="server" CssClass="Labels" placeholder="Product"></asp:Label>
        <br />
        <asp:Label ID="lblStone" runat="server" CssClass="Labels" placeholder="Stone"></asp:Label>
        <br />
        <asp:Label ID="lblPrice" runat="server" CssClass="Labels" placeholder="Price"></asp:Label>--%>
        

        <br />
        
        <div id="searchCust" >
                <h4>Customer Name</h4>
                <input id="customers" />

            <button id="button" type="button">
    <span class="k-icon"></span> Cancel
</button>
<script>
    $("#button").kendoButton({
        icon: "cancel",
        click: function(e) {
            window.location.href = "LandingPage.aspx";
        }
    });
</script>
            </div>
        <div id="grid_Quotes"></div>

            <script>
                $(document).ready(function () {
                    $("#customers").kendoComboBox({
                        placeholder: "Customer Name...",
                        dataTextField: "FullName",
                        dataValueField: "CustomerID",
                        filter: "contains",
                        autoBind: false,
                        minLength: 3,
                        change: function(e) {
                            DisplayCustQuotes(this.value());
                            // Use the value of the widget
                        },
                        dataSource: {
                            type: "json",
                            transport: {
                                read: "../api/Customers"
                            }
                        }
                    });
                });
                
                function DisplayCustQuotes(custID)
                {
                    $("#grid_Quotes").kendoGrid({
                        
                        dataSource: {
                            transport: {
                                read: {
                                    url: "../Api/Quotes/" + custID,
                                    dataType: "json"
                                }
                            },
                            pageSize: 5
                        },
                        columns: [
                            {
                                field: "Quote_Ref",
                                title: "Quote Ref"
                            },
                            {
                                field: "Quote_Price",
                                title: "Quote Price",
                                format: "€{0:n2}"
                            },
                            {
                                field: "Quote_Date",
                                title: "Quote Date",
                                template: "#= kendo.toString(kendo.parseDate(Quote_Date, 'yyyy-MM-dd'), 'dd/MM/yyyy') #"
                            },
                            { 
                                command: { text: "View Details",
                                    click: showDetails
                                },
                                title: " ",
                                width: "130px"
                            }]
                    });
                }

                
                function showDetails(e) {
                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                    
                    var accessWindow = $("#window").kendoWindow({
                        actions: [
                                "Maximize",
                                "Close"
                        ],
                        draggable: true,
                        height: "250px",
                        modal: true,
                        resizable: false,
                        title: "Access",
                        width: "800px",
                        visible: false /*don't show it yet*/
                    }).data("kendoWindow").center().open();
                    //alert(dataItem.QuoteId);
                    $("#QuoteDetails").kendoGrid({
                        
                        dataSource: {
                            transport: {
                                read: {
                                    url: "../Api/QuoteDetails/" + dataItem.QuoteId,
                                    dataType: "json"
                                }
                            },
                            pageSize: 5
                        },
                        columns: [
                            {
                                field: "ProdOption",
                                title: "Product Name"
                            },
                            {
                                field: "StoneType",
                                title: "Stone Type"
                            },
                            {
                                field: "Quantity",
                                title: "Quantity"
                                
                            },
                             {
                                 field: "Item_Price",
                                 title: "Unit Price",
                                 format: "€{0:n2}"

                             },
                             {
                                 field: "Item_Total",
                                 title: "Total",
                                 format: "€{0:n2}"

                             },
                            {
                                command: {
                                    text: "Edit",
                                    click: EditDetail
                                },
                                title: " ",
                                width: "100px"
                            }]
                    });
                }
                
                function EditDetail(e)
                {
                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                    
                    if(dataItem.ProductOptionID == 1) // pillar cap
                    {
                        window.location.href = "PillarCap.aspx?QuoteDetailsID=" + dataItem.Quote_Details_ID;
                    }
                    else if (dataItem.ProductOptionID == 2)
                    {
                    }

                }
            </script>
        
       <%-- <asp:DataGrid ID="gvQuoteDetails" runat="server" AutoGenerateColumns="False">
            <Columns>
              <asp:BoundColumn DataField="ProdOption" HeaderText="Product Name"></asp:BoundColumn>
                <asp:BoundColumn DataField="StoneType" HeaderText="Stone Type"></asp:BoundColumn>
                  <asp:BoundColumn DataField="Quantity" HeaderText="Quantity"></asp:BoundColumn>
                    <asp:BoundColumn DataField="Item_Price" HeaderText="Unit Price"></asp:BoundColumn>
                        <asp:BoundColumn DataField="Item_Total" HeaderText="Total"></asp:BoundColumn>
                <asp:TemplateColumn>
                    <ItemTemplate>
                        <asp:Button runat="server" ID="btnEdit" Text="Edit..." CommandArgument='<%# Eval("ProductOptionID")+","+ Eval("Quote_Details_ID") %>' OnCommand="btn_EditCommand" />
                    </ItemTemplate>
                </asp:TemplateColumn>

    </Columns>                
</asp:DataGrid>--%>
        </>
        
        <br />
        <br />
<%--        <asp:Button ID="btnEditQuote" runat="server" Text="Edit Quote" CssClass="Buttons" OnClick="btnEditQuote_Click"/>--%>
<%--        <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="Buttons"/>--%>
        <br />
    </div>
        
        <div id="window">
                <div id="QuoteDetails"></div>
        </div>

    </form>
</body>
</html>
