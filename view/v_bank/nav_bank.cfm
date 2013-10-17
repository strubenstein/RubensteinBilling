<cfset Variables.navParameters = "&userID=#URL.userID#">
<cfif URL.control is not "user">
	<cfset Variables.navParameters = "&companyID=#URL.companyID#" & Variables.navParameters>
</cfif>

<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listBanks")><a href="index.cfm?method=#URL.control#.listBanks#Variables.navParameters#" title="List current banks for this company/user" class="SubNavLink<cfif Variables.doAction is "listBanks">On</cfif>">List Active Banks</a></cfif>
<cfif Application.fn_IsUserAuthorized("listBanksAll")> | <a href="index.cfm?method=#URL.control#.listBanksAll#Variables.navParameters#" title="List all current and previous banks for this company/user" class="SubNavLink<cfif Variables.doAction is "listBanksAll">On</cfif>">List All Banks</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertBank")> | <a href="index.cfm?method=#URL.control#.insertBank#Variables.navParameters#" title="Add new bank for this company/user" class="SubNavLink<cfif Variables.doAction is "insertBank">On</cfif>">Add New Bank</a></cfif>
</div><br>
</cfoutput>

