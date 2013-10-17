<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_admin#">
<cfcase value="invalidControl">You did not specify a valid admin action.</cfcase>
<cfcase value="invalidAction">You did not specify a valid admin action.</cfcase>
<cfcase value="noPermissionForAction">You do not have permission for this feature.</cfcase>
<cfcase value="noSetupPermission">You do not have permission for any setup functions.</cfcase>
<cfcase value="deleteLoginAttempt">You did not request a valid username to re-enable.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>