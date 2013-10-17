<cfset Variables.navParameters = "&userID=#URL.userID#">
<cfif URL.control is not "user">
	<cfset Variables.navParameters = "&companyID=#URL.companyID#" & Variables.navParameters>
</cfif>

<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listCreditCards")><a href="index.cfm?method=#URL.control#.listCreditCards#Variables.navParameters#" title="List current credit cards for this company/user" class="SubNavLink<cfif Variables.doAction is "listCreditCards">On</cfif>">List Active Credit Cards</a></cfif>
<cfif Application.fn_IsUserAuthorized("listCreditCardsAll")> | <a href="index.cfm?method=#URL.control#.listCreditCardsAll#Variables.navParameters#" title="List all current and previous credit cards for this company/user" class="SubNavLink<cfif Variables.doAction is "listCreditCardsAll">On</cfif>">List All Credit Cards</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertCreditCard")> | <a href="index.cfm?method=#URL.control#.insertCreditCard#Variables.navParameters#" title="Add new credit card for this company/user" class="SubNavLink<cfif Variables.doAction is "insertCreditCard">On</cfif>">Add New Credit Card</a></cfif>
</div><br>
</cfoutput>

