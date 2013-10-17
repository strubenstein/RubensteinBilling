<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewUser", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_user.viewUser>
<cfelse>
	<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.userID) is 1 and Arguments.userID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_user.invalidUser>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		</cfinvoke>

		<cfset returnValue = qry_selectUser>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

