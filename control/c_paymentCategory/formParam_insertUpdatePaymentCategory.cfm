<cfif Variables.doAction is "updatePaymentCategory" and IsDefined("qry_selectPaymentCategory")>
	<cfparam Name="Form.paymentCategoryName" Default="#qry_selectPaymentCategory.paymentCategoryName#">
	<cfparam Name="Form.paymentCategoryTitle" Default="#qry_selectPaymentCategory.paymentCategoryTitle#">
	<cfparam Name="Form.paymentCategoryID_custom" Default="#qry_selectPaymentCategory.paymentCategoryID_custom#">
	<cfparam Name="Form.paymentCategoryOrder" Default="#qry_selectPaymentCategory.paymentCategoryOrder#">
	<cfparam Name="Form.paymentCategoryStatus" Default="#qry_selectPaymentCategory.paymentCategoryStatus#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.paymentCategoryAutoMethod" Default="#qry_selectPaymentCategory.paymentCategoryAutoMethod#">
	</cfif>
</cfif>

<cfparam Name="Form.paymentCategoryName" Default="">
<cfparam Name="Form.paymentCategoryTitle" Default="">
<cfparam Name="Form.paymentCategoryID_custom" Default="">
<cfparam Name="Form.paymentCategoryOrder" Default="0">
<cfparam Name="Form.paymentCategoryStatus" Default="1">
<cfparam Name="Form.paymentCategoryAutoMethod" Default="">

