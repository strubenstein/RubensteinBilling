<cfoutput>
<cfif qry_selectExportQueryFieldList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no fields in this export query.</p>
<cfelse>
	<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	var checkflag = "true";
	function check () {
		if (checkflag == "false") {
			for (i = 0; i < document.exportQFC.exportQueryFieldCompanyXmlStatus.length; i++) {
				document.exportQFC.exportQueryFieldCompanyXmlStatus[i].checked = true;
				document.exportQFC.exportQueryFieldCompanyTabStatus[i].checked = true;
				<!--- document.exportQFC.exportQueryFieldCompanyHtmlStatus[i].checked = true; --->
			}
			checkflag = "true";
			return "Uncheck All Fields"; }
		else {
			for (i = 0; i < document.exportQFC.exportQueryFieldCompanyXmlStatus.length; i++) {
				document.exportQFC.exportQueryFieldCompanyXmlStatus[i].checked = false;
				document.exportQFC.exportQueryFieldCompanyTabStatus[i].checked = false;
				<!--- document.exportQFC.exportQueryFieldCompanyHtmlStatus[i].checked = false; --->
			}
			checkflag = "false";
			return "Check All Fields"; }
	}
	//  End -->
	</SCRIPT>

	<p class="MainText" style="width: 550">A <i>data</i> file is an XML or tab-delimited file where the query values are exported as the actual value stored in the database, e.g., 1 / 0 instead of Active / Inactive. A <i>display</i> file is typically an Excel file (but could be XML or tab) designed to be viewed without processing, so the meaning of the data is more important than the actual value.</p>

	<form method="post" name="exportQFC" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">

	<p align="center" style="width:500">
	<input type=button value="Uncheck All Fields" onClick="this.value=check(this.form.exportQueryFieldCompanyXmlStatus)">
	&nbsp; &nbsp; 
	<input type="reset" value="Reset"></p>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectExportQueryFieldList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#CurrentRow#</td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableName#</td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableFieldName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectExportQueryFieldList.exportQueryFieldAs is "">&nbsp;<cfelse>#qry_selectExportQueryFieldList.exportQueryFieldAs#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectExportQueryFieldList.exportTableFieldType#</td>
		<!--- 
		<cfif Variables.formAction is not "" and ListFind(Variables.permissionActionList, "moveExportQueryFieldCompanyUp") and ListFind(Variables.permissionActionList, "moveExportQueryFieldCompanyDown")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryFieldCompanyDown&exportQueryID=#URL.exportQueryID#&exportQueryFieldID=#qry_selectExportQueryFieldList.exportQueryFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=export.moveExportQueryFieldCompanyUp&exportQueryID=#URL.exportQueryID#&exportQueryFieldID=#qry_selectExportQueryFieldList.exportQueryFieldID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		--->
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportQueryFieldList.exportTableFieldXmlStatus is 0>
				n/a
			<cfelse>
				<input type="checkbox" name="exportQueryFieldCompanyXmlStatus" value="#qry_selectExportQueryFieldList.exportQueryFieldID#"<cfif ListFind(Form.exportQueryFieldCompanyXmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID)> checked</cfif>>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportQueryFieldList.exportTableFieldTabStatus is 0>
				n/a
			<cfelse>
				<input type="checkbox" name="exportQueryFieldCompanyTabStatus" value="#qry_selectExportQueryFieldList.exportQueryFieldID#"<cfif ListFind(Form.exportQueryFieldCompanyTabStatus, qry_selectExportQueryFieldList.exportQueryFieldID)> checked</cfif>>
			</cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectExportQueryFieldList.exportTableFieldHtmlStatus is 1></cfif>
				n/a
			<cfelse>
				<input type="checkbox" name="exportQueryFieldCompanyHtmlStatus" value="#qry_selectExportQueryFieldList.exportQueryFieldID#"<cfif ListFind(Form.exportQueryFieldCompanyHtmlStatus, qry_selectExportQueryFieldList.exportQueryFieldID)> checked</cfif>>
			</cfif>
		</td>
		--->
		</tr>
	</cfloop>

	<cfif Variables.formAction is not "">
		<tr height="40"><td align="center" colspan="#Variables.columnCount#"><input type="submit" name="submitExportQueryFieldCompany" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></tr>
	</cfif>
	</table>

	</form>
</cfif>
</cfoutput>