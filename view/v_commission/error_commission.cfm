<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_commission#">
<cfcase value="invalidCommission">You did not specify a valid commission plan.</cfcase>
<cfcase value="bothProductAndCategory">The commission cannot initially apply to both a category and a product.</cfcase>
<cfcase value="controlCategory">To specify a category commission, you must start at the category page.</cfcase>
<cfcase value="controlProduct">To specify a product commission, you must start at the product page.</cfcase>
<cfcase value="invalidProduct">You did not select a valid product that this commission applies to.</cfcase>
<cfcase value="productAlreadyApplies">The commission can already be applied to the product you selected.</cfcase>
<cfcase value="productDoesNotApply">The product you selected has not been applied to this commission.</cfcase>
<cfcase value="invalidTarget">You did not select a valid commission target to change the status of.</cfcase>
<cfcase value="invalidTargetStatus0">The commission target you selected is already disabled.</cfcase>
<cfcase value="invalidTargetStatus1">The commission target you selected is already active.</cfcase>
<cfcase value="invalidAction">You did not specify a valid commission function.</cfcase>
<cfcase value="insertCommissionTargetCompany">You did not select a valid company(s) to add as a commission target.</cfcase>
<cfcase value="insertCommissionTargetUser">You did not select a valid user(s) to add as a commission target.</cfcase>
<cfcase value="insertCommissionTargetAffiliate">You did not select a valid affiliate(s) to add as a commission target.</cfcase>
<cfcase value="insertCommissionTargetCobrand">You did not select a valid cobrand(s) to add as a commission target.</cfcase>
<cfcase value="insertCommissionTargetVendor">You did not select a valid vendor(s) to add as a commission target.</cfcase>
<cfcase value="insertCommissionCustomer">To add a salesperson commission for a customer, please first select the customer's company or subscriber.</cfcase>
<cfcase value="updateCommissionCustomer_blank">You did not specify which salesperson commission record to update for this customer.</cfcase>
<cfcase value="updateCommissionCustomer_exist">You did not specify a valid salesperson commission record to update.</cfcase>
<cfcase value="updateCommissionCustomer_status">The salesperson commission record you requested to update is inactive and cannot be updated.</cfcase>
<cfcase value="viewCommissionCustomer">To view the salesperson(s) for a customer, please start at the customer company.<br>To view the customers for a salesperson, please start at the salesperson (user).</cfcase>
<cfcase value="updateCommissionCustomer">To make the salesperson commission record for this company inactive, please start at the customer company or salesperson.</cfcase>
<cfcase value="updateCommissionCustomerStatus_blank">You did not specify which salesperson commission record to make inactive.</cfcase>
<cfcase value="updateCommissionCustomerStatus_exist">You did not specify a valid salesperson commission record to make inactive.</cfcase>
<cfcase value="updateCommissionCustomerStatus_status">The salesperson commission record you requested to make inactive is already inactive.</cfcase>
<cfcase value="insertCommissionProduct,listCommissionProducts,updateCommissionProduct,insertCommissionCategory,viewCommissionCategory">
	This commission plan is based on the invoice, not individual products.
</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>