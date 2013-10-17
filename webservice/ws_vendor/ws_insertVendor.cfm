<cfinclude template="wslang_vendor.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertVendor", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_vendor.insertVendor>
<cfelse>
	<cfloop Index="field" List="vendorDescriptionHtml,vendorDescriptionDisplay,vendorURLdisplay,vendorStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_vendor.invalidCompany>
	<cfelse>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
		<cfif Arguments.userID is not 0>
			<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>

		<cfset Form = Arguments>
		<cfset URL.vendorID = 0>
		<cfset Variables.doAction = "insertVendor">

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfinvoke>

		<cfif Not IsDefined("fn_IsValidURL")>
			<cfinclude template="../../include/function/fn_IsValidURL.cfm">
		</cfif>

		<cfinclude template="../../control/c_vendor/formParam_insertUpdateVendor.cfm">
		<cfinvoke component="#Application.billingMapping#data.Vendor" method="maxlength_Vendor" returnVariable="maxlength_Vendor" />
		<cfinclude template="../../view/v_vendor/lang_insertUpdateVendor.cfm">
		<cfinclude template="../../control/c_vendor/formValidate_insertUpdateVendor.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="insertVendor" ReturnVariable="newVendorID">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="vendorCode" Value="#Arguments.vendorCode#">
				<cfinvokeargument Name="vendorDescription" Value="#Arguments.vendorDescription#">
				<cfinvokeargument Name="vendorDescriptionHtml" Value="#Arguments.vendorDescriptionHtml#">
				<cfinvokeargument Name="vendorDescriptionDisplay" Value="#Arguments.vendorDescriptionDisplay#">
				<cfif Arguments.vendorURL is Variables.default_vendorURL>
					<cfinvokeargument Name="vendorURL" Value="">
				<cfelse>
					<cfinvokeargument Name="vendorURL" Value="#Arguments.vendorURL#">
				</cfif>
				<cfinvokeargument Name="vendorURLdisplay" Value="#Arguments.vendorURLdisplay#">
				<cfinvokeargument Name="vendorName" Value="#Arguments.vendorName#">
				<cfinvokeargument Name="vendorImage" Value="#Arguments.vendorImage#">
				<cfinvokeargument Name="vendorStatus" Value="#Arguments.vendorStatus#">
				<cfinvokeargument Name="vendorID_custom" Value="#Arguments.vendorID_custom#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="companyIsVendor" Value="1">
			</cfinvoke>

			<cfset Arguments.vendorID = newVendorID>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "">
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="vendorID">
					<cfinvokeargument Name="targetID" Value="#newVendorID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="vendorID">
					<cfinvokeargument Name="targetID" Value="#newVendorID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertVendor">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="company">
				<cfinvokeargument name="primaryTargetKey" value="vendorID">
				<cfinvokeargument name="targetID" value="#newVendorID#">
			</cfinvoke>

			<cfset returnValue = Arguments.vendorID>
		</cfif><!--- vendor was successfully created --->
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

