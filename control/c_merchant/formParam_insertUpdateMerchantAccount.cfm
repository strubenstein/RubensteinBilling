<cfif Variables.doAction is "updateMerchantAccount" and IsDefined("qry_selectMerchantAccount")>
	<cfparam Name="Form.merchantID" Default="#qry_selectMerchantAccount.merchantID#">
	<cfparam Name="Form.merchantAccountStatus" Default="#qry_selectMerchantAccount.merchantAccountStatus#">
	<cfparam Name="Form.merchantAccountUsername" Default="#qry_selectMerchantAccount.merchantAccountUsername#">
	<cfparam Name="Form.merchantAccountPassword" Default="#qry_selectMerchantAccount.merchantAccountPassword#">
	<cfparam Name="Form.merchantAccountID_custom" Default="#qry_selectMerchantAccount.merchantAccountID_custom#">
	<cfparam Name="Form.merchantAccountDescription" Default="#qry_selectMerchantAccount.merchantAccountDescription#">
	<cfparam Name="Form.merchantAccountName" Default="#qry_selectMerchantAccount.merchantAccountName#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.merchantAccountBank" Default="#qry_selectMerchantAccount.merchantAccountBank#">
		<cfparam Name="Form.merchantAccountCreditCard" Default="#qry_selectMerchantAccount.merchantAccountCreditCard#">
		<cfparam Name="Form.merchantAccountCreditCardTypeList" Default="#qry_selectMerchantAccount.merchantAccountCreditCardTypeList#">
	</cfif>
</cfif>

<cfparam Name="Form.merchantID" Default="0">
<cfparam Name="Form.merchantAccountUsername" Default="">
<cfparam Name="Form.merchantAccountPassword" Default="">
<cfparam Name="Form.merchantAccountID_custom" Default="">
<cfparam Name="Form.merchantAccountBank" Default="0">
<cfparam Name="Form.merchantAccountStatus" Default="1">
<cfparam Name="Form.merchantAccountCreditCard" Default="0">
<cfparam Name="Form.merchantAccountDescription" Default="">
<cfparam Name="Form.merchantAccountName" Default="">
<cfparam Name="Form.merchantAccountCreditCardTypeList" Default="">

