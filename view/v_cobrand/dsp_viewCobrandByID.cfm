<cfoutput>
<p class="ErrorMessage">More than one cobrand has the ID or code you entered. Please select the correct cobrand:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th>Code</th>
	<th align="left">Cobrand Name</th>
	<th align="left">Company Name</th>
</tr>
<cfloop Query="qry_viewCobrandByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewCobrandByID.cobrandID#</td>
	<td><cfif qry_viewCobrandByID.cobrandID_custom is "">&nbsp;<cfelse>#qry_viewCobrandByID.cobrandID_custom#</cfif></td>
	<td><cfif qry_viewCobrandByID.cobrandCode is "">&nbsp;<cfelse>#qry_viewCobrandByID.cobrandCode#</cfif></td>
	<td><a href="index.cfm?method=cobrand.viewCobrand&cobrandID=#qry_viewCobrandByID.cobrandID#" class="plainlink">#qry_viewCobrandByID.cobrandName#</a></td>
	<td><cfif qry_viewCobrandByID.companyName is "">&nbsp;<cfelse>#qry_viewCobrandByID.companyName#</cfif></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
