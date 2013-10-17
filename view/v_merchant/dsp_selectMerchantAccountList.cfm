<cfoutput>
<cfif qry_selectMerchantAccountList.RecordCount is 0>
	<p class="ErrorMessage">There are no merchant accounts at this time.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectMerchantAccountList">
		<cfif qry_selectMerchantAccountList.merchantAccountDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<!--- <tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>> --->
		<td><cfif qry_selectMerchantAccountList.merchantAccountName is "">-<cfelse>#qry_selectMerchantAccountList.merchantAccountName#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectMerchantAccountList.merchantTitle#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantAccountList.merchantAccountCreditCardTypeList is "">-<cfelse>#Replace(merchantAccountCreditCardTypeList, ",", ", ", "ALL")#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantAccountList.merchantAccountBank is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantAccountList.merchantAccountStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectMerchantAccountList.merchantAccountDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectMerchantAccountList.merchantAccountDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updateMerchantAccount")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=merchant.updateMerchantAccount&merchantAccountID=#qry_selectMerchantAccountList.merchantAccountID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><i>Description</i>: #qry_selectMerchantAccountList.merchantAccountDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>
