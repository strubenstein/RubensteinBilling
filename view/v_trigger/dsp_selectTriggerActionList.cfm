<cfoutput>
<cfif qry_selectTriggerActionList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no trigger actions.</p>
<cfelse>
	<script language="JavaScript">
	function fn_toggleBgcolorOver(rowNum, rowShowA, rowShowB)
	{
		document.getElementById('row' + rowNum).style.backgroundColor = 'FFFFCC';
		if (rowShowA == 'True')
			document.getElementById('row' + rowNum + 'a').style.backgroundColor = 'FFFFCC';
		if (rowShowB == 'True')
			document.getElementById('row' + rowNum + 'b').style.backgroundColor = 'FFFFCC';
	}

	function fn_toggleBgcolorOut(rowNum, rowShowA, rowShowB, rowColor)
	{
		document.getElementById('row' + rowNum).style.backgroundColor = rowColor;
		if (rowShowA == 'True')
			document.getElementById('row' + rowNum + 'a').style.backgroundColor = rowColor;
		if (rowShowB == 'True')
			document.getElementById('row' + rowNum + 'b').style.backgroundColor = rowColor;
	}
	</script>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectTriggerActionList">
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<cfif qry_selectTriggerActionList.triggerActionDescription is not ""><cfset displayTriggerActionDescription = True><cfelse><cfset displayTriggerActionDescription = False></cfif>
		<cfset triggerRow = ListFind(ValueList(qry_selectTriggerList.triggerAction), qry_selectTriggerActionList.triggerAction)>
		<cfif triggerRow is not 0 and qry_selectTriggerList.triggerDescription[triggerRow] is not ""><cfset displayTriggerDescription = True><cfelse><cfset displayTriggerDescription = False></cfif>

		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#displayTriggerActionDescription#','#displayTriggerDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#displayTriggerActionDescription#','#displayTriggerDescription#','#Variables.bgcolor#');">
		<!--- 
		<td align="right">#qry_selectTriggerActionList.triggerActionOrder#</td>
		<td>&nbsp;</td>
		--->
		<td>#qry_selectTriggerActionList.triggerActionControl#</td>
		<td>&nbsp;</td>
		<td>#qry_selectTriggerActionList.triggerAction#</td>
		<cfif Variables.displayStatus is True>
			<td>&nbsp;</td>
			<td><cfif qry_selectTriggerActionList.triggerActionStatus is 1>Active<cfelse>Inactive</cfif></td>
		</cfif>
		<!--- 
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectTriggerActionList.triggerActionDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectTriggerActionList.triggerActionDateUpdated, "mm-dd-yy")#</td>
		--->
		<cfif ListFind(Variables.permissionActionList, "moveTriggerActionDown") and ListFind(Variables.permissionActionList, "moveTriggerActionUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=trigger.moveTriggerActionDown&triggerAction=#qry_selectTriggerActionList.triggerAction#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=trigger.moveTriggerActionUp&triggerAction=#qry_selectTriggerActionList.triggerAction#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateTriggerAction")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=trigger.updateTriggerAction&triggerAction=#qry_selectTriggerActionList.triggerAction#" class="plainlink">Update</a></td>
		</cfif>
		<cfif qry_selectTriggerList.RecordCount is not 0>
			<td>&nbsp;</td>
			<td><cfif triggerRow is 0>&nbsp;-<cfelse>#qry_selectTriggerList.triggerFilename[triggerRow]#</cfif></td>
			<td>&nbsp;</td>
			<td nowrap><cfif triggerRow is 0>&nbsp;-<cfelse>#DateFormat(qry_selectTriggerList.triggerDateBegin[triggerRow], "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td nowrap><cfif triggerRow is 0 or Not IsDate(qry_selectTriggerList.triggerDateEnd[triggerRow])>&nbsp;-<cfelse>#DateFormat(qry_selectTriggerList.triggerDateEnd[triggerRow], "mm-dd-yy")#</cfif></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "insertTrigger") or ListFind(Variables.permissionActionList, "updateTrigger")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif triggerRow is 0 and ListFind(Variables.permissionActionList, "insertTrigger")>
					<a href="index.cfm?method=trigger.insertTrigger&triggerAction=#qry_selectTriggerActionList.triggerAction#" class="plainlink">Add Trigger</a>
				<cfelseif triggerRow is not 0 and ListFind(Variables.permissionActionList, "updateTrigger")>
					<a href="index.cfm?method=trigger.updateTrigger&triggerAction=#qry_selectTriggerActionList.triggerAction#" class="plainlink">Update Trigger</a>
				<cfelse>
					&nbsp;-
				</cfif>
			</td>
		</cfif>
		</tr>
		<cfif displayTriggerActionDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True','#displayTriggerActionDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#displayTriggerActionDescription#','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><i>Action Description</i>: #qry_selectTriggerActionList.triggerActionDescription#</td></tr>
		</cfif>
		<cfif displayTriggerDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#b" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#displayTriggerActionDescription#','True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#displayTriggerActionDescription#','True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><i>Trigger Description</i>: #qry_selectTriggerList.triggerDescription[triggerRow]#</td></tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>
