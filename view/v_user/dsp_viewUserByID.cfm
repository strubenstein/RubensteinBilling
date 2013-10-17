<cfoutput>
<p class="ErrorMessage">More than one user has the username or ID you entered. Please select the correct user:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th>Username</th>
	<th align="left">Last/First Name</th>
	<th align="left">Company Name</th>
</tr>
<cfloop Query="qry_viewUserByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewUserByID.userID#</td>
	<td><cfif qry_viewUserByID.userID_custom is "">&nbsp;<cfelse>#qry_viewUserByID.userID_custom#</cfif></td>
	<td><cfif qry_viewUserByID.username is "">&nbsp;<cfelse>#qry_viewUserByID.username#</cfif></td>
	<td><a href="index.cfm?method=#URL.control#.viewUser&userID=#qry_viewUserByID.userID#" class="plainlink">#qry_viewUserByID.lastName#<cfif qry_viewUserByID.firstName is not "">, #qry_viewUserByID.firstName#</cfif></a></td>
	<td><cfif qry_viewUserByID.companyName is "">&nbsp;<cfelse>#qry_viewUserByID.companyName#</cfif></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
