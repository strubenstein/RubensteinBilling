<cfoutput>
<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td><b><i>Custom Status</i>: </b></td>
	<td>
		<select name="statusID" size="1">
		<option value="0"<cfif Form.statusID is 0> selected</cfif>>-- NO CUSTOM STATUS SELECTED --</option>
		<cfloop Query="qry_selectStatusList"><option value="#qry_selectStatusList.statusID#"<cfif Form.statusID is qry_selectStatusList.statusID> selected</cfif>>#qry_selectStatusList.statusOrder#. #HTMLEditFormat(qry_selectStatusList.statusTitle)#</option></cfloop>
		</select><br>
		<i>Optional Comment</i>: <input type="text" name="statusHistoryComment" value="#HTMLEditFormat(Form.statusHistoryComment)#" size="50" maxlength="#maxlength_StatusHistory.statusHistoryComment#">
	</td>
</tr>
</table>
</p>
</cfoutput>
