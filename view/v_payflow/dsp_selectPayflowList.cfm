<cfoutput>
<cfif qry_selectPayflowList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no subscription processing methods.</p>
<cfelse>
	<p><table border="0" cellspacing="0" cellpadding="0" width="600"><tr><td  class="MainText">
	You may add companies or groups to use this subscription processing method by managing that company or group. 
	This means beginning by viewing the list of companies/groups, and selecting the company/group you wish to manage. 
	The priority order for determining which subscription processing method to use when processing a subscriber is: 
	company, group, default.
	</td></tr></table></p>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectPayflowList">
		<cfif qry_selectPayflowList.payflowDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<td align="right">#qry_selectPayflowList.payflowOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectPayflowList.payflowName#</td>
		<cfif Variables.displayPayflowID_custom is True>
			<td>&nbsp;</td>
			<td><cfif qry_selectPayflowList.payflowID_custom is "">&nbsp;<cfelse>#qry_selectPayflowList.payflowID_custom#</cfif></td>
		</cfif>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectPayflowList.payflowDefault is 0>&nbsp;<cfelse>Default</cfif></td>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectPayflowList.payflowStatus is 0><font color="red">Inactive</font><cfelse><font color="green">Active</font></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "movePayflowUp") and ListFind(Variables.permissionActionList, "movePayflowDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=payflow.movePayflowDown&payflowID=#qry_selectPayflowList.payflowID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=payflow.movePayflowUp&payflowID=#qry_selectPayflowList.payflowID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPayflowList.payflowDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPayflowList.payflowDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPayflowList.payflowDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPayflowList.payflowDateUpdated, "hh:mm tt")#</div></td>
		<cfif ListFind(Variables.permissionActionList, "viewPayflow")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=payflow.viewPayflow&payflowID=#qry_selectPayflowList.payflowID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
				<td colspan="#Variables.columnCount#"><i>Description: </i>#qry_selectPayflowList.payflowDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>
