<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_content#">
<cfcase value="invalidContentCategory">You did not specify a valid content category.</cfcase>
<cfcase value="noContentCategory">You must specify a valid content category for this action.</cfcase>
<cfcase value="invalidContent">You did not specify a valid content listing.</cfcase>
<cfcase value="invalidLanguage">You did not specify a valid language.</cfcase>
<cfcase value="noContent">You did not specify a valid content listing.</cfcase>
<cfcase value="insertContent">You may not add a content listing until you have created a category.<br>Please create the content category below.</cfcase>
<cfcase value="invalidAction">You did not specify a valid content function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this content management function.</cfcase>
<cfcase value="invalidContentStatus">You cannot update an archived version of a particular content listing.</cfcase>
<cfcase value="deleteContentCategory">This category cannot be deleted because it contains at least content listing.</cfcase>
<cfcase value="noContentListings">This category does not contain any content listings.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>