<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_user#">
<cfcase value="insertUser">User successfully created!</cfcase>
<cfcase value="updateUser">User successfully updated!</cfcase>
<cfcase value="insertGroupUser">User group settings successfully updated!</cfcase>
<cfcase value="insertPermissionTarget">User permissions successfully updated!</cfcase>
<cfcase value="updateUserIsExported">Export status of user records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
