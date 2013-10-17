<cfinclude template="wslang_address.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertAddress", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_address.updateAddress>
<cfelse>
	<cfloop Index="field" List="addressStatus,addressTypeShipping,addressTypeBilling">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset updateFieldList_valid = "addressName,addressDescription,addressTypeShipping,addressTypeBilling,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country,addressStatus">
	<cfset returnValue = 0>
	<cfset URL.addressID = 0>

	<!--- 
	If addressID is not 0, validate addressID and update that. Get companyID/userID from existing address.
	Else determine addressID if companyID/userID/addressTypeShipping/addressTypeBilling/addressStatus=1 is unique
		If yes, "update".
		Else error.
	If simply updating addressStatus, addressTypeBilling and/or addressTypeShipping, update.
	Else update status and re-insert.
	--->

	<!--- Determine existing addressID --->
	<cfif Application.fn_IsIntegerPositive(Arguments.addressID)><!--- validate ID --->
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
			<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
		</cfinvoke>

		<cfif qry_selectAddress.RecordCount is not 1>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_address.addressNotExist>
		<cfelse>
			<cfif qry_selectAddress.companyID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="checkCompanyPermission" ReturnVariable="isAddressPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="companyID" Value="#qry_selectAddress.companyID#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isAddressPermission">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID" Value="#qry_selectAddress.userID#">
				</cfinvoke>
			</cfif>

			<cfif isAddressPermission is False>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_address.addressNotExist>
			<cfelseif qry_selectAddress.addressStatus is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_address.addressStatusInactive>
			<cfelse>
				<cfset URL.addressID = Arguments.addressID>
				<cfset Arguments.companyID = qry_selectAddress.companyID>
				<cfset Arguments.userID = qry_selectAddress.userID>
			</cfif>
		</cfif>

	<cfelse><!--- Determine addressID based on company/user/addressTypeBilling/addressTypeShipping --->
		<!--- Determine companyID and userID --->
		<cfif Arguments.companyID is 0 and Arguments.companyID_custom is "">
			<cfset Arguments.companyID = 0>
		<cfelse>
			<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.companyID is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_address.invalidCompany>
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
				<cfset returnError = Variables.wslang_address.invalidUser>
			</cfif>
		</cfif>

		<cfif Arguments.companyID is 0 and Arguments.userID is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_address.invalidCompanyOrUser>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddress">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Application.fn_IsIntegerPositive(Arguments.userID)>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="addressTypeShipping" Value="#Arguments.addressTypeShipping#">
				<cfinvokeargument Name="addressTypeBilling" Value="#Arguments.addressTypeBilling#">
				<cfinvokeargument Name="addressStatus" Value="1">
				<cfinvokeargument Name="companyIDorUserID" Value="False">
			</cfinvoke>

			<cfif qry_selectAddress.RecordCount is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_address.invalidAddress>
			<cfelseif qry_selectAddress.RecordCount gt 1>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_address.updateAddressMultiple>
			<cfelse>
				<cfset URL.addressID = qry_selectAddress.addressID>
				<cfset Arguments.addressID = qry_selectAddress.addressID>
			</cfif><!--- /does address exist --->
		</cfif><!--- /if company/user are valid --->
	</cfif><!--- /determine addressID --->

	<cfif returnValue is 0>
		<!--- if updating only non-essential fields, can update instead of re-insert --->
		<cfset isAddressUpdate = True>
		<cfloop Index="field" List="#Arguments.updateFieldList#">
			<cfif Not ListFind("addressStatus,addressTypeShipping,addressTypeBilling", field)>
				<cfset isAddressUpdate = False>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif isAddressUpdate is True><!--- update existing address --->
			<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
				<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
				<cfloop Index="field" List="addressStatus,addressTypeShipping,addressTypeBilling">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
			</cfinvoke>

			<cfset returnValue = Arguments.addressID>

		<cfelse><!--- insert new address --->
			<cfloop Index="field" List="#updateFieldList_valid#">
				<cfif Not ListFind(Arguments.updateFieldList, field)>
					<cfset Arguments[field] = Evaluate("qry_selectAddress.#field#")>
				</cfif>
			</cfloop>

			<cfset Form = Arguments>
			<cfset Variables.doAction = "updateAddress">

			<cfinclude template="wsact_insertUpdateAddress.cfm">
		</cfif><!--- /update or insert address --->
	</cfif><!--- /if valid address to update --->
</cfif><!--- /if logged in and permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">
