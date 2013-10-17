<cfoutput>
<cfif qry_selectExportTableFieldList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no fields in this export table.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectExportTableFieldList">
		<cfif qry_selectExportTableFieldList.exportTableFieldDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<td>#qry_selectExportTableFieldList.exportTableFieldName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldPrimaryKey is 1>Primary<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectExportTableFieldList.exportTableFieldType#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldSize is 0>-<cfelse>#qry_selectExportTableFieldList.exportTableFieldSize#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldXmlStatus is 0>n/a<cfelse>#qry_selectExportTableFieldList.exportTableFieldXmlName#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldTabStatus is 0>n/a<cfelse>#HTMLEditFormat(qry_selectExportTableFieldList.exportTableFieldTabName)#</cfif></td>
		<!--- 
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldHtmlStatus is 0>n/a<cfelse>#HTMLEditFormat(qry_selectExportTableFieldList.exportTableFieldHtmlName)#</cfif></td>
		--->
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldList.exportTableFieldStatus is 1>Active<cfelse>Inactive</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "moveExportTableFieldUp") and ListFind(Variables.permissionActionList, "moveExportTableFieldDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportTableFieldDown&exportTableID=#URL.exportTableID#&exportTableFieldID=#qry_selectExportTableFieldList.exportTableFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportTableFieldUp&exportTableID=#URL.exportTableID#&exportTableFieldID=#qry_selectExportTableFieldList.exportTableFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateExportTableField")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=export.updateExportTableField&exportTableID=#URL.exportTableID#&exportTableFieldID=#qry_selectExportTableFieldList.exportTableFieldID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="TableText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#" class="SmallText">&nbsp; &nbsp; &nbsp; #qry_selectExportTableFieldList.exportTableFieldDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>