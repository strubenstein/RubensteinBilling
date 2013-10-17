<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_group#">
<cfcase value="insertGroup">Group successfully created!<br>You may create another group below.</cfcase>
<cfcase value="updateGroup">Group successfully updated!</cfcase>
<cfcase value="insertGroupUser">User(s) successfully added to group!<br>You may continue to add new users to this group below.</cfcase>
<cfcase value="deleteGroupUser">User(s) successfully removed from group!</cfcase>
<cfcase value="insertGroupCompany">Company(s) successfully added to group!<br>You may continue to add new companies to this group below.</cfcase>
<cfcase value="deleteGroupCompany">Company(s) successfully removed from group!</cfcase>
<cfcase value="groupPermission">Group permissions successfully updated!</cfcase>
<cfcase value="insertPermissionTarget">Group permissions successfully updated!</cfcase>
<cfcase value="insertGroupAffiliate">Affiliate(s) successfully added to group!<br>You may continue to add new affiliates to this group below.</cfcase>
<cfcase value="deleteGroupAffiliate">Affiliate(s) successfully removed from group!</cfcase>
<cfcase value="insertGroupCobrand">Cobrand(s) successfully added to group!<br>You may continue to add new cobrands to this group below.</cfcase>
<cfcase value="deleteGroupCobrand">Cobrand(s) successfully removed from group!</cfcase>
<cfcase value="insertGroupVendor">Vendor(s) successfully added to group!<br>You may continue to add new vendors to this group below.</cfcase>
<cfcase value="deleteGroupVendor">Vendor(s) successfully removed from group!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>