<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_vendor#">
<cfcase value="insertVendor">Vendor successfully added!<br>You may add another vendor listing below for this company.</cfcase>
<cfcase value="updateVendor">Vendor successfully updated!</cfcase>
<cfcase value="updateVendorIsExported">Export status of vendor records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
