<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_contactTemplate#">
<cfcase value="invalidContactTemplate">You did not specify a valid contact management template.</cfcase>
<cfcase value="noContactTemplate">You must specify a valid contact management template.</cfcase>
<cfcase value="invalidLanguage">You did not specify a valid language.</cfcase>
<cfcase value="invalidAction">You did not specify a valid contact management template function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this contact management template function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>