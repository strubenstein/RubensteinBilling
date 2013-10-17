<cfoutput>
<cfif qry_selectExportTableFieldCompanyList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no fields in this export table.</p>
<cfelse>
	<p class="Instructions">
	To change the XML field name or tab-delimited header, enter the new value in the text field. 
	XML field names must be unique for this table and must be valid field names: letters (A-Z), numbers (0-9) or underscore (_). The first character must be a letter.
	The display header is the first row in an Excel or tab-delimited file exported in display format; it has no name restrictions. 
	The default value is listed below the text field. To use (or revert to) the default value, simply leave the text field blank.
	</p>

	<form method="post" name="exportTableFieldCompany" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">
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
			<cfelse>
				<input type="text" name="exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" value="#Form["exportTableFieldCompanyXmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#" size="20" maxlength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyXmlName#">
				<div class="SmallText">#qry_selectExportTableFieldCompanyList.exportTableFieldXmlName#</div>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportTableFieldCompanyList.exportTableFieldTabStatus is 0>
				n/a
			<cfelse>
				<input type="text" name="exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" value="#Form["exportTableFieldCompanyTabName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#" size="20" maxlength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyTabName#">
				<div class="SmallText">#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldTabName)#</div>
			</cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportTableFieldCompanyList.exportTableFieldHtmlStatus is 0>
				n/a
			<cfelse>
				<input type="text" name="exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#" value="#Form["exportTableFieldCompanyHtmlName#qry_selectExportTableFieldCompanyList.exportTableFieldID#"]#" size="20" maxlength="#maxlength_ExportTableFieldCompany.exportTableFieldCompanyHtmlName#">
				<div class="SmallText">#HTMLEditFormat(qry_selectExportTableFieldCompanyList.exportTableFieldHtmlName)#</div>
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
	<tr class="TableText" height="40" valign="bottom">
		<td colspan="#Variables.columnCount#" align="center">
			<input type="reset" value="Reset"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
			<input type="submit" name="submitExportTableFieldCompany" value="Update Export Fields Settings">
		</td>
	</tr>
	</table>
	</form>
</cfif>
</cfoutput>