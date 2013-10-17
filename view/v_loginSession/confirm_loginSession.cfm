<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_loginSession#">
<cfcase Value="updateLoginSession">User login session successfully ended. The user is now able to log in.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlRoot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>