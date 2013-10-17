<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_primaryTarget#">
<cfcase value="invalidPrimaryTarget">You did not specify a valid primary target.</cfcase>
<cfcase value="noPrimaryTarget">You must specify a valid primary target.</cfcase>
<cfcase value="invalidAction">You did not specify a valid primary target function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this primary target function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>