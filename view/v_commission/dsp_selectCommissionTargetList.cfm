<cfoutput>
<cfif qry_selectCommissionTarget.RecordCount is 0>
	<p class="ErrorMessage">This commission currently has no targets who receive this commission.</p>
<cfelse>
	<p class="MainText"><b>Below are the targets which receive this commission.</b></p>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectCommissionTarget">
		<cfif CurrentRow is 1 or qry_selectCommissionTarget.primaryTargetID is not qry_selectCommissionTarget.primaryTargetID[CurrentRow - 1]>
			<tr class="TableText" bgcolor="cdcdcd">
				<td colspan="#Variables.columnCount#">
					<b>&nbsp; Type: 
					<cfif qry_selectCommissionTarget.primaryTargetID is 0>
						All Targets
					<cfelse>
						<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectCommissionTarget.primaryTargetID)#">
						<cfcase value="userID">User</cfcase>
						<cfcase value="companyID">Company</cfcase>
						<cfcase value="groupID">Group</cfcase>
						<cfcase value="cobrandID">Cobrand</cfcase>
						<cfcase value="affiliateID">Affiliate</cfcase>
						<cfcase value="regionID">Region</cfcase>
						<cfcase value="vendorID">Vendor</cfcase>
						<cfdefaultcase>?</cfdefaultcase>
						</cfswitch>
					</cfif>
					</b>
				</td>
			</tr>
		</cfif>

		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>
			<cfif qry_selectCommissionTarget.targetID is 0>ALL<cfelseif qry_selectCommissionTarget.targetName is "">(no name)<cfelse>#qry_selectCommissionTarget.targetName#</cfif> 
			<cfif qry_selectCommissionTarget.targetID is not 0>
				<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectCommissionTarget.primaryTargetID)#">
				<cfcase value="userID"><cfif ListFind(Variables.permissionActionList, "viewUser")>(<a href="index.cfm?method=user.viewUser&userID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="companyID"><cfif ListFind(Variables.permissionActionList, "viewCompany")>(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="groupID"><cfif ListFind(Variables.permissionActionList, "viewGroup")>(<a href="index.cfm?method=group.viewGroup&groupID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="cobrandID"><cfif ListFind(Variables.permissionActionList, "viewCobrand")>(<a href="index.cfm?method=cobrand.viewCobrand&cobrandID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="affiliateID"><cfif ListFind(Variables.permissionActionList, "viewAffiliate")>(<a href="index.cfm?method=affiliate.viewAffiliate&affiliateID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="regionID"><cfif ListFind(Variables.permissionActionList, "viewRegion")>(<a href="index.cfm?method=region.viewRegion&regionID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				<cfcase value="vendorID"><cfif ListFind(Variables.permissionActionList, "viewVendor")>(<a href="index.cfm?method=vendor.viewVendor&regionID=#qry_selectCommissionTarget.targetID#" class="plainlink">go</a>)</cfif></cfcase>
				</cfswitch>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCommissionTarget.commissionTargetStatus is 1><font color="green">Active</font><cfelse><font color="red">Disabled</font></cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCommissionTarget.commissionTargetDateCreated, "mm-dd-yy")#<!--- <div class="SmallText">#TimeFormat(qry_selectCommissionTarget.commissionTargetDateCreated, "hh:mm tt")#</div> ---></td>
		<td>&nbsp;</td>
		<td nowrap><cfif qry_selectCommissionTarget.commissionTargetStatus is 1>-<cfelse>#DateFormat(qry_selectCommissionTarget.commissionTargetDateUpdated, "mm-dd-yy")#<!--- <div class="SmallText">#TimeFormat(qry_selectCommissionTarget.commissionTargetDateUpdated, "hh:mm tt")#</div> ---></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updateCommissionTargetStatus0") or ListFind(Variables.permissionActionList, "updateCommissionTargetStatus1")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif qry_selectCommissionTarget.commissionTargetStatus is 1 and ListFind(Variables.permissionActionList, "updateCommissionTargetStatus0")>
					<a href="#Replace(Variables.navCommissionAction, URL.action, "updateCommissionTargetStatus0", "ONE")#&commissionTargetID=#qry_selectCommissionTarget.commissionTargetID#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Request'; return true;" title="Verify Request" onclick="return confirm('Are you sure you want to remove this commission from this target?');">Disable</a>
				<!---
				<cfelseif qry_selectCommissionTarget.commissionTargetStatus is 0 and ListFind(Variables.permissionActionList, "updateCommissionTargetStatus1")>
					<a href="#Replace(Variables.navCommissionAction, URL.action, "updateCommissionTargetStatus1", "ONE")#&commissionTargetID=#qry_selectCommissionTarget.commissionTargetID#" class="plainlink">Change to<br>Active</a>
				--->
				</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
