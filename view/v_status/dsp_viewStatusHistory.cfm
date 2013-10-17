<cfoutput>
<cfif qry_selectStatusHistory.RecordCount is 0>
	<p class="ErrorMessage">There is no status history for this target.</p>
<cfelse>
	<p>
	<div class="SubTitle">Custom Status History</div>
	<table border="0" cellspacing="0" cellpadding="2">
	<tr class="TableHeader" align="left" valign="bottom">
		<th>##</th><th>&nbsp;</th>
		<th>Status</th><th>&nbsp;</th>
		<th>User</th><th>&nbsp;</th>
		<th>Date Updated</th><th>&nbsp;</th>
		<th>Auto?</th><th>&nbsp;</th>
		<th>Comment</th>
	</tr>
	<tr><td colspan="15" height="3" align="center"><img src="#Application.billingUrlRoot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>

	<cfloop Query="qry_selectStatusHistory">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
		<td>###IncrementValue(RecordCount - CurrentRow)#.</td><td>&nbsp;</td>
		<td>#qry_selectStatusHistory.statusOrder#. #qry_selectStatusHistory.statusTitle#</td><td>&nbsp;</td>
		<td>#qry_selectStatusHistory.firstName# #qry_selectStatusHistory.lastName#</td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectStatusHistory.statusHistoryDateCreated, "mm-dd-yy")# at #TimeFormat(qry_selectStatusHistory.statusHistoryDateCreated, "hh:mm tt")#</td><td>&nbsp;</td>
		<td><cfif qry_selectStatusHistory.statusHistoryManual is 1>Manual<cfelse>Auto</cfif></td><td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectStatusHistory.statusHistoryComment is "">&nbsp;<cfelse>#qry_selectStatusHistory.statusHistoryComment#</cfif></td>
		</tr>
	</cfloop>
	</table>
	</p>
</cfif>
</cfoutput>
