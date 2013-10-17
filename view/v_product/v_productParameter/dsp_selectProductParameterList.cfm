<cfoutput>
<p><table border="0" cellspacing="0" cellpadding="0" width="650"><tr><td class="MainText">
A product parameter is an option the customer selects from when purchasing a product, such as a color and/or size. Parameters can have codes associated with them that are added to the custom ID of the product to create the full SKU for that combination of parameters for that product. Parameters apply to child products.<br>
<br>
It is possible to create exceptions for combinations of parameters, including not being available, having a price premium (or discount) or a text note, e.g., a late shipping date. The exception can be for a particular combination of parameters or any combination that includes one or more parameters.<br>
<br>
To change the display or code order, the parameters must first be be sorted by that particular order type.
</td></tr></table></p>

<cfif qry_selectProductParameterList.RecordCount is 0>
	<p class="ErrorMessage">This product has no parameters.</p>
<cfelse>
	<form>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Variables.queryOrderBy, "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectProductParameterList">
		<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectProductParameterList.productParameterName#</td>
		<td>&nbsp;</td>
		<td>#qry_selectProductParameterList.productParameterText#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterList.productParameterRequired is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterList.productParameterStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectProductParameterList.productParameterOrder#</td>
		<cfif ListFind(Variables.permissionActionList, "moveProductParameterDown") and ListFind(Variables.permissionActionList, "moveProductParameterUp")>
			<td>&nbsp;</td>
			<td>
				<cfif Variables.queryOrderBy is not "productParameterOrder">
					n/a
				<cfelse>
					<cfif CurrentRow is RecordCount>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductParameterDown&productID=#URL.productID#&productParameterID=#qry_selectProductParameterList.productParameterID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
					<cfif CurrentRow is 1>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductParameterUp&productID=#URL.productID#&productParameterID=#qry_selectProductParameterList.productParameterID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
				</cfif>
			</td>
		</cfif>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductParameterList.productParameterDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductParameterList.productParameterDateUpdated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterList.productParameterCodeOrder is 0>-<cfelse>#qry_selectProductParameterList.productParameterCodeOrder#</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "moveProductParameterCodeDown") and ListFind(Variables.permissionActionList, "moveProductParameterCodeUp")>
			<td>&nbsp;</td>
			<td>
				<cfif Variables.queryOrderBy is not "productParameterCodeOrder" or qry_selectProductParameterList.productParameterCodeStatus is 0>
					n/a
				<cfelse>
					<cfif CurrentRow is RecordCount or qry_selectProductParameterList.productParameterCodeStatus[CurrentRow + 1] is 0>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductParameterCodeDown&productID=#URL.productID#&productParameterID=#qry_selectProductParameterList.productParameterID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
					<cfif CurrentRow is 1>
						<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
					<cfelse>
						<a href="index.cfm?method=product.moveProductParameterCodeUp&productID=#URL.productID#&productParameterID=#qry_selectProductParameterList.productParameterID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
					</cfif>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateProductParameter")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=product.updateProductParameter&productID=#URL.productID#&productParameterID=#qry_selectProductParameterList.productParameterID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif Variables.displayParameterOptions is True>
			<cfset Variables.parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), qry_selectProductParameterList.productParameterID)>
			<td>&nbsp;</td>
			<td>#qry_selectProductParameterList.productParameterOptionCount# - 
			<cfif Variables.parameterOptionRow is not 0>
				<cfset Variables.thisParameterID = qry_selectProductParameterList.productParameterID>
				<select name="parameter#qry_selectProductParameterList.productParameterID#" size="1" class="SmallText">
				<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterOptionRow#">
					<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID><cfbreak></cfif>
					<option value="#qry_selectProductParameterOptionList.productParameterOptionValue#">#HTMLEditFormat(qry_selectProductParameterOptionList.productParameterOptionLabel)#</option>
				</cfloop>
				</select>
			</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>	
	</table>
	</form>
</cfif>
</cfoutput>
