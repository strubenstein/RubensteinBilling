<cfoutput>
<cfif URL.control is "company" or (URL.companyID is not 0 and Variables.doAction is not "listCompanies")>
	<div class="SubNav">
	<cfif Variables.isViewPermission is True>
		<form method="get" action="index.cfm">
		<input type="hidden" name="method" value="company.viewCompany">
		<input type="hidden" name="submitView" value="True">
	</cfif>
</cfif>
<cfif URL.control is "company">
	<cfif Application.fn_IsUserAuthorized("listCompanies")><a href="index.cfm?method=company.listCompanies" title="List existing companies, including your company, customers and partners" class="SubNavLink<cfif Variables.doAction is "listCompanies">On</cfif>">List Existing Companies</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCompany")> | <a href="index.cfm?method=company.insertCompany" title="Create new company as a customer and/or partner." class="SubNavLink<cfif Variables.doAction is "insertCompany">On</cfif>">Create New Company</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewCompany") or Application.fn_IsUserAuthorized("updateCompany")> | <a href="index.cfm?method=company.viewCompany&companyID=#Session.companyID#" title="Manage your own company information. Saves you the effort of locating it in the list below." class="SubNavLink<cfif URL.companyID is Session.companyID>On</cfif>">Manage My Company</a></cfif>
	<cfif Variables.isViewPermission is True> || View Company ##: <input type="text" name="companyID" size="8" class="SmallText" title="Enter ID or custom ID of company"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
</cfif>
<cfif URL.companyID is not 0 and Variables.doAction is not "listCompanies">
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Company:</span> 
	<span class="SubNavName">
	<cfif qry_selectCompany.companyID_custom is not "">#qry_selectCompany.companyID_custom#. </cfif>
	<cfif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<cfelseif qry_selectCompany.companyDBA is not "">#qry_selectCompany.companyDBA#<cfelse>(<i>No Company Name</i>)</cfif>
	</span><br>
	<cfif Application.fn_IsUserAuthorized("viewCompany")><a href="index.cfm?method=company.viewCompany&companyID=#URL.companyID#" title="View summary of company information" class="SubNavLink<cfif Variables.doAction is "viewCompany" and Not IsDefined("URL.viewFieldArchives")>On</cfif>">Summary</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateCompany")> | <a href="index.cfm?method=company.updateCompany&companyID=#URL.companyID#" title="Update company information" class="SubNavLink<cfif Variables.doAction is "updateCompany">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listAddresses")> | <a href="index.cfm?method=company.listAddresses&companyID=#URL.companyID#" title="Manage and view addresses for this company" class="SubNavLink<cfif Find("Address", Variables.doAction)>On</cfif>">Address</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPhones")> | <a href="index.cfm?method=company.listPhones&companyID=#URL.companyID#" title="Manage and view phone and fax numbers for this company" class="SubNavLink<cfif Find("Phone", Variables.doAction)>On</cfif>">Phone</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCreditCards")> | <a href="index.cfm?method=company.listCreditCards&companyID=#URL.companyID#" title="Manage and view credit card numbers for this company" class="SubNavLink<cfif Find("CreditCard", Variables.doAction)>On</cfif>">Credit Card</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listBanks")> | <a href="index.cfm?method=company.listBanks&companyID=#URL.companyID#" title="Manage and view bank accounts for this company" class="SubNavLink<cfif Find("Bank", Variables.doAction)>On</cfif>">Bank</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listUsers")> | <a href="index.cfm?method=company.listUsers&companyID=#URL.companyID#" title="List existing contacts of this company" class="SubNavLink<cfif Find("User", Variables.doAction) and Variables.doAction is not "insertUser">On</cfif>">List Existing Users</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertUser")> | <a href="index.cfm?method=company.insertUser&companyID=#URL.companyID#" title="Add new contact for this company" class="SubNavLink<cfif Variables.doAction is "insertUser">On</cfif>">Create New User</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertGroupCompany")> | <a href="index.cfm?method=company.insertGroupCompany&companyID=#URL.companyID#" title="Manage and view the groups to which this company belongs" class="SubNavLink<cfif Find("Group", Variables.doAction)>On</cfif>">Groups</a>
	  <cfelseif Application.fn_IsUserAuthorized("listGroupCompany")> | <a href="index.cfm?method=company.listGroupCompany&companyID=#URL.companyID#" title="View groups of which this company is a member" class="SubNavLink<cfif Find("Group", Variables.doAction)>On</cfif>">Groups</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listInvoices")> | <a href="index.cfm?method=company.listInvoices&companyID=#URL.companyID#" title="List invoices for this company" class="SubNavLink<cfif Find("Invoice", Variables.doAction) and Variables.doAction is not "insertInvoice">On</cfif>">List Existing Invoices</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertInvoice")> | <a href="index.cfm?method=company.insertInvoice&companyID=#URL.companyID#" title="Manually create new invoice for this company" class="SubNavLink<cfif Variables.doAction is "insertInvoice">On</cfif>">Create New Invoice</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSubscribers")> | <a href="index.cfm?method=company.listSubscribers&companyID=#URL.companyID#" title="Manage and view the product subscriptions for this company" class="SubNavLink<cfif Find("Subscri", Variables.doAction)>On</cfif>">Subscriptions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertPayflowCompany")> | <a href="index.cfm?method=company.insertPayflowCompany&companyID=#URL.companyID#" title="Manage and view the subscription processing method used to process this company" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subcription Processing</a>
	  <cfelseif Application.fn_IsUserAuthorized("viewPayflowCompany")> | <a href="index.cfm?method=company.viewPayflowCompany&companyID=#URL.companyID#" title="View the subscription processing method used to process this company" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subcription Processing</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewCompany")> | <a href="index.cfm?method=company.viewCompany&companyID=#URL.companyID#&viewFieldArchives=True" title="View previous values of company information" class="SubNavLink<cfif Variables.doAction is "viewCompany" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")> | <a href="index.cfm?method=company.listPrices&companyID=#URL.companyID#" title="Create and view custom pricing options that apply to this customer company" class="SubNavLink<cfif Find("Price", Variables.doAction)>On</cfif>">Custom Pricing</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPayments")> | <a href="index.cfm?method=company.listPayments&companyID=#URL.companyID#" title="Create and view payments made by this company" class="SubNavLink<cfif Find("Payment", Variables.doAction)>On</cfif>">Payments</a>
	  <cfelseif Application.fn_IsUserAuthorized("listPaymentRefunds")> | <a href="index.cfm?method=payment.listPaymentRefunds&companyID=#URL.companyID#" title="Create and view refnds for this company" class="SubNavLink<cfif Find("Payment", Variables.doAction)>On</cfif>">Payments</a>
	  <cfelseif Application.fn_IsUserAuthorized("listPaymentCredits")> | <a href="index.cfm?method=paymentCredit.listPaymentCredits&companyID=#URL.companyID#" title="Create and view payment credits for this company" class="SubNavLink<cfif Find("PaymentCredit", Variables.doAction)>On</cfif>">Payments</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewCommissionCustomer")> | <a href="index.cfm?method=#URL.control#.viewCommissionCustomer&companyID=#URL.companyID#" title="Manage and view the salesperson(s) associated with this customer company. Used when calculating sales commissions." class="SubNavLink<cfif Find("CommissionCustomer", Variables.doAction)>On</cfif>">Salesperson(s)</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=#URL.control#.listSalesCommissions&companyID=#URL.companyID#" title="List calculated sales commissions for salespeople and partners related to this customer company" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")> | <a href="index.cfm?method=#URL.control#.insertContact&companyID=#URL.companyID#" title="Send and list existing messages sent regarding this company" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a>
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")> | <a href="index.cfm?method=#URL.control#.listContacts&companyID=#URL.companyID#" title="List existing messages sent regarding this company" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=#URL.control#.insertNote&companyID=#URL.companyID#" title="Create and view notes associated with this company" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")> | <a href="index.cfm?method=#URL.control#.listNotes&companyID=#URL.companyID#" title="View notes associated with this company" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")> | <a href="index.cfm?method=#URL.control#.insertTask&companyID=#URL.companyID#" title="Create and view tasks associated with this company" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")> | <a href="index.cfm?method=#URL.control#.listTasks&companyID=#URL.companyID#" title="View tasks associated with this company" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCompanyAffiliates")> | <a href="index.cfm?method=company.listCompanyAffiliates&companyID=#URL.companyID#" title="Manage and view affiliate listings for this company" class="SubNavLink<cfif Find("Affiliate", Variables.doAction)>On</cfif>">Affiliate</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCompanyCobrands")> | <a href="index.cfm?method=company.listCompanyCobrands&companyID=#URL.companyID#" title="Manage and view cobrand listings for this company" class="SubNavLink<cfif Find("Cobrand", Variables.doAction)>On</cfif>">Cobrand</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCompanyVendors")> | <a href="index.cfm?method=company.listCompanyVendors&companyID=#URL.companyID#" title="Manage and view vendor listings for this company" class="SubNavLink<cfif Find("Vendor", Variables.doAction)>On</cfif>">Vendor</a></cfif>
	<cfif qry_selectCompany.companyPrimary is 1 and Session.companyID is Application.billingSuperuserCompanyID and Application.billingSuperuserEnabled is True>
		<cfif Application.fn_IsUserAuthorized("insertPermissionTarget")> | <a href="index.cfm?method=company.insertPermissionTarget&companyID=#URL.companyID#" title="Manage and view permissions for this company (which they may apply to their own users)." class="SubNavLink<cfif Variables.realControl is "company" and Find("Permission", Variables.doAction)>On</cfif>">Permissions</a>
		  <cfelseif Application.fn_IsUserAuthorized("viewPermissionTarget")> | <a href="index.cfm?method=company.viewPermissionTarget&companyID=#URL.companyID#" title="View permissions for this company (which they may apply to their own users)." class="SubNavLink<cfif Variables.realControl is "company" and Find("Permission", Variables.doAction)>On</cfif>">Permissions</a></cfif>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("insertMerchant")> | <a href="index.cfm?method=merchant.insertMerchant&companyID=#URL.companyID#" title="Create a new merchant processor linked to this company" class="SubNavLink<cfif Find("Merchant", Variables.doAction)>On</cfif>">Add As Merchant Processor</a></cfif>
</cfif>
<cfif URL.control is "company" or (URL.companyID is not 0 and Variables.doAction is not "listCompanies")>
	</div><br>
	<cfif Variables.isViewPermission is True></form></cfif>
</cfif>
</cfoutput>

