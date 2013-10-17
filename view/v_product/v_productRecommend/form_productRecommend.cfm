<cfoutput>
<p class="MainText">
<i>Recommends Product</i> - This product currently being managed recommends the product in the list.<br>
<i>Recommended By Product</i> - This product is recommended by the product in the list.
</p>

<cfif qry_selectProductList.RecordCount is 0>
	<p class="ErrorMessage">No products meet your search criteria.</p>
<cfelse>
	<form method="post" action="index.cfm?method=product.insertProductRecommend&productID=#URL.productID#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<input type="hidden" name="queryViewAction" value="#Variables.queryViewAction#">

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
		<td align="center"><input type="checkbox" name="productID_recommend" value="#qry_selectProductList.productID#"<cfif ListFind(Variables.productID_recommendList, qry_selectProductList.productID)> checked disabled</cfif>></td>
		<td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="productID_target" value="#qry_selectProductList.productID#"<cfif ListFind(Variables.productID_targetList, qry_selectProductList.productID)> checked disabled</cfif>></td>
		</tr>
	</cfloop>
	<tr><td colspan="#Variables.columnCount#" align="right"><input type="submit" name="submitProductRecommend" value="Submit Recommendations"></td></tr>
	</form>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages)#
</cfif>
<br clear="all">
</cfoutput>

