<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewEmployee.aspx.cs" Inherits="SetInStone.NewEmployee" UnobtrusiveValidationMode="None"%>
<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <%: Styles.Render("~/Content/bootstrap.css", "~/Content/LandingPage/css/grayscale.css", "~/Content/NewEmployee.css") %>    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
</head>
<body>
    <br/>
    <br/>
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <form id="form1" runat="server">
    <div id="divEmp" >
        <br/>
        <br/>
    <asp:Label runat="server" Text="Enter employee details below and click Add Employee"></asp:Label>
        <br/>
        <br/>
        <asp:TextBox ID="txtUserName" runat="server" CssClass="TextBoxes" placeholder="UserName"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="txtUserName" ErrorMessage="User name required"></asp:RequiredFieldValidator>
        <br />
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBoxes" placeholder="First Name"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rvfFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name required"></asp:RequiredFieldValidator>
        <br />
        <asp:TextBox ID="txtSurname" runat="server" CssClass="TextBoxes" placeholder="Surname"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rvfSurname" runat="server" ControlToValidate="txtSurname" ErrorMessage="Surname required"></asp:RequiredFieldValidator>
        <br />
        <asp:TextBox ID="txtPassword" runat="server" CssClass="TextBoxes" placeholder="Password" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rvfPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password required"></asp:RequiredFieldValidator>
        <asp:CompareValidator ID="cpvPassword" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" ErrorMessage="Passwords must match"></asp:CompareValidator>
        <br />
        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="TextBoxes" placeholder="Confirm Password" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rvfConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Must confirm password"></asp:RequiredFieldValidator>
        <br />
        <br />
        <asp:Button ID="btnAddEmployee" runat="server" Text="Add Employee" OnClick="btnAddEmployee_Click" CssClass="Buttons"/>
    
        <asp:Button ID="btnCancel" runat="server" CausesValidation="False" Text="Cancel" OnClick="btnCancel_Click" 
            CssClass="Buttons"/>
    
    </div>
    </form>
</body>
</html>
