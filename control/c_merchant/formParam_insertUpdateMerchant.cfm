<cfparam Name="Variables.default_merchantURL" Default="http://www.">

<cfif Variables.doAction is "updateMerchant" and IsDefined("qry_selectMerchant")>
	<cfparam Name="Form.userID" Default="#qry_selectMerchant.userID#">
	<cfparam Name="Form.merchantName" Default="#qry_selectMerchant.merchantName#">
	<cfparam Name="Form.merchantTitle" Default="#qry_selectMerchant.merchantTitle#">
	<cfparam Name="Form.merchantDescription" Default="#qry_selectMerchant.merchantDescription#">
	<cfparam Name="Form.merchantFilename" Default="#qry_selectMerchant.merchantFilename#">
	<cfparam Name="Form.merchantStatus" Default="#qry_selectMerchant.merchantStatus#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.merchantBank" Default="#qry_selectMerchant.merchantBank#">
		<cfparam Name="Form.merchantCreditCard" Default="#qry_selectMerchant.merchantCreditCard#">
		<cfparam Name="Form.merchantRequiredFields" Default="#qry_selectMerchant.merchantRequiredFields#">
	</cfif>
	<cfif qry_selectMerchant.merchantURL is "">
		<cfparam Name="Form.merchantURL" Default="#Variables.default_merchantURL#">
	<cfelse>
		<cfparam Name="Form.merchantURL" Default="#qry_selectMerchant.merchantURL#">
	</cfif>
</cfif>

<cfparam Name="Form.userID" Default="0">
<cfparam Name="Form.merchantName" Default="">
<cfparam Name="Form.merchantTitle" Default="">
<cfparam Name="Form.merchantBank" Default="0">
<cfparam Name="Form.merchantCreditCard" Default="0">
<cfparam Name="Form.merchantURL" Default="#Variables.default_merchantURL#">
<cfparam Name="Form.merchantDescription" Default="">
<cfparam Name="Form.merchantFilename" Default="">
<cfparam Name="Form.merchantStatus" Default="1">
<cfparam Name="Form.merchantRequiredFields" Default="">

<cfif Form.merchantURL is "">
	<cfset Form.merchantURL = Variables.default_merchantURL>
</cfif>
