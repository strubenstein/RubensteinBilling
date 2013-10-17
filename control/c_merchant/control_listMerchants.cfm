<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="selectMerchantList" ReturnVariable="qry_selectMerchantList">
	<cfinvokeargument Name="returnCompanyFields" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_merchant/lang_listMerchants.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateMerchant,viewCompany,viewUser")>

<cfset Variables.columnHeaderList = Variables.lang_listMerchants_title.companyName
		& "^" &  Variables.lang_listMerchants_title.lastName
		& "^" &  Variables.lang_listMerchants_title.merchantName
		& "^" &  Variables.lang_listMerchants_title.merchantTitle
		& "^" &  Variables.lang_listMerchants_title.merchantURL
		& "^" &  Variables.lang_listMerchants_title.merchantCreditCard
		& "^" &  Variables.lang_listMerchants_title.merchantBank
		& "^" &  Variables.lang_listMerchants_title.merchantFilename
		& "^" &  Variables.lang_listMerchants_title.merchantStatus
		& "^" &  Variables.lang_listMerchants_title.merchantDateCreated
		& "^" &  Variables.lang_listMerchants_title.merchantDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateMerchant")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listMerchants_title.updateMerchant>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_merchant/dsp_selectMerchantList.cfm">
