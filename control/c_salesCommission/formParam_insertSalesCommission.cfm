<cfif ListFind("invoice,salesCommission", URL.control)>
	<cfparam Name="Form.primaryTargetKey" Default="userID">
<cfelse>
	<cfset Form.primaryTargetKey = Application.fn_GetPrimaryTargetKey(Variables.primaryTargetID)>
	<cfset Variables.targetID =  Variables.targetID>
</cfif>

<cfparam Name="Form.affiliateID" Default="0">
<cfparam Name="Form.cobrandID" Default="0">
<cfparam Name="Form.userID" Default="0">
<cfparam Name="Form.vendorID" Default="0">

<cfparam Name="Form.salesCommissionAmount" Default="0.00">
<cfparam Name="Form.salesCommissionDateBegin" Default="">
<cfparam Name="Form.salesCommissionDateEnd" Default="">
<cfparam Name="Form.salesCommissionPaid" Default="">
<cfparam Name="Form.salesCommissionBasisTotal" Default="">
<cfparam Name="Form.salesCommissionBasisQuantity" Default="">
