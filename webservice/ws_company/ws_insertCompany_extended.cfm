<!--- company, primary user, billing address, shipping address, phone, fax, credit card, bank, groups, custom fields, custom status, subscriber, subscriberNotify, subscriberPayment, and payflow --->
<cfinclude template="wslang_company.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValueXml = "">
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertCompany", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValueXml = "">
	<cfset returnError = Variables.wslang_company.insertCompany>
<cfelse>
	<cfloop Index="field" List="companyStatus,companyIsTaxExempt,companyIsCustomer,userStatus,userNewsletterStatus,userNewsletterHtml,bankPersonalOrCorporate,bankRetain,creditCardRetain,subscriberPaymentViaCreditCard,subscriberPaymentViaBank,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc,subscriberNotifyFax,subscriberNotifyBillingAddress,subscriberNotifyShippingAddress">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset permissionActionList = Application.objWebServiceSession.isUserAuthorizedListWS("insertUser,insertAddress,insertPhone,insertCreditCard,insertBank,insertGroupCompany,insertSubscriber,insertPayflowCompany,insertSubscriberNotify", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>

	<cfset Form = Arguments>
	<cfset returnValueXml = "">

	<cfinclude template="wsact_insertCompany.cfm">

	<cfif returnValue gt 0>
		<cfset Arguments.companyID = returnValue>
		<cfset returnValueXml = returnValueXml & "<companyID>#Arguments.companyID#</companyID>">

		<!--- Company custom fields --->
		<cfif Trim(Arguments.customField_company) is not "">
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="companyID">
				<cfinvokeargument Name="targetID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="customField" Value="#Arguments.customField_company#">
			</cfinvoke>
		</cfif>

		<!--- Company custom status --->
		<cfif Arguments.statusID_company is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID_company") or ListFind(Arguments.useCustomIDFieldList, "statusID_company_custom")>
			<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
				<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="primaryTargetKey" Value="companyID">
				<cfinvokeargument Name="targetID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="useCustomIDFieldList" Value="#ReplaceNoCase(ReplaceNoCase(Arguments.useCustomIDFieldList, 'statusID_company', 'statusID', '"ALL'), 'statusID_company_custom', 'statusID_custom', 'ALL')#">
				<cfinvokeargument Name="statusID" Value="#Arguments.statusID_company#">
				<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_company_custom#">
				<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment_company#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfset Variables.doAction = "insertCompany">
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
			<cfinvokeargument name="doAction" value="insertCompany">
			<cfinvokeargument name="isWebService" value="True">
			<cfinvokeargument name="doControl" value="company">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#Arguments.companyID#">
		</cfinvoke>

		<!--- user --->
		<cfif ListFind(Arguments.insertExtendedFieldTypeList, "userID") and ListFind(permissionActionList, "insertUser")>
			<cfinclude template="wsact_insertCompany_extendedUser.cfm">
		</cfif>

		<cfinclude template="wsact_insertCompany_extendedPhone.cfm">
		<cfinclude template="wsact_insertCompany_extendedAddress.cfm">
		<cfinclude template="wsact_insertCompany_extendedCreditBank.cfm">

		<!--- group(s) --->
		<cfif ListFind(Arguments.insertExtendedFieldTypeList, "groupID") and ListFind(permissionActionList, "insertGroupCompany")>
			<cfset Arguments.primaryTargetKey = "companyID">
			<cfset Arguments.targetID = Arguments.companyID>
			<cfinclude template="../ws_group/wsact_insertGroupTarget.cfm">
		</cfif>

		<!--- payflow --->
		<cfif ListFind(Arguments.insertExtendedFieldTypeList, "payflowID") and ListFind(permissionActionList, "insertPayflowCompany")>
			<cfset Arguments.primaryTargetKey = "companyID">
			<cfset Arguments.targetID = Arguments.companyID>
			<cfinclude template="../ws_payflow/wsact_insertPayflowTarget.cfm">
		</cfif>

		<!--- subscriber and payment --->
		<cfif ListFind(Arguments.insertExtendedFieldTypeList, "subscriberID") and ListFind(permissionActionList, "insertSubscriber")>
			<cfinclude template="wsact_insertCompany_extendedSubscriber.cfm">
		</cfif><!--- /insert subscriber --->
	</cfif><!--- company was successfully created --->
</cfif><!--- user is logged in and has permission to insert company --->

<!--- insert root xml tag into return variable --->
<cfset returnValue = "<xml>" & returnValueXml & "</xml>">

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

