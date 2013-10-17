<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listSalesCommissions")>
	<a href="index.cfm?method=#URL.control#.listSalesCommissions#Variables.urlParameters#" title="List exising sales commissions" class="SubNavLink<cfif Variables.doAction is "listSalesCommissions">On</cfif>">List Sales Commissions <cfif URL.control is "invoice">For Invoice<cfelseif URL.control is "subscription"><cfif Variables.subscriptionID is 0>For Subscriber<cfelse>For Subscription</cfif></cfif></a>
</cfif>
<cfif ListFind("affiliate,cobrand,invoice,user,vendor,salesCommission", URL.control) and Application.fn_IsUserAuthorized("insertSalesCommission")>
	 | <a href="index.cfm?method=#URL.control#.insertSalesCommission#Variables.urlParameters#" title="Add manual sales commission" class="SubNavLink<cfif Variables.doAction is "insertSalesCommission">On</cfif>">Add Manual Sales Commission<cfif URL.control is "invoice"> For This Invoice<cfelseif URL.control is not "salesCommission"> For This Target</cfif></a>
</cfif>
</div><br>
</cfoutput>
