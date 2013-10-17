<cfinclude template="wslang_company.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertCompany", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_company.insertCompany>
<cfelse>
	<cfloop Index="field" List="companyStatus,companyIsTaxExempt,companyIsCustomer">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<cfset Form = Arguments>
	<cfinclude template="wsact_insertCompany.cfm">

	<cfif returnValue gt 0>
		<cfset Arguments.companyID = returnValue>

		<!--- custom fields --->
		<cfif Trim(Arguments.customField) is not "">
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="companyID">
				<cfinvokeargument Name="targetID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="customField" Value="#Arguments.customField#">
			</cfinvoke>
		</cfif>

		<!--- custom status --->
		<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="companyID">
				<cfinvokeargument Name="targetID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
				<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
				<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
				<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
			<cfinvokeargument name="doAction" value="insertCompany">
			<cfinvokeargument name="isWebService" value="True">
			<cfinvokeargument name="doControl" value="company">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#Arguments.companyID#">
		</cfinvoke>

		<cfset returnValue = Arguments.companyID>
	</cfif><!--- company was successfully created --->
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

