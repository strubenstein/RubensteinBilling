<cfoutput>
<p class="ErrorMessage">More than one vendor has the ID or code you entered. Please select the correct vendor:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th>Code</th>
	<th align="left">Vendor Name</th>
	<th align="left">Company Name</th>
</tr>
<cfloop Query="qry_viewVendorByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewVendorByID.vendorID#</td>
	<td><cfif qry_viewVendorByID.vendorID_custom is "">&nbsp;<cfelse>#qry_viewVendorByID.vendorID_custom#</cfif></td>
	<td><cfif qry_viewVendorByID.vendorCode is "">&nbsp;<cfelse>#qry_viewVendorByID.vendorCode#</cfif></td>
	<td><a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_viewVendorByID.vendorID#" class="plainlink">#qry_viewVendorByID.vendorName#</a></td>
	<td><cfif qry_viewVendorByID.companyName is "">&nbsp;<cfelse>#qry_viewVendorByID.companyName#</cfif></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
