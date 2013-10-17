<cfinclude template="wslang_phone.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertPhone", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_phone.updatePhone>
<cfelse>
	<cfloop Index="field" List="phoneStatus">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset updateFieldList_valid = "phoneAreaCode,phoneNumber,phoneExtension,phoneType,phoneDescription,phoneStatus">
	<cfset returnValue = 0>
	<cfset URL.phoneID = 0>

	<!--- 
	If phoneID is not 0, validate phoneID and update that. Get companyID/userID from existing phone.
	Else determine phoneID if companyID/userID/phoneType/phoneStatus=1 is unique
		If yes, "update".
		Else error.
	If simply updating phoneStatus, update.
	Else update status and re-insert.
	--->

	<!--- Determine existing phoneID --->
	<cfif Application.fn_IsIntegerPositive(Arguments.phoneID)><!--- validate ID --->
		<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhone" ReturnVariable="qry_selectPhone">
			<cfinvokeargument Name="phoneID" Value="#Arguments.phoneID#">
		</cfinvoke>

		<cfif qry_selectPhone.RecordCount is not 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_phone.phoneNotExist>
		<cfelse>
			<cfif qry_selectPhone.companyID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isPhonePermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="companyID" Value="#qry_selectPhone.companyID#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isPhonePermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID" Value="#qry_selectPhone.userID#">
				</cfinvoke>
			</cfif>

			<cfif isPhonePermission is False>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.phoneNotExist>
			<cfelseif qry_selectPhone.phoneStatus is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.phoneStatusInactive>
			<cfelse>
				<cfset URL.phoneID = Arguments.phoneID>
				<cfset Arguments.companyID = qry_selectPhone.companyID>
				<cfset Arguments.userID = qry_selectPhone.userID>
			</cfif>
		</cfif>

	<cfelse><!--- Determine phoneID based on company/user/phoneType --->
		<!--- Determine companyID and userID --->
		<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
			<cfset Arguments.companyID = 0>
		<cfelse>
			<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.companyID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.invalidCompany>
			</cfif>
		</cfif>

		<cfif Arguments.userID is 0 and Arguments.userID_custom is "">
			<cfset Arguments.userID = 0>
		<cfelseif returnValue is 0>
			<cfif Arguments.companyID is not 0>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfelse>
				<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
			</cfif>

			<cfif Arguments.userID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.invalidUser>
			</cfif>
		</cfif>

		<cfif returnValue is 0 and Arguments.companyID is 0 and Arguments.userID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_phone.invalidCompanyOrUser>
		<cfelseif returnValue is 0>
			<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhone">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Application.fn_IsIntegerPositive(Arguments.userID)>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="phoneType" Value="#Arguments.phoneType#">
				<cfinvokeargument Name="phoneStatus" Value="1">
				<cfinvokeargument Name="companyIDorUserID" Value="False">
			</cfinvoke>

			<cfif qry_selectPhone.RecordCount is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.invalidPhone>
			<cfelseif qry_selectPhone.RecordCount gt 1>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_phone.updatePhoneMultiple>
			<cfelse>
				<cfset URL.phoneID = qry_selectPhone.phoneID>
				<cfset Arguments.phoneID = qry_selectPhone.phoneID>
			</cfif><!--- /does phone exist --->
		</cfif><!--- /if company/user are valid --->
	</cfif><!--- /determine phoneID --->

	<cfif returnValue is 0>
		<!--- if updating only non-essential fields, can update instead of re-insert --->
		<cfset isPhoneUpdate = True>
		<cfloop Index="field" List="#Arguments.updateFieldList#">
			<cfif Not ListFind("phoneStatus", field)>
				<cfset isPhoneUpdate = False>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif isPhoneUpdate is True><!--- update existing phone --->
			<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isPhoneUpdated">
				<cfinvokeargument Name="phoneID" Value="#Arguments.phoneID#">
				<cfloop Index="field" List="phoneStatus">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<cfset returnValue = Arguments.phoneID>

		<cfelse><!--- insert new phone --->
			<cfloop Index="field" List="#updateFieldList_valid#">
				<cfif Not ListFind(Arguments.updateFieldList, field)>
					<cfset Arguments[field] = Evaluate("qry_selectPhone.#field#")>
				</cfif>
			</cfloop>

			<cfset Form = Arguments>
			<cfset Variables.doAction = "updatePhone">

			<cfinclude template="wsact_insertPhone.cfm">
		</cfif><!--- /update or insert phone --->
	</cfif><!--- /if valid phone to update --->
</cfif><!--- /user has permission to update phone records --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

