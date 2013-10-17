<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.exportTableField.exportTableFieldXmlName.value == "")
		document.exportTableField.exportTableFieldXmlName.value = document.exportTableField.exportTableFieldName.value;
	if (document.exportTableField.exportTableFieldTabName.value == "")
		document.exportTableField.exportTableFieldTabName.value = document.exportTableField.exportTableFieldName.value;
	if (document.exportTableField.exportTableFieldHtmlName.value == "")
		document.exportTableField.exportTableFieldHtmlName.value = document.exportTableField.exportTableFieldName.value;
}
</script>

<form method="post" name="exportTableField" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertExportTableField">
	<tr>
		<td>Order: </td>
		<td>
			<select name="exportTableFieldOrder" size="1">
			<cfloop Query="qry_selectExportTableFieldList">
				<option value="#qry_selectExportTableFieldList.exportTableFieldOrder#"<cfif Form.exportTableFieldOrder is qry_selectExportTableFieldList.exportTableFieldOrder> selected</cfif>>Before ###qry_selectExportTableFieldList.exportTableFieldOrder#. #HTMLEditFormat(qry_selectExportTableFieldList.exportTableFieldName)#</option>
			</cfloop>
			<option value="0"<cfif Form.exportTableFieldOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr valign="top">
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="exportTableFieldStatus" value="1"<cfif Form.exportTableFieldStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="exportTableFieldStatus" value="0"<cfif Form.exportTableFieldStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Field Name: </td>
	<td><input type="text" name="exportTableFieldName" value="#HTMLEditFormat(Form.exportTableFieldName)#" size="30" maxlength="#maxlength_ExportTableField.exportTableFieldName#" onBlur="setTitle()"> (actual database field name)</td>
</tr>
<tr>
	<td>Primary Key: </td>
	<td><label><input type="checkbox" name="exportTableFieldPrimaryKey" value="1"<cfif Form.exportTableFieldPrimaryKey is 1> checked</cfif>>This field is the primary key of the table, or part of a multi-field primary key.</label></td>
</tr>

<tr>
	<td>Field Type: </td>
	<td>
		<select name="exportTableFieldType" size="1">
		<option value="">-- SELECT TYPE --</option>
		<cfloop Index="type" List="#Variables.exportTableFieldTypeList#">
			<option value="#type#"<cfif Form.exportTableFieldType is type> selected</cfif>>#HTMLEditFormat(type)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>Field Size: </td>
	<td><input type="text" name="exportTableFieldSize" value="#HTMLEditFormat(Form.exportTableFieldSize)#" size="5"></td>
</tr>

<tr>
	<td>Description: </td>
	<td><input type="text" name="exportTableFieldDescription" value="#HTMLEditFormat(Form.exportTableFieldDescription)#" size="50" maxlength="#maxlength_ExportTableField.exportTableFieldDescription#"> (optional)</td>
</tr>
<tr>
	<td valign="top">XML Export File: </td>
	<td>
		<label><input type="checkbox" name="exportTableFieldXmlStatus" value="1"<cfif Form.exportTableFieldXmlStatus is 1> checked</cfif>> This field can be included in the XML export file.</label><br>
		Default Field Name: <input type="text" name="exportTableFieldXmlName" value="#HTMLEditFormat(Form.exportTableFieldXmlName)#" size="30" maxlength="#maxlength_ExportTableField.exportTableFieldXmlName#">
	</td>
</tr>
<tr>
	<td valign="top">Tab-Delimited File: </td>
	<td>
		<label><input type="checkbox" name="exportTableFieldTabStatus" value="1"<cfif Form.exportTableFieldTabStatus is 1> checked</cfif>> This field can be included in the tab-delimited export file.</label><br>
		Default Column Header: <input type="text" name="exportTableFieldTabName" value="#HTMLEditFormat(Form.exportTableFieldTabName)#" size="30" maxlength="#maxlength_ExportTableField.exportTableFieldTabName#">
		<div class="SmallText">(If generated for import purposes, XML field name is used. If for displaying in Excel, this column header is used.)</div>
	</td>
</tr>
<tr>
	<td valign="top">Browser Display: </td>
	<td>
		<label><input type="checkbox" name="exportTableFieldHtmlStatus" value="1"<cfif Form.exportTableFieldHtmlStatus is 1> checked</cfif>> This field can be displayed in the browser.</label><br>
		Default Column Header: <input type="text" name="exportTableFieldHtmlName" value="#HTMLEditFormat(Form.exportTableFieldHtmlName)#" size="30" maxlength="#maxlength_ExportTableField.exportTableFieldHtmlName#">
		<div class="SmallText">(Currently disabled. Option is not displayed to users.)</div>
	</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitExportTableField" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
