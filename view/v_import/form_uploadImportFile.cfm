<cfoutput>
<p class="MainText" style="width: 650">
There are 3 steps to importing records:<br>
&nbsp; 1.&nbsp;  Select record type and upload import file.<br>
&nbsp; 2.&nbsp;  Match field types to columns in your import file.<br>
&nbsp; 3.&nbsp;  After import is complete, download file with any failed import records.
</p>

<form method="post" action="#Variables.formAction#" enctype="multipart/form-data">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Record Type: </td>
	<td>
		<select name="primaryTargetKey" size="1">
		<option value="">-- SELECT --</option>
		<cfloop Index="targetKey" List="#Variables.primaryTargetKey_list#">
			<option value="#targetKey#"<cfif Form.primaryTargetKey is targetKey> selected</cfif>>#Ucase(Left(targetKey, 1))##Mid(targetKey, 2, Len(targetKey) - 3)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>File: </td>
	<td><input type="file" name="importFile" size="50"></td>
</tr>
<tr valign="top">
	<td>File Type: </td>
	<td>
		<label><input type="radio" name="importFileType" value="tab"<cfif Form.importFileType is "tab"> checked</cfif>>Tab-delimited file</label><br>
		<label><input type="radio" name="importFileType" value="comma"<cfif Form.importFileType is "comma"> checked</cfif>>Comma-delimited file</label><br>
		<!--- <label><input type="radio" name="importFileType" value="xml"<cfif Form.importFileType is "xml"> checked</cfif>>XML</label><br> --->
	</td>
</tr>
<tr>
	<td>First Row: </td>
	<td>
		<label><input type="checkbox" name="importFileFirstRowIsHeader" value="True"<cfif Form.importFileFirstRowIsHeader is True> checked</cfif>>
		<!--- If uploading a tab- or comma-delimited text file, --->Check if the first row is column headers, <i>not</i> data. If checked, first row will <i>not</i> be imported.</label>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="submitImportUpload" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
