<cfswitch expression="#URL.control#">
<cfcase value="paymentCredit">
	<cfset Variables.navPaymentControl = "payment">
	<cfset Variables.navCreditControl = URL.control>
</cfcase>
<cfcase value="payment">
	<cfset Variables.navCreditControl = "paymentCredit">
	<cfset Variables.navPaymentControl = URL.control>
</cfcase>
<cfdefaultcase>
	<cfset Variables.navPaymentControl = URL.control>
	<cfset Variables.navCreditControl = URL.control>
</cfdefaultcase>
</cfswitch>
<!--- 
<cfif URL.control is "paymentCredit"><cfset Variables.navPaymentControl = "payment"><cfelse><cfset Variables.navPaymentControl = URL.control></cfif>
<cfif URL.control is "payment"><cfset Variables.navCreditControl = "paymentCredit"><cfelse><cfset Variables.navCreditControl = URL.control></cfif>
--->

<cfoutput>
<div class="SubNav">
<!--- 
<cfinclude template="../v_payment/nav_payment_main.cfm">
<cfinclude template="../v_paymentCredit/nav_paymentCredit_main.cfm">
--->
<cfset Variables.displayBR = False>
<cfif Application.fn_IsUserAuthorized("listPayments")><cfset Variables.displayBR = True><a href="index.cfm?method=#Variables.navPaymentControl#.listPayments#Variables.urlParameters#" title="List existing payments" class="SubNavLink<cfif Variables.doAction is "listPayments">On</cfif>">List Existing Payments</a></cfif>
<cfif Application.fn_IsUserAuthorized("listPaymentRefunds")><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navPaymentControl#.listPaymentRefunds#Variables.urlParameters#" title="List existing refunds" class="SubNavLink<cfif Variables.doAction is "listPaymentRefunds">On</cfif>">List Existing Refunds</a></cfif>
<cfif Application.fn_IsUserAuthorized("listPaymentCredits")><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navCreditControl#.listPaymentCredits#Variables.urlParameters#" title="List existing payment credits" class="SubNavLink<cfif Variables.doAction is "listPaymentCredits">On</cfif>">List Existing Credits</a></cfif>
<cfif Variables.displayBR is True><br></cfif>

<cfset Variables.displayBR = False>
<cfif Application.fn_IsUserAuthorized("insertPayment") and ListFind("invoice,company", URL.control)><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navPaymentControl#.insertPayment#Variables.urlParameters#" title="Add new payment" class="SubNavLink<cfif Variables.doAction is "insertPayment">On</cfif>">Add New Payment</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPaymentRefund") and ListFind("invoice,company", URL.control)><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navPaymentControl#.insertPaymentRefund#Variables.urlParameters#" title="Add new refund" class="SubNavLink<cfif Variables.doAction is "insertPaymentRefund">On</cfif>">Add New Refund</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPaymentCredit") and ListFind("invoice,company", URL.control)><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navCreditControl#.insertPaymentCredit#Variables.urlParameters#" title="Add new payment credit" class="SubNavLink<cfif Variables.doAction is "insertPaymentCredit">On</cfif>">Add New Credit</a></cfif>
<cfif Variables.displayBR is True><br></cfif>

<cfif URL.control is "invoice" and IsDefined("URL.invoiceID")>
	<cfset Variables.displayBR = False>
	<cfif Application.fn_IsUserAuthorized("listPaymentsForInvoice")><cfset Variables.displayBR = True><a href="index.cfm?method=#Variables.navPaymentControl#.listPaymentsForInvoice#Variables.urlParameters#" title="List payments applied to this invoice" class="SubNavLink<cfif Variables.doAction is "listPaymentsForInvoice">On</cfif>">List Payments Applied To This Invoice</a></cfif>
	<cfif Application.fn_IsUserAuthorized("applyPaymentsToInvoice")><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navPaymentControl#.applyPaymentsToInvoice#Variables.urlParameters#" title="Apply payments to this invoice" class="SubNavLink<cfif Variables.doAction is "applyPaymentsToInvoice">On</cfif>">Apply Payments To This Invoice</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPaymentCreditsForInvoice")><cfset Variables.displayBR = True> | <a href="index.cfm?method=#Variables.navCreditControl#.listPaymentCreditsForInvoice#Variables.urlParameters#" title="List payment credits applied to this invoice" class="SubNavLink<cfif Variables.doAction is "listPaymentCreditsForInvoice">On</cfif>">List Credits Applied To This Invoice</a></cfif>
	<cfif Variables.displayBR is True><br></cfif>
</cfif>

<cfif Variables.doControl is "payment" and URL.paymentID is not 0 and Not ListFind("listPayments,listPaymentRefunds", Variables.doAction)>
	<img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">#Variables.paymentOrRefundTextUcase# Info:</span> 
	<span class="SubNavName">
	#Variables.paymentOrRefundTextUcase# of #DollarFormat(qry_selectPayment.paymentAmount)# on #DateFormat(qry_selectPayment.paymentDateReceived, "mm/dd/yy")#
	<cfif qry_selectPayment.paymentID_custom is not ""> (ID: #qry_selectPayment.paymentID_custom#)</cfif>
	 - Status: <cfif qry_selectPayment.paymentStatus is 0><span style="color: red">Ignored</span> / </cfif>#Replace(fn_DisplayPaymentApproved(qry_selectPayment.paymentApproved), "green", "33FF66", "ONE")#
	</span><br>
	<cfif qry_selectPayment.paymentIsRefund is 0><!--- payment --->
		<cfif Application.fn_IsUserAuthorized("viewPayment")><a href="index.cfm?method=#URL.control#.viewPayment#Variables.urlParameters#&paymentID=#URL.paymentID#" title="View summary of this payment" class="SubNavLink<cfif Variables.doAction is "viewPayment">On</cfif>">Summary</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("updatePayment")><a href="index.cfm?method=#URL.control#.updatePayment#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Update payment" class="SubNavLink<cfif Variables.doAction is "updatePayment">On</cfif>">Update Payment</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("listInvoicesForPayment")><a href="index.cfm?method=#URL.control#.listInvoicesForPayment#Variables.urlParameters#&paymentID=#URL.paymentID#" title="List invoices that have been applied to this payment" class="SubNavLink<cfif Variables.doAction is "listInvoicesForPayment">On</cfif>">List Invoices Applied To This Payment</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("applyInvoicesToPayment")><a href="index.cfm?method=#URL.control#.applyInvoicesToPayment#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Apply this payment to an invoice" class="SubNavLink<cfif Variables.doAction is "applyInvoicesToPayment">On</cfif>">Apply To New Invoice</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("insertPaymentRefund")><a href="index.cfm?method=#URL.control#.insertPaymentRefund#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Create a refund of this payment" class="SubNavLink<cfif Variables.doAction is "insertPaymentRefund">On</cfif>">Refund This Payment</a> | </cfif>
	<cfelse><!--- refund --->
		<cfif Application.fn_IsUserAuthorized("viewPaymentRefund")><a href="index.cfm?method=#URL.control#.viewPaymentRefund#Variables.urlParameters#&paymentID=#URL.paymentID#" title="View summary of refund" class="SubNavLink<cfif Variables.doAction is "viewPaymentRefund">On</cfif>">Summary</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("updatePaymentRefund")><a href="index.cfm?method=#URL.control#.updatePaymentRefund#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Update refund information" class="SubNavLink<cfif Variables.doAction is "updatePaymentRefund">On</cfif>">Update Refund</a> | </cfif>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=payment.insertNote#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Add and view notes associated with this payment" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=payment.listNotes#Variables.urlParameters#&paymentID=#URL.paymentID#" title="View notes associated with this payment" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")><a href="index.cfm?method=payment.insertTask#Variables.urlParameters#&paymentID=#URL.paymentID#" title="Add and view tasks associated with this payment" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=payment.listTasks#Variables.urlParameters#&paymentID=#URL.paymentID#" title="View tasks associated with this payment" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
<cfif Variables.doControl is "paymentCredit" and URL.paymentCreditID is not 0 and Variables.doAction is not "listPaymentCredits">
	<img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Credit Info:</span> 
	<span class="SubNavName">
	<cfif qry_selectPaymentCredit.paymentCreditName is not "">#qry_selectPaymentCredit.paymentCreditName#<br></cfif>
	Credit of #DollarFormat(qry_selectPaymentCredit.paymentCreditAmount)# on #DateFormat(qry_selectPaymentCredit.paymentCreditDateCreated, "mm/dd/yy")#
	<cfif qry_selectPaymentCredit.paymentCreditID_custom is not ""> (ID: #qry_selectPaymentCredit.paymentCreditID_custom#)</cfif>
	</span><br>
	<cfif Application.fn_IsUserAuthorized("viewPaymentCredit")><a href="index.cfm?method=#URL.control#.viewPaymentCredit#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="View summary of payment credit" class="SubNavLink<cfif Variables.doAction is "viewPaymentCredit">On</cfif>">Summary</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("updatePaymentCredit")><a href="index.cfm?method=#URL.control#.updatePaymentCredit#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="Update payment credit information" class="SubNavLink<cfif Variables.doAction is "updatePaymentCredit">On</cfif>">Update Credit</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listInvoicesForPaymentCredit")><a href="index.cfm?method=#URL.control#.listInvoicesForPaymentCredit#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="List invoices to which this payment credit been applied" class="SubNavLink<cfif Variables.doAction is "listInvoicesForPaymentCredit">On</cfif>">List Invoices Applied To This Credit</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=paymentCredit.insertNote#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="Add and view notes associated with this payment credit" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=paymentCredit.listNotes#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="View notes associated with this payment credit" class="SubNavLink<cfif FindNoCase("Note", Variables.doAction)>On</cfif>">Notes</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")><a href="index.cfm?method=paymentCredit.insertTask#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="Add and view tasks associated with this payment credit" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=paymentCredit.listTasks#Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#" title="View tasks associated with this payment credit" class="SubNavLink<cfif FindNoCase("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
</div><br>
</cfoutput>

