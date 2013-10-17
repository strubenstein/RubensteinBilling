<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_contact#">
<cfcase value="invalidContact">You did not specify a valid contact management message.</cfcase>
<cfcase value="noContact">You must specify a valid contact management message.</cfcase>
<cfcase value="updateContactSent">This message has already been sent and thus cannot be updated.</cfcase>
<cfcase value="invalidLanguage">You did not specify a valid language.</cfcase>
<cfcase value="invalidAction">You did not specify a valid contact management message function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this contact management message function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>