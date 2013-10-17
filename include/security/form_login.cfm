<cfoutput>
<p style="font-family: Tahoma; font-size: 22px; font-weight: bold; color: 784397">Billing System</p>

<cfif IsDefined("URL.confirm") and URL.confirm is "logout">
	<p class="ConfirmationMessage">You have successfully logged out.</p>
</cfif>

<p class="SubTitle">Admin Login</p>
<form method="post" action="#Application.billingSecureUrl#/admin/index.cfm">
<input type="hidden" name="isFormSubmitted" value="True">
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Application.billingSuperuserEnabled is True>
	<tr>
		<td>Company: </td>
		<td><input type="text" name="login_companyDirectory" size="15"></td>
	</tr>
</cfif>
<tr>
	<td>Username: </td>
	<td><input type="text" name="login_username" size="15"></td>
</tr>
<tr>
	<td>Password: </td>
	<td><input type="password" name="login_password" size="15"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitLogin" value="Login"></td>
</tr>
</table>
</form>
</cfoutput>