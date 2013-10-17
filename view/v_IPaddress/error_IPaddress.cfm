<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_IPaddress#">
<cfcase value="invalidIPaddress">You did not specify a valid IP address.</cfcase>
<cfcase value="noIPaddress">You must specify a valid IP address.</cfcase>
<cfcase value="invalidAction">You did not specify a valid IP address function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this IP address function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>