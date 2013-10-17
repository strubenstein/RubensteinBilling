<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
		<cfinvokeargument Name="companyIDorUserID" Value="False">
	</cfif>
	<cfif URL.action is not "listBanksAll">
		<cfinvokeargument Name="bankStatus" Value="1">
	</cfif>
</cfinvoke>

<cfset Variables.bankActionUpdate = Replace(Variables.formAction, URL.action, "updateBank", "ONE")>
<cfset Variables.bankActionView = Replace(Variables.formAction, URL.action, "viewBank", "ONE")>
<cfset Variables.bankActionList = Replace(Variables.formAction, URL.action, "listBanks", "ONE")>
<cfset Variables.bankActionListAll = Replace(Variables.formAction, URL.action, "listBankAll", "ONE")>
<cfset Variables.bankActionDelete = Replace(Variables.formAction, URL.action, "deleteBank", "ONE")>

<cfset Variables.bankActionStatusActive = Replace(Variables.formAction, URL.action, "updateBankStatus1", "ONE")>
<cfset Variables.bankActionStatusArchived = Replace(Variables.formAction, URL.action, "updateBankStatus0", "ONE")>
<cfset Variables.bankActionRetainYes = Replace(Variables.formAction, URL.action, "updateBankRetain1", "ONE")>
<cfset Variables.bankActionRetainNo = Replace(Variables.formAction, URL.action, "updateBankRetain0", "ONE")>

<cfinclude template="../../view/v_bank/lang_listBanks.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertBank,viewBank,listBanks,listBanksAll,deleteBank,updateBankStatus1,updateBankStatus0,updateBankRetain1,updateBankRetain0")>
<cfset Variables.bankColumnList = Variables.lang_listBanks_title.bankDescription
		& "^" & Variables.lang_listBanks_title.companyID
		& "^" & Variables.lang_listBanks_title.bankStatus
		& "^" & Variables.lang_listBanks_title.bankRetain
		& "^" & Variables.lang_listBanks_title.bankName
		& "^" & Variables.lang_listBanks_title.bankAccountName
		& "^" & Variables.lang_listBanks_title.bankPersonalOrCorporate
		& "^" & Variables.lang_listBanks_title.bankCheckingOrSavings
		& "^" & Variables.lang_listBanks_title.bankAccountNumber
		& "^" & Variables.lang_listBanks_title.bankBranchCityState
		& "^" & Variables.lang_listBanks_title.bankDateCreated
		& "^" & Variables.lang_listBanks_title.bankDateUpdated>

<cfif ListFind(Variables.permissionActionList, "deleteBank")>
	<cfset Variables.bankColumnList = Variables.lang_listBanks_title.deleteBank & "^" & Variables.bankColumnList>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertBank")>
	<cfset Variables.bankColumnList = Variables.bankColumnList & "^" & Variables.lang_listBanks_title.insertBank>
</cfif>
<cfif ListFind(Variables.permissionActionList, "viewBank")>
	<cfset Variables.bankColumnList = Variables.bankColumnList & "^" & Variables.lang_listBanks_title.viewBank>
</cfif>

<cfset Variables.bankColumnCount = DecrementValue(2 * ListLen(Variables.bankColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_bank/dsp_selectBankList.cfm">
