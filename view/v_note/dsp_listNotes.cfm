<cfoutput>
<cfif qry_selectNoteList.RecordCount is 0>
	<p class="ErrorMessage">No notes meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(methodStruct.queryViewAction, Form.queryOrderBy, "<br>", methodStruct.columnCount, methodStruct.firstRecord, methodStruct.lastRecord, methodStruct.totalRecords, methodStruct.columnHeaderList, methodStruct.columnOrderByList, True)#
	<cfloop Query="qry_selectNoteList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#qry_selectNoteList.lastName#,<br>#qry_selectNoteList.firstName#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectNoteList.noteDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectNoteList.noteDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td width="100%">#qry_selectNoteList.noteMessage#</td>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(methodStruct.columnCount, methodStruct.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, methodStruct.firstRecord, methodStruct.lastRecord, methodStruct.totalRecords, methodStruct.totalPages, False, "")#
</cfif>
</cfoutput>

