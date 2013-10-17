<cfoutput>
<cfif qry_selectProductBundleProductList.RecordCount is 0>
	<p class="ErrorMessage">This product bundle does not currently include any products.</p>
<cfelse>
	<cfif Variables.isDisplayForm is True and ListFind(Variables.permissionActionList, "updateProductBundle")>
		<form method="post" name="productBundleUpdate" action="index.cfm?method=product.updateProductBundle&productID=#URL.productID#">
		<input type="hidden" name="isFormSubmitted" value="True">
	<cfelse>
		<p class="MainText"><b>To make any changes to the products in this bundle, you must first change the product status to <i>Inactive</i> via the <i>Main</i> tab.</b></p>
	</cfif>

	<table border="1" cellspacing="2" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>Order</th>
		<th>Product<br>Code</th>
		<th>Product Name</th>
		<th>Product<br>Price</th>
		<th>Product<br>Listed On Site</th>
		<th>Product<br>Quantity</th>
		<cfif Variables.isDisplayForm is True>
			<cfif ListFind(Variables.permissionActionList, "moveProductBundleDown") and ListFind(Variables.permissionActionList, "moveProductBundleUp")>
				<th>Switch<br>Order</th>
			</cfif>
			<cfif ListFind(Variables.permissionActionList, "updateProductBundle")>
				<th>Update<br>Quantity</th>
			</cfif>
			<cfif ListFind(Variables.permissionActionList, "deleteProductBundle")>
				<th>Remove From<br>Bundle</th>
			</cfif>
		</cfif>
	</tr>

	<cfloop Query="qry_selectProductBundleProductList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td ailgn="center">#qry_selectProductBundleProductList.productBundleProductOrder#</td>
		<td><cfif qry_selectProductBundleProductList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductBundleProductList.productID_custom#</cfif></td>
		<td>#qry_selectProductBundleProductList.productName#</td>
		<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductBundleProductList.productPrice)#</td>
		<td align="center"><cfif qry_selectProductBundleProductList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td align="center">#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectProductBundleProductList.productBundleProductQuantity)#</td>
		<cfif Variables.isDisplayForm is True>
			<cfif ListFind(Variables.permissionActionList, "moveProductBundleDown") and ListFind(Variables.permissionActionList, "moveProductBundleUp")>
				<td align="center">
					<cfif CurrentRow is RecordCount>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductBundleDown&productID=#URL.productID#&productID_bundle=#qry_selectProductBundleProductList.productID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
					<cfif CurrentRow is 1>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductBundleUp&productID=#URL.productID#&productID_bundle=#qry_selectProductBundleProductList.productID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
				</td>
			</cfif>
			<cfif ListFind(Variables.permissionActionList, "updateProductBundle")>
				<td align="center"><input type="text" name="productBundleProductQuantity#qry_selectProductBundleProductList.productID#" value="#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectProductBundleProductList.productBundleProductQuantity)#" size="5"></td>
			</cfif>
			<cfif ListFind(Variables.permissionActionList, "deleteProductBundle")>
				<td align="center" class="SmallText"><a href="index.cfm?method=product.deleteProductBundle&productID=#URL.productID#&productID_bundle=#qry_selectProductBundleProductList.productID#" class="plainlink">Remove</a></td>
			</cfif>
		</cfif>
		</tr>
	</cfloop>
	</table>

	<cfif Variables.isDisplayForm is True and ListFind(Variables.permissionActionList, "updateProductBundle")>
		<p><input type="submit" name="submitProductBundleUpdate" value="Update Quantity"></p>
		</form>
	</cfif>
</cfif>
</cfoutput>

