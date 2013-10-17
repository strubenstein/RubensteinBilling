<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_import#">
<cfcase value="noImportPermission">You do not have permission to add/import any record types.</cfcase>
<cfcase value="noFilename">You did not specify a filename of failed export records.</cfcase>
<cfcase value="fileNotExist">The filename for failed export records does not exist.<br>It is deleted immediately after it is downloaded.</cfcase>
<cfcase value="invalidAction">You did not specify a valid import function.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>