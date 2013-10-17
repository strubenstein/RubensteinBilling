<cfinclude template="wslang_payment.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelse>
	<cfset Arguments.paymentID = Application.objWebServiceSecurity.ws_checkPaymentPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentID, Arguments.paymentID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.paymentID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_payment.invalidPaymentOrRefund>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
			<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID#">
		</cfinvoke>

		<cfif qry_selectPayment.paymentIsRefund is 0 and Not Application.objWebServiceSession.isUserAuthorizedWS("exportPayments", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_payment.exportPayments>
		<cfelseif qry_selectPayment.paymentIsRefund is 1 and Not Application.objWebServiceSession.isUserAuthorizedWS("exportPaymentRefunds", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_payment.exportPaymentRefunds>
		<cfelseif Arguments.paymentIsExported is not "" and Not ListFind("0,1", Arguments.paymentIsExported)>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_payment.exportStatus>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePaymentIsExported" ReturnVariable="isPaymentExported">
				<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID#">
				<cfinvokeargument Name="paymentIsExported" Value="#Arguments.paymentIsExported#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


