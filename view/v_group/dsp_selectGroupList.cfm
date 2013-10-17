<cfif qry_selectGroupList.RecordCount is 0>
	<cfoutput><p class="ErrorMessage">There are currently no groups.</p></cfoutput>
<cfelse>
	<cfoutput>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.groupColumnCount, 0, 0, 0, Variables.groupColumnList, "", True)#
	</cfoutput>

	<cfoutput Query="qry_selectGroupList" Group="groupCategory">
		<tr><td class="TableText" bgcolor="CCCCFF" colspan="#Variables.groupColumnCount#">&nbsp; <cfif qry_selectGroupList.groupCategory is "">(<i>no group category</i>)<cfelse><b>#qry_selectGroupList.groupCategory#</b></cfif></td></tr>
		<cfoutput>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectGroupList.groupName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectGroupList.groupID_custom is "">&nbsp;<cfelse>#qry_selectGroupList.groupID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectGroupList.groupStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectGroupList.groupDescription is "">&nbsp;<cfelse>#qry_selectGroupList.groupDescription#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectGroupList.groupDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectGroupList.groupDateUpdated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>
			#qry_selectGroupList.groupUserCount# <cfif qry_selectGroupList.groupUserCount is 1>user<cfelse>users</cfif><br>
			#qry_selectGroupList.groupCompanyCount# <cfif qry_selectGroupList.groupCompanyCount is 1>company<cfelse>companies</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>
			#qry_selectGroupList.groupAffiliateCount# <cfif qry_selectGroupList.groupAffiliateCount is 1>affiliate<cfelse>affiliates</cfif><br>
			#qry_selectGroupList.groupCobrandCount# <cfif qry_selectGroupList.groupCobrandCount is 1>cobrand<cfelse>cobrands</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#qry_selectGroupList.groupPriceCount#</td>
		<cfif ListFind(Variables.permissionActionList, "viewGroup")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=group.viewGroup&groupID=#qry_selectGroupList.groupID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
		</cfoutput>
	</cfoutput>

	<cfoutput>
	</table>
	</cfoutput>
</cfif>
