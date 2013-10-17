<cfoutput>
<cfif qry_selectProductList.RecordCount is 0>
	<p class="ErrorMessage">No products meet your search criteria.</p>
<cfelse>
	<p class="MainText"><b>To add a product to the bundle, just enter the quantity and click<br>
	submit. Quantity may have a maximum of 4 decimal places.<br>
	Only products not already included in this package are listed.</b></p>

	<form method="post" action="index.cfm?method=product.insertProductBundle&productID=#URL.productID#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<input type="hidden" name="queryViewAction" value="#Variables.queryViewAction#">
	<input type="hidden" name="productID_list" value="#ValueList(qry_selectProductList.productID)#">

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectProductList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectProductList.productID_custom#</td>
		<td>&nbsp;</td>
		<td>#qry_selectProductList.productName#</td>
		<td>&nbsp;</td>
		<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductList.productPrice)#</td>
		<td>&nbsp;</td>
		<td align="center"><cfif qry_selectProductList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td>&nbsp;</td>
		<td align="center" nowrap>#DateFormat(qry_selectProductList.productDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td align="center"><input type="text" name="productBundleProductQuantity#qry_selectProductList.productID#" value="" size="5"></td>
		</tr>
	</cfloop>
	<tr><td colspan="13" align="right"><input type="submit" name="submitProductBundle" value="Add to Bundle"></td></tr>
	</form>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages)#
</cfif>
<br clear="all">
</cfoutput>

