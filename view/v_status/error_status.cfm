<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_status#">
<cfcase value="invalidStatus">You did not specify a valid status option.</cfcase>
<cfcase value="noStatus">You must specify a valid status option.</cfcase>
<cfcase value="invalidAction">You did not specify a valid status option function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this status option function.</cfcase>
<cfcase value="invalidPrimaryTargetID">You did not select a valid target type.</cfcase>
<cfcase value="updateStatusTarget">You cannot edit the status export options until you create a status option.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>