<cfoutput>
<cfset Variables.query_list = "">
<cfif qry_selectProductRecommendList_recommend.RecordCount is 0>
	<p class="ErrorMessage">No products are currently recommended by this product.</p>
<cfelse>
	<cfset Variables.query_list = "qry_selectProductRecommendList_recommend">
</cfif>

<cfif qry_selectProductRecommendList_target.RecordCount is 0>
	<p class="ErrorMessage">No products currently recommend this product.</p>
<cfelse>
	<cfset Variables.query_list = ListAppend(Variables.query_list, "qry_selectProductRecommendList_target")>
</cfif>

<cfif Variables.query_list is not "">
	<table border="0" cellspacing="0" cellpadding="2">
	<cfloop Index="query_name" List="#Variables.query_list#">
		<th class="SubTitle" colspan="17">
			<cfif query_name is "qry_selectProductRecommendList_recommend">
				Products Recommended by this Product
			<cfelse><!--- qry_selectProductRecommendList_target --->
				<br>Products That Recommend This Product
			</cfif>
		</th>

		<tr class="TableHeader" valign="bottom">
			<th>ID</th>
			<td>&nbsp;</td>
			<th>Product Name</th>
			<td>&nbsp;</td>
			<th>Product<br>Price</th>
			<td>&nbsp;</td>
			<th>Product<br>Status</th>
			<td>&nbsp;</td>
			<th>Product<br>Created</th>
			<td>&nbsp;</td>
			<th>Manage<br>Product</th>
			<td>&nbsp;</td>
			<th>Recommendation<br>Added</th>
			<td>&nbsp;</td>
			<th>Recommends<br>in Return?</th>
			<td>&nbsp;</td>
			<th>Un-Recommend</th>
		</tr>

		<cfloop Query="#query_name#">
			<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>#productID_custom#</td>
			<td>&nbsp;</td>
			<td>#productName#</td>
			<td>&nbsp;</td>
			<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(productPrice)#</td>
			<td>&nbsp;</td>
			<td align="center"><cfif productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
			<td>&nbsp;</td>
			<td align="center" nowrap>#DateFormat(productDateCreated, "mm-dd-yy")#</td>
			<cfif ListFind(Variables.permissionActionList, "viewProduct")>
				<td>&nbsp;</td>
				<td align="center" class="SmallText"><a href="index.cfm?method=product.viewProduct&productID=#productID#" class="plainlink">Manage</a></td>
			</cfif>
			<td>&nbsp;</td>
			<td align="center" nowrap>#DateFormat(productRecommendDateCreated, "mm-dd-yy")#</td>
			<td>&nbsp;</td>
			<td align="center"><cfif productRecommendReverse is 0>&nbsp;<cfelse>Yes</cfif></td>
			<cfif ListFind(Variables.permissionActionList, "updateProductRecommend")>
				<td>&nbsp;</td>
				<td align="center" class="SmallText"><a href="index.cfm?method=product.updateProductRecommend&productID=#URL.productID#&productID_target=#productID_target#&productID_recommend=#productID_recommend#&productRecommendStatus=0" class="plainlink">Un-Recommend</a></td>
			</cfif>
			</tr>
		</cfloop>
	</cfloop>
	</table>
</cfif>
</cfoutput>

