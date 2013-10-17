<cfoutput>
<div class="SubNav">
<cfif Variables.isViewPermission is True>
	<form method="get" action="index.cfm">
	<input type="hidden" name="method" value="affiliate.viewAffiliate">
	<input type="hidden" name="submitView" value="True">
</cfif>
<span class="SubNavTitle">Affiliates: </span>
<cfif URL.control is "company">
	<cfif Application.fn_IsUserAuthorized("listCompanyAffiliates")><a href="index.cfm?method=#URL.control#.listCompanyAffiliates&companyID=#URL.companyID#" title="List existing affiliates for this company" class="SubNavLink<cfif Variables.doAction is "listCompanyAffiliates">On</cfif>">List Affiliates For This Company</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertAffiliate")> | <a href="index.cfm?method=#URL.control#.insertAffiliate&companyID=#URL.companyID#" title="Add new affiliate for this company" class="SubNavLink<cfif Variables.doAction is "insertAffiliate">On</cfif>">Add New Affiliate For This Company</a></cfif>
<cfelse>
	<cfif Application.fn_IsUserAuthorized("listAffiliates")><a href="index.cfm?method=affiliate.listAffiliates" title="List all existing affiliates" class="SubNavLink<cfif Variables.doAction is "listAffiliates">On</cfif>">List All Existing Affiliates</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertAffiliate")> | To create a new affiliate, first select the company via Companies.</cfif>
	<cfif Variables.isViewPermission is True> || View Affiliate ##: <input type="text" name="affiliateID" size="8" class="SmallText" title="Enter code, ID or custom ID of affiliate"> <input type="submit" value="Go" class="SmallText" style="color=white;background=784397;bordercolor=white"></cfif>
</cfif>
<cfif URL.affiliateID is not 0>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Affiliate: </span> 
	<span class="SubNavName">
	<cfif qry_selectAffiliate.affiliateID_custom is not "">#qry_selectAffiliate.affiliateID_custom#. </cfif>
	<cfif qry_selectAffiliate.affiliateName is "">(no name)<cfelse>#qry_selectAffiliate.affiliateName#</cfif>
	</span><br>
	<cfif Application.fn_IsUserAuthorized("viewAffiliate")><a href="index.cfm?method=#URL.control#.viewAffiliate&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="View affiliate summary information" class="SubNavLink<cfif Variables.doAction is "viewAffiliate" and Not IsDefined("URL.viewFieldArchives")>On</cfif>">Summary</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateAffiliate")> | <a href="index.cfm?method=#URL.control#.updateAffiliate&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Update affiliate information" class="SubNavLink<cfif Variables.doAction is "updateAffiliate">On</cfif>">Update</a></cfif>
	<cfif Application.fn_IsUserAuthorized("viewAffiliate")> | <a href="index.cfm?method=#URL.control#.viewAffiliate&affiliateID=#URL.affiliateID#&viewFieldArchives=True#Variables.urlParameters#" title="View previous values of affiliate information" class="SubNavLink<cfif Variables.doAction is "viewAffiliate" and IsDefined("URL.viewFieldArchives") and URL.viewFieldArchives is True>On</cfif>">Archived Values</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listPrices")> | <a href="index.cfm?method=#URL.control#.listPrices&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Create and view custom pricing options that apply to customers of this affiliate" class="SubNavLink<cfif Find("Price", Variables.doAction)>On</cfif>">Custom Pricing</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listCommissions")> | <a href="index.cfm?method=#URL.control#.listCommissions&affiliateID=#URL.affiliateID#" title="Create and view sales commission plans that apply to this affiliate" class="SubNavLink<cfif Variables.doAction is "listCommissions">On</cfif>">Commission Plans</a></cfif>
	<cfif Application.fn_IsUserAuthorized("listSalesCommissions")> | <a href="index.cfm?method=#URL.control#.listSalesCommissions&affiliateID=#URL.affiliateID#" title="View calculated sales commissions for this affiliate" class="SubNavLink<cfif Find("SalesCommission", Variables.doAction)>On</cfif>">Sales Commissions</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertContact")> | <a href="index.cfm?method=#URL.control#.insertContact&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Create/send new contact management message and view existing messages associated with this affiliate" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a>
	  <cfelseif Application.fn_IsUserAuthorized("listContacts")> | <a href="index.cfm?method=#URL.control#.listContacts&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="View existing contact management messages associated with this affiliate" class="SubNavLink<cfif Find("Contact", Variables.doAction)>On</cfif>">Contact Mgmt.</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertNote")> | <a href="index.cfm?method=#URL.control#.insertNote&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Create and view notes associated with this affiliate" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a>
	  <cfelseif Application.fn_IsUserAuthorized("listNotes")> | <a href="index.cfm?method=#URL.control#.listNotes&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="View notes associated with this affiliate" class="SubNavLink<cfif Find("Note", Variables.doAction)>On</cfif>">Notes</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertTask")> | <a href="index.cfm?method=#URL.control#.insertTask&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Create and view tasks associated with this affiliate" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a>
	  <cfelseif Application.fn_IsUserAuthorized("listTasks")> | <a href="index.cfm?method=#URL.control#.listTasks&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="View tasks associated with this affiliate" class="SubNavLink<cfif Find("Task", Variables.doAction)>On</cfif>">Tasks</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertPayflowTarget")> | <a href="index.cfm?method=#URL.control#.insertPayflowTarget&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="Determine the subscription processing method used to process customers of this affiliate" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subscription Processing</a>
	  <cfelseif Application.fn_IsUserAuthorized("viewPayflowTarget")> | <a href="index.cfm?method=#URL.control#.viewPayflowTarget&affiliateID=#URL.affiliateID##Variables.urlParameters#" title="View the subscription processing method used to process customers of this affiliate" class="SubNavLink<cfif Find("Payflow", Variables.doAction)>On</cfif>">Subscription Processing</a></cfif>
</cfif>
</div><br>
<cfif Variables.isViewPermission is True></form></cfif>
</cfoutput>

