<cfset errorMessage_fields = StructNew()>

<cfset Variables.realFileExt = "">
<cfset Variables.realFileName = "">

<cfif Form.primaryTargetKey is "" or Not ListFind(Variables.primaryTargetKey_list, Form.primaryTargetKey)>
	<cfset errorMessage_fields.primaryTargetKey = Variables.lang_uploadImportFile.primaryTargetKey>
</cfif>

<cfif Form.importFile is "">
	<cfset errorMessage_fields.importFile = Variables.lang_uploadImportFile.importFile_blank>
<cfelseif URL.importStep is "upload">
	<cftry>
		<cffile
			Action="Upload"
			FileField="importFile"
			Destination="#Variables.importFileDirectory#"
			Accept="text/plain,text/xml"
			NameConflict="MakeUnique">

		<cfif File.FileWasSaved is "Yes">
			<cfset Variables.realFileName = File.ServerFile>
			<cfset Variables.realFileExt = File.ServerFileExt>
			<cfset Form.importFile = File.ServerFile>
		<cfelse>
			<cfset errorMessage_fields.importFile = Variables.lang_uploadImportFile.importFile_notSaved>
		</cfif>

		<cfcatch>
			<cfset errorMessage_fields.importFile = Variables.lang_uploadImportFile.importFile_invalid>
		</cfcatch>
	</cftry>
<!--- validate file exists --->
<cfelseif Not FileExists(Variables.importFileDirectory & Form.importFile)>
	<cfset errorMessage_fields.importFile = Variables.lang_uploadImportFile.importFile_exist>
<cfelse>
	<cfset Variables.realFileExt = ListLast(Form.importFile, ".")>
</cfif>

<cfif Not ListFind("tab,comma,xml", Form.importFileType)>
	<cfset errorMessage_fields.importFileType = Variables.lang_uploadImportFile.importFileType_type>
<cfelseif Form.importFileType is "xml" and Variables.realFileExt is not "xml">
	<cfset errorMessage_fields.importFileType = Variables.lang_uploadImportFile.importFileType_xml>
<cfelseif ListFind("tab,comma", Form.importFileType) and Variables.realFileExt is not "txt">
	<cfset errorMessage_fields.importFileType = Variables.lang_uploadImportFile.importFileType_txt>
</cfif>

<cfif IsDefined("Form.importFileFirstRowIsHeader") and Form.importFileFirstRowIsHeader is True>
	<cfset Form.importFileFirstRowIsHeader = True>
<cfelse>
	<cfset Form.importFileFirstRowIsHeader = False>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfif Form.importFileType is "tab">
		<cfset Variables.importFileSeparator = "	">
	<cfelse>
		<cfset Variables.importFileSeparator = ",">
	</cfif>

	<cffile Action="Read" File="#Variables.importFileDirectory##Form.importFile#" Variable="importFileContent">
	<cfset Variables.importRowCount = ListLen(importFileContent, Chr(10))>

	<cfif Variables.importRowCount is 0>
		<cfset Variables.importColumnCount = 0>
	<cfelse>
		<cfset Variables.importColumnCount = ListLen(ListFirst(importFileContent, Chr(10)), Variables.importFileSeparator)>
	</cfif>

	<cfif Variables.importColumnCount is 0>
		<cfset errorMessage_fields.importColumnCount = Variables.lang_uploadImportFile.importColumnCount>
	<cfelseif Variables.importRowCount is 0 or (Form.importFileFirstRowIsHeader is True and Variables.importRowCount is 1)>
		<cfset errorMessage_fields.importRowCount = Variables.lang_uploadImportFile.importRowCount>
	</cfif> 
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfif FileExists(Variables.importFileDirectory & Form.importFile)>
		<cffile Action="Delete" File="#Variables.importFileDirectory##Form.importFile#">
	</cfif>

	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_uploadImportFile.errorTitle>
	<cfset errorMessage_header = Variables.lang_uploadImportFile.errorHeader>
	<cfset errorMessage_footer = Variables.lang_uploadImportFile.errorFooter>
</cfif>
