<cfoutput>
<div class="SubNav">
<cfif Variables.isViewPermission is True>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="cobrand.viewCobrand">
	<input type="hidden" name="submitView" value="True">
</cfif>
<span class="SubNavTitle">Cobrands: </span>
<cfif URL.control is "company">
	<cfif Application.fn_IsUserAuthorized("listCompanyCobrands")><a href="index.cfm?method=#URL.control#.listCompanyCobrands&companyID=#URL.companyID#" title="List existing cobrands for this company" class="SubNavLink<cfif Variables.doAction is "listCompanyCobrands">On</cfif>">List Cobrands For This Company</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCobrand")> | <a href="index.cfm?method=#URL.control#.insertCobrand&companyID=#URL.companyID#" title="Add new cobrand for this company" class="SubNavLink<cfif Variables.doAction is "insertCobrand">On</cfif>">Add New Cobrand For This Company</a></cfif>
<cfelse>
	<cfif Application.fn_IsUserAuthorized("listCobrands")><a href="index.cfm?method=#URL.control#.listCobrands" title="List all existing cobrands" class="SubNavLink<cfif Variables.doAction is "listCobrands">On</cfif>">List All Existing Cobrands</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCobrand")> | To create a new cobrand, first select the company via Companies.</cfif>
	<cfif Variables.isViewPermission is True> || View Cobrand ##: <input type="text" name="cobrandID" size="8" class="SmallText" title="Enter code, ID or custom ID of cobrand"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
</cfif>
<cfif URL.cobrandID is not 0>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Cobrand: </span> 
	<span class="SubNavName">
	<cfif qry_selectCobrand.cobrandID_custom is not "">#qry_selectCobrand.cobrandID_custom#. </cfif>
	<cfif qry_selectCobrand.cobrandName is "">(no name)<cfelse>#qry_selectCobrand.cobrandName#</cfif>
	</span><br>
	<cfif Application.fn_IsUserAuthorized("viewCobrand")><a href="index.cfm?method=#URL.control#.viewCobrand&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="View cobrand summary information" class="SubNavLink<cfif Variables.doAction is "viewCobrand" and Not IsDefined("URL.viewFieldArchives")>On</cfif>">Summary</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateCobrand")> | <a href="index.cfm?method=#URL.control#.updateCobrand&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Update cobrand information" class="SubNavLink<cfif Variables.doAction is "updateCobrand">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertCobrandHeader")> | <a href="index.cfm?method=#URL.control#.insertCobrandHeader&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Update cobrand header and footer for public site" class="SubNavLink<cfif Variables.doAction is "insertCobrandHeader">On</cfif>">Header &amp; Footer</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewCobrand")> | <a href="index.cfm?method=#URL.control#.viewCobrand&cobrandID=#URL.cobrandID#&viewFieldArchives=True#Variables.urlParameters#" title="View previous values of cobrand information" class="SubNavLink<cfif Variables.doAction is "viewCobrand" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")> | <a href="index.cfm?method=#URL.control#.listPrices&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Create and view custom pricing options that apply to customers of this cobrand" class="SubNavLink<cfif Find("Price", Variables.doAction)>On</cfif>">Custom Pricing</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCommissions")> | <a href="index.cfm?method=#URL.control#.listCommissions&cobrandID=#URL.cobrandID#" title="Create and view sales commission plans that apply to this cobrand" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=#URL.control#.listSalesCommissions&cobrandID=#URL.cobrandID#" title="View calculated sales commissions for this cobrand" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")> | <a href="index.cfm?method=#URL.control#.insertContact&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Create/send new contact management message and view existing messages associated with this cobrand" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a>
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")> | <a href="index.cfm?method=#URL.control#.listContacts&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="View existing contact management messages associated with this cobrand" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=#URL.control#.insertNote&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Create and view notes associated with this cobrand" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")> | <a href="index.cfm?method=#URL.control#.listNotes&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="View notes associated with this cobrand" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")> | <a href="index.cfm?method=#URL.control#.insertTask&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Create and view tasks associated with this cobrand" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")> | <a href="index.cfm?method=#URL.control#.listTasks&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="View tasks associated with this cobrand" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertPayflowTarget")> | <a href="index.cfm?method=#URL.control#.insertPayflowTarget&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="Determine the subscription processing method used to process customers of this cobrand" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subscription Processing</a>
	  <cfelseif Application.fn_IsUserAuthorized("viewPayflowTarget")> | <a href="index.cfm?method=#URL.control#.viewPayflowTarget&cobrandID=#URL.cobrandID##Variables.urlParameters#" title="View the subscription processing method used to process customers of this cobrand" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subscription Processing</a></cfif>
</cfif>
</div><br>
<cfif Variables.isViewPermission is True></form></cfif>
</cfoutput>

