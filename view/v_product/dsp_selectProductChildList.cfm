<cfoutput>
<cfif Variables.displayProductParent is False>
	<p class="ErrorMessage">This product is <i>not</i> the child of another product.</p>
<cfelse>
	<p class="MainText">
	<b>Parent Product</b><br>
	<cfif qry_selectProductParent.productID_custom is not "">#qry_selectProductParent.productID_custom#. </cfif>
	#qry_selectProductParent.productName#
	<cfif ListFind(Variables.permissionActionList, "viewProduct")>
		 (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectProductParent.productID#" class="plainlink">Manage</a>)
	</cfif>
	</p>
</cfif>

<cfif qry_selectProductChildList.RecordCount is 0>
	<p class="ErrorMessage">This product has no child products.</p>
<cfelse>
	<cfset Variables.isChildOrderOk = True>

	<p class="SubTitle">Child Product(s)</p>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectProductChildList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectProductChildList.productChildOrder#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductChildList.productID_custom is "">&nbsp;<cfelse>#qry_selectProductChildList.productID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectProductChildList.productName#</td>
		<td>&nbsp;</td>
		<td>
			<cfswitch expression="#qry_selectProductChildList.productChildType#">
			<cfcase value="1">Variation</cfcase>
			<cfcase value="2">Upgrade</cfcase>
			<cfdefaultcase>?</cfdefaultcase>
			</cfswitch>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectProductChildList.productChildSeparate is 1>
				Yes<cfif ListFind(Variables.permissionActionList, "unseparateChildProduct")><div class="SmallText"><a href="index.cfm?method=product.unseparateChildProduct&productID=#URL.productID#&productID_child=#qry_selectProductChildList.productID#" class="plainlink">Revert to No</a></div></cfif>
			<cfelse>
				No<cfif ListFind(Variables.permissionActionList, "separateChildProduct")><div class="SmallText"><a href="index.cfm?method=product.separateChildProduct&productID=#URL.productID#&productID_child=#qry_selectProductChildList.productID#" class="plainlink">Switch to Yes</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductChildList.productPrice)#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductChildList.productListedOnSite is 1>Listed<cfelse>Not Listed</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductChildList.productDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewProduct")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=product.viewProduct&productID=#qry_selectProductChildList.productID#" class="plainlink">Manage</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "moveChildProductDown") and ListFind(Variables.permissionActionList, "moveChildProductUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=product.moveChildProductDown&productID=#URL.productID#&productID_child=#qry_selectProductChildList.productID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=product.moveChildProductUp&productID=#URL.productID#&productID_child=#qry_selectProductChildList.productID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		</tr>

		<cfif qry_selectProductChildList.productChildOrder is not CurrentRow>
			<cfset Variables.isChildOrderOk = False>
		</cfif>
	</cfloop>
	</table>

	<p class="TableText">
	Variation - Color, size, model, etc. for child products ordered instead of the parent product. Separate from <i>Parameter</i> options.<br>
	Upgrade - Add-on option to the product; assumes customer also orders parent product.
	</p>

	<p class="MainText">
	The child product can begin a new table to separate the listings.<br>
	The first child product listed automatically begins a new table.<br>
	The child product summary is displayed to separate the tables.
	</p>

	<cfif Variables.isChildOrderOk is False and ListFind(Variables.permissionActionList, "fixChildProductOrder")>
		<cflocation url="index.cfm?method=product.fixChildProductOrder&productID=#URL.productID#" AddToken="No">
		<!--- 
		<p class="MainText"><b>[<a href="index.cfm?method=product.fixChildProductOrder&productID=#URL.productID#" class="plainlink">Fix Child Order Now</a>]</b></p>
		--->
	</cfif>
</cfif>
</cfoutput>

