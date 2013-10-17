<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listPhones")><a href="index.cfm?method=#URL.control#.listPhones&companyID=#URL.companyID#&userID=#URL.userID#" title="List current phone numbers for this company/user" class="SubNavLink<cfif Variables.doAction is "listPhones">On</cfif>">List Current Phone Numbers</a></cfif>
<cfif Application.fn_IsUserAuthorized("listPhonesAll")> | <a href="index.cfm?method=#URL.control#.listPhonesAll&companyID=#URL.companyID#&userID=#URL.userID#" title="List all current and previous phone numbers for this company/user" class="SubNavLink<cfif Variables.doAction is "listPhonesAll">On</cfif>">List All Phone Numbers</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPhone")> | <a href="index.cfm?method=#URL.control#.insertPhone&companyID=#URL.companyID#&userID=#URL.userID#" title="Add new phone/fax number for this company/user" class="SubNavLink<cfif Variables.doAction is "insertPhone">On</cfif>">Add New Phone Numbers</a></cfif>
</div><br>
</cfoutput>

