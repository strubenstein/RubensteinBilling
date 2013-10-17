<cfoutput>
<p class="SubTitle">Import Results</p>

<cfif Variables.importCountFail is 0>
	<p class="ConfirmationMessage">Import Successful!</p>
<cfelseif Variables.importCountSuccess is 0>
	<p class="ErrorMessage">Import Failed!</p>
<cfelse>
	<p class="ConfirmationMessage">Import partially successful.</p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Records successfully imported: </td>
	<td align="right"><font color="green">#Variables.importCountSuccess#</font></td>
</tr>
<tr>
	<td>Records not imported: </td>
	<td align="right"><font color="red">#Variables.importCountFail#</font></td>
</tr>
<tr>
	<td>Total records processed: </td>
	<td align="right">#Variables.importCountSuccess + Variables.importCountFail#</td>
</tr>
</table>

<cfif Variables.importCountFail is not 0 and Variables.importFailedFilename is not "" and FileExists(Variables.importFileDirectory & Variables.importFailedFilename)>
	<p class="MainText">[<a href="index.cfm?method=import.downloadFailedImports&importFailedFilename=#URLEncodedFormat(Variables.importFailedFilename)#" class="plainlink">Download Failed Import Records</a>] (tab-delimited file)</p>
</cfif>
</cfoutput>