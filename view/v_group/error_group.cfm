<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_group#">
<cfcase value="noGroup">You did not specify a valid group.</cfcase>
<cfcase value="invalidGroup">You did not specify a valid group.</cfcase>
<cfcase value="invalidAction">You did not select a valid group function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>