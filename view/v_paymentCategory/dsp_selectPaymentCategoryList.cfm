<cfoutput>
<cfif qry_selectPaymentCategoryList.RecordCount is 0>
	<p class="ErrorMessage">There are no payment categories at this time.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectPaymentCategoryList">
		<!--- 
		<cfif CurrentRow is 1 or qry_selectPaymentCategoryList.paymentCategoryType is not qry_selectPaymentCategoryList.paymentCategoryType[CurrentRow - 1]>
			<tr class="TableText" bgcolor="CCCCFF"><td colspan="#Variables.columnCount#">&nbsp; <b>#qry_selectPaymentCategoryList.paymentCategoryType#</b></td></tr>
		</cfif>
		--->
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#qry_selectPaymentCategoryList.paymentCategoryOrder#</td>
		<cfif Variables.displayPaymentCategoryID_custom is True>
			<td>&nbsp;</td>
			<td>#qry_selectPaymentCategoryList.paymentCategoryID_custom#</td>
		</cfif>
		<td>&nbsp;</td>
		<td>#qry_selectPaymentCategoryList.paymentCategoryName#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPaymentCategoryList.paymentCategoryTitle#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPaymentCategoryList.paymentCategoryAutoMethod#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPaymentCategoryList.paymentCategoryStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectPaymentCategoryList.paymentCategoryDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "movePaymentCategoryUp") and ListFind(Variables.permissionActionList, "movePaymentCategoryDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount or qry_selectPaymentCategoryList.paymentCategoryType is not qry_selectPaymentCategoryList.paymentCategoryType[CurrentRow + 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=paymentCategory.movePaymentCategoryDown&paymentCategoryType=#URL.paymentCategoryType#&paymentCategoryID=#qry_selectPaymentCategoryList.paymentCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1 or qry_selectPaymentCategoryList.paymentCategoryType is not qry_selectPaymentCategoryList.paymentCategoryType[CurrentRow - 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=paymentCategory.movePaymentCategoryUp&paymentCategoryType=#URL.paymentCategoryType#&paymentCategoryID=#qry_selectPaymentCategoryList.paymentCategoryID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updatePaymentCategory")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=paymentCategory.updatePaymentCategory&paymentCategoryType=#URL.paymentCategoryType#&paymentCategoryID=#qry_selectPaymentCategoryList.paymentCategoryID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>