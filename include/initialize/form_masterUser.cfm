<cfoutput>
<p class="SubTitle">Insert Master User</p>

<form method="post" action="initialize.cfm?step=#URL.step#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Master Company &amp; User Information:</b></td></tr>
<tr>
	<td class="#fn_setTextClass('companyName')#">Company Name: </td>
	<td><input type="text" name="companyName" size="30" value="#HTMLEditFormat(Form.companyName)#" maxlength="#maxlength_Company.companyName#"></td>
</tr>
<!--- 
<tr>
	<td class="#fn_setTextClass('companyDirectory')#">Company Directory: </td>
	<td><input type="text" name="companyDirectory" size="20" value="#HTMLEditFormat(Form.companyDirectory)#" maxlength="#maxlength_Company.companyDirectory#"> (will be default directory)</td>
</tr>
--->
<tr>
	<td class="#fn_setTextClass('username')#">Username: </td>
	<td><input type="text" name="username" size="20" value="#HTMLEditFormat(Form.username)#" maxlength="#maxlength_User.username#"> (this will be the primary user)</td>
</tr>
<tr>
	<td class="#fn_setTextClass('password')#">Password: </td>
	<td><input type="text" name="password" size="20" value="#HTMLEditFormat(Form.password)#" maxlength="#maxlength_User.password_decrypted#"> (here's an example of a good password!)</td>
</tr>
<tr>
	<td class="#fn_setTextClass('passwordVerify')#">Verify Password: </td>
	<td><input type="text" name="passwordVerify" size="20" value="#HTMLEditFormat(Form.passwordVerify)#" maxlength="#maxlength_User.password_decrypted#"> (re-enter your password)</td>
</tr>
<tr>
	<td class="#fn_setTextClass('firstName')#">First Name: </td>
	<td>
		<input type="text" name="firstName" size="15" value="#HTMLEditFormat(Form.firstName)#" maxlength="#maxlength_User.firstName#"> 
		<span class="#fn_setTextClass('lastName')#">Last:</span> <input type="text" name="lastName" size="20" value="#HTMLEditFormat(Form.lastName)#" maxlength="#maxlength_User.lastName#">
	</td>
</tr>
<tr>
	<td class="#fn_setTextClass('email')#">Email: </td>
	<td><input type="text" name="email" size="40" value="#HTMLEditFormat(Form.email)#" maxlength="#maxlength_User.email#"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitMasterUser" value="Create Master User"></td>
</tr>
</table>
</form>
</cfoutput>
