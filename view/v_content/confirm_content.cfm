<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_content#">
<cfcase value="insertContentCategory">Content category successfully added!<br>You may add another content category below.</cfcase>
<cfcase value="updateContentCategory">Content category successfully updated!</cfcase>
<cfcase value="moveContentCategoryUp,moveContentCategoryDown">Content category successfully moved.</cfcase>
<cfcase value="deleteContentCategory">Content category deleted.</cfcase>
<cfcase value="insertContent">Content listing successfully added!</cfcase>
<cfcase value="updateContent">Content listing successfully updated!</cfcase>
<cfcase value="moveContentUp,moveContentDown">Content listing successfully moved!</cfcase>
<cfcase value="insertContentCompany">Content value successfully updated.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
