<cfoutput>
<p class="ErrorMessage">More than one company has the ID you entered. Please select the correct company:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th align="left">Company Name</th>
</tr>
<cfloop Query="qry_viewCompanyByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewCompanyByID.companyID#</td>
	<td><cfif qry_viewCompanyByID.companyID_custom is "">&nbsp;<cfelse>#qry_viewCompanyByID.companyID_custom#</cfif></td>
	<td><a href="index.cfm?method=#URL.control#.viewCompany&companyID=#qry_viewCompanyByID.companyID#" class="plainlink">#qry_viewCompanyByID.companyName#</a></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
