<cfoutput>
<form method="post" name="payflowNotify" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<cfif Variables.doAction is "insertPayflowNotify">
	<input type="hidden" name="userID" value="#Form.userID#">
</cfif>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
<cfloop Query="qry_selectUserList">
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_selectUserList.lastName#, #qry_selectUserList.firstName#</td>
	<cfloop Index="type" List="#Variables.payflowTemplateTypeList_value#">
		<td>&nbsp;</td>
		<td class="SmallText" align="center">
			<label><input type="checkbox" name="payflowNotifyTask#qry_selectUserList.userID#_#type#" value="1"<cfif Form["payflowNotifyTask#qry_selectUserList.userID#_#type#"] is 1> checked</cfif>>Task</label> &nbsp;<br>
			<label><input type="checkbox" name="payflowNotifyEmail#qry_selectUserList.userID#_#type#" value="1"<cfif Form["payflowNotifyEmail#qry_selectUserList.userID#_#type#"] is 1> checked</cfif>>Email</label>
		</td>
	</cfloop>
	</tr>
</cfloop>
<cfif Variables.formAction is not "" and qry_selectUserList.RecordCount is not 0>
	<tr height="40" valign="bottom"><th colspan="#Variables.columnCount#"><input type="submit" name="submitUpdatePayflowNotify" value="#HTMLEditFormat(Variables.formSubmitValue)#"></th></tr>
</cfif>
</table>
</form>
</cfoutput>
