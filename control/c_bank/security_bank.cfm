<cfif Not Application.fn_IsIntegerNonNegative(URL.bankID)>
	<cflocation url="#Variables.bankActionList#&error_bank=noBank" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user", URL.control))>
	<cflocation url="#Variables.bankActionList#&error_bank=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company", URL.control))>
	<cflocation url="#Variables.bankActionList#&error_bank=invalidUser" AddToken="No">
<cfelseif URL.userID is 0 and URL.companyID is 0>
	<cflocation url="#Variables.bankActionList#&error_bank=invalidCompany" AddToken="No">
<cfelseif URL.bankID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="checkBankPermission" ReturnVariable="isBankPermission">
		<cfinvokeargument Name="bankID" Value="#URL.bankID#">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
	</cfinvoke>

	<cfif isBankPermission is False>
		<cflocation url="#Variables.bankActionList#&error_bank=invalidBank" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBank" ReturnVariable="qry_selectBank">
			<cfinvokeargument Name="bankID" Value="#URL.bankID#">
		</cfinvoke>

		<cfif qry_selectBank.companyID is not URL.companyID and qry_selectBank.userID is not URL.userID>
			<cflocation url="#Variables.bankActionList#&error_bank=invalidBank" AddToken="No">
		<cfelseif qry_selectBank.bankStatus is 0 and Variables.doAction is "insertBank">
			<cflocation url="#Variables.bankActionList#&error_bank=invalidBankStatus" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listBanks,listBanksAll,insertBank", Variables.doAction)>
	<cflocation url="#Variables.bankActionList#&error_bank=noBank" AddToken="No">
</cfif>
