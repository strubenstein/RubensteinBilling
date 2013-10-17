<cfoutput>
<cfif qry_selectProductList.RecordCount is 0>
	<p class="ErrorMessage">No products meet your search criteria.</p>
<cfelse>
	<p class="MainText"><b>
	To add a product to this #Variables.insertName#, click the &quot;#Variables.formSubmitValue#&quot; link for that product. To remove, click the or &quot;Remove&quot; link.
	<cfif Variables.includeProductChildren is True>
		<br>To add a product <i>and</i> its child products, click the &quot;#Variables.formSubmitValueChildren#&quot; link instead of the &quot;#Variables.formSubmitValue#&quot; link.
	</cfif>
	</b></p>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectProductList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectProductList.productID_custom#</td>
		<td>&nbsp;</td>
		<td>#qry_selectProductList.productName#<cfif Variables.includeProductChildren is True and Variables.productsWithChildren is not "" and ListFind(Variables.productsWithChildren, qry_selectProductList.productID)><br>&nbsp; &nbsp; --<i>Includes product children</i></cfif></td>
		<td>&nbsp;</td>
		<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductList.productPrice)#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductList.productDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td class="SmallText">
			<a href="#Variables.insertURL#&productID=#qry_selectProductList.productID#" class="plainlink">#Variables.formSubmitValue#</a>
			<cfif Variables.includeProductChildren is True and Variables.formSubmitValueChildren is not "">
				 | <a href="#Variables.insertURL#&productID=#qry_selectProductList.productID#&includeProductChildren=1" class="plainlink">#Variables.formSubmitValueChildren#</a>
			</cfif>
		</td>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#
</cfif>
<br clear="all">
</cfoutput>

