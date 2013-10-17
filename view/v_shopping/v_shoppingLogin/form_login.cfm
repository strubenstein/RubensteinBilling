<cfoutput>
<p class="SubTitle">Login</p>

<cfif IsDefined("Variables.error_login") and Trim(Variables.error_login) is not "">
	<p class="ErrorMessage">#Variables.error_login#<br>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfif>

<form method="post" action="index.cfm?method=user.login<cfif Trim(CGI.Query_String) is not "">?#CGI.Query_String#</cfif>">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
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

<p class="MainText"><a href="#Application.billingSecureUrl#/index.cfm?method=user.forgetLogin">Forget your username and/or password?</a></p>
</cfoutput>
