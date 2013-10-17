<!---
invoiceDateDue
invoiceSent

search for: company name, user first/last/email/phone, product, shipping/billing address city/state/zip/country
jump to alphabet?
--->

<cfparam Name="URL.invoiceID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif ListFind("company,subscription", URL.control) and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.invoiceActionList = Replace(Variables.formAction, URL.action, "listInvoices", "ONE")>

<!--- Enable user to go directly to invoice by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewInvoice")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewInvoice" and IsDefined("URL.submitView") and Trim(URL.invoiceID) is not "">
	<cfinclude template="act_viewInvoiceByID.cfm">
</cfif>

<cfif URL.invoiceID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&invoiceID=" & URL.invoiceID>
</cfif>

<cfparam Name="URL.displayInvoiceSpecial" Default="">

<cfinclude template="security_invoice.cfm">
<cfinclude template="security_invoiceLineItem.cfm">
<cfinclude template="../../view/v_invoice/nav_invoice.cfm">
<cfif IsDefined("URL.confirm_invoice")>
	<cfinclude template="../../view/v_invoice/confirm_invoice.cfm">
</cfif>
<cfif IsDefined("URL.error_invoice")>
	<cfinclude template="../../view/v_invoice/error_invoice.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listInvoices">
	<cfinclude template="control_listInvoices.cfm">
</cfcase>

<!--- Must be coming from company or user --->
<cfcase value="insertInvoice,updateInvoice">
	<cfinclude template="control_insertUpdateInvoice.cfm">
</cfcase>

<cfcase value="viewInvoice">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_invoice/dsp_viewInvoiceByID.cfm">
		</cfif>
		<cfinclude template="control_viewInvoice.cfm">

	<cfelseif Not Application.fn_IsUserAuthorized("listStatusHistory")>
		<cfset URL.error_invoice = "invalidAction">
		<cfinclude template="../../view/v_invoice/error_invoice.cfm">

	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
			<cfinvokeargument name="primaryTargetKey" value="invoiceID">
			<cfinvokeargument name="targetID" value="#URL.invoiceID#">
		</cfinvoke>
	</cfif>
</cfcase>

<cfcase value="viewInvoiceTemplate">
	<cfinclude template="control_viewInvoiceTemplate.cfm">
</cfcase>

<cfcase value="insertShipping,updateShipping,listShipping">
	<cfset Variables.doControl = "shipping">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="viewInvoiceLineItems,viewInvoiceLineItemsAll">
	<cfinclude template="control_viewInvoiceLineItems.cfm">
</cfcase>

<cfcase value="viewInvoiceLineItem">
	<cfinclude template="control_viewInvoiceLineItem.cfm">
</cfcase>

<cfcase value="insertInvoiceLineItem,updateInvoiceLineItem">
	<cfif qry_selectInvoice.invoiceClosed is not 0>
		<cflocation url="index.cfm?method=invoice.viewInvoiceLineItems&invoiceID=#URL.invoiceID#&error_invoice=invoiceIsClosed" AddToken="No">
	<cfelse>
		<cfinclude template="control_insertInvoiceLineItem.cfm">
	</cfif>
</cfcase>

<cfcase value="updateInvoiceLineItemStatus">
	<cfinclude template="control_updateInvoiceLineItemStatus.cfm">
</cfcase>

<cfcase value="moveInvoiceLineItemUp,moveInvoiceLineItemDown">
	<cfif qry_selectInvoice.invoiceClosed is not 0>
		<cflocation url="index.cfm?method=invoice.viewInvoiceLineItems&invoiceID=#URL.invoiceID#&error_invoice=invoiceIsClosed" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="switchInvoiceLineItemOrder" ReturnVariable="isInvoiceLineItemSwitched">
			<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
			<cfinvokeargument Name="invoiceLineItemOrder_direction" Value="#Variables.doAction#">
		</cfinvoke>

		<cflocation url="index.cfm?method=invoice.viewInvoiceLineItems&invoiceID=#URL.invoiceID#&confirm_invoice=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("invoiceID")>
	<cfset Variables.targetID = URL.invoiceID>

	<cfset Variables.userID = qry_selectInvoice.userID>
	<cfset Variables.companyID = qry_selectInvoice.companyID>
	<cfset Variables.invoiceID = URL.invoiceID>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="invoiceID">
		<cfinvokeargument name="targetID" value="#URL.invoiceID#">
		<cfinvokeargument name="urlParameters" value="&invoiceID=#URL.invoiceID#">
		<cfinvokeargument name="userID_target" value="#qry_selectInvoice.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectInvoice.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&invoiceID=#URL.invoiceID#">
		<cfinvokeargument name="primaryTargetKey" value="invoiceID">
		<cfinvokeargument name="targetID" value="#URL.invoiceID#">
		<cfinvokeargument name="userID_target" value="#qry_selectInvoice.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectInvoice.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listStatusHistory">
	<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
		<cfinvokeargument name="primaryTargetKey" value="invoiceID">
		<cfinvokeargument name="targetID" value="#URL.invoiceID#">
	</cfinvoke>
</cfcase>

<cfcase value="listPayments,viewPayment,insertPayment,updatePayment,listInvoicesForPayment,listPaymentsForInvoice,applyInvoicesToPayment,applyPaymentsToInvoice,deleteInvoicePayment">
	<cfset Variables.companyID = qry_selectInvoice.companyID>
	<cfset Variables.invoiceID = URL.invoiceID>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentRefunds,viewPaymentRefund,insertPaymentRefund,updatePaymentRefund">
	<cfset Variables.companyID = qry_selectInvoice.companyID>
	<cfset Variables.invoiceID = URL.invoiceID>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentCredits,viewPaymentCredit,insertPaymentCredit,updatePaymentCredit,listInvoicesForPaymentCredit,listPaymentCreditsForInvoice,updateInvoicePaymentCredit,deleteInvoicePaymentCredit">
	<cfset Variables.companyID = qry_selectInvoice.companyID>
	<cfset Variables.invoiceID = URL.invoiceID>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">

	<cfset Variables.doControl = "paymentCredit">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions,insertSalesCommission">
	<cfset Variables.companyID = qry_selectInvoice.companyID>
	<cfset Variables.invoiceID = URL.invoiceID>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_invoice = "invalidAction">
	<cfinclude template="../../view/v_invoice/error_invoice.cfm">
</cfdefaultcase>
</cfswitch>

