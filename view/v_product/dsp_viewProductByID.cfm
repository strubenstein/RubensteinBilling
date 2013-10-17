<cfoutput>
<p class="ErrorMessage">More than one product has the ID you entered. Please select the correct product:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th align="left">Product Name</th>
</tr>
<cfloop Query="qry_viewProductByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewProductByID.productID#</td>
	<td><cfif qry_viewProductByID.productID_custom is "">&nbsp;<cfelse>#qry_viewProductByID.productID_custom#</cfif></td>
	<td><a href="index.cfm?method=product.viewProduct&productID=#qry_viewProductByID.productID#" class="plainlink">#qry_viewProductByID.productName#</a></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
