<cfoutput>
<cfif qry_selectPayflowTarget.RecordCount is 0>
	<p class="ErrorMessage">There are no groups that use this subscription processing method at this time.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.groupColumnCount, 0, 0, 0, Variables.groupColumnList, "", True)#
	<cfloop Query="qry_selectPayflowTarget">
		<cfset Variables.groupRow = ListFind(ValueList(qry_selectGroupList.groupID), qry_selectPayflowTarget.targetID)>
		<cfif Variables.groupRow is not 0>
			<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>#qry_selectGroupList.groupName[Variables.groupRow]#</td>
			<td>&nbsp;</td>
			<td><cfif qry_selectGroupList.groupStatus[Variables.groupRow] is 1>Live<cfelse>Disabled</cfif></td>
			<td>&nbsp;</td>
			<td nowrap><cfif Not IsDate(qry_selectPayflowTarget.payflowTargetDateBegin)>n/a<cfelse>#DateFormat(qry_selectPayflowTarget.payflowTargetDateBegin, "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td nowrap><cfif Not IsDate(qry_selectPayflowTarget.payflowTargetDateEnd)>(No End Date)<cfelse>#DateFormat(qry_selectPayflowTarget.payflowTargetDateEnd, "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td width="100%"><cfif qry_selectGroupList.groupDescription[Variables.groupRow] is "">&nbsp;<cfelse>#qry_selectGroupList.groupDescription[Variables.groupRow]#</cfif></td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>
