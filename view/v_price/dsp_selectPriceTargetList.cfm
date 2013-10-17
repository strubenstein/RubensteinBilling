<cfoutput>
<cfif qry_selectPriceTarget.RecordCount is 0>
	<p class="ErrorMessage">This price currently has no targets who receive this price.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.priceColumnCount, 0, 0, 0, Variables.priceColumnList, "", False)#
	<cfloop Query="qry_selectPriceTarget">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
		<cfif qry_selectPriceTarget.primaryTargetID is 0>
			All Customers
		<cfelse>
			<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectPriceTarget.primaryTargetID)#">
			<cfcase value="userID">User</cfcase>
			<cfcase value="companyID">Company</cfcase>
			<cfcase value="groupID">Group</cfcase>
			<cfcase value="cobrandID">Cobrand</cfcase>
			<cfcase value="affiliateID">Affiliate</cfcase>
			<cfcase value="regionID">Region</cfcase>
			<cfdefaultcase>?</cfdefaultcase>
			</cfswitch>
		</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPriceTarget.targetName is "">(no name)<cfelse>#qry_selectPriceTarget.targetName#</cfif> 
			<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectPriceTarget.primaryTargetID)#">
			<cfcase value="userID"><cfif ListFind(Variables.permissionActionList, "viewUser")>(<a href="index.cfm?method=user.viewUser&userID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			<cfcase value="companyID"><cfif ListFind(Variables.permissionActionList, "viewCompany")>(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			<cfcase value="groupID"><cfif ListFind(Variables.permissionActionList, "viewGroup")>(<a href="index.cfm?method=group.viewGroup&groupID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			<cfcase value="cobrandID"><cfif ListFind(Variables.permissionActionList, "viewCobrand")>(<a href="index.cfm?method=cobrand.viewCobrand&cobrandID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			<cfcase value="affiliateID"><cfif ListFind(Variables.permissionActionList, "viewAffiliate")>(<a href="index.cfm?method=affiliate.viewAffiliate&affiliateID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			<cfcase value="regionID"><cfif ListFind(Variables.permissionActionList, "viewRegion")>(<a href="index.cfm?method=region.viewRegion&regionID=#qry_selectPriceTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
			</cfswitch>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPriceTarget.priceTargetStatus is 1>Active<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPriceTarget.priceTargetDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceTarget.priceTargetDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPriceTarget.priceTargetDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceTarget.priceTargetDateCreated, "hh:mm tt")#</div></td>
		<cfif ListFind(Variables.permissionActionList, "updatePriceTargetStatus0") or ListFind(Variables.permissionActionList, "updatePriceTargetStatus1")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif qry_selectPriceTarget.priceTargetStatus is 1 and ListFind(Variables.permissionActionList, "updatePriceTargetStatus0")>
					<a href="#Replace(Variables.navPriceAction, URL.action, "updatePriceTargetStatus0", "ONE")#&priceTargetID=#qry_selectPriceTarget.priceTargetID#" class="plainlink">Change to<br>Disabled</a>
				<cfelseif qry_selectPriceTarget.priceTargetStatus is 0 and ListFind(Variables.permissionActionList, "updatePriceTargetStatus1")>
					<a href="#Replace(Variables.navPriceAction, URL.action, "updatePriceTargetStatus1", "ONE")#&priceTargetID=#qry_selectPriceTarget.priceTargetID#" class="plainlink">Change to<br>Active</a>
				</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>

