<cfoutput>
<cfif qry_selectProductBundleList.RecordCount is 0>
	<p class="ErrorMessage">This product is not currently listed in any product bundles.</p>
<cfelse>
	<table border="1" cellspacing="2" cellpadding="2">
	<tr class="TableHeader">
		<th class="SubTitle" colspan="8">Product Bundles That Include This Product</th>
	</tr>
	<tr class="TableHeader" valign="bottom">
		<th>Product Bundle<br>Code</th>
		<th>Product Bundle<br>Name</th>
		<th>Product Bundle<br>Price</th>
		<th>Product Bundle<br>Status</th>
		<th>Product Bundle<br>Listed On Site</th>
		<th>Product Bundle<br>Date<br>Created</th>
		<th>Product<br>Quantity</th>
		<cfif ListFind(Variables.permissionActionList, "listProductBundles")>
			<th>Manage<br>Product<br>Bundle</th>
		</cfif>
	</tr>

	<cfloop Query="qry_selectProductBundleList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectProductBundleList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductBundleList.productID_custom#</cfif></td>
		<td>#qry_selectProductBundleList.productName#</td>
		<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductBundleList.productPrice)#</td>
		<td align="center"><cfif qry_selectProductBundleList.productStatus is 1>Active<cfelse>Not Active</cfif></td>
		<td align="center"><cfif qry_selectProductBundleList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td align="center" nowrap>#DateFormat(qry_selectProductBundleList.productBundleDateCreated, "mm-dd-yy")#</td>
		<td align="center">#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectProductBundleList.productBundleProductQuantity)#</td>
		<cfif ListFind(Variables.permissionActionList, "listProductBundles")>
			<td align="center" class="SmallText"><a href="index.cfm?method=product.listProductBundles&productID=#qry_selectProductBundleList.productID#">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
