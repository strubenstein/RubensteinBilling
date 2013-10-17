<cfoutput>
<form method="post" action="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&queryDisplayResults=False">
<table border="0" cellspacing="0" cellpadding="5" width="800"><tr><td align="center">
<table border="0" cellspacing="0" cellpadding="3">
<tr align="center" class="SmallText">
	<td>
		Export Method:<br>
		<select name="exportResultsMethod" size="1">
			<option value="excel">Excel</option>
			<option value="iif">QuickBooks (IIF)</option>
			<option value="tab">Tab-Delimited</option>
			<option value="xml">XML</option>
		</select>
	</td>
	<td>
		Export Format:<br>
		<select name="exportResultsFormat" size="1">
			<option value="display">Display Format</option>
			<option value="data">Data Format</option>
		</select>
	</td>
	<td>
		Update Export Status:<br>
		<select name="targetIsExported" size="1" class="TableText">
			<option value="-1">-- EXPORT STATUS --</option>
			<option value="">Not Exported</option>
			<option value="0" selected>Awaiting Import Confirmation</option>
			<option value="1">Exported &amp; Import Confirmed</option>
		</select>
	</td>
</tr>
<tr class="TableText">
	<td colspan="2">
		&nbsp; &nbsp; <label><input type="radio" name="exportFunction" value="exportOnly" checked> Export only</label><br>
		&nbsp; &nbsp; <label><input type="radio" name="exportFunction" value="statusOnly"> Update export status only</label><br>
		&nbsp; &nbsp; <label><input type="radio" name="exportFunction" value="exportAndStatus"> Export &amp; update status</label><br>
	</td>
	<td><input type="submit" name="submitExportResults" value="Export All Results"></td>
</tr>
<tr align="center" class="SmallText">
	<td colspan="3">Display Format: Values reflect meaning, e.g., status = Active / Inactive instead of 1 / 0.</td>
</tr>
</table>
</td></tr></table>
</form>
</cfoutput>
