<cfinclude template="wslang_address.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertAddress", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_address.insertAddress>
<cfelse>
	<cfloop Index="field" List="addressTypeShipping,addressTypeBilling">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
		<cfset Arguments.companyID = 0>
	<cfelse>
		<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.companyID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_address.invalidCompany>
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
			<cfset returnError = Variables.wslang_address.invalidUser>
		</cfif>
	</cfif>

	<cfif Arguments.companyID is 0 and Arguments.userID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_address.invalidCompanyOrUser>
	<cfelse>
		<cfset Form = Arguments>
		<cfset Variables.doAction = "insertAddress">
		<cfset URL.addressID = 0>

		<cfinclude template="wsact_insertUpdateAddress.cfm">
	</cfif><!--- /if ok to insert address --->
</cfif><!--- /if logged in and permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

