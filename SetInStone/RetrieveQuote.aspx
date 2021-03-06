﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrieveQuote.aspx.cs" Inherits="SetInStone.RetrieveQuote" %>

<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%--Bundles & Scripts--%>
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/RetrieveQuote.css") %>
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone - Retrieve Quote</title>

    <%--Stylesheet & script for kendo ui--%>
    <link rel="stylesheet" href="http://cdn.kendostatic.com/2015.2.624/styles/kendo.common-material.min.css" />
    <link rel="stylesheet" href="http://cdn.kendostatic.com/2015.2.624/styles/kendo.material.min.css" />
    <script src="http://cdn.kendostatic.com/2015.2.624/js/kendo.all.min.js"></script>
      <link rel="icon" type="image/jpg" href="Content/Images/sisIcon.png"/>
</head>
<body>
    <form id="frmRetrieve" runat="server">
        <br />
        <br />
        <div id="divTitle">
            <label>Set In Stone</label>
        </div>
        <div id="divRetrieve">
            <br />
            <br />
            <%--Div for title and cancel button--%>
            <div id="searchCust">
                <h3>Enter customer name</h3>
                <input id="customers" />

                <button id="button" type="button">
                    <span class="k-icon"></span>Cancel</button>

                <%--Cancel button.  Redirects to landing page--%>
                <script>
                    $("#button").kendoButton({
                        icon: "cancel",
                        click: function (e) {
                            window.location.href = "LandingPage.aspx";
                        }
                        //  click: 
                    });

                </script>
            </div>
            <div id="grid_Quotes"></div>

            <%--Kendo combo box including api for customer returns--%>
            <%--            Code was found at:  http://demos.telerik.com/kendo-ui/grid/custom-command--%>
            <script>
                $(document).ready(function () {
                    $("#customers").kendoComboBox({
                        placeholder: "Customer Name...",
                        dataTextField: "FullName",
                        dataValueField: "CustomerID",
                        filter: "contains",
                        autoBind: false,
                        minLength: 3,
                        change: function (e) {
                            DisplayCustQuotes(this.value());

                        },
                        dataSource: {
                            type: "json",
                            transport: {
                                read: "../api/Customers"
                            }
                        }
                    });
                });


                //Display quote for selected customers including api for quote returns
                function DisplayCustQuotes(custID) {
                    $("#grid_Quotes").kendoGrid({
                        sortable:true,
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
                                 command: {
                                     text: "View Details",
                                     click: showDetails
                                 },
                                 title: "Edit ",
                                 width: "130px"
                             },
                            {
                                command: {
                                    text: "Delete",
                                   // click: delete,
                                    type: 'DELETE'
                                },
                                title: "Delete ",
                                width: "130px"
                            }]
                    });
                }

                //This code doesn't work.  It should delete the 
                //record from the database but it does not
                function Delete(e) {
                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                    
                    $.ajax({
                        url: "../Api/DeleteQuote/" + dataItem.Quote_Details_ID,
                        type: 'DELETE',
                        dataType: 'json'

                    });
                   
                }

                //Show details of quotes selected including api for quote detail returns
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
                        title: "Quote Details",
                        width: "800px",
                        visible: false /*don't show it yet*/
                    }).data("kendoWindow").center().open();

                    $("#QuoteDetails").kendoGrid({
                        dataSource: {
                            transport: {
                                read: {
                                    url: "../Api/QuoteDetails/" + dataItem.QuoteId,
                                    dataType: "json"
                                },
                                destroy: {
                                    url: "../Api/DeleteQuote/" + dataItem.QuoteId,
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
                                title: "Edit ",
                                width: "100px"
                            },
                         {
                             command: {
                                 text: "Delete",
                                 click: Delete,
                                 type: 'DELETE'
                             },
                             
                             title: "Delete ",
                             width: "130px"
                         }]
                    });
                }

                //This code only deletes the record from 
                //the Kendo UI and not the database.
                function DeleteRec(e) {
                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                    if (confirm('Do you really want to this quote?')) {
                        var dataSource = $("#grid_Quotes").data("kendoGrid").dataSource;
                        dataSource.remove(dataItem);

                        dataSource.sync();
                    }
                }

                //Redirect to product page 
                function EditDetail(e) {
                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));

                    if (dataItem.ProductOptionID == 1) // pillar cap
                    {
                        window.location.href = "PillarCap.aspx?QuoteDetailsID=" + dataItem.Quote_Details_ID;
                    }
                    else if (dataItem.ProductOptionID == 2)//square pillar
                    {
                        window.location.href = "SquarePillar.aspx?QuoteDetailsID=" + dataItem.Quote_Details_ID;
                    }
                    else if (dataItem.ProductOptionID == 3)//round pillar
                    {
                        window.location.href = "RoundPillar.aspx?QuoteDetailsID=" + dataItem.Quote_Details_ID;
                    }
                    else if (dataItem.ProductOptionID == 4)//fireplace
                    {
                        window.location.href = "FirePlace.aspx?QuoteDetailsID=" + dataItem.Quote_Details_ID;
                    }
                }
               
            </script>


            <br />
        </div>

        <%--Div for quote displays--%>
        <div id="window">
            <div id="QuoteDetails"></div>
        </div>

    </form>
</body>
</html>
