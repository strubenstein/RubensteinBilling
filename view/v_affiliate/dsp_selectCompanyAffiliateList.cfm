<cfoutput>
<cfif qry_selectCompanyAffiliateList.RecordCount is 0>
	<p class="ErrorMessage">This company is not a listed affiliate.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.affiliateColumnCount, 0, 0, 0, Variables.affiliateColumnList, "", False)#
	<cfloop Query="qry_selectCompanyAffiliateList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectCompanyAffiliateList.affiliateID_custom is "">&nbsp;<cfelse>#qry_selectCompanyAffiliateList.affiliateID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectCompanyAffiliateList.affiliateName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyAffiliateList.affiliateStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCompanyAffiliateList.affiliateCode is "">&nbsp;<cfelse>#qry_selectCompanyAffiliateList.affiliateCode#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyAffiliateList.affiliateDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCompanyAffiliateList.affiliateDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "viewAffiliate")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=#URL.control#.viewAffiliate&companyID=#URL.companyID#&affiliateID=#qry_selectCompanyAffiliateList.affiliateID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
