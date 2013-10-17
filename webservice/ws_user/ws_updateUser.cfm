<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateUser", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_user.updateUser>
<cfelse>
	<cfloop Index="field" List="userStatus,userNewsletterStatus,userNewsletterHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.userID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_user.invalidUser>
	<cfelse>
		<cfset Form = Arguments>
		<cfset URL.userID = Arguments.userID>
		<cfset Variables.doAction = "updateUser">

		<cfset Variables.updateFieldList_valid = "username,password,userStatus,firstName,middleName,lastName,suffix,salutation,email,jobTitle,jobDepartment,jobDivision,userNewsletterStatus,userNewsletterHtml">
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
			<cfinvokeargument Name="returnPassword" Value="True">
		</cfinvoke>

		<cfloop Index="field" List="#Variables.updateFieldList_valid#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectUser.#field#")>
			</cfif>
		</cfloop>

		<cfset Form.salutation_select = "">
		<cfset Form.salutation_text = Form.salutation>
		<cfset Form.suffix_select = "">
		<cfset Form.suffix_text = Form.suffix>
		<cfset Form.jobDepartment_select = "">
		<cfset Form.jobDepartment_text = Form.jobDepartment>
		<cfset Form.passwordVerify = Form.password>

		<cfif Not IsDefined("fn_IsValidEmail")>
			<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
		</cfif>

		<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
		<cfinclude template="../../view/v_user/lang_insertUpdateUser.cfm">
		<cfinclude template="../../control/c_user/formValidate_insertUpdateUser.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
				<cfinvokeargument Name="userID" Value="#Arguments.userID#">
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
					<cfinvokeargument Name="primaryTargetKey" Value="userID">
					<cfinvokeargument Name="targetID" Value="#Arguments.userID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif ListFind(Arguments.updateFieldList, "statusID")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="userID">
					<cfinvokeargument Name="targetID" Value="#Arguments.userID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- archive field changes --->
			<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
				<cfinvokeargument name="primaryTargetKey" value="userID">
				<cfinvokeargument name="targetID" value="#Arguments.userID#">
				<cfinvokeargument name="userID" value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument name="qry_selectTarget" value="#qry_selectUser#">
			</cfinvoke>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateUser">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="user">
				<cfinvokeargument name="primaryTargetKey" value="userID">
				<cfinvokeargument name="targetID" value="#Arguments.userID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

