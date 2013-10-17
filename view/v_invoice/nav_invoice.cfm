<cfoutput>
<div class="SubNav">
<cfif Variables.isViewPermission is True>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="#URL.control#.viewInvoice">
	<input type="hidden" name="submitView" value="True">
</cfif>
<cfif Application.fn_IsUserAuthorized("listInvoices")><a href="index.cfm?method=#URL.control#.listInvoices<cfif ListFind("user,company", URL.control)>&invoiceClosed=1&companyID=#URL.companyID#&userID=#URL.userID#</cfif>" title="List existing invoices" class="SubNavLink<cfif Variables.doAction is "listInvoices">On</cfif>">List Existing Invoices/Purchases</a></cfif>
<cfif Application.fn_isUserAuthorized("insertInvoice") and ListFind("user,company", URL.control)> | <a href="index.cfm?method=#URL.control#.insertInvoice&companyID=#URL.companyID#&userID=#URL.userID#" title="Create new invoice for this company/user" class="SubNavLink<cfif Variables.doAction is "insertInvoice">On</cfif>">Create New Invoice</a></cfif>
<cfif Variables.isViewPermission is True> | View Invoice ##: <input type="text" name="invoiceID" size="8" class="SmallText" title="Enter ID or custom ID of invoice"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
<cfif URL.invoiceID is not 0 and Variables.doAction is not "listInvoices">
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Invoice:</span> 
	<span class="SubNavName">###URL.invoiceID#. <cfif qry_selectInvoice.invoiceID_custom is not "">#qry_selectInvoice.invoiceID_custom# - </cfif></span>
	<cfif qry_selectInvoice.companyName is "">
		<cfif Application.fn_IsUserAuthorized("viewCompany")> [<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectInvoice.companyID#" title="View company this invoices belongs to" class="SubNavLink">company</a>]</cfif>
	<cfelse>
		<span class="SubNavName">#qry_selectInvoice.companyName#</span> <cfif Application.fn_IsUserAuthorized("viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectInvoice.companyID#" title="View company this invoices belongs to" class="SubNavLink">go</a>)</cfif>
	</cfif>
	<cfif qry_selectInvoice.userID is not 0>
		 <span class="SubNavName">- #qry_selectInvoice.firstName# #qry_selectInvoice.lastName#</span><cfif Application.fn_IsUserAuthorized("viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectInvoice.userID#" title="View user that is contact person for this invoice" class="SubNavLink">go</a>)</cfif>
	</cfif>
	<br>
	<cfif Application.fn_IsUserAuthorized("viewInvoice")><a href="index.cfm?method=invoice.viewInvoice&invoiceID=#URL.invoiceID#" title="View invoice summary information" class="SubNavLink<cfif Variables.doAction is "viewInvoice">On</cfif>">Summary</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewInvoiceTemplate")><a href="index.cfm?method=invoice.viewInvoiceTemplate&invoiceID=#URL.invoiceID#" title="View invoice via template" class="SubNavLink<cfif Variables.doAction is "viewInvoiceTemplate">On</cfif>">View Invoice</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("updateInvoice")><a href="index.cfm?method=invoice.updateInvoice&invoiceID=#URL.invoiceID#" title="Update invoice information" class="SubNavLink<cfif Variables.doAction is "updateInvoice">On</cfif>">Update Invoice</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewInvoiceLineItems")><a href="index.cfm?method=invoice.viewInvoiceLineItems&invoiceID=#URL.invoiceID#" title="View active invoice line items" class="SubNavLink<cfif Variables.doAction is "viewInvoiceLineItems">On</cfif>">List Active Line Items</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewInvoiceLineItemsAll")><a href="index.cfm?method=invoice.viewInvoiceLineItemsAll&invoiceID=#URL.invoiceID#" title="View all active and inactive invoice line items" class="SubNavLink<cfif Variables.doAction is "viewInvoiceLineItemsAll">On</cfif>">List All Line Items</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertInvoiceLineItem")>
		 | <cfif Variables.doAction is "insertInvoiceLineItem"><b><i>Add New Line Item</i>:</b><cfelse><i>Add New Line Item</i>:</cfif> 
		 <cfif qry_selectInvoice.invoiceClosed is 0>
			<a href="index.cfm?method=invoice.insertInvoiceLineItem&invoiceID=#URL.invoiceID#" title="Add existing product as new line item to invoice " class="SubNavLink<cfif Variables.doAction is "insertInvoiceLineItem" and (Not IsDefined("URL.productID") or URL.productID is not 0)>On</cfif>">Existing Product</a> | 
			<a href="index.cfm?method=invoice.insertInvoiceLineItem&invoiceID=#URL.invoiceID#&productID=0" title="Add custom product as new line item to invoice" class="SubNavLink<cfif Variables.doAction is "insertInvoiceLineItem" and IsDefined("URL.productID") and URL.productID is 0>On</cfif>">Custom Product</a><br>
		 <cfelse>
		 	Existing Product | Custom Product<br>
		 </cfif>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("listPaymentsForInvoice")><a href="index.cfm?method=invoice.listPaymentsForInvoice&invoiceID=#URL.invoiceID#" title="Manage payments, refunds and credits associatd with this invoice" class="SubNavLink<cfif Find("Payment", Variables.doAction)>On</cfif>">Payments</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("insertPayment") and qry_selectInvoice.invoicePaid is 0><a href="index.cfm?method=invoice.insertPayment&invoiceID=#URL.invoiceID#" title="Add payment associated with this invoice" class="SubNavLink<cfif Find("Payment", Variables.doAction)>On</cfif>">Payments</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listPaymentRefunds")><a href="index.cfm?method=invoice.listPaymentRefunds&invoiceID=#URL.invoiceID#" title="List refunds associated with this invoice" class="SubNavLink<cfif Find("Payment", Variables.doAction)>On</cfif>">Payments</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listPaymentCredits")><a href="index.cfm?method=invoice.listPaymentCredits&invoiceID=#URL.invoiceID#" title="List credits associatd with this invoice" class="SubNavLink<cfif Find("PaymentCredit", Variables.doAction)>On</cfif>">Payments</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")><a href="index.cfm?method=invoice.listSalesCommissions&invoiceID=#URL.invoiceID#" title="List calculated sales commissions for salespeople and partners associated with this invoice" class="SubNavLink<cfif Find("Commission", Variables.doAction)>On</cfif>">Sales Commissions</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("insertSalesCommission")><a href="index.cfm?method=invoice.insertSalesCommission&invoiceID=#URL.invoiceID#" title="Add manual sales commission for salesperson or partner for this invoice" class="SubNavLink<cfif Find("Commission", Variables.doAction)>On</cfif>">Sales Commissions</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listShipping")><a href="index.cfm?method=invoice.listShipping&invoiceID=#URL.invoiceID#" title="List existing shipments for this invoice" class="SubNavLink<cfif Variables.doAction is "listShipping">On</cfif>">Existing Shipments</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertShipping")><a href="index.cfm?method=invoice.insertShipping&invoiceID=#URL.invoiceID#" title="Add new shipment for this invoice" class="SubNavLink<cfif Variables.doAction is "addShipping">On</cfif>">New Shipment</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewInvoice") or Application.fn_IsUserAuthorized("listStatusHistory")><a href="index.cfm?method=invoice.viewInvoice&invoiceID=#URL.invoiceID#&viewFieldArchives=True" title="View previous values of invoice information" class="SubNavLink<cfif Variables.doAction is "viewInvoice" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")><a href="index.cfm?method=invoice.insertContact&invoiceID=#URL.invoiceID#" title="Send new contact management message and view existing messages" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")><a href="index.cfm?method=invoice.listContacts&invoiceID=#URL.invoiceID#" title="View existing contact management messages" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=invoice.insertNote&invoiceID=#URL.invoiceID#" title="Add and view existing notes associated with this invoice" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=invoice.listNotes&invoiceID=#URL.invoiceID#" title="View existing notes associated with this invoice" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")><a href="index.cfm?method=invoice.insertTask&invoiceID=#URL.invoiceID#" title="Add and view existing tasks associated with this invoice" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=invoice.listTasks&invoiceID=#URL.invoiceID#" title="View existing tasks associated with this invoice" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
</div><br>
<cfif Variables.isViewPermission is True></form></cfif>
</cfoutput>

