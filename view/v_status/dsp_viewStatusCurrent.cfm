<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td><i>Custom Status</i>: </td>
	<td>
		<cfif qry_selectStatusHistory.RecordCount is 0>
			(no current status)
		<cfelse>
			#qry_selectStatusHistory.statusOrder#. #qry_selectStatusHistory.statusTitle#
			<cfif qry_selectStatusHistory.statusHistoryComment is not "">
				<div class="TableText"><i>Comment</i>: #qry_selectStatusHistory.statusHistoryComment#</div>
			</cfif>
		</cfif>
	</td>
</tr>
</table>
</cfoutput>