<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.exportQuery.exportQueryTitle.value == "")
	document.exportQuery.exportQueryTitle.value = document.exportQuery.exportQueryName.value;
}
</script>

<form method="post" name="exportQuery" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertExportQuery">
	<tr>
		<td>Order: </td>
		<td>
			<select name="exportQueryOrder" size="1">
			<cfloop Query="qry_selectExportQueryList">
				<option value="#qry_selectExportQueryList.exportQueryOrder#"<cfif Form.exportQueryOrder is qry_selectExportQueryList.exportQueryOrder> selected</cfif>>Before ###qry_selectExportQueryList.exportQueryOrder#. #HTMLEditFormat(qry_selectExportQueryList.exportQueryName)#</option>
			</cfloop>
			<option value="0"<cfif Form.exportQueryOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr valign="top">
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="exportQueryStatus" value="1"<cfif Form.exportQueryStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="exportQueryStatus" value="0"<cfif Form.exportQueryStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Query Name: </td>
	<td><input type="text" name="exportQueryName" value="#HTMLEditFormat(Form.exportQueryName)#" size="30" maxlength="#maxlength_ExportQuery.exportQueryName#" onBlur="javascript:setTitle();"> (internal)</td>
</tr>
<tr>
	<td>Query Title: </td>
	<td><input type="text" name="exportQueryTitle" value="#HTMLEditFormat(Form.exportQueryTitle)#" size="30" maxlength="#maxlength_ExportQuery.exportQueryTitle#"> (displayed to customer)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="exportQueryDescription" value="#HTMLEditFormat(Form.exportQueryDescription)#" size="50" maxlength="#maxlength_ExportQuery.exportQueryDescription#"> (optional)</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitExportQuery" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
