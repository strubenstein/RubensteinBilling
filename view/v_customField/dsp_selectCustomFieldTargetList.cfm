<cfif qry_selectCustomFieldList.RecordCount is 0>
	<cfoutput><p class="ErrorMessage">There are no custom field targets at this time.</p></cfoutput>
<cfelse>
	<cfoutput>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	</cfoutput>

	<cfoutput Query="qry_selectCustomFieldTargetList" Group="primaryTargetID">
		<cfset Variables.targetPosition = ListFind(Variables.customFieldTargetList_value, Application.fn_GetPrimaryTargetKey(qry_selectCustomFieldTargetList.primaryTargetID))>
		<tr><td class="TableText" bgcolor="CCCCFF" colspan="#Variables.columnCount#">&nbsp; <b>
			Target: <cfif Variables.targetPosition is 0>#qry_selectCustomFieldTargetList.primaryTargetID#?<cfelse>#ListGetAt(Variables.customFieldTargetList_label, Variables.targetPosition)#</cfif>
		</b></td></tr>

		<cfoutput>
		<cfset Variables.customFieldRow = ListFind(ValueList(qry_selectCustomFieldList.customFieldID), qry_selectCustomFieldTargetList.customFieldID)>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectCustomFieldTargetList.customFieldTargetOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectCustomFieldList.customFieldName[Variables.customFieldRow]#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCustomFieldList.customFieldTitle[Variables.customFieldRow] is qry_selectCustomFieldList.customFieldName[Variables.customFieldRow]><div align="center">&quot;</div><cfelse>#qry_selectCustomFieldList.customFieldTitle[Variables.customFieldRow]#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfset Variables.typeRow = ListFind(Variables.customFieldTypeList_value, qry_selectCustomFieldList.customFieldType[Variables.customFieldRow], "^")>
			<cfif Variables.typeRow is 0>
				#qry_selectCustomFieldList.customFieldType[Variables.customFieldRow]# (?)
			<cfelse>
				#ListFirst(ListGetAt(Variables.customFieldTypeList_label, Variables.typeRow, "^"), " ")#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#qry_selectCustomFieldList.customFieldFormType[Variables.customFieldRow]#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCustomFieldTargetList.customFieldTargetStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCustomFieldTargetList.customFieldTargetDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap><cfif qry_selectCustomFieldTargetList.customFieldTargetStatus is 0>-<cfelse>#DateFormat(qry_selectCustomFieldTargetList.customFieldTargetDateUpdated, "mm-dd-yy")#</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "moveCustomFieldTargetDown") and ListFind(Variables.permissionActionList, "moveCustomFieldTargetUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount or qry_selectCustomFieldTargetList.primaryTargetID is not qry_selectCustomFieldTargetList.primaryTargetID[CurrentRow + 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=customField.moveCustomFieldTargetDown&primaryTargetID=#qry_selectCustomFieldTargetList.primaryTargetID#&customFieldID=#qry_selectCustomFieldTargetList.customFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1 or qry_selectCustomFieldTargetList.primaryTargetID is not qry_selectCustomFieldTargetList.primaryTargetID[CurrentRow - 1]>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=customField.moveCustomFieldTargetUp&primaryTargetID=#qry_selectCustomFieldTargetList.primaryTargetID#&customFieldID=#qry_selectCustomFieldTargetList.customFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateCustomField")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=customField.updateCustomField&customFieldID=#qry_selectCustomFieldTargetList.customFieldID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif Variables.displayCustomFieldOptions is True>
			<cfset Variables.customFieldOptionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldID), qry_selectCustomFieldTargetList.customFieldID)>
			<td>&nbsp;</td>
			<td>
			<cfif Variables.customFieldOptionRow is 0>
				&nbsp;
			<cfelse>
				<cfset Variables.thisCustomFieldID = qry_selectCustomFieldTargetList.customFieldID>
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
	</cfoutput>
</cfif>

