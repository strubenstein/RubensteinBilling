<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_adminMain#">
<cfcase value="deleteLoginAttempt">Username successfully re-enabled!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>