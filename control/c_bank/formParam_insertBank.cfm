<cfif URL.bankID is not 0 and IsDefined("qry_selectBank")>
	<cfparam Name="Form.bankName" Default="#qry_selectBank.bankName#">
	<cfparam Name="Form.bankBranch" Default="#qry_selectBank.bankBranch#">
	<cfparam Name="Form.bankBranchCity" Default="#qry_selectBank.bankBranchCity#">
	<cfparam Name="Form.bankBranchState" Default="#qry_selectBank.bankBranchState#">
	<cfparam Name="Form.bankBranchCountry" Default="#qry_selectBank.bankBranchCountry#">
	<cfparam Name="Form.bankBranchContactName" Default="#qry_selectBank.bankBranchContactName#">
	<cfparam Name="Form.bankBranchPhone" Default="#qry_selectBank.bankBranchPhone#">
	<cfparam Name="Form.bankBranchFax" Default="#qry_selectBank.bankBranchFax#">
	<cfparam Name="Form.bankRoutingNumber" Default="#qry_selectBank.bankRoutingNumber#">
	<cfparam Name="Form.bankAccountNumber" Default="#qry_selectBank.bankAccountNumber#">
	<cfparam Name="Form.bankAccountName" Default="#qry_selectBank.bankAccountName#">
	<cfparam Name="Form.bankCheckingOrSavings" Default="#qry_selectBank.bankCheckingOrSavings#">
	<cfparam Name="Form.bankPersonalOrCorporate" Default="#qry_selectBank.bankPersonalOrCorporate#">
	<cfparam Name="Form.bankDescription" Default="#qry_selectBank.bankDescription#">
	<cfparam Name="Form.bankAccountType" Default="#qry_selectBank.bankAccountType#">
	<cfparam Name="Form.bankStatus" Default="#qry_selectBank.bankStatus#">
	<cfparam Name="Form.bankRetain" Default="#qry_selectBank.bankRetain#">
	<cfparam Name="Form.addressID" Default="#qry_selectBank.addressID#">
</cfif>

<cfparam Name="Form.bankName" Default="">
<cfparam Name="Form.bankBranch" Default="">
<cfparam Name="Form.bankBranchCity" Default="">
<cfparam Name="Form.bankBranchState" Default="">
<cfparam Name="Form.bankBranchStateOther" Default="">
<cfparam Name="Form.bankBranchCountry" Default="United States">
<cfparam Name="Form.bankBranchCountryOther" Default="">
<cfparam Name="Form.bankBranchContactName" Default="">
<cfparam Name="Form.bankBranchPhone" Default="">
<cfparam Name="Form.bankBranchFax" Default="">
<cfparam Name="Form.bankRoutingNumber" Default="">
<cfparam Name="Form.bankAccountNumber" Default="">
<cfparam Name="Form.bankAccountName" Default="">
<cfif URL.control is "user">
	<cfparam Name="Form.bankPersonalOrCorporate" Default="0">
<cfelse>
	<cfparam Name="Form.bankPersonalOrCorporate" Default="1">
</cfif>
<cfparam Name="Form.bankCheckingOrSavings" Default="0">
<cfparam Name="Form.bankDescription" Default="">
<cfparam Name="Form.bankAccountType" Default="">
<cfparam Name="Form.bankStatus" Default="1">
<cfparam Name="Form.bankRetain" Default="1">
<cfparam Name="Form.addressID" Default="">

