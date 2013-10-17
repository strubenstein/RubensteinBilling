<cfif Variables.doAction is "updateExportTableField" and IsDefined("qry_selectExportTableField")>
	<cfparam Name="Form.exportTableFieldName" Default="#qry_selectExportTableField.exportTableFieldName#">
	<cfparam Name="Form.exportTableFieldType" Default="#qry_selectExportTableField.exportTableFieldType#">
	<cfparam Name="Form.exportTableFieldSize" Default="#qry_selectExportTableField.exportTableFieldSize#">
	<cfparam Name="Form.exportTableFieldDescription" Default="#qry_selectExportTableField.exportTableFieldDescription#">
	<cfparam Name="Form.exportTableFieldOrder" Default="#qry_selectExportTableField.exportTableFieldOrder#">
	<cfparam Name="Form.exportTableFieldXmlName" Default="#qry_selectExportTableField.exportTableFieldXmlName#">
	<cfparam Name="Form.exportTableFieldTabName" Default="#qry_selectExportTableField.exportTableFieldTabName#">
	<cfparam Name="Form.exportTableFieldHtmlName" Default="#qry_selectExportTableField.exportTableFieldHtmlName#">
	<cfparam Name="Form.exportTableFieldStatus" Default="#qry_selectExportTableField.exportTableFieldStatus#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.exportTableFieldPrimaryKey" Default="#qry_selectExportTableField.exportTableFieldPrimaryKey#">
		<cfparam Name="Form.exportTableFieldXmlStatus" Default="#qry_selectExportTableField.exportTableFieldXmlStatus#">
		<cfparam Name="Form.exportTableFieldTabStatus" Default="#qry_selectExportTableField.exportTableFieldTabStatus#">
		<cfparam Name="Form.exportTableFieldHtmlStatus" Default="#qry_selectExportTableField.exportTableFieldHtmlStatus#">
	</cfif>
</cfif>

<cfparam Name="Form.exportTableFieldName" Default="">
<cfparam Name="Form.exportTableFieldType" Default="">
<cfparam Name="Form.exportTableFieldPrimaryKey" Default="0">
<cfparam Name="Form.exportTableFieldSize" Default="">
<cfparam Name="Form.exportTableFieldDescription" Default="">
<cfparam Name="Form.exportTableFieldOrder" Default="0">
<cfparam Name="Form.exportTableFieldXmlName" Default="">
<cfparam Name="Form.exportTableFieldTabName" Default="">
<cfparam Name="Form.exportTableFieldHtmlName" Default="">
<cfparam Name="Form.exportTableFieldStatus" Default="1">

<cfif Variables.doAction is "insertExportTableField" and Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.exportTableFieldXmlStatus" Default="1">
	<cfparam Name="Form.exportTableFieldTabStatus" Default="1">
	<cfparam Name="Form.exportTableFieldHtmlStatus" Default="1">
<cfelse>
	<cfparam Name="Form.exportTableFieldXmlStatus" Default="0">
	<cfparam Name="Form.exportTableFieldTabStatus" Default="0">
	<cfparam Name="Form.exportTableFieldHtmlStatus" Default="0">
</cfif>

<cfif Form.exportTableFieldSize is 0>
	<cfset Form.exportTableFieldSize = "">
</cfif>

