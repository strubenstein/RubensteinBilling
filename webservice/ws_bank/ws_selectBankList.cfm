<cfinclude template="wslang_bank.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listBanks", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_bank.listBanks>
<cfelse>
	<cfloop Index="field" List="bankPersonalOrCorporate,bankRetain,bankCheckingOrSavings,bankStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfif ListFind(Arguments.searchFieldList, "companyID") or ListFind(Arguments.searchFieldList, "companyID_custom")>
		<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	</cfif>
	<cfif ListFind(Arguments.searchFieldList, "userID") or ListFind(Arguments.searchFieldList, "userID_custom")>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
	</cfif>
	<cfif ListFind(Arguments.searchFieldList, "subscriberID") or ListFind(Arguments.searchFieldList, "subscriberID_custom")>
		<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	</cfif>

	<cfif returnError is not "">
		<cfset returnValue = QueryNew("error")>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="returnCompanyFields" Value="True">
			<cfloop Index="field" List="companyID,userID,subscriberID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field]) and ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfloop Index="field" List="bankRetain,bankStatus,bankPersonalOrCorporate,bankCheckingOrSavings">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field]) and ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfloop Index="field" List="bankDescription,bankAccountType">
				<cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "" and ListFind(Arguments.searchFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
		</cfinvoke>

		<cfset returnValue = qry_selectBankList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


