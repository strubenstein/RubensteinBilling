<cfif qry_selectGroupList.RecordCount is 0>
	<cfoutput><p class="ErrorMessage">There are no groups at this time.</p></cfoutput>
<cfelse>
	<cfoutput>
	<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.groupColumnCount, 0, 0, 0, Variables.groupColumnList, "", False)#
	</cfoutput>

	<cfoutput Query="qry_selectGroupList" Group="groupCategory">
		<tr><td class="TableText" bgcolor="CCCCFF" colspan="#Variables.groupColumnCount#">&nbsp; <cfif qry_selectGroupList.groupCategory is "">(<i>no group category</i>)<cfelse><b>#qry_selectGroupList.groupCategory#</b></cfif></td></tr>
		<cfoutput>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td align="center"><input type="checkbox" name="groupID" value="#qry_selectGroupList.groupID#"<cfif ListFind(Form.groupID, qry_selectGroupList.groupID)> checked</cfif>></td>
		<td>&nbsp;</td>
		<td>#qry_selectGroupList.groupName#</td>
		<td>&nbsp;</td>
		<td align="center"><cfif qry_selectGroupList.groupStatus is 1>Live<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td align="center"><cfif qry_selectGroupList.groupDescription is "">&nbsp;<cfelse>#qry_selectGroupList.groupDescription#</cfif></td>
		</tr>
		</cfoutput>
	</cfoutput>

	<cfoutput>
	</table>
	<cfif Variables.formAction is not "">
		<p><input type="submit" name="#Variables.formSubmitName#" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
	</cfif>
	</form>
	</cfoutput>
</cfif>