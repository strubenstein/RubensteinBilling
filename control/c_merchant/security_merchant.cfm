<cfif Not Application.fn_IsIntegerNonNegative(URL.merchantID)>
	<cfset URL.error_content = "invalidMerchant">
	<cfset Variables.doAction = "listMerchants">
<cfelseif URL.merchantID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="selectMerchant" ReturnVariable="qry_selectMerchant">
		<cfinvokeargument Name="merchantID" Value="#URL.merchantID#">
	</cfinvoke>

	<cfif qry_selectMerchant.RecordCount is 0>
		<cfset URL.error_merchant = "invalidMerchant">
		<cfset Variables.doAction = "listMerchants">
	</cfif>
<cfelseif ListFind("updateMerchant", Variables.doAction)>
	<cfset URL.error_merchant = "noMerchant">
	<cfset Variables.doAction = "listMerchants">
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(URL.merchantAccountID)>
	<cfset URL.error_merchant = "invalidMerchantAccount">
	<cfset Variables.doAction = "listMerchantAccounts">
<cfelseif URL.merchantAccountID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccount" ReturnVariable="qry_selectMerchantAccount">
		<cfinvokeargument Name="merchantAccountID" Value="#URL.merchantAccountID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif qry_selectMerchantAccount.RecordCount is 0>
		<cfset URL.error_merchant = "invalidMerchantAccount">
		<cfset Variables.doAction = "listMerchantAccounts">
	</cfif>
<cfelseif ListFind("updateMerchantAccount", Variables.doAction)>
	<cfset URL.error_merchant = "noMerchantAccount">
	<cfset Variables.doAction = "listMerchantAccounts">
</cfif>

