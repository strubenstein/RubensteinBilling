<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="returnMerchantFields" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_merchant/lang_listMerchantAccounts.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateMerchantAccount")>
<cfset Variables.columnHeaderList = Variables.lang_listMerchantAccounts_title.merchantAccountName
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantTitle
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantAccountCreditCard
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantAccountBank
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantAccountStatus
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantAccountDateCreated
		& "^" &  Variables.lang_listMerchantAccounts_title.merchantAccountDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateMerchantAccount")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listMerchantAccounts_title.updateMerchantAccount>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_merchant/dsp_selectMerchantAccountList.cfm">

