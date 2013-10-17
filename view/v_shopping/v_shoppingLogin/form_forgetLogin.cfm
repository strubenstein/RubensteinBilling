<cfoutput>
<form method="post" name="forgetUsername" action="index.cfm?method=user.forgetUsername">
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

<form method="post" name="forgetPassword" action="index.cfm?method=user.forgetPassword">
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