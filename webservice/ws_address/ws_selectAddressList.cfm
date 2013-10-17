<cfinclude template="wslang_address.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listAddresses", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_address.viewAddress>
<cfelse>
	<cfloop Index="field" List="addressTypeShipping,addressTypeBilling,addressStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.companyID) is 1 and Arguments.companyID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_address.invalidCompany>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
			<cfloop Index="field" List="userID,regionID">
				<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfloop Index="field" List="addressStatus,addressTypeShipping,addressTypeBilling">
				<cfif ListFind(Arguments.searchFieldList, field) and ListFind("0,1", Arguments[field])>
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfloop Index="field" List="addressName,addressDescription">
				<cfif ListFind(Arguments.searchFieldList, field) and Trim(Arguments[field]) is not "">
					<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
				</cfif>
			</cfloop>
			<cfif ListFind(Arguments.searchFieldList, field) and Application.fn_IsIntegerList(Arguments.userID) and Arguments.userID is not 0>
				<cfinvokeargument Name="companyIDorUserID" Value="False">
			<cfelse>
				<cfinvokeargument Name="companyIDorUserID" Value="True">
			</cfif>
		</cfinvoke>

		<cfset returnValue = qry_selectAddressList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

