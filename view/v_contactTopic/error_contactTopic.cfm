<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_contactTopic#">
<cfcase value="invalidContactTopic">You did not specify a valid contact management topic.</cfcase>
<cfcase value="noContactTopic">You must specify a valid contact management topic.</cfcase>
<cfcase value="invalidLanguage">You did not specify a valid language.</cfcase>
<cfcase value="invalidAction">You did not specify a valid contact management topic function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this contact management topic function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>