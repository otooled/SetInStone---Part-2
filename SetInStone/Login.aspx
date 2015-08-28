<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SetInStone.Login" UnobtrusiveValidationMode="None" %>

<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/Login.css") %>
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
    <script language="JavaScript">
        javascript: window.history.forward(1);
    </script>

</head>

<body>
    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <form id="Login" runat="server">

        <div id="LoginDiv">
            <%--TextBox for StaffID input with required field validator--%>
            <asp:TextBox runat="server" placeholder="Staff ID" ID="txtStaffID" CssClass="TextBoxes"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvStaffId" runat="server" ControlToValidate="txtStaffID" ErrorMessage="Staff ID required" Display="None"></asp:RequiredFieldValidator>

            <br />
            <%--Display visual white bar--%>
            <label class="bars"></label>
            <br />
            
            <%--TextBox for Password input with required field validator--%>
            <asp:TextBox runat="server" placeholder="Password" ID="txtPassword" CssClass="TextBoxes" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password required" Display="None"></asp:RequiredFieldValidator>
            
            <br />
            <%--Display visual white bar--%>
            <label class="bars"></label>

            <br />
            <%--Login button--%>
            <asp:Button runat="server" ID="btnLogin" Text="Login" CssClass="LoginButtons" OnClick="btnLogin_Click" />
            <br/>
             <br/>
           <asp:Label runat="server" CssClass="Labels">Forgot your <asp:HyperLink ID="hypUser" runat="server" CssClass="Links" NavigateUrl="~/ChangePassword.aspx?purpose=userName">UserName</asp:HyperLink></asp:Label>
            <asp:Label runat="server" CssClass="Labels"> or <asp:HyperLink ID="hypPassword" CssClass="Links" runat="server" NavigateUrl="~/ChangePassword.aspx?purpose=password">Password</asp:HyperLink></asp:Label>
            <asp:Label runat="server" Text="?" CssClass="Labels"></asp:Label>
            

<%--             <label class="Labels">Forgot your <asp:HyperLink ID="hypUserName" runat="server" NavigateUrl="~/ChangePassword.aspx?purpose=userName">UserName</asp:HyperLink></label>
            <label class="Labels"> or <asp:HyperLink ID="hypPassword" runat="server" NavigateUrl="~/ChangePassword.aspx?purpose=password">Password?</asp:HyperLink></label>
          --%>
            <br />
            <%--Validation summary--%>
            <asp:ValidationSummary ID="vldLoginSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />
            
        </div>
       
    </form>
</body>
</html>
