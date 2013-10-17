<cfoutput>
<cfif URL.control is "user" or (URL.userID is not 0 and Variables.doAction is not "listUsers")>
	<div class="SubNav">
	<cfif Variables.isViewPermission is True>
		<form method="get" action="index.cfm">
		<input type="hidden" name="method" value="user.viewUser">
		<input type="hidden" name="submitView" value="True">
	</cfif>
</cfif>
<cfif URL.control is "user">
	<cfif Application.fn_IsUserAuthorized("listUsers")>
		<a href="index.cfm?method=user.listUsers" title="List existing users in all companies" class="SubNavLink<cfif Variables.doAction is "listUsers">On</cfif>">List Existing Users</a>
		 | <a href="index.cfm?method=user.listUsers&returnMyCompanyUsersOnly=1" title="List users in your company" class="SubNavLink<cfif Variables.doAction is "listUsers" and IsDefined("returnMyCompanyUsersOnly") and returnMyCompanyUsersOnly is 1>On</cfif>">List My Company Users</a>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("viewUser")> | <a href="index.cfm?method=user.viewUser&userID=#Session.userID#" title="Manage your own user information" class="SubNavLink<cfif URL.userID is Session.userID>On</cfif>">Manage My User Info</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertUser")> | <a href="index.cfm?method=user.insertUser" title="Create new user in your company" class="SubNavLink<cfif Variables.doAction is "insertUser">On</cfif>">Create New User</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listLoginSessions")> | <a href="index.cfm?method=user.listLoginSessions" title="View login stats for admin users." class="SubNavLink<cfif Variables.doAction is "listLoginSessions">On</cfif>">Current Admin Sessions</a></cfif>
	<cfif Variables.isViewPermission is True> || View User ##: <input type="text" name="userID" size="8" class="SmallText" title="Enter username, ID or custom ID of user"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
</cfif>
<cfif URL.userID is not 0 and Variables.doAction is not "listUsers">
	<cfif URL.control is "user"><br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br></cfif>
	<span class="SubNavObject">User:</span> <span class="SubNavName"><cfif qry_selectUser.userID_custom is not "">#qry_selectUser.userID_custom#. </cfif> #qry_selectUser.firstName# #qry_selectUser.lastName# #qry_selectUser.suffix#</span><br>
	<cfif Application.fn_IsUserAuthorized("viewUser")><a href="index.cfm?method=#URL.control#.viewUser&companyID=#URL.companyID#&userID=#URL.userID#" title="View user summary information" class="SubNavLink<cfif Variables.doAction is "viewUser" and Not IsDefined("URL.viewFieldArchives")>On</cfif>">Summary</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("updateUser")><a href="index.cfm?method=#URL.control#.updateUser&companyID=#URL.companyID#&userID=#URL.userID#" title="Update user information" class="SubNavLink<cfif Variables.doAction is "updateUser">On</cfif>">Update</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("viewLoginSessionsForUser")><a href="index.cfm?method=#URL.control#.viewLoginSessionsForUser&companyID=#URL.companyID#&userID=#URL.userID#" title="View login session history for this user" class="SubNavLink<cfif Variables.doAction is "viewLoginSessionsForUser">On</cfif>">User Activity</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listAddresses")><a href="index.cfm?method=#URL.control#.listAddresses&companyID=#URL.companyID#&userID=#URL.userID#" title="Manage and view addresses for this user" class="SubNavLink<cfif Find("Address", Variables.doAction)>On</cfif>">Address</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPhones")><a href="index.cfm?method=#URL.control#.listPhones&companyID=#URL.companyID#&userID=#URL.userID#" title="Manage and view phone/fax numbers for this user" class="SubNavLink<cfif Find("Phone", Variables.doAction)>On</cfif>">Phone</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listCreditCards")><a href="index.cfm?method=#URL.control#.listCreditCards&companyID=#URL.companyID#&userID=#URL.userID#" title="Manage and view credit card numbers for this user" class="SubNavLink<cfif Find("CreditCard", Variables.doAction)>On</cfif>">Credit Card</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listBanks")><a href="index.cfm?method=#URL.control#.listBanks&companyID=#URL.companyID#&userID=#URL.userID#" title="Manage and view bank accounts for this user" class="SubNavLink<cfif Find("Bank", Variables.doAction)>On</cfif>">Bank</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertPermissionTarget")><a href="index.cfm?method=#URL.control#.insertPermissionTarget&companyID=#URL.companyID#&userID=#URL.userID#" title="Manage and view permissions assigned directly to this user" class="SubNavLink<cfif Find("Permission", Variables.doAction)>On</cfif>">Permissions</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("viewPermissionTarget")><a href="index.cfm?method=#URL.control#.viewPermissionTarget&companyID=#URL.companyID#&userID=#URL.userID#" title="View permissions assigned directly to this user (as opposed to via groups)" class="SubNavLink<cfif Find("Permission", Variables.doAction)>On</cfif>">Permissions</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertGroupUser")><a href="index.cfm?method=#URL.control#.insertGroupUser&companyID=#URL.companyID#&userID=#URL.userID#" title="Determine groups of which the user is a member" class="SubNavLink<cfif Find("Group", Variables.doAction)>On</cfif>">Groups</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listGroupUser")><a href="index.cfm?method=#URL.control#.listGroupUser&companyID=#URL.companyID#&userID=#URL.userID#" title="View groups of which this user is a member" class="SubNavLink<cfif Find("Group", Variables.doAction)>On</cfif>">Groups</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listInvoices")><a href="index.cfm?method=#URL.control#.listInvoices&companyID=#URL.companyID#&userID=#URL.userID#" title="List invoices where this user is the stated contact person" class="SubNavLink<cfif Find("Invoice", Variables.doAction) and Variables.doAction is not "insertInvoice">On</cfif>">Existing Invoices</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertInvoice")><a href="index.cfm?method=#URL.control#.insertInvoice&companyID=#URL.companyID#&userID=#URL.userID#" title="Create new invoice where the user is the stated contact person" class="SubNavLink<cfif Variables.doAction is "insertInvoice">On</cfif>">New Invoice</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listSubscribers")><a href="index.cfm?method=#URL.control#.listSubscribers&companyID=#URL.companyID#&userID=#URL.userID#" title="List the subscribers and subscriptions where this user is the contact person" class="SubNavLink<cfif Find("Subscri", Variables.doAction)>On</cfif>">Subscriptions</a> | </cfif>
	<!--- <cfif Application.fn_IsUserAuthorized("listUserCompanies")><a href="index.cfm?method=#URL.control#.listUserCompanies&companyID=#URL.companyID#&userID=#URL.userID#" title="List the companies to which this user belongs" class="SubNavLink<cfif Variables.doAction is "listUserCompanies">On</cfif>">Existing Companies</a> | </cfif> --->
	<!--- <cfif Application.fn_IsUserAuthorized("insertUserCompany")><a href="index.cfm?method=#URL.control#.insertUserCompany&companyID=#URL.companyID#&userID=#URL.userID#" title="Determine which companies this user belongs to" class="SubNavLink<cfif Variables.doAction is "insertUserCompany">On</cfif>">Add to Company</a> | </cfif> --->
	<cfif Application.fn_IsUserAuthorized("viewUser")><a href="index.cfm?method=#URL.control#.viewUser&companyID=#URL.companyID#&userID=#URL.userID#&viewFieldArchives=True" title="View previous values of user information" class="SubNavLink<cfif Variables.doAction is "viewUser" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")><a href="index.cfm?method=#URL.control#.listPrices&companyID=#URL.companyID#&userID=#URL.userID#" title="Create and view custom pricing options that apply to this user" class="SubNavLink<cfif Find("Price", Variables.doAction)>On</cfif>">Custom Pricing</a> | </cfif>
	<cfif qry_selectUser.companyID is Session.companyID_author>
		<cfif Application.fn_IsUserAuthorized("viewCommissionCustomer")><a href="index.cfm?method=#URL.control#.viewCommissionCustomer&companyID=#URL.companyID#&userID=#URL.userID#" title="View customers for which this user is the stated salesperson (for purposes of calculating sales commissions)" class="SubNavLink<cfif Find("CommissionCustomer", Variables.doAction)>On</cfif>">Customers</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("listCommissions")><a href="index.cfm?method=#URL.control#.listCommissions&companyID=#URL.companyID#&userID=#URL.userID#" title="Create and view sales commission plans that apply to this user" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a> | </cfif>
		<cfif Application.fn_IsUserAuthorized("listSalesCommissions")><a href="index.cfm?method=#URL.control#.listSalesCommissions&companyID=#URL.companyID#&userID=#URL.userID#" title="View calculated sales commissions for this user" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a> | </cfif>
	</cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")><a href="index.cfm?method=#URL.control#.insertContact&companyID=#URL.companyID#&userID=#URL.userID#" title="Create/send new contact management message and view existing messages associated with this user" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")><a href="index.cfm?method=#URL.control#.listContacts&companyID=#URL.companyID#&userID=#URL.userID#" title="View existing contact management messages associated with this user" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")><a href="index.cfm?method=#URL.control#.insertNote&companyID=#URL.companyID#&userID=#URL.userID#" title="Create and view notes associated with this user" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a> | 
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")><a href="index.cfm?method=#URL.control#.listNotes&companyID=#URL.companyID#&userID=#URL.userID#" title="View notes associated with this user" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")><a href="index.cfm?method=#URL.control#.insertTask&companyID=#URL.companyID#&userID=#URL.userID#" title="Create and view tasks associated with this user" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")><a href="index.cfm?method=#URL.control#.listTasks&companyID=#URL.companyID#&userID=#URL.userID#" title="View tasks associated with this user" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
<cfif URL.control is "user" or (URL.userID is not 0 and Variables.doAction is not "listUsers")>
	</div><br>
	<cfif Variables.isViewPermission is True></form></cfif>
</cfif>
</cfoutput>

