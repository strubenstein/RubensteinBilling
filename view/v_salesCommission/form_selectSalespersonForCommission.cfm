<cfoutput>

<style type="text/css">
.RecipientType {background-color: ##E7D8F3};
</style>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<div class="MainText"><b>Select Commission Recipient:</b> 
<select name="primary_target" size="1">
<option value="">-- SELECT RECIPIENT --</option>
<cfif qry_selectCompany.affiliateID is not 0>
	<option value="" class="RecipientType">-- AFFILIATE --</option>
	<option value="affiliateID_#qry_selectCompany.affiliateID#"<cfif Form.primary_target is "affiliateID_#qry_selectCompany.affiliateID#"> selected</cfif>>#HTMLEditFormat(qry_selectAffiliate.affiliateName)#<cfif qry_selectAffiliate.affiliateID_custom is not ""> (#HTMLEditFormat(qry_selectAffiliate.affiliateID_custom)#)</cfif></option>
</cfif>
<cfif qry_selectCompany.cobrandID is not 0>
	<option value="" class="RecipientType">-- COBRAND --</option>
	<option value="cobrandID_#qry_selectCompany.cobrandID#"<cfif Form.primary_target is "cobrandID_#qry_selectCompany.cobrandID#"> selected</cfif>>#HTMLEditFormat(qry_selectCobrand.cobrandName)#<cfif qry_selectCobrand.cobrandID_custom is not ""> (#HTMLEditFormat(qry_selectCobrand.cobrandID_custom)#)</cfif></option>
</cfif>
<cfif Variables.userID_salespersonList is not "">
	<option value="" class="RecipientType">-- CUSTOMER SALESPERSON(S) --</option>
	<cfloop Query="qry_selectUserCompanyList_company">
		<cfif ListFind(Variables.userID_salespersonList, qry_selectUserCompanyList_company.userID)>
			<option value="userID_#qry_selectUserCompanyList_company.userID#"<cfif Form.primary_target is "userID_#qry_selectUserCompanyList_company.userID#"> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)# <cfif qry_selectUserCompanyList_company.userID_custom is not "">(#HTMLEditFormat(qry_selectUserCompanyList_company.userID_custom)#)</cfif></option>
		</cfif>
	</cfloop>
</cfif>
<cfif qry_selectVendorProductList.RecordCount is not 0>
	<option value="" class="RecipientType">-- VENDOR(S) --</option>
	<cfloop Query="qry_selectVendorProductList">
		<option value="vendorID_#qry_selectVendorProductList.vendorID#"<cfif Form.primary_target is "vendorID_#qry_selectVendorProductList.vendorID#"> selected</cfif>>#HTMLEditFormat(qry_selectVendorProductList.vendorName)#<cfif qry_selectVendorProductList.vendorID_custom is not ""> (#HTMLEditFormat(qry_selectVendorProductList.vendorID_custom)#)</cfif> - #HTMLEditFormat(Left(qry_selectVendorProductList.invoiceLineItemName, 50))#</option>
	</cfloop>
</cfif>
<option value="" class="RecipientType">-- ALL USERS --</option>
<cfloop Query="qry_selectUserCompanyList_company">
	<option value="userID_#qry_selectUserCompanyList_company.userID#"<cfif Form.primary_target is "userID_#qry_selectUserCompanyList_company.userID#" and Not ListFind(Variables.userID_salespersonList, qry_selectUserCompanyList_company.userID)> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)# <cfif qry_selectUserCompanyList_company.userID_custom is not "">(#HTMLEditFormat(qry_selectUserCompanyList_company.userID_custom)#)</cfif></option>
</cfloop>
</select> 
<input type="submit" name="submitPrimaryTarget" value="Go">
</div>
</form>
</cfoutput>
