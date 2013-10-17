<cfoutput>
<p class="SubTitle">Verify Email</p>

<cfif Variables.error_verifyEmail is not "">
	<p class="ErrorMessage">
	#Variables.error_verifyEmail#
	<br><hr noshade size="2" width="400" align="left" color="006699"></p>
</cfif>

<form method="get" action="index.cfm?method=user.verifyEmail">
<input type="hidden" name="isFormSubmitted" value="True">

<p class="MainText">Please enter your email verification code in the field below and click the Submit button:</p>

<input type="text" name="userEmailVerifyCode" size="20"> <input type="submit" value="Submit">

</form>
</cfoutput>