<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrieveQuote.aspx.cs" Inherits="SetInStone.RetrieveQuote" %>
<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/RetrieveQuote.css") %> 
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
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
    <br/>
        <asp:Label ID="lblInstructions" runat="server" ForeColor="white" Text="Enter quote reference below and click Retrieve Quote" ></asp:Label>
        <br/>
        <asp:TextBox ID="txtQuoteRef" runat="server" CssClass="TextBoxes"
            placeholder="Quote Ref"></asp:TextBox>

    <asp:Button ID="btnRetrieveQuote" runat="server" Text="Retrieve Quote" 
            OnClick="btnRetrieveQuote_Click" CssClass="Buttons" />
        <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" OnClick="btnCancel_Click"/>
        <br />
        <asp:Label ID="lblFirstName" runat="server" CssClass="Labels" ></asp:Label>

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
        <asp:Label ID="lblPrice" runat="server" CssClass="Labels" placeholder="Price"></asp:Label>
        

        <br />
        
        <br />
        <br />
        <asp:Button ID="btnEditQuote" runat="server" Text="Edit Quote" CssClass="Buttons" OnClick="btnEditQuote_Click"/>
        <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="Buttons"/>
        <br />
    </div>
    </form>
</body>
</html>
