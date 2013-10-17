<cfparam Name="URL.paymentID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">
<cfparam Name="Variables.invoiceID" Default="0">
<cfparam Name="Variables.userID" Default="0">
<cfparam Name="Variables.companyID" Default="0">
<cfparam Name="Variables.subscriberID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#">
<cfinclude template="../../view/v_payment/fn_DisplayPaymentApproved.cfm">

<cfif FindNoCase("Refund", Variables.doAction)>
	<cfset Variables.paymentOrRefundText = "refund">
	<cfset Variables.paymentOrRefundTextUcase = "Refund">
<cfelse>
	<cfset Variables.paymentOrRefundText = "payment">
	<cfset Variables.paymentOrRefundTextUcase = "Payment">
</cfif>

<cfinclude template="security_payment.cfm">
<cfinclude template="../../view/v_payment/nav_payment.cfm">
<cfif IsDefined("URL.confirm_payment")>
	<cfinclude template="../../view/v_payment/confirm_payment.cfm">
</cfif>
<cfif IsDefined("URL.error_payment")>
	<cfinclude template="../../view/v_payment/error_payment.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPayments,listPaymentRefunds">
	<cfinclude template="control_listPayments.cfm">
</cfcase>

<cfcase value="viewPayment,viewPaymentRefund"><!--- display payment info, including invoices payment is attributed to --->
	<cfinclude template="control_viewPayment.cfm">
</cfcase>

<cfcase value="insertPayment,insertPaymentRefund">
	<cfif ListFind("invoice,company", URL.control)>
		<cfinclude template="control_insertPayment.cfm">
	<cfelseif Variables.doAction is "insertPaymentRefund" and URL.paymentID is not 0>
		<cfset Variables.userID = qry_selectPayment.userID>
		<cfset Variables.companyID = qry_selectPayment.companyID>
		<cfset Variables.subscriberID = qry_selectPayment.subscriberID>
		<cfinclude template="control_insertPayment.cfm">
	<cfelseif Variables.doAction is "insertPayment">
		<cfset URL.error_payment = "insertPayment">
		<cfinclude template="../../view/v_payment/error_payment.cfm">
	<cfelse>
		<cfset URL.error_payment = "insertPaymentRefund">
		<cfinclude template="../../view/v_payment/error_payment.cfm">
	</cfif>
</cfcase>

<cfcase value="updatePayment,updatePaymentRefund"><!--- can only change non-relevant info, including scheduled processing date if applicable --->
	<cfinclude template="control_updatePayment.cfm">
</cfcase>

<cfcase value="listInvoicesForPayment"><!--- lists invoices attributed to a payment --->
	<cfinclude template="control_listInvoicesForPayment.cfm">
</cfcase>

<cfcase value="listPaymentsForInvoice"><!--- lists payments attributed to an invoice --->
	<cfif URL.control is "invoice" and Application.fn_IsIntegerList(URL.invoiceID)>
		<cfinclude template="control_listPaymentsForInvoice.cfm">
	<cfelse>
		<cfset URL.error_payment = "noInvoice">
		<cfinclude template="../../view/v_payment/error_payment.cfm">
	</cfif>
</cfcase>

<cfcase value="applyInvoicesToPayment"><!--- add invoice(s) to payment --->
	<cfinclude template="control_applyInvoicesToPayment.cfm">
</cfcase>

<cfcase value="applyPaymentsToInvoice"><!--- add payment(s) to invoice --->
	<cfif URL.control is "invoice" and Application.fn_IsIntegerList(URL.invoiceID)>
		<cfinclude template="control_applyPaymentsToInvoice.cfm">
	<cfelse>
		<cfset URL.error_payment = "noInvoice">
		<cfinclude template="../../view/v_payment/error_payment.cfm">
	</cfif>
</cfcase>

<cfcase value="deleteInvoicePayment">
	<cfinclude template="control_deleteInvoicePayment.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="paymentID">
		<cfinvokeargument name="targetID" value="#URL.paymentID#">
		<cfinvokeargument name="urlParameters" value="&paymentID=#URL.paymentID#">
		<cfinvokeargument name="userID_target" value="#qry_selectPayment.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectPayment.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&paymentID=#URL.paymentID#">
		<cfinvokeargument name="primaryTargetKey" value="paymentID">
		<cfinvokeargument name="targetID" value="#URL.paymentID#">
		<cfinvokeargument name="userID_target" value="#qry_selectPayment.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectPayment.companyID#">
	</cfinvoke>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_payment = "invalidAction">
	<cfinclude template="../../view/v_payment/error_payment.cfm">
</cfdefaultcase>
</cfswitch>