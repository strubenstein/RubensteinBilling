<cfinclude template="../ws_user/wsact_insertUser.cfm">
<cfif returnValue gt 0>
	<cfset Arguments.userID = returnValue>
	<cfset returnValueXml = returnValueXml & "<userID>#Arguments.userID#</userID>">

	<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
	</cfinvoke>

	<!--- User custom fields --->
	<cfif Trim(Arguments.customField_user) is not "">
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="userID">
			<cfinvokeargument Name="targetID" Value="#Arguments.userID#">
			<cfinvokeargument Name="customField" Value="#Arguments.customField_company#">
		</cfinvoke>
	</cfif>

	<!--- User custom status --->
	<cfif Arguments.statusID_user is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID_user") or ListFind(Arguments.useCustomIDFieldList, "statusID_user_custom")>
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="userID">
			<cfinvokeargument Name="targetID" Value="#Arguments.userID#">
			<cfinvokeargument Name="useCustomIDFieldList" Value="#ReplaceNoCase(ReplaceNoCase(Arguments.useCustomIDFieldList, 'statusID_user', 'statusID', '"ALL'), 'statusID_user_custom', 'statusID_custom', 'ALL')#">
			<cfinvokeargument Name="statusID" Value="#Arguments.statusID_user#">
			<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_user_custom#">
			<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment_user#">
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
</cfif>

