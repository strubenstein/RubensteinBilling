<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_company#">
<cfcase value="insertCompany">Company successfully created!</cfcase>
<cfcase value="updateCompany">Company successfully updated!</cfcase>
<cfcase value="insertGroupCompany">Company group memberships successfully updated!</cfcase>
<cfcase value="companyPermission">Company permissions successfully updated!</cfcase>
<cfcase value="insertPermissionTarget">Company permissions successfully updated!</cfcase>
<cfcase value="updateCompanyIsExported">Export status of company records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>