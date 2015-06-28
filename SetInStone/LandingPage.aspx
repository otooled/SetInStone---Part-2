<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="SetInStone.LandingPage" %>
<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/LandingPage/css/grayscale.css", "~/Content/LandingPage.css") %> 
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
</head>
<body>
    <br/>
    <br/>
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <form id="form1" runat="server">
        <div id="createControlsDiv" class="controlsDiv">
               <asp:DropDownList ID="ddlProductType" runat="server"   data-toggle="dropdown" OnSelectedIndexChanged="ddlProductType_SelectedIndexChanged1"
                   AutoPostBack="True" CssClass="drops"/>
            
        </div>
        <div id="retrieveControlsDiv">
            <asp:Button runat="server" ID="btnRetrieveQuote" CssClass="LoginButtons" Text="Retrieve Quote" OnClick="btnRetrieveQuote_Click" />
        </div>
        <div id="otherDiv">
            <asp:DropDownList runat="server" ID="ddlOther" AutoPostBack="True" CssClass="drops" OnSelectedIndexChanged="ddlOther_SelectedIndexChanged">
                <asp:ListItem Value="0">Other</asp:ListItem>
                <asp:ListItem Value="1">Add Employee</asp:ListItem>
                <asp:ListItem Value="2">Update Stock</asp:ListItem>
            </asp:DropDownList>
            </div>
        <div id="divLogOut">
            <asp:Button  runat="server" ID="btnLogOut" Text="Logout" OnClick="btnLogOut_Click" CssClass="LoginButtons"/>
        </div>
    
    </form>
</body>
</html>
