<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_commission#">
<cfcase value="insertCommission">Commission plan successfully created!</cfcase>
<cfcase value="updateCommission">Commission plan successfully updated!</cfcase>
<cfcase value="deleteCommission">Commission plan deleted.</cfcase>
<cfcase value="updateCommissionStatus">Commission plan updated to inactive.</cfcase>
<cfcase value="updateCommissionTargetStatus0">Commission target status updated to disabled.</cfcase>
<cfcase value="updateCommissionTargetStatus1">Commission target status successfully updated to active.</cfcase>
<cfcase value="insertCommissionTargetCompany">Company(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionTargetGroup">Group(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionTargetUser">User(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionTargetAffiliate">Affiliate(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionTargetCobrand">Cobrand(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionTargetVendor">Vendor(s) successfully added to commission target.</cfcase>
<cfcase value="insertCommissionCategory">Categories for which this commission may be applied has been updated.</cfcase>
<cfcase value="insertCommissionProduct">Commission will now be applied to the selected product.</cfcase>
<cfcase value="updateCommissionProduct">Commission will no longer be applied to the selected product.</cfcase>
<cfcase value="insertCommissionCustomer">Salesperson commission record for this company successfully added.</cfcase>
<cfcase value="updateCommissionCustomer">Salesperson commission record for this company successfully updated.<br>The original record has been archived for historical purposes.</cfcase>
<cfcase value="updateCommissionCustomerStatus">Salesperson commission record for this company is now inactive.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>