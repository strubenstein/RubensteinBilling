<cfoutput>
<div class="SubNav">
<cfif Variables.isViewPermission is True>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="vendor.viewVendor">
	<input type="hidden" name="submitView" value="True">
</cfif>
<span class="SubNavTitle">Vendors: </span>
<cfif URL.control is "company">
	<cfif Application.fn_IsUserAuthorized("listCompanyVendors")><a href="index.cfm?method=#URL.control#.listCompanyVendors&companyID=#URL.companyID#" title="List existing vendors for this company" class="SubNavLink<cfif Variables.doAction is "listCompanyVendors">On</cfif>">List Vendors For This Company</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertVendor")> | <a href="index.cfm?method=#URL.control#.insertVendor&companyID=#URL.companyID#" title="Add new vendor for this company" class="SubNavLink<cfif Variables.doAction is "insertVendor">On</cfif>">Add New Vendor For This Company</a></cfif>
<cfelse>
	<cfif Application.fn_IsUserAuthorized("listVendors")><a href="index.cfm?method=#URL.control#.listVendors" title="List all existing vendors" class="SubNavLink<cfif Variables.doAction is "listVendors">On</cfif>">List All Existing Vendors</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertVendor")> | To create a new vendor, first select the company via Companies.</cfif>
	<cfif Variables.isViewPermission is True> || View Vendor ##: <input type="text" name="vendorID" size="8" class="SmallText" title="Enter code, ID or custom ID of vendor"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
</cfif>
<cfif URL.vendorID is not 0>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Vendor: </span> 
	<span class="SubNavName">
	<cfif qry_selectVendor.vendorID_custom is not "">#qry_selectVendor.vendorID_custom#. </cfif>
	<cfif qry_selectVendor.vendorName is "">(no name)<cfelse>#qry_selectVendor.vendorName#</cfif>
	</span><br>
	<cfif Application.fn_IsUserAuthorized("viewVendor")><a href="index.cfm?method=#URL.control#.viewVendor&vendorID=#URL.vendorID##Variables.urlParameters#" title="View vendor summary information" class="SubNavLink<cfif Variables.doAction is "viewVendor" and Not IsDefined("URL.viewFieldArchives")>On</cfif>">Summary</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateVendor")> | <a href="index.cfm?method=#URL.control#.updateVendor&vendorID=#URL.vendorID##Variables.urlParameters#" title="Update vendor information" class="SubNavLink<cfif Variables.doAction is "updateVendor">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewVendor")> | <a href="index.cfm?method=#URL.control#.viewVendor&vendorID=#URL.vendorID#&viewFieldArchives=True#Variables.urlParameters#" title="View previous values of vendor information" class="SubNavLink<cfif Variables.doAction is "viewVendor" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listProducts")> | <a href="index.cfm?method=#URL.control#.listProducts&vendorID=#URL.vendorID##Variables.urlParameters#" title="List products supplied by this vendor" class="SubNavLink<cfif Variables.doAction is "listProducts">On</cfif>">Products</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCommissions")> | <a href="index.cfm?method=#URL.control#.listCommissions&vendorID=#URL.vendorID##Variables.urlParameters#" title="Create and view sales commission plans that apply to this vendor" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=#URL.control#.listSalesCommissions&vendorID=#URL.vendorID##Variables.urlParameters#" title="View calculated sales commissions for this vendor" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")> | <a href="index.cfm?method=#URL.control#.insertContact&vendorID=#URL.vendorID##Variables.urlParameters#" title="Create/send new contact management message and view existing messages associated with this vendor" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a>
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")> | <a href="index.cfm?method=#URL.control#.listContacts&vendorID=#URL.vendorID##Variables.urlParameters#" title="View existing contact management messages associated with this vendor" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=#URL.control#.insertNote&vendorID=#URL.vendorID##Variables.urlParameters#" title="Create and view notes associated with this vendor" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")> | <a href="index.cfm?method=#URL.control#.listNotes&vendorID=#URL.vendorID##Variables.urlParameters#" title="View notes associated with this vendor" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")> | <a href="index.cfm?method=#URL.control#.insertTask&vendorID=#URL.vendorID##Variables.urlParameters#" title="Create and view tasks associated with this vendor" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")> | <a href="index.cfm?method=#URL.control#.listTasks&vendorID=#URL.vendorID##Variables.urlParameters#" title="View tasks associated with this vendor" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
</cfif>
</div><br>
<cfif Variables.isViewPermission is True></form></cfif>
</cfoutput>
