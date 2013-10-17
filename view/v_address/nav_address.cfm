<!--- 
<cfscript>
function fn_SubNavAddress (navAction, navTitle, navText, navSeparator)
{
	var navClass = "SubNavLink";
	if (Application.fn_IsUserAuthorized(navAction))
	{
		if (Variables.doAction is navAction)
			navClass = "SubNavLinkOn";
		return "<a href=""index.cfm?method=#URL.control#.#navAction#&companyID=#URL.companyID#&userID=#URL.userID#"" title=""#navTitle#"" class=""#navClass#"">#navText#</a>#navSeparator#";
	}
}
</cfscript>
#fn_SubNavAddress("listAddresses", "List current addresses for this company/user", "List Current Addresses", " | ")#
#fn_SubNavAddress("listAddressesAll", "List all addresses for this company/user", "List All Addresses", " | ")#
#fn_SubNavAddress("insertAddress", "Add new address for this company/user", "Add New Address", "")#
--->

<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listAddresses")><a href="index.cfm?method=#URL.control#.listAddresses&companyID=#URL.companyID#&userID=#URL.userID#" title="List current addresses for this company/user" class="SubNavLink<cfif Variables.doAction is "listAddresses">On</cfif>">List Current Addresses</a> | </cfif>
<cfif Application.fn_IsUserAuthorized("listAddressesAll")><a href="index.cfm?method=#URL.control#.listAddressesAll&companyID=#URL.companyID#&userID=#URL.userID#" title="List all addresses for this company/user" class="SubNavLink<cfif Variables.doAction is "listAddressesAll">On</cfif>">List All Addresses</a> | </cfif>
<cfif Application.fn_IsUserAuthorized("insertAddress")><a href="index.cfm?method=#URL.control#.insertAddress&companyID=#URL.companyID#&userID=#URL.userID#" title="Add new address for this company/user" class="SubNavLink<cfif Variables.doAction is "insertAddress">On</cfif>">Add New Address</a></cfif>
</div><br>
</cfoutput>

