<cfparam Name="URL.merchantID" Default="0">
<cfparam Name="URL.merchantAccountID" Default="0">

<cfinclude template="security_merchant.cfm">
<cfinclude template="../../view/v_merchant/nav_merchant.cfm">
<cfif IsDefined("URL.confirm_merchant")>
	<cfinclude template="../../view/v_merchant/confirm_merchant.cfm">
</cfif>
<cfif IsDefined("URL.error_merchant")>
	<cfinclude template="../../view/v_merchant/error_merchant.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<!--- merchant options  --->
<cfcase value="listMerchants">
	<cfinclude template="control_listMerchants.cfm">
</cfcase>

<cfcase value="insertMerchant">
	<cfinclude template="control_insertMerchant.cfm">
</cfcase>

<cfcase value="updateMerchant">
	<cfinclude template="control_updateMerchant.cfm">
</cfcase>

<!--- merchant account options --->
<cfcase value="listMerchantAccounts">
	<cfinclude template="control_listMerchantAccounts.cfm">
</cfcase>

<cfcase value="insertMerchantAccount">
	<cfinclude template="control_insertMerchantAccount.cfm">
</cfcase>

<cfcase value="updateMerchantAccount">
	<cfinclude template="control_updateMerchantAccount.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_merchant = "invalidAction">
	<cfinclude template="../../view/v_merchant/error_merchant.cfm">
</cfdefaultcase>
</cfswitch>

