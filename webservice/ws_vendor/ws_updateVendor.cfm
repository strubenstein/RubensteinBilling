<cfinclude template="wslang_vendor.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateVendor", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_vendor.updateVendor>
<cfelse>
	<cfloop Index="field" List="vendorDescriptionHtml,vendorDescriptionDisplay,vendorURLdisplay,vendorStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.vendorID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.vendorID, Arguments.vendorID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.vendorID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_vendor.invalidVendor>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
			<cfinvokeargument Name="vendorID" Value="#Arguments.vendorID#">
			<cfinvokeargument Name="returnVendorDescription" Value="True">
		</cfinvoke>

		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectVendor.companyID)>
		<cfif Arguments.userID is not 0>
			<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>

		<cfset Form = Arguments>
		<cfset URL.vendorID = Arguments.vendorID>
		<cfset Variables.doAction = "updateVendor">
		<cfset Variables.updateFieldList_valid = "userID,vendorCode,vendorDescription,vendorDescriptionHtml,vendorDescriptionDisplay,vendorURL,vendorURLdisplay,vendorName,vendorImage,vendorStatus">

		<cfloop Index="field" List="#Variables.updateFieldList_valid#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectVendor.#field#")>
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
			<cfinvokeargument Name="companyID" Value="#qry_selectVendor.companyID#">
		</cfinvoke>

		<cfif Not IsDefined("fn_IsValidURL")>
			<cfinclude template="../../include/function/fn_IsValidURL.cfm">
		</cfif>

		<cfinclude template="../../control/c_vendor/formParam_insertUpdateVendor.cfm">
		<cfinvoke component="#Application.billingMapping#data.Vendor" method="maxlength_Vendor" returnVariable="maxlength_Vendor" />
		<cfinclude template="../../view/v_vendor/lang_insertUpdateVendor.cfm">
		<cfinclude template="../../control/c_vendor/formValidate_insertUpdateVendor.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="updateVendor" ReturnVariable="isVendorUpdated">
				<cfinvokeargument Name="vendorID" Value="#Arguments.vendorID#">
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
					<cfinvokeargument Name="primaryTargetKey" Value="vendorID">
					<cfinvokeargument Name="targetID" Value="#Arguments.vendorID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif ListFind(Arguments.updateFieldList, "statusID")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="vendorID">
					<cfinvokeargument Name="targetID" Value="#Arguments.vendorID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- archive field changes --->
			<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
				<cfinvokeargument name="primaryTargetKey" value="vendorID">
				<cfinvokeargument name="targetID" value="#Arguments.vendorID#">
				<cfinvokeargument name="userID" value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument name="qry_selectTarget" value="#qry_selectVendor#">
			</cfinvoke>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateVendor">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="company">
				<cfinvokeargument name="primaryTargetKey" value="vendorID">
				<cfinvokeargument name="targetID" value="#Arguments.vendorID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

