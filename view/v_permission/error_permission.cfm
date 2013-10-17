<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_permission#">
<cfcase value="invalidPermissionCategory">You did not specify a valid permission category.</cfcase>
<cfcase value="noPermissionCategory">You must specify a valid permission category for this action.</cfcase>
<cfcase value="invalidPermission">You did not specify a valid permission listing.</cfcase>
<cfcase value="noPermission">You did not specify a valid permission listing.</cfcase>
<cfcase value="invalidAction">You did not specify a valid permission function.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this permission function.</cfcase>
<cfcase value="noPermissionListings">This category does not contain any permission listings.</cfcase>
<cfcase value="insertPermissionCategory">You may only create up to 255 permission categories.</cfcase>
<cfcase value="insertPermission_noCategory">You may not add a permission listing until you have created a category.<br>Please create the permission category below.</cfcase>
<cfcase value="insertPermission_categoryMax">You may only create up to 32 permission listings per category.</cfcase>
<cfcase value="invalidTarget">You did not select to edit the permissions for a valid user or group.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>