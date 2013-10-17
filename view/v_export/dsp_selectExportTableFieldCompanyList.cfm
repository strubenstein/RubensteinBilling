<cfoutput>
<cfif qry_selectExportTableFieldCompanyList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no fields in this export table.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectExportTableFieldCompanyList">
		<cfif qry_selectExportTableFieldCompanyList.exportTableFieldDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<td>#qry_selectExportTableFieldCompanyList.exportTableFieldName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldCompanyList.exportTableFieldPrimaryKey is 1>Primary<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectExportTableFieldCompanyList.exportTableFieldType#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportTableFieldCompanyList.exportTableFieldSize is 0>-<cfelse>#qry_selectExportTableFieldCompanyList.exportTableFieldSize#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportTableFieldCompanyList.exportTableFieldXmlStatus is 0>
				n/a
			<cfelseif qry_selectExportTableFieldCompanyList.exportTableFieldCompanyXmlName is "">
				#qry_selectExportTableFieldCompanyList.exportTableFieldXmlName#
			<cfelse>
				#qry_selectExportTableFieldCompanyList.exportTableFieldCompanyXmlName#
				<div class="SmallText">(#qry_selectExportTableFieldCompanyList.exportTableFieldXmlName#)</div>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportTableFieldCompanyList.exportTableFieldTabStatus is 0>
				n/a
			<cfelseif qry_selectExportTableFieldCompanyList.exportTableFieldCompanyTabName is "">
				#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldTabName)#
			<cfelse>
				#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldCompanyTabName)#
				<div class="SmallText">(#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldTabName)#)</div>
			</cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportTableFieldCompanyList.exportTableFieldHtmlStatus is 0>
				n/a
			<cfelseif qry_selectExportTableFieldCompanyList.exportTableFieldCompanyHtmlName is "">
				#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldHtmlName)#
			<cfelse>
				#qry_selectExportTableFieldCompanyList.exportTableFieldCompanyHtmlName#
				<div class="SmallText">(#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldHtmlName)#)</div>
			</cfif>
		</td>
		--->
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="TableText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#" class="SmallText">&nbsp; &nbsp; &nbsp; #qry_selectExportTableFieldCompanyList.exportTableFieldDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>