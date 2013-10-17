<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateInvoice", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_invoice.updateInvoice>
<cfelse>
	<cfloop Index="field" List="invoiceStatus,invoiceClosed,invoiceCompleted,invoiceSent,invoicePaid">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.invoiceID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_invoice.invalidInvoice>
	<cfelse>
		<cfif Arguments.invoiceCompleted is 1>
			<cfset Arguments.invoiceClosed = 2>
		</cfif>

		<cfset Variables.doAction = "updateInvoice">
		<cfset URL.invoiceID = Arguments.invoiceID>
		<cfset Form = Arguments>

		<cfset Variables.updateFieldList_valid = "invoiceStatus,invoiceSent,invoicePaid,invoiceDateDue,invoiceShipped,invoiceTotalShipping,invoiceShippingMethod,invoiceInstructions,addressID_shipping,addressID_billing">
		<cfset Variables.updateFieldList_validSpecial = "invoiceClosed">
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
		</cfinvoke>

		<cfset URL.companyID = qry_selectInvoice.companyID>
		<cfset URL.userID = qry_selectInvoice.userID>

		<cfloop Index="field" List="#Variables.updateFieldList_valid#,#Variables.updateFieldList_validSpecial#">
			<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectInvoice.#field#")>
			</cfif>
		</cfloop>

		<cfinclude template="wsact_validateInsertUpdateInvoice.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
				<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfloop Index="field" List="#Variables.updateFieldList_valid#">
					<cfif ListFind(Arguments.updateFieldList, field)>
						<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
					</cfif>
				</cfloop>
				<cfif ListFind(Arguments.updateFieldList, "invoiceClosed")>
					<cfswitch expression="#Arguments.invoiceClosed#">
					<cfcase value="0">
						<cfinvokeargument Name="invoiceClosed" Value="0">
						<cfinvokeargument Name="invoiceCompleted" Value="0">
						<cfinvokeargument Name="invoiceDateClosed" Value="">
						<cfinvokeargument Name="invoiceDateCompleted" Value="">
					</cfcase>
					<cfcase value="1">
						<cfinvokeargument Name="invoiceClosed" Value="1">
						<cfinvokeargument Name="invoiceCompleted" Value="0">
						<cfif Not IsDate(qry_selectInvoice.invoiceDateClosed)>
							<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
						</cfif>
						<cfinvokeargument Name="invoiceDateCompleted" Value="">
					</cfcase>
					<cfcase value="2">
						<cfinvokeargument Name="invoiceClosed" Value="1">
						<cfinvokeargument Name="invoiceCompleted" Value="1">
						<cfif Not IsDate(qry_selectInvoice.invoiceDateClosed)>
							<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
						</cfif>
						<cfif Not IsDate(qry_selectInvoice.invoiceDateCompleted)>
							<cfinvokeargument Name="invoiceDateCompleted" Value="#Now()#">
						</cfif>
					</cfcase>
					</cfswitch>
				</cfif>
				<cfif ListFind(Arguments.updateFieldList, "invoicePaid")>
					<cfif Arguments.invoicePaid is "">
						<cfinvokeargument Name="invoiceDatePaid" Value="">
					<cfelseif Arguments.invoicePaid is 0 and Not IsDate(qry_selectInvoice.invoiceDatePaid)>
						<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
					<cfelseif Arguments.invoicePaid is 1 and (Not IsDate(qry_selectInvoice.invoiceDatePaid) or qry_selectInvoice.invoicePaid is not 1)>
						<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
					</cfif>
				</cfif>
			</cfinvoke>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "" and ListFind(Arguments.updateFieldList, "customField")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="invoiceID">
					<cfinvokeargument Name="targetID" Value="#Arguments.invoiceID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif ListFind(Arguments.updateFieldList, "statusID")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="invoiceID">
					<cfinvokeargument Name="targetID" Value="#Arguments.invoiceID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateInvoice">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="invoice">
				<cfinvokeargument name="primaryTargetKey" value="invoiceID">
				<cfinvokeargument name="targetID" value="#Arguments.invoiceID#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

