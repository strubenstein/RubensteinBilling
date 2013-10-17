<cfinclude template="wslang_phone.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertPhone", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_phone.insertPhone>
<cfelse>
	<cfset returnValue = 0>

	<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
		<cfset Arguments.companyID = 0>
	<cfelse>
		<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
		<cfif Arguments.companyID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_phone.invalidCompany>
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
			<cfset returnError = Variables.wslang_phone.invalidUser>
		</cfif>
	</cfif>

	<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.userID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_phone.invalidCompanyOrUser>
	<cfelseif returnValue is 0>
		<cfset Form = Arguments>
		<cfset URL.phoneID = 0>
		<cfinclude template="wsact_insertPhone.cfm">
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

