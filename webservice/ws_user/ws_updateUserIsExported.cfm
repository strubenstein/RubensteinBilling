<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportUsers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_user.exportUsers>
<cfelse>
	<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.userID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_user.invalidUser>
	<cfelseif Arguments.userIsExported is not "" and Not ListFind("0,1", Arguments.userIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_user.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUserIsExported" ReturnVariable="isUserExported">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
			<cfinvokeargument Name="userIsExported" Value="#Arguments.userIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


