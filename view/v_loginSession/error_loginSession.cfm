<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_loginSession#">
<cfcase Value="updateLoginSession">You did not specify a valid login session for this user.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlRoot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>