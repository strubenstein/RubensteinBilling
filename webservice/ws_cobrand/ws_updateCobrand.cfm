<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateCobrand", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_cobrand.updateCobrand>
<cfelse>
	<cfloop Index="field" List="cobrandStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.cobrandID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_cobrand.invalidCobrand>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
			<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
		</cfinvoke>

		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectCobrand.companyID)>
		<cfif Arguments.userID is not 0>
			<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>

		<cfset Form = Arguments>
		<cfset URL.cobrandID = Arguments.cobrandID>
		<cfset Variables.doAction = "updateCobrand">
		<cfset Variables.updateFieldList_valid = "userID,cobrandCode,cobrandURL,cobrandName,cobrandStatus,cobrandTitle,cobrandDomain,cobrandDirectory,cobrandImage">

		<cfloop Index="field" List="#Variables.updateFieldList_valid#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectCobrand.#field#")>
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#qry_selectCobrand.companyID#">
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
			<cfset returnValue = False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="updateCobrand" ReturnVariable="isCobrandUpdated">
				<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfloop Index="field" List="#Variables.updateFieldList_valid#">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "" and ListFind(Arguments.updateFieldList, "customField")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="cobrandID">
					<cfinvokeargument Name="targetID" Value="#Arguments.cobrandID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif ListFind(Arguments.updateFieldList, "statusID")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="cobrandID">
					<cfinvokeargument Name="targetID" Value="#Arguments.cobrandID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- archive field changes --->
			<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
				<cfinvokeargument name="primaryTargetKey" value="cobrandID">
				<cfinvokeargument name="targetID" value="#Arguments.cobrandID#">
				<cfinvokeargument name="userID" value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument name="qry_selectTarget" value="#qry_selectCobrand#">
			</cfinvoke>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateCobrand">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="cobrand">
				<cfinvokeargument name="primaryTargetKey" value="cobrandID">
				<cfinvokeargument name="targetID" value="#Arguments.cobrandID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

