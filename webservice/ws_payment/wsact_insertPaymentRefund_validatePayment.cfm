<!--- Validate payments that are source of refund --->
<cfset thePaymentID_refund = 0>
<cfif returnValue is 0 and (Arguments.paymentID_refund is not 0 or ListFind(Arguments.useCustomIDFieldList, "paymentID_refund") or ListFind(Arguments.useCustomIDFieldList, "paymentID_refund_custom"))>
	<cfset Arguments.paymentID_refund = Application.objWebServiceSecurity.ws_checkPaymentPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentID_refund, Arguments.paymentID_refund_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.paymentID_refund is not 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidPaymentRefund>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPaymentList">
			<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID_refund#">
		</cfinvoke>

		<cfloop Query="qry_selectPaymentList">
			<cfif qry_selectPaymentList.CurrentRow gt 1 and qry_selectPaymentList.subscriberID is not qry_selectPaymentList.subscriberID[qry_selectPaymentList.CurrentRow - 1]>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.multipleSubscriberRefund>
			<cfelseif theSubscriberID is not 0 and qry_selectPaymentList.subscriberID is not theSubscriberID>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.notSubscriberPayment>
			</cfif>
		</cfloop>

		<!--- set companyID and subscriberID to invoice values if necessary --->
		<cfif returnValue is 0>
			<cfset thePaymentID_refund = Arguments.paymentID_refund>
			<cfif theSubscriberID is 0>
				<cfset theSubscriberID = qry_selectPaymentList.subscriberID[1]>
			</cfif>
			<cfif theCompanyID is 0>
				<cfset theCompanyID = qry_selectPaymentList.companyID>
			</cfif>
		</cfif><!--- /set companyID and subscriberID to invoice values if necessary --->
	</cfif><!--- /if payments are valid, validate payments --->
</cfif><!--- /validate payments --->
