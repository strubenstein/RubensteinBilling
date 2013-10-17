<cfinclude template="wslang_bank.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateBank", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_bank.updateBank>
<cfelse>
	<cfloop Index="field" List="bankStatus,bankRetain,bankPersonalOrCorporate,bankCheckingOrSavings">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset updateFieldList_valid = "bankName,bankBranch,bankBranchCity,bankBranchState,bankBranchCountry,bankBranchContactName,bankBranchPhone,bankBranchFax,bankRoutingNumber,bankAccountNumber,bankAccountName,bankCheckingOrSavings,bankPersonalOrCorporate,bankDescription,bankAccountType,bankRetain,addressID">
	<cfset returnValue = 0>
	<cfset URL.bankID = 0>

	<!--- 
	If bankID is not 0, validate bankID and update that. Get companyID/userID from existing bank.
	Else determine bankID if companyID/userID/bankPersonalOrCorporate,bankCheckingOrSavings/bankStatus=1 is unique
		If yes, "update".
		Else error.
	If simply updating bankStatus, bankPersonalOrCorporate, bankCheckingOrSavings and/or bankRetain, update.
	Else update status and re-insert.
	--->

	<!--- Determine existing bankID --->
	<cfif Application.fn_IsIntegerPositive(Arguments.bankID)><!--- validate ID --->
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBank" ReturnVariable="qry_selectBank">
			<cfinvokeargument Name="bankID" Value="#Arguments.bankID#">
		</cfinvoke>

		<cfif qry_selectBank.RecordCount is not 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_bank.bankNotExist>
		<cfelse>
			<cfif qry_selectBank.companyID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isBankPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="companyID" Value="#qry_selectBank.companyID#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isBankPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID" Value="#qry_selectBank.userID#">
				</cfinvoke>
			</cfif>

			<cfif isBankPermission is False>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.bankNotExist>
			<cfelseif qry_selectBank.bankStatus is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.bankStatusInactive>
			<cfelse>
				<cfset URL.bankID = Arguments.bankID>
				<cfset Arguments.companyID = qry_selectBank.companyID>
				<cfset Arguments.userID = qry_selectBank.userID>
			</cfif>
		</cfif>

	<cfelse><!--- Determine bankID based on company/user/bankPersonalOrCorporate,bankCheckingOrSavings --->
		<!--- Determine companyID and userID --->
		<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
			<cfset Arguments.companyID = 0>
		<cfelse>
			<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.companyID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.invalidCompany>
			</cfif>
		</cfif>

		<cfif Arguments.userID is 0 and Arguments.userID_custom is "">
			<cfset Arguments.userID = 0>
		<cfelseif returnValue is 0>
			<cfif Arguments.companyID is not 0>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfelse>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
			</cfif>

			<cfif Arguments.userID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.invalidUser>
			</cfif>
		</cfif>

		<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.userID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_bank.invalidCompanyOrUser>
		<cfelseif returnValue is 0>
			<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBank">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Application.fn_IsIntegerPositive(Arguments.userID)>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="bankPersonalOrCorporate" Value="#Arguments.bankPersonalOrCorporate#">
				<cfinvokeargument Name="bankCheckingOrSavings" Value="#Arguments.bankCheckingOrSavings#">
				<cfinvokeargument Name="bankStatus" Value="1">
				<cfinvokeargument Name="companyIDorUserID" Value="False">
			</cfinvoke>

			<cfif qry_selectBank.RecordCount is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.invalidBank>
			<cfelseif qry_selectBank.RecordCount gt 1>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_bank.updateBankMultiple>
			<cfelse>
				<cfset URL.bankID = qry_selectBank.bankID>
				<cfset Arguments.bankID = qry_selectBank.bankID>
			</cfif><!--- /does bank exist --->
		</cfif><!--- /if company/user are valid --->
	</cfif><!--- /determine bankID --->

	<cfif returnValue is 0>
		<!--- if updating only non-essential fields, can update instead of re-insert --->
		<cfset isBankUpdate = True>
		<cfloop Index="field" List="#Arguments.updateFieldList#">
			<cfif Not ListFind("bankStatus,bankRetain,bankPersonalOrCorporate,bankCheckingOrSavings", field)>
				<cfset isBankUpdate = False>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif isBankUpdate is True><!--- update existing bank --->
			<cfinvoke Component="#Application.billingMapping#data.Bank" Method="updateBank" ReturnVariable="isBankUpdated">
				<cfinvokeargument Name="bankID" Value="#Arguments.bankID#">
				<cfloop Index="field" List="bankStatus,bankRetain,bankPersonalOrCorporate,bankCheckingOrSavings">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<cfset returnValue = Arguments.bankID>

		<cfelse><!--- insert new bank --->
			<cfloop Index="field" List="#updateFieldList_valid#">
				<cfif Not ListFind(Arguments.updateFieldList, field)>
					<cfset Arguments[field] = Evaluate("qry_selectBank.#field#")>
				</cfif>
			</cfloop>

			<cfset Form = Arguments>
			<cfset Variables.doAction = "updateBank">

			<cfinclude template="wsact_insertBank.cfm">
		</cfif><!--- /update or insert bank --->
	</cfif><!--- /if valid bank to update --->
</cfif><!--- /user has permission to update bank accounts --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">
