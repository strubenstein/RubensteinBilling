<cfif qry_selectCustomFieldList.RecordCount is 0>
	<cfoutput><p class="ErrorMessage">There are no custom fields at this time.</p></cfoutput>
<cfelse>
	<cfoutput>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	</cfoutput>

	<cfoutput Query="qry_selectCustomFieldList" Group="customFieldType">
		<tr><td class="TableText" bgcolor="CCCCFF" colspan="#Variables.columnCount#">&nbsp; <b>
			<cfset Variables.typeRow = ListFind(Variables.customFieldTypeList_value, qry_selectCustomFieldList.customFieldType, "^")>
			Field Type: 
			<cfif Variables.typeRow is 0>
				#qry_selectCustomFieldList.customFieldType# (?)
			<cfelse>
				#ListGetAt(Variables.customFieldTypeList_label, Variables.typeRow, "^")#
			</cfif>
		</b></td></tr>

		<cfoutput>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#qry_selectCustomFieldList.customFieldName#</td><td>&nbsp;</td>
		<td><cfif qry_selectCustomFieldList.customFieldTitle is qry_selectCustomFieldList.customFieldName><div align="center">&quot;</div><cfelse>#qry_selectCustomFieldList.customFieldTitle#</cfif></td><td>&nbsp;</td>
		<td>#qry_selectCustomFieldList.customFieldFormType#</td><td>&nbsp;</td>
		<td>#qry_selectCustomFieldList.customFieldDescription#</td><td>&nbsp;</td>
		<td><cfif qry_selectCustomFieldList.customFieldStatus is 1>Active<cfelse>Inactive</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectCustomFieldList.customFieldInternal is 1>Internal<cfelse>Public</cfif></td><td>&nbsp;</td>
		<td class="SmallText">
			<cfset Variables.targetStartRow = ListFind(ValueList(qry_selectCustomFieldTargetList.customFieldID), qry_selectCustomFieldList.customFieldID)>
			<cfif Variables.targetStartRow is 0>
				&nbsp;
			<cfelse>
				<cfset thisCustomFieldID = qry_selectCustomFieldList.customFieldID>
				<cfloop Query="qry_selectCustomFieldTargetList" StartRow="#Variables.targetStartRow#">
					<cfif qry_selectCustomFieldTargetList.customFieldID is not thisCustomFieldID><cfbreak></cfif>
					<cfset Variables.targetPosition = ListFind(Variables.customFieldTargetList_value, Application.fn_GetPrimaryTargetKey(qry_selectCustomFieldTargetList.primaryTargetID))>
					<cfif qry_selectCustomFieldTargetList.customFieldTargetStatus is 0><font color="red"><cfelse><font color="green"></cfif>
					<cfif Variables.targetPosition is 0>#qry_selectCustomFieldTargetList.primaryTargetID#?<cfelse>#ListGetAt(Variables.customFieldTargetList_label, Variables.targetPosition)#</cfif></font><br>
				</cfloop>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCustomFieldList.customFieldDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updateCustomField")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=customField.updateCustomField&customFieldID=#qry_selectCustomFieldList.customFieldID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif Variables.displayCustomFieldOptions is True>
			<cfset Variables.customFieldOptionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldID), qry_selectCustomFieldList.customFieldID)>
			<td>&nbsp;</td>
			<td>
			<cfif Variables.customFieldOptionRow is 0>
				&nbsp;
			<cfelse>
				<cfset Variables.thisCustomFieldID = qry_selectCustomFieldList.customFieldID>
				<select name="customField#qry_selectCustomFieldList.customFieldID#" size="1" class="SmallText">
				<cfloop Query="qry_selectCustomFieldOptionList" StartRow="#Variables.customFieldOptionRow#">
					<cfif qry_selectCustomFieldOptionList.customFieldID is not Variables.thisCustomFieldID><cfbreak></cfif>
					<option value="#qry_selectCustomFieldOptionList.customFieldOptionValue#">#HTMLEditFormat(qry_selectCustomFieldOptionList.customFieldOptionLabel)#</option>
				</cfloop>
				</select>
			</cfif>
			</td>
		</cfif>
		</tr>
		</cfoutput>
	</cfoutput>

	<cfoutput>
	</table>
	<p class="TableText">Note: Target font color indicate whether the target is currently active (green) or no longer active (red).</p>
	</cfoutput>
</cfif>

