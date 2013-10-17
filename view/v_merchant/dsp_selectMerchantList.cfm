<cfoutput>
<cfif qry_selectMerchantList.RecordCount is 0>
	<p class="ErrorMessage">There are no merchant processors at this time.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectMerchantList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>
			<cfif qry_selectMerchantList.companyID is 0>
				-
			<cfelse>
				#qry_selectMerchantList.companyName#
				<cfif ListFind(Variables.permissionActionList, "viewCompany")>
					<font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectMerchantList.companyID#" class="plainlink">Go</a>)</font>
				</cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectMerchantList.userID is 0>
				-
			<cfelse>
				#qry_selectMerchantList.firstName# #qry_selectMerchantList.lastName#
				<cfif ListFind(Variables.permissionActionList, "viewUser")>
					<font class="SmallText">(<a href="index.cfm?method=company.viewUser&companyID=#qry_selectMerchantList.companyID#&userID=#qry_selectMerchantList.userID#" class="plainlink">Go</a>)</font>
				</cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#qry_selectMerchantList.merchantName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantList.merchantTitle is qry_selectMerchantList.merchantName><div align="center">&quot;</div><cfelse>#qry_selectMerchantList.merchantTitle#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectMerchantList.merchantURL is not ""><div class="SmallText">#qry_selectMerchantList.merchantURL#</div></cfif>
			<cfif qry_selectMerchantList.merchantDescription is not "">#qry_selectMerchantList.merchantDescription#</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantList.merchantCreditCard is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantList.merchantBank is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantList.merchantFilename is "">&nbsp;<cfelse>#qry_selectMerchantList.merchantFilename#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectMerchantList.merchantStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectMerchantList.merchantDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectMerchantList.merchantDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updateMerchant")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=merchant.updateMerchant&merchantID=#qry_selectMerchantList.merchantID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
