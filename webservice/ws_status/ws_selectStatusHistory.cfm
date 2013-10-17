<cfinclude template="wslang_status.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listStatusHistory", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_status.listStatusHistory>
<cfelse>
	<cfinclude template="../../view/v_status/var_statusTargetList.cfm">
	<cfif Not ListFind(Variables.statusTargetList_value, Arguments.primaryTargetKey)>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_status.invalidTargetType>
	<cfelse>
		<cfinclude template="wsact_validateStatusTarget.cfm">

		<cfif Arguments.targetID is 0>
			<cfset returnValue = QueryNew("error")>
			<cfset returnError = Variables.wslang_status.invalidTarget>
		<cfelseif isUserAuthorized is False>
			<cfset returnValue = QueryNew("error")>
			<cfset returnError = Variables.wslang_status.noTargetPermission>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistory" ReturnVariable="qry_selectStatusHistory">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			</cfinvoke>

			<cfset returnValue = qry_selectStatusHistory>
		</cfif><!--- valid target --->
	</cfif><!--- valid status target type --->
</cfif><!--- /user is logged in --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

