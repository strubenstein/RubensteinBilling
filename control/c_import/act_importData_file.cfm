<cfif Variables.importCountFail is 0>
	<cfif FileExists(Variables.importFileDirectory & Form.importFile)>
		<cffile Action="Delete" File="#Variables.importFileDirectory##Form.importFile#">
	</cfif>
<cfelse>
	<cfif FileExists("#Variables.importFileDirectory##Form.importFile#")>
		<cfset Variables.importFailedFilename = Form.importFile>
	<cfelse>
		<cfset Variables.importFailedFilename = "failedImport_" & DateFormat(Now(), "yyyymmdd") & "_" & TimeFormat(Now(), "hhmmss") & ".txt">
	</cfif>

	<cfif Form.importFileFirstRowIsHeader is True>
		<cfset Variables.importDataFailed = ListFirst(importFileContent, Chr(10)) & Variables.importDataFailed>
	</cfif>

	<cffile Action="Write" File="#Variables.importFileDirectory##Variables.importFailedFilename#" Output="#Variables.importDataFailed#">
</cfif>
