<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_note#">
<cfcase value="invalidNote">You did not specify a valid note.</cfcase>
<cfcase value="noNote">You must specify a valid note.</cfcase>
<cfcase value="invalidAction">You did not specify a valid note function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this note function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>