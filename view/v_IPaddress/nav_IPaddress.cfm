<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">IP Address Restrictions: </span>
<cfif Application.fn_IsUserAuthorized("listIPaddresses")><a href="index.cfm?method=IPaddress.listIPaddresses" title="List existing IP address restrictions for your users to access Billing" class="SubNavLink<cfif Variables.doAction is "listIPaddresses">On</cfif>">List Existing IP Address Restrictions</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertIPaddress")> | <a href="index.cfm?method=IPaddress.insertIPaddress" title="Add new IP address restriction for your users to access Billing" class="SubNavLink<cfif Variables.doAction is "insertIPaddress">On</cfif>">Add New IP Address Restrictions</a></cfif>
</div><br>
</cfoutput>

