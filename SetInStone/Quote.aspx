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
    
        
    <asp:Label runat="server" ID="lblQuoteCaption" CssClass="Labels" Text="Total: "></asp:Label>
       
        <asp:Label runat="server" ID="lblDisplayQuote" CssClass="Labels"></asp:Label>
        
        <br />
         <asp:Label runat="server" ID="lblRefCaption" CssClass="Labels" Text="Quote Ref: "></asp:Label>
        <asp:Label runat="server" ID="lblDisplayQuoteRef" CssClass="Labels"></asp:Label>
        <br/>
        <br/>
        <asp:Label runat="server" ID="lblInstuctions" ForeColor="white" Text="Enter details below and click Save Quote"
            Font-Italic="True"></asp:Label>
        <br/>
       <br/>
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBoxes" placeholder="First Name"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Please enter a first name" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <br/>
       <br/>
        <asp:TextBox ID="txtSurname" runat="server" CssClass="TextBoxes" placeholder="Surname"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtSurname" ErrorMessage="Please enter a surname" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
      <br/>
        <br/>
        <asp:TextBox ID="txtAddress" runat="server" CssClass="TextBoxes" placeholder="Address"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="Please enter address" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <br/>
        <br/>
        <asp:TextBox ID="txtDate" runat="server" CssClass="TextBoxes" placeholder="Date"></asp:TextBox>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="TextBoxes" placeholder="Email" TextMode="Email"></asp:TextBox>
        <br />
       <br/>
        <asp:TextBox ID="txtPhoneNo" runat="server" CssClass="TextBoxes" placeholder="Phone Number"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPhoneNo" runat="server" ControlToValidate="txtPhoneNo" ErrorMessage="Please enter a contact number" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="regPhone" runat="server" ControlToValidate="txtPhoneNo" ErrorMessage="Numbers only" ValidationExpression="\d+" Display="None" SetFocusOnError="True"></asp:RegularExpressionValidator>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="None" ErrorMessage="Please enter an email address" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmail" Display="None" ErrorMessage="Incorrect email address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" SetFocusOnError="True"></asp:RegularExpressionValidator>
        <br />
         <br />
        
        
       
        <asp:Button ID="btnSubmit" runat="server" Text="Save Quote" OnClick="btnSubmit_Click" CssClass="Buttons"
             />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="Buttons" OnClick="btnCancel_Click" CausesValidation="False"
            />
        </div>
          <asp:ValidationSummary ID="vldSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />
    </form>
</body>
</html>
