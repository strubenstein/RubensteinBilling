<cfoutput>
<cfif qry_selectStatusHistory.RecordCount is 0>
	<p class="ErrorMessage">There is no status history for this target.</p>
<cfelse>
	<p>
	<div class="SubTitle">Custom Status History</div>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectStatusHistory">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>###IncrementValue(RecordCount - CurrentRow)#.</td>
		<td>&nbsp;</td>
		<td>#qry_selectStatusHistory.statusOrder#. #qry_selectStatusHistory.statusTitle#</td>
		<td>&nbsp;</td>
		<td>#qry_selectStatusHistory.firstName# #qry_selectStatusHistory.lastName#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectStatusHistory.statusHistoryDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectStatusHistory.statusHistoryDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectStatusHistory.statusHistoryManual is 1>Manual<cfelse>Auto</cfif></td>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectStatusHistory.statusHistoryComment is "">&nbsp;<cfelse>#qry_selectStatusHistory.statusHistoryComment#</cfif></td>
		</tr>
	</cfloop>
	</table>
	</p>
</cfif>
</cfoutput>
