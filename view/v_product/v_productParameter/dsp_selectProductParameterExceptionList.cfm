<cfoutput>
<cfif qry_selectProductParameterExceptionList.RecordCount is 0>
	<p class="ErrorMessage">There are no parameter exceptions at this time.</p>
<cfelse>
	<cfset Variables.fontColorList = "black,green,red,orange">
	<cfset Variables.isFirstInactive = True>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectProductParameterExceptionList">
		<cfif qry_selectProductParameterExceptionList.productParameterExceptionStatus is 0 and Variables.isFirstInactive is True>
			<tr class="TableText" bgcolor="FFFF66"><td colspan="17"><b>The exceptions below are inactive, either because they were made inactive manually or were replaced by an updated version.</b></td></tr>
			<cfset Variables.isFirstInactive = False>
		</cfif>
		<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectProductParameterExceptionList.productParameterExceptionDescription is "">&nbsp;<cfelse>#qry_selectProductParameterExceptionList.productParameterExceptionDescription#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfloop Index="count" From="1" To="4">
				<cfset Variables.thisProductParameterID = Evaluate("qry_selectProductParameterExceptionList.productParameterID#count#")>
				<cfif Variables.thisProductParameterID is not 0>
					<cfset Variables.parameterRow = ListFind(ValueList(qry_selectProductParameterList.productParameterID), Variables.thisProductParameterID)>
					<cfif Variables.parameterRow is not 0>
						<font color="#ListGetAt(Variables.fontColorList, count)#"><cfif count gte 2>AND </cfif>#qry_selectProductParameterList.productParameterName[Variables.parameterRow]# = #Evaluate("qry_selectProductParameterExceptionList.productParameterOptionValue#count#")#<br></font>
					</cfif>
				</cfif>
			</cfloop>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterExceptionList.productParameterExceptionExcluded is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterExceptionList.productParameterExceptionPricePremium is 0>-<cfelse>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProductParameterExceptionList.productParameterExceptionPricePremium)#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterExceptionList.productParameterExceptionText is "">&nbsp;<cfelse>#qry_selectProductParameterExceptionList.productParameterExceptionText#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectProductParameterExceptionList.productParameterExceptionStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectProductParameterExceptionList.productParameterExceptionDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>
			<cfif qry_selectProductParameterExceptionList.productParameterExceptionStatus is 1 and ListFind(Variables.permissionActionList, "updateProductParameterExceptionStatus")>
				<div class="SmallText"><a href="index.cfm?method=product.updateProductParameterExceptionStatus&productID=#URL.productID#&productParameterExceptionID=#qry_selectProductParameterExceptionList.productParameterExceptionID#" class="plainlink">Make<br>Inactive</a></div>
			<cfelseif qry_selectProductParameterExceptionList.productParameterExceptionStatus is 0>
				#DateFormat(qry_selectProductParameterExceptionList.productParameterExceptionDateUpdated, "mm-dd-yy")#
			</cfif>
		</td>
		<cfif ListFind(Variables.permissionActionList, "updateProductParameterException")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=product.updateProductParameterException&productID=#URL.productID#&productParameterExceptionID=#qry_selectProductParameterExceptionList.productParameterExceptionID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
