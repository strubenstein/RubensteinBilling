<cfparam Name="URL.paymentCreditID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">
<cfparam Name="Variables.invoiceID" Default="0">
<cfparam Name="Variables.userID" Default="0">
<cfparam Name="Variables.companyID" Default="0">
<cfparam Name="Variables.subscriberID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#">

<cfinclude template="security_paymentCredit.cfm">
<cfinclude template="../../view/v_paymentCredit/nav_paymentCredit.cfm">
<cfif IsDefined("URL.confirm_paymentCredit")>
	<cfinclude template="../../view/v_paymentCredit/confirm_paymentCredit.cfm">
</cfif>
<cfif IsDefined("URL.error_paymentCredit")>
	<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPaymentCredits">
	<cfinclude template="control_listPaymentCredits.cfm">
</cfcase>

<cfcase value="viewPaymentCredit"><!--- display payment credit info --->
	<cfinclude template="control_viewPaymentCredit.cfm">
</cfcase>

<cfcase value="insertPaymentCredit">
	<cfif ListFind("invoice,company", URL.control)>
		<cfinclude template="control_insertPaymentCredit.cfm">
	<cfelse>
		<cfset URL.error_payment = "insertPaymentCredit">
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
	</cfif>
</cfcase>

<cfcase value="updatePaymentCredit"><!--- can only change non-relevant info, including begin date if applicable --->
	<cfinclude template="control_updatePaymentCredit.cfm">
</cfcase>

<cfcase value="listInvoicesForPaymentCredit"><!--- lists invoices attributed to a payment credit --->
	<cfinclude template="control_listInvoicesForPaymentCredit.cfm">
</cfcase>

<cfcase value="listPaymentCreditsForInvoice"><!--- lists payment credits attributed to an invoice --->
	<cfif URL.control is "invoice" and Application.fn_IsIntegerList(URL.invoiceID)>
		<cfinclude template="control_listPaymentCreditsForInvoice.cfm">
	<cfelse>
		<cfset URL.error_paymentCredit = "noInvoice">
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
	</cfif>
</cfcase>

<cfcase value="updateInvoicePaymentCredit"><!--- update line item text for credits on an invoice --->
	<cfinclude template="control_updateInvoicePaymentCredit.cfm">
</cfcase>

<cfcase value="deleteInvoicePaymentCredit">
	<cfif Application.fn_IsIntegerPositive(URL.invoiceID) and Application.fn_IsIntegerPositive(URL.invoicePaymentCreditID)>
		<cfinclude template="control_deleteInvoicePaymentCredit.cfm">
	<cfelse>
		<cfset URL.error_paymentCredit = "noInvoice">
		<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
	</cfif>
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="paymentCreditID">
		<cfinvokeargument name="targetID" value="#URL.paymentCreditID#">
		<cfinvokeargument name="urlParameters" value="&paymentCreditID=#URL.paymentCreditID#">
		<cfinvokeargument name="userID_target" value="#qry_selectPaymentCredit.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectPaymentCredit.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&paymentCreditID=#URL.paymentCreditID#">
		<cfinvokeargument name="primaryTargetKey" value="paymentCreditID">
		<cfinvokeargument name="targetID" value="#URL.paymentCreditID#">
		<cfinvokeargument name="userID_target" value="#qry_selectPaymentCredit.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectPaymentCredit.companyID#">
	</cfinvoke>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_paymentCredit = "invalidAction">
	<cfinclude template="../../view/v_paymentCredit/error_paymentCredit.cfm">
</cfdefaultcase>
</cfswitch>