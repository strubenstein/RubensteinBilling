<cfif Find("Refund", Variables.doAction)>
	<cfset Variables.redirectAction = "listPaymentRefunds">
<cfelse>
	<cfset Variables.redirectAction = "listPayments">
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(URL.paymentID)>
	<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=invalidPayment" AddToken="No">
<cfelseif URL.paymentID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="checkPaymentPermission" ReturnVariable="isPaymentPermission">
		<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfif isPaymentPermission is False>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=invalidPayment" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
			<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
		</cfinvoke>

		<!--- if refund, ensure refund action and thus permission --->
		<cfif qry_selectPayment.paymentIsRefund is 1 and Not Find("Refund", Variables.doAction)>
			<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=invalidPaymentRefund" AddToken="No">
		<!--- if payment, ensure payment permission and thus permission; unless creating refund linked to a payment --->
		<cfelseif qry_selectPayment.paymentIsRefund is 0 and Find("Refund", Variables.doAction) and Variables.doAction is not "insertPaymentRefund">
			<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=invalidPayment" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listPayments,insertPayment,listPaymentsForInvoice,applyPaymentsToInvoice,listPaymentRefunds,insertPaymentRefund", Variables.doAction)>
	<cfif Find("Refund", Variables.doAction)>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=noPaymentRefund" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&error_payment=noPayment" AddToken="No">
	</cfif>
</cfif>
