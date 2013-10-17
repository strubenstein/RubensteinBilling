<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_permission#">
<cfcase value="insertPermissionCategory">Permission category successfully added!<br>You may add another permission category below.</cfcase>
<cfcase value="updatePermissionCategory">Permission category successfully updated!</cfcase>
<cfcase value="movePermissionCategoryUp,movePermissionCategoryDown">Permission category successfully moved.</cfcase>
<cfcase value="insertPermission">Permission listing successfully added!</cfcase>
<cfcase value="updatePermission">Permission listing successfully updated!</cfcase>
<cfcase value="movePermissionUp,movePermissionDown">Permission listing successfully moved!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
