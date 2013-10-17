<cfoutput>
<p class="SubTitle">Forget Your Username and/or Password?</p>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("URL.action") and IsDefined("Form.email")>
	<cfinclude template="control/c_shopping/c_shoppingAccount/control_forgetUsernamePassword.cfm">
	<cfif Variables.error_forget is not "" or Not IsDefined("Variables.confirmationMessage") or Not StructKeyExists(Variables, "confirmationMessageHtml")>
		<p class="ErrorMessage">#Variables.error_forget#</p>
	<cfelseif Variables.confirmationMessageHtml is 1>
		#Variables.confirmationMessage#
	<cfelse>
		#ParagraphFormat(HTMLEditFormat(Variables.confirmationMessage))#
	</cfif>
	<hr noshade size="2" width="400" align="left" color="006699">
</CFIF>

<form method="post" name="forgetUsername" action="forget.cfm?action=forgetUsername">
<input type="hidden" name="isFormSubmitted" value="True">
<p class="MainText">
<b>Forget your username?</b><br>
Enter your email address and we will email your username to you.<br>
 
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr>
	<td>Your Email: </td>
	<td><input type="text" name="email" size="30"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitForgetUsername" value="Get Username"></td>
</tr>
</table>
</p>
</form>

<form method="post" name="forgetPassword" action="forget.cfm?action=forgetPassword">
<input type="hidden" name="isFormSubmitted" value="True">
<p class="MainText">
<b>Forget your password?</b><br>
Enter your username and your email address and we will email you a new password.<br>
You can then login and change the new password to whatever you want.<br>
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr>
	<td>Your Username: </td>
	<td><input type="text" name="username" size="30"></td>
</tr>
<tr>
	<td>Your Email: </td>
	<td><input type="text" name="email" size="30"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitForgetPassword" value="Reset Password"></td>
</tr>
</table>
</p>
</form>
</cfoutput>
