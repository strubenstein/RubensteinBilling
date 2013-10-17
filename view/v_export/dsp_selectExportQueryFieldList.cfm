<cfoutput>
<cfif qry_selectExportQueryFieldList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no fields in this export query.</p>
<cfelse>
	<cfif ListFind(Variables.permissionActionList, "updateExportQueryField")>
		<form method="post" action="#Variables.formAction#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectExportQueryFieldList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#qry_selectExportQueryFieldList.exportQueryFieldOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableName#</td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableFieldName#</td>
		<td>&nbsp;</td>
		<td>
			<cfif ListFind(Variables.permissionActionList, "updateExportQueryField")>
				<input type="text" name="exportQueryFieldAs#qry_selectExportQueryFieldList.exportQueryFieldID#" value="#HTMLEditFormat(qry_selectExportQueryFieldList.exportQueryFieldAs)#" size="30" maxlength="#maxlength_ExportQueryField.exportQueryFieldAs#" class="TableText">
			<cfelseif qry_selectExportQueryFieldList.exportQueryFieldAs is "">
				-
			<cfelse>
				#qry_selectExportQueryFieldList.exportQueryFieldAs#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableFieldType#</td>
		<cfif ListFind(Variables.permissionActionList, "moveExportQueryFieldUp") and ListFind(Variables.permissionActionList, "moveExportQueryFieldDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryFieldDown&exportQueryID=#URL.exportQueryID#&exportQueryFieldID=#qry_selectExportQueryFieldList.exportQueryFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryFieldUp&exportQueryID=#URL.exportQueryID#&exportQueryFieldID=#qry_selectExportQueryFieldList.exportQueryFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteExportQueryField")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=export.deleteExportQueryField&exportQueryID=#URL.exportQueryID#&exportQueryFieldID=#qry_selectExportQueryFieldList.exportQueryFieldID#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Remove'; return true;" title="Verify Remove" onclick="return confirm('Are you sure you want to remove this field from the export query?');">Remove</a></td>
		</cfif>
		</tr>
	</cfloop>

	<cfif ListFind(Variables.permissionActionList, "updateExportQueryField")>
		<tr height="40"><td align="center" colspan="#Variables.columnCount#">
		<input type="submit" name="submitExportQueryField" value="#HTMLEditFormat(Variables.formSubmitValue)#">
		</td></tr>
		</form>
	</cfif>
	</table>
</cfif>
</cfoutput>