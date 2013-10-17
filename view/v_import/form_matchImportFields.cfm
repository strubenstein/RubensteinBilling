<cfoutput>
<form method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="importFile" Value="#HTMLEditFormat(Form.importFile)#">
<input type="hidden" name="importFileType" Value="#HTMLEditFormat(Form.importFileType)#">
<input type="hidden" name="primaryTargetKey" Value="#HTMLEditFormat(Form.primaryTargetKey)#">
<input type="hidden" name="importFileFirstRowIsHeader" Value="#HTMLEditFormat(Form.importFileFirstRowIsHeader)#">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Record Type: </td>
	<td>#Ucase(Left(Form.primaryTargetKey, 1))##Mid(Form.primaryTargetKey, 2, Len(Form.primaryTargetKey) - 3)#</td>
</tr>
<tr>
	<td>First Row: </td>
	<td><cfif Form.importFileFirstRowIsHeader is "True">First row is header, and is <i>not</i> imported.<cfelse>First row is data and is imported.</cfif></td>
</tr>
<tr>
	<td>## Records: </td>
	<td><cfif Form.importFileFirstRowIsHeader is "True">#DecrementValue(Variables.importRowCount)#<cfelse>#Variables.importRowCount#</cfif></td>
</tr>
</table>

<p class="MainText" style="width: 650">For each column in the import file, please indicate which field it corresponds to. You may not select a field more than once. If a column should not be imported, simply do not select a field name. Any columns left blank will be ignored.</p>
<p class="MainText" style="width: 650">After submitting the list of fields, each record will be imported. Any records that cannot be imported will be written to a tab-delimited error file, which you will be able to download after the import process completes.</p>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr class="TableHeader">
	<th>Field</th>
	<th>First Row</th>
	<th>2nd Row</th>
	<th>3rd Row</th>
</tr>

<cfset Variables.fieldListCount = ListLen(Variables.importFieldList_label)>
<cfloop Index="colCount" From="1" To="#Variables.importColumnCount#">
	<tr valign="top"<cfif (colCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>
		<select name="field#colCount#" size="1">
		<option value="">-- SELECT --</option>
		<cfset Variables.thisSelectValue = Form["field#colCount#"]>
		<cfloop Index="fieldCount" From="1" To="#Variables.fieldListCount#">
			<option value="#HTMLEditFormat(ListGetAt(Variables.importFieldList_value, fieldCount))#"<cfif Variables.thisSelectValue is ListGetAt(Variables.importFieldList_value, fieldCount)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.importFieldList_label, fieldCount))#</option>
		</cfloop>
		</select>
	</td>
	<td><cfif Variables.importRowCount lt 1>&nbsp;<cfelse>#HTMLEditFormat(Left(Variables.importDataArray[1][colCount], 100))#</cfif></td>
	<td><cfif Variables.importRowCount lt 2>&nbsp;<cfelse>#HTMLEditFormat(Left(Variables.importDataArray[2][colCount], 100))#</cfif></td>
	<td><cfif Variables.importRowCount lt 3>&nbsp;<cfelse>#HTMLEditFormat(Left(Variables.importDataArray[3][colCount], 100))#</cfif></td>
	</tr>
</cfloop>

<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="submitImportMatch" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
