<!--- 
Import instructions:

1. Display file upload form
2. Upload XML, comma-delimited or tab-delimited file
3. Display first and second row to match data to columns
4. Loop thru each record and import.
5. Track and return results for successful and unsuccessful rows
6. Present link to download file with unsuccessful rows
7. Scheduled script to delete temporary import/export files after X hours
--->

<cfinclude template="../../view/v_import/nav_import.cfm">

<!--- determine temp directory for uploading import file --->
<cfset Variables.importFileDirectory = Application.billingTempPath & Application.billingFilePathSlash>
<cfif Session.companyDirectory is not "">
	<cfset Variables.importFileDirectory = Variables.importFileDirectory & Session.companyDirectory & Application.billingFilePathSlash>
</cfif>

<cfset Variables.primaryTargetKey_list = "">
<cfloop Index="targetKey" List="company,user,affiliate,cobrand,vendor,product,invoice,invoiceLineItem,newsletterSubscriber">
	<cfif Application.fn_IsUserAuthorized("insert" & Ucase(Left(targetKey, 1)) & Mid(targetKey, 2, Len(targetKey) - 1))>
		<cfset Variables.primaryTargetKey_list = ListAppend(Variables.primaryTargetKey_list, targetKey & "ID")>
	</cfif>
</cfloop>

<cfif Variables.primaryTargetKey_list is "">
	<cfset Variables.doAction = "noImportPermission">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="importData">
	<cfinclude template="control_importData.cfm">
</cfcase>

<cfcase value="downloadFailedImports">
	<cfif Not IsDefined("URL.importFailedFilename") or Trim(URL.importFailedFilename) is "">
		<cfset URL.error_contact = "noFilename">
		<cfinclude template="../../view/v_import/error_import.cfm">
	<cfelseif Not FileExists(Variables.importFileDirectory & URL.importFailedFilename)>
		<cfset URL.error_contact = "fileNotExist">
		<cfinclude template="../../view/v_import/error_import.cfm">
	<cfelseif Right(URL.importFailedFilename, 3) is "txt">
		<cfheader Name="Content-Disposition" Value="attachment;filename=#URL.importFailedFilename#">
		<cfcontent File="#Variables.importFileDirectory##URL.importFailedFilename#" Type="text/plain" DeleteFile="Yes">
	<cfelse><!--- xml --->
		<cfheader Name="Content-Disposition" Value="attachment;filename=#URL.importFailedFilename#">
		<cfcontent File="#Variables.importFileDirectory##URL.importFailedFilename#" Type="text/xml" DeleteFile="Yes">
	</cfif>
</cfcase>

<cfcase value="noImportPermission">
	<cfset URL.error_contact = Variables.doAction>
	<cfinclude template="../../view/v_import/error_import.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_contact = "invalidAction">
	<cfinclude template="../../view/v_import/error_import.cfm">
</cfdefaultcase>
</cfswitch>


