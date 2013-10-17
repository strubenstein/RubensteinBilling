<cfoutput>
<cfif qry_selectProductList.RecordCount is 0>
	<p class="ErrorMessage">No products meet your search criteria.</p>
<cfelse>
	<cfif Variables.displayProductCategoryOrder is True>
		<p class="MainText">
		Products are listed in alphabetical order by default.<br>
		<b>To switch the product order within a category, the products must be listed by their order.</b><br>
		<b>To do this, click the &quot;Up&quot; arrow beneath the ## sign in the first column.</b><br>
		Before switching the order in which the products are listed in the category, please note<br>
		that all products in this category may not be listed, depending on your filter criteria.<br>
		If a product order is skipped, the order number will be <font color="red">red</font> to indicate a missing product.
		</p>
	</cfif>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectProductList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.displayProductCategoryOrder is True>
			<td align="right"><cfif CurrentRow is 1 or Variables.displaySwitchProductCategoryOrder is False>#qry_selectProductList.productCategoryOrder#<cfelseif qry_selectProductList.productCategoryOrder is not IncrementValue(qry_selectProductList.productCategoryOrder[CurrentRow - 1])><font color="red">#qry_selectProductList.productCategoryOrder#</font><cfelse>#qry_selectProductList.productCategoryOrder#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td><cfif qry_selectProductList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductList.productID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectProductList.productName#</td>
		<td>&nbsp;</td>
		<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductList.productPrice)#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductList.productDateCreated, "mm-dd-yy")#</td>
		<cfif Variables.displayProductViewCount is True>
			<td>&nbsp;</td>
			<td>#qry_selectProductList.productViewCount#</td>
		</cfif>
		<cfif Variables.displayProductCategoryOrder is True and ListFind(Variables.permissionActionList, "moveProductCategoryDown") and ListFind(Variables.permissionActionList, "moveProductCategoryUp")>
			<td>&nbsp;</td>
			<td>
				<cfif Variables.displaySwitchProductCategoryOrder is False>
					-
				<cfelse>
					<cfif CurrentRow is RecordCount>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=#URL.method#.moveProductCategoryDown&productID=#qry_selectProductList.productID#&categoryID=#URL.categoryID#&redirectURL=#Variables.redirectURL#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
					<cfif CurrentRow is 1>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=category.moveProductCategoryUp&productID=#qry_selectProductList.productID#&categoryID=#URL.categoryID#&redirectURL=#Variables.redirectURL#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "viewProduct")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=product.viewProduct&productID=#qry_selectProductList.productID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportProducts")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>

