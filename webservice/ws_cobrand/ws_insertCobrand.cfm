
<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertCobrand", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_cobrand.insertCobrand>
<cfelse>
	<cfloop Index="field" List="cobrandStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_cobrand.invalidCompany>
	<cfelse>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
		<cfif Arguments.userID is not 0>
			<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>

		<cfset Form = Arguments>
		<cfset URL.cobrandID = 0>
		<cfset Variables.doAction = "insertCobrand">

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfinvoke>

		<cfif Not IsDefined("fn_IsValidURL")>
			<cfinclude template="../../include/function/fn_IsValidURL.cfm">
		</cfif>
		<cfif Not IsDefined("fn_GetDomainFromURL")>
			<cfinclude template="../../include/function/fn_GetDomainFromURL.cfm">
		</cfif>

		<cfinclude template="../../control/c_cobrand/formParam_insertUpdateCobrand.cfm">
		<cfinvoke component="#Application.billingMapping#data.Cobrand" method="maxlength_Cobrand" returnVariable="maxlength_Cobrand" />
		<cfinclude template="../../view/v_cobrand/lang_insertUpdateCobrand.cfm">
		<cfinclude template="../../control/c_cobrand/formValidate_insertUpdateCobrand.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="insertCobrand" ReturnVariable="newCobrandID">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="cobrandCode" Value="#Arguments.cobrandCode#">
				<cfinvokeargument Name="cobrandTitle" Value="#Arguments.cobrandTitle#">
				<cfinvokeargument Name="cobrandDomain" Value="#Arguments.cobrandDomain#">
				<cfinvokeargument Name="cobrandDirectory" Value="#Arguments.cobrandDirectory#">
				<cfinvokeargument Name="cobrandURL" Value="#Arguments.cobrandURL#">
				<cfinvokeargument Name="cobrandName" Value="#Arguments.cobrandName#">
				<cfinvokeargument Name="cobrandImage" Value="#Arguments.cobrandImage#">
				<cfinvokeargument Name="cobrandStatus" Value="#Arguments.cobrandStatus#">
				<cfinvokeargument Name="cobrandID_custom" Value="#Arguments.cobrandID_custom#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="companyIsCobrand" Value="1">
			</cfinvoke>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "">
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="cobrandID">
					<cfinvokeargument Name="targetID" Value="#newCobrandID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="cobrandID">
					<cfinvokeargument Name="targetID" Value="#newCobrandID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertCobrand">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="cobrand">
				<cfinvokeargument name="primaryTargetKey" value="cobrandID">
				<cfinvokeargument name="targetID" value="#newCobrandID#">
			</cfinvoke>

			<cfset returnValue = newCobrandID>
		</cfif><!--- cobrand was successfully created --->
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

