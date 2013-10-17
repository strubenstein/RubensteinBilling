<!--- 
INPUT:
Variables.xmlTagPlural
Variables.xmlTagSingle
Variables.fileNamePrefix
Variables.exportQueryName

Variables.fieldsWithCustomName
Variables.fieldsWithCustomDisplay

fnx_ functions for each field that must be processed before exporting
--->

<cfswitch expression="#Form.exportResultsMethod#">
<cfcase value="excel">
	<cfset Variables.exportFileExtension = ".xls">
	<cfset Variables.exportFileType = "application/msexcel">
</cfcase>
<cfcase value="iif"><!--- QuickBooks tab-delimited --->
	<cfset Variables.exportFileExtension = ".iif">
	<cfset Variables.exportFileType = "text/txt">
</cfcase>
<cfcase value="tab">
	<cfset Variables.exportFileExtension = ".txt">
	<cfset Variables.exportFileType = "text/txt">
</cfcase>
<cfcase value="xml">
	<cfset Variables.exportFileExtension = ".xml">
	<cfset Variables.exportFileType = "text/xml">
</cfcase>
</cfswitch>

<cfif Form.exportResultsMethod is not "iif">
	<!--- If XML or data format, get XML field names. If tab/excel and display, get field headers. --->
	<cfinvoke Component="#Application.billingMapping#data.ExportQueryFieldCompany" Method="selectExportQueryForCompany" ReturnVariable="qry_selectExportQueryForCompany">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="exportQueryName" Value="#Variables.exportQueryName#">
		<cfif Form.exportResultsMethod is "xml" or Form.exportResultsFormat is "data"><!--- tab,html,xml --->
			<cfinvokeargument Name="exportResultsMethod" Value="xml">
		<cfelse><!--- data --->
			<cfinvokeargument Name="exportResultsMethod" Value="tab">
		</cfif>
	</cfinvoke>
<cfelse><!--- QuickBooks tab-delimited --->
	<!--- Create query of export fields --->
	<cfset qry_selectExportQueryForCompany = QueryNew("")>
	<!--- exportTableFieldName,exportQueryFieldAs,exportTableFieldName_default,exportTableFieldName_custom --->
	<!--- Determine fields based on QuickBooks export and query name --->
	<cfinclude template="act_exportQueryForCompany_quickbooks.cfm">
</cfif>

<!--- 
If any fields have different names as returned in query compared to actual database field name, rename export query fields
List of realName|selectAsName

<cfloop Index="fieldOldNew" List="#Variables.fieldsWithCustomName#">
	<cfset Variables.fieldRow = ListFind(ValueList(qry_selectExportQueryForCompany.exportTableFieldName), ListFirst(fieldOldNew, "|"))>
	<cfif Variables.fieldRow is not 0>
		<cfset temp = QuerySetCell(qry_selectExportQueryForCompany, exportTableFieldName, ListLast(fieldOldNew, "|"), Variables.fieldRow)>
	</cfif>
</cfloop>
--->

<cfset Variables.exportFileDirectory = Application.billingTempPath & Application.billingFilePathSlash>
<cfif Session.companyDirectory is not "">
	<cfset Variables.exportFileDirectory = Variables.exportFileDirectory & Session.companyDirectory & Application.billingFilePathSlash>
</cfif>
<cfset Variables.exportFilename = Variables.fileNamePrefix & "_" & DateFormat(Now(), "yyyymmdd") & Variables.exportFileExtension>

<cfscript>
function fnx_fieldName (defaultFieldName, customFieldName)
{
	if (customFieldName is "")
		return defaultFieldName;
	else
		return customFieldName;
}

function fnx_fieldData (fieldName, fieldAs, queryRow)
{
	var fieldData = "";
	if (fieldAs is "")
		{
		fieldData = Evaluate("#Variables.exportQueryName#.#fieldName#[queryRow]");
		if (ListFind(Variables.fieldsWithCustomDisplay, fieldName))
			fieldData = Evaluate("fnx_#fieldName#(fieldData)");
		}
	else
		{
		fieldData = Evaluate("#Variables.exportQueryName#.#fieldAs#[queryRow]");
		if (ListFind(Variables.fieldsWithCustomDisplay, fieldAs))
			fieldData = Evaluate("fnx_#fieldAs#(fieldData)");
		}

	return fieldData;
}
</cfscript>

<cfswitch expression="#Form.exportResultsMethod#">
<cfcase value="xml">
	<cfset Variables.exportFile = "<?xml version=""1.0""?><#Variables.xmlTagPlural#>">
	<cfloop Query="#Variables.exportQueryName#">
		<cfset Variables.queryRow = CurrentRow>
		<cfset Variables.exportFile = Variables.exportFile & "<#Variables.xmlTagSingle#>">
		<cfloop Query="qry_selectExportQueryForCompany">
			<cfset Variables.exportFile = Variables.exportFile
				& "<" & fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom) & ">"
				& XmlFormat(fnx_fieldData(qry_selectExportQueryForCompany.exportTableFieldName, qry_selectExportQueryForCompany.exportQueryFieldAs, Variables.queryRow))
				& "</" & fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom) & ">">
		</cfloop>
		<cfset Variables.exportFile = Variables.exportFile & "</#Variables.xmlTagSingle#>">
	</cfloop>
	<cfset Variables.exportFile = Variables.exportFile & "</#Variables.xmlTagPlural#>">
</cfcase>

<cfcase value="iif"><!--- QuickBooks tab-delimited --->


</cfcase>

<cfdefaultcase><!--- tab,excel --->
	<cfset Variables.exportFile = "">
	<cfset tab = "	">
	<cfloop Query="qry_selectExportQueryForCompany">
		<cfset Variables.exportFile = ListAppend(Variables.exportFile, fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom), tab)>
	</cfloop>

	<cfloop Query="#Variables.exportQueryName#">
		<cfset Variables.queryRow = CurrentRow>
		<cfset Variables.thisDataRow = "">
		<cfloop Query="qry_selectExportQueryForCompany">
			<cfset Variables.thisDataRow = ListAppend(Variables.thisDataRow, fnx_fieldData(qry_selectExportQueryForCompany.exportTableFieldName, qry_selectExportQueryForCompany.exportQueryFieldAs, Variables.queryRow), tab)>
		</cfloop>
		<cfset Variables.exportFile = Variables.exportFile & Chr(10) & Variables.thisDataRow>
	</cfloop>
</cfdefaultcase>
</cfswitch>

<cffile Action="Write" File="#Variables.exportFileDirectory##Variables.exportFilename#" Output="#Variables.exportFile#">

<cfheader Name="Content-Disposition" Value="attachment;filename=#Variables.exportFilename#">
<cfcontent File="#Variables.exportFileDirectory##Variables.exportFilename#" Type="#Variables.exportFileType#" DeleteFile="Yes">

