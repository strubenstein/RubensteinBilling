<!--- user, billing address, shipping address, phone, fax, groups, custom fields, custom status, subscriberNotify --->
<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValueXml = "">
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertUser", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValueXml = "">
	<cfset returnError = Variables.wslang_user.insertUser>
<cfelse>
	<cfloop Index="field" List="userStatus,userNewsletterStatus,userNewsletterHtml,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyDoc">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValueXml = "">
		<cfset returnError = Variables.wslang_user.invalidCompany>
	<cfelse>
		<cfset permissionActionList = Application.objWebServiceSession.isUserAuthorizedListWS("insertUser,insertAddress,insertPhone,insertCreditCard,insertBank,insertGroupUser,insertSubscriberNotify", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>

		<cfset Form = Arguments>
		<cfset returnValueXml = "">

		<!--- user --->
		<cfinclude template="wsact_insertUser.cfm">
		<cfif returnValue is 0>
			<cfset returnValueXml = "">
		<cfelse>
			<cfset Arguments.userID = returnValue>
			<cfset returnValueXml = returnValueXml & "<userID>#Arguments.userID#</userID>">

			<!--- phone --->
			<cfset Arguments.phoneID = 0>
			<cfif ListFind(Arguments.insertExtendedFieldTypeList, "phoneID") and ListFind(permissionActionList, "insertPhone")>
				<cfset URL.phoneID = 0>
				<cfinclude template="../ws_phone/wsact_insertPhone.cfm">
				<cfif returnValue gt 0>
					<cfset Arguments.phoneID = returnValue>
					<cfset returnValueXml = returnValueXml & "<phoneID>#Arguments.phoneID#</phoneID>">
				</cfif>
			</cfif>

			<!--- fax --->
			<cfset Arguments.faxID = 0>
			<cfif ListFind(Arguments.insertExtendedFieldTypeList, "faxID") and ListFind(permissionActionList, "insertPhone")>
				<cfset Arguments.phoneExtension = "">
				<cfset Arguments.phoneType = "fax">
				<cfloop Index="field" List="AreaCode,Number,Description">
					<cfset Arguments["Phone#field#"] = Arguments["Fax#field#"]>
				</cfloop>
	
				<cfset URL.phoneID = 0>
				<cfinclude template="../ws_phone/wsact_insertPhone.cfm">
				<cfif returnValue gt 0>
					<cfset Arguments.faxID = returnValue>
					<cfset returnValueXml = returnValueXml & "<faxID>#Arguments.faxID#</faxID>">
				</cfif>
			</cfif>

			<!--- address: billing and maybe shipping --->
			<cfset Arguments.addressID_billing = 0>
			<cfset Arguments.addressID_shipping = 0>
			<cfset URL.addressID = 0>
			<cfset Variables.doAction = "insertAddress">

			<cfif ListFind(Arguments.insertExtendedFieldTypeList, "addressID_billing") and ListFind(permissionActionList, "insertAddress")>
				<cfloop Index="field" List="addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country">
					<cfset Arguments[field] = Arguments["#field#_billing"]>
				</cfloop>

				<cfset Variables.doAction = "insertAddress">
				<cfset Arguments.addressTypeBilling = 1>
				<cfif Arguments.shippingAddressSameAsBillingAddress is True>
					<cfset Arguments.addressTypeShipping = 1>
				<cfelse>
					<cfset Arguments.addressTypeShipping = 0>
				</cfif>

				<cfinclude template="../ws_address/wsact_insertUpdateAddress.cfm">
				<cfif returnValue gt 0>
					<cfset Arguments.addressID_billing = returnValue>
					<cfset returnValueXml = returnValueXml & "<addressID_billing>#Arguments.addressID_billing#</addressID_billing>">

					<cfif Arguments.addressTypeShipping is 1>
						<cfset Arguments.addressID_shipping = Arguments.addressID_billing>
						<cfset returnValueXml = returnValueXml & "<addressID_shipping>#Arguments.addressID_shipping#</addressID_shipping>">
					</cfif>
				</cfif>
			</cfif>

			<!--- shipping address --->
			<cfif Arguments.addressID_shipping is 0 and ListFind(Arguments.insertExtendedFieldTypeList, "addressID_shipping") and ListFind(permissionActionList, "insertAddress")>
				<cfloop Index="field" List="addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country">
					<cfset Arguments[field] = Arguments["#field#_shipping"]>
				</cfloop>
	
				<cfset Variables.doAction = "insertAddress">
				<cfset Arguments.addressTypeBilling = 0>
				<cfset Arguments.addressTypeShipping = 1>
				<cfinclude template="../ws_address/wsact_insertUpdateAddress.cfm">
				<cfif returnValue gt 0>
					<cfset Arguments.addressID_shipping = returnValue>
					<cfset returnValueXml = returnValueXml & "<addressID_shipping>#Arguments.addressID_shipping#</addressID_shipping>">
				</cfif>
			</cfif>
		</cfif><!--- /user was valid --->

		<!--- custom fields --->
		<cfif Trim(Arguments.customField) is not "">
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="userID">
				<cfinvokeargument Name="targetID" Value="#Arguments.userID#">
				<cfinvokeargument Name="customField" Value="#Arguments.customField#">
			</cfinvoke>
		</cfif>

		<!--- custom status --->
		<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
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

		<!--- check for trigger --->
		<cfset Variables.doAction = "insertUser">
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
			<cfinvokeargument name="doAction" value="insertUser">
			<cfinvokeargument name="isWebService" value="True">
			<cfinvokeargument name="doControl" value="company">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#Arguments.userID#">
		</cfinvoke>

		<!--- group(s) --->
		<cfif ListFind(Arguments.insertExtendedFieldTypeList, "groupID") and ListFind(permissionActionList, "insertGroupCompany")>
			<cfset Arguments.primaryTargetKey = "userID">
			<cfset Arguments.targetID = Arguments.userID>
			<cfinclude template="../ws_group/wsact_insertGroupTarget.cfm">
		</cfif>

		<!--- subscriber notify --->
		<cfif ListFind(permissionActionList, "insertSubscriberNotify")
				and (Arguments.subscriberNotifyEmail is 1 or Arguments.subscriberNotifyEmailHtml is 1 or Arguments.subscriberNotifyPdf is 1
					or Arguments.subscriberNotifyDoc is 1 or Arguments.subscriberNotifyFax is 1
					or Arguments.subscriberNotifyBillingAddress is 1 or Arguments.subscriberNotifyShippingAddress is 1)>
			<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.subscriberID gt 0>
				<cfset Arguments.phoneID = Arguments.faxID>
				<!--- validate subscriber belongs to this company? --->
				<cfinclude template="../ws_subscription/wsact_insertSubscriberNotify.cfm">
			</cfif>
		</cfif><!--- user info was valid --->
	</cfif><!--- companyID was valid --->
</cfif><!--- user is logged in and has permission to insert user --->

<!--- insert root xml tag into return variable --->
<cfset returnValue = "<xml>" & returnValueXml & "</xml>">

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

