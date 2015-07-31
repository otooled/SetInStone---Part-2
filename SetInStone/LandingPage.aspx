﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="SetInStone.LandingPage" %>

<%@ Import Namespace="System.Web.Optimization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%--Bundles & Scripts--%>
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/LandingPage.css") %>
    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone</title>
</head>
<body>
    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>
    <form id="form1" runat="server">

        <%--Dropdownlist for product selection--%>
        <div id="ControlsDivCol1" class="controlsDivCol1">
            <asp:DropDownList ID="ddlProductType" runat="server" data-toggle="dropdown" OnSelectedIndexChanged="ddlProductType_SelectedIndexChanged1"
                AutoPostBack="True" />
            <br />
            <br />
            <%--Retrieve quote button--%>
            <asp:Button runat="server" ID="btnRetrieveQuote" CssClass="LoginButtons" Text="Retrieve Quote" OnClick="btnRetrieveQuote_Click" />
        </div>

        <%--Dropdownlist for product selection--%>
        <div id="controlsDivCol2">
            <asp:DropDownList runat="server" ID="ddlOther" AutoPostBack="True" OnSelectedIndexChanged="ddlOther_SelectedIndexChanged">
                <asp:ListItem Value="0">Other</asp:ListItem>
                <asp:ListItem Value="1">Add Employee</asp:ListItem>
                <asp:ListItem Value="2">Update Stock</asp:ListItem>
            </asp:DropDownList>
            <br />
            <br />

            <%--Logout quote button--%>

            <asp:Button runat="server" ID="btnLogOut" Text="Logout" OnClick="btnLogOut_Click" CssClass="LoginButtons" />
        </div>

    </form>
</body>
</html>
