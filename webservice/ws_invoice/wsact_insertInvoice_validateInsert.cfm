<cfif Arguments.invoiceCompleted is 1>
	<cfset Arguments.invoiceClosed = 2>
</cfif>

<cfset Variables.doAction = "insertInvoice">
<cfset Form = Arguments>
<cfset URL.invoiceID = 0>
<cfset URL.companyID = Arguments.companyID>
<cfset URL.userID = Arguments.userID>
<cfinclude template="wsact_validateInsertUpdateInvoice.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="insertInvoice" ReturnVariable="newInvoiceID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="invoiceStatus" Value="#Arguments.invoiceStatus#">
		<cfinvokeargument Name="invoiceTotalShipping" Value="#Arguments.invoiceTotalShipping#">
		<cfswitch expression="#Arguments.invoiceClosed#">
		<cfcase value="0">
			<cfinvokeargument Name="invoiceClosed" Value="0">
			<cfinvokeargument Name="invoiceCompleted" Value="0">
		</cfcase>
		<cfcase value="1">
			<cfinvokeargument Name="invoiceClosed" Value="1">
			<cfinvokeargument Name="invoiceCompleted" Value="0">
			<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
		</cfcase>
		<cfcase value="2">
			<cfinvokeargument Name="invoiceClosed" Value="1">
			<cfinvokeargument Name="invoiceCompleted" Value="1">
			<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
			<cfinvokeargument Name="invoiceDateCompleted" Value="#Now()#">
		</cfcase>
		</cfswitch>
		<cfinvokeargument Name="invoicePaid" Value="#Arguments.invoicePaid#">
		<cfif Arguments.invoicePaid is not "">
			<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
		</cfif>
		<cfinvokeargument Name="invoiceShippingMethod" Value="#Arguments.invoiceShippingMethod#">
		<cfinvokeargument Name="invoiceInstructions" Value="#Arguments.invoiceInstructions#">
		<cfinvokeargument Name="invoiceID_custom" Value="#Arguments.invoiceID_custom#">
		<cfinvokeargument Name="invoiceShipped" Value="#Arguments.invoiceShipped#">
		<cfinvokeargument Name="invoiceDateDue" Value="#Arguments.invoiceDateDue#">
		<cfinvokeargument Name="invoiceSent" Value="#Arguments.invoiceSent#">
		<cfinvokeargument Name="invoiceManual" Value="1">
		<cfinvokeargument Name="addressID_shipping" Value="#Arguments.addressID_shipping#">
		<cfinvokeargument Name="addressID_billing" Value="#Arguments.addressID_billing#">
		<cfinvokeargument Name="creditCardID" Value="0">
		<cfinvokeargument Name="bankID" Value="0">
		<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
	</cfinvoke>

	<cfset Arguments.invoiceID = newInvoiceID>

	<!--- custom fields --->
	<cfif Trim(invoice_customField) is not "">
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="invoiceID">
			<cfinvokeargument Name="targetID" Value="#newInvoiceID#">
			<cfinvokeargument Name="customField" Value="#invoice_customField#">
		</cfinvoke>
	</cfif>

	<!--- custom status --->
	<cfif invoice_statusID is not 0
			or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")
			or ListFind(Arguments.useCustomIDFieldList, "statusID_invoice") or ListFind(Arguments.useCustomIDFieldList, "statusID_invoice_custom")>
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="invoiceID">
			<cfinvokeargument Name="targetID" Value="#newInvoiceID#">
			<cfinvokeargument Name="useCustomIDFieldList" Value="#invoice_useCustomIDFieldList#">
			<cfinvokeargument Name="statusID" Value="#invoice_statusID#">
			<cfinvokeargument Name="statusID_custom" Value="#invoice_statusID_custom#">
			<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
		</cfinvoke>
	</cfif>

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="doAction" value="insertInvoice">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="doControl" value="invoice">
		<cfinvokeargument name="primaryTargetKey" value="invoiceID">
		<cfinvokeargument name="targetID" value="#newInvoiceID#">
	</cfinvoke>

	<cfset returnValue = Arguments.invoiceID>
</cfif>
