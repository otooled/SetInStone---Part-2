<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Quote.aspx.cs" Inherits="SetInStone.Quote1" UnobtrusiveValidationMode="None" %>
<%@ Import Namespace="System.Web.Optimization" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/Quote.css") %><%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
</head>
<body>
    <form id="form1" runat="server">
        
          <br/>
    <br/>
        <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <div id="divQuote">
    <br/>
        <asp:Label runat="server" ID="lblInstuctions" ForeColor="white" Text="Enter details below and click Save Quote"></asp:Label>
    
        
        <asp:Label runat="server" ID="lblDisplayQuote" CssClass="Labels"></asp:Label>
        
        <br />
        <asp:Label runat="server" ID="lblDisplayQuoteRef" CssClass="Labels"></asp:Label>
        <br/>
       <%-- <asp:Label ID="lblName" runat="server" Text="First Name"></asp:Label>--%>
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBoxes" placeholder="First Name"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Please enter a first name"></asp:RequiredFieldValidator>
        <br />
         <br />
        <%--<asp:Label ID="lblSurname" runat="server" Text="Surname"></asp:Label>--%>
        <asp:TextBox ID="txtSurname" runat="server" CssClass="TextBoxes" placeholder="Surname"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtSurname" ErrorMessage="Please enter a surname"></asp:RequiredFieldValidator>
        <br />
         <br />
        <%--<asp:Label ID="lblAddress" runat="server" Text="Address"></asp:Label>--%>
        <asp:TextBox ID="txtAddress" runat="server" CssClass="TextBoxes" placeholder="Address"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="Please enter address"></asp:RequiredFieldValidator>
        <br />
         <br />
        <%--<asp:Label ID="lblPhone" runat="server" Text="Phone No."></asp:Label>--%>
        <asp:TextBox ID="txtPhoneNo" runat="server" CssClass="TextBoxes" placeholder="Phone Number"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPhoneNo" runat="server" ControlToValidate="txtPhoneNo" ErrorMessage="Please enter a contact number"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="regPhone" runat="server" ControlToValidate="txtPhoneNo" ErrorMessage="Numbers only" ValidationExpression="\d+"></asp:RegularExpressionValidator>
        <br />
         <br />
        <asp:Label ID="lblQuoteRef" runat="server" Text=""></asp:Label>
        
        <br />
        <asp:Button ID="btnSubmit" runat="server" Text="Save Quote" OnClick="btnSubmit_Click" CssClass="Buttons"
             />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="Buttons" OnClick="btnCancel_Click" CausesValidation="False"
            />
        </div>
    </form>
</body>
</html>
