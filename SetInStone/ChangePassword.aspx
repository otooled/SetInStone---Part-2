<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="SetInStone.ChangePassword" UnobtrusiveValidationMode="None" %>

<%@ Import Namespace="System.Web.Optimization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/ChangeLoginDetails.css") %>    <%: Scripts.Render("~/bundles/jQuery") %>
    <title>Set In Stone - Edit Login Details</title>
</head>
<body>
    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>

    <form id="frmChangeDetails" runat="server">
        <br />
        <asp:Label runat="server" ID="lblTitle" Text="Edit Login Details"></asp:Label>
        <div id="forgotUserName" runat="server">

            <div id="header">
                <asp:Label ID="lblEmailHeadInstruction" runat="server" CssClass="Labels" Text="Please enter your employee email address : "></asp:Label>
            </div>
            <br />
            <asp:TextBox ID="txtEmail" runat="server" CssClass="TextBoxes" placeholder="Your Email Address"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" Display="None" ErrorMessage="Please enter employee email address" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="regEmail" runat="server" ControlToValidate="txtEmail" Display="None" ErrorMessage="Valid email required" SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
            <br />
            <br />
            <asp:Button ID="btnSendEmail" runat="server" CssClass="Buttons" Text="Send For Details" OnClick="btnSendEmail_Click" />
            <asp:Button ID="btnCancelUser" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="Buttons" CausesValidation="False" />
        </div>

        <div id="changePassword" runat="server">

            <div id="passLabels">
                <div id="pLabels">
                    <asp:Label ID="lblPasswordHeadInstruction" runat="server" CssClass="Labels" Text="Please enter your new password below"></asp:Label>
                </div>
                <br />
                <div id="passTxts">
                    <asp:TextBox ID="txtFirstPassword" runat="server" CssClass="TextBoxes" placeholder="Password" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtFirstPassword" Display="None" ErrorMessage="New password required" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <br />
                    <asp:TextBox ID="txtSecondPassword" runat="server" CssClass="TextBoxes" placeholder="Confirm Password" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtSecondPassword" Display="None" ErrorMessage="Confirm your password" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cmpPassword" runat="server" ControlToCompare="txtFirstPassword" ControlToValidate="txtSecondPassword" Display="None" ErrorMessage="Passwords must match" SetFocusOnError="True"></asp:CompareValidator>
                    <br />
                    <br />
                    <div id="subBtn">
                        <asp:Button ID="btnChangePassword" runat="server" Text="Submit" OnClick="btnChangePassword_Click" CssClass="Buttons" />
                        <asp:Button ID="btnCancelPassword" runat="server" Text="Cancel" OnClick="btnCancelPassword_Click" CssClass="Buttons" CausesValidation="False" />

                    </div>
                </div>
            </div>
        </div>
        <asp:ValidationSummary ID="vldSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />
    </form>
</body>
</html>
