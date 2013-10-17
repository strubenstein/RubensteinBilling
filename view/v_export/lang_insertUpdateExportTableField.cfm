<cfset Variables.lang_insertUpdateExportTableField = StructNew()>

<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldOrder = "You did not select a valid field order.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldStatus = "You did not select a valid field status.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldPrimaryKey = "You did not select a valid option for whether this field is a primary key.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldXmlStatus = "You did not select a valid option for whether this field can be included in the XML export file.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldTabStatus = "You did not select a valid option for whether this field can be included in the tab-delimited export file.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldHtmlStatus = "You did not select a valid option for whether this field can be displayed in the browser.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldType = "You did not select a valid field type.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldSize = "The field size must be an integer greater than or equal to 0.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldName_blank = "The field name cannot be blank.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldName_maxlength = "The field name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldName_unique = "The field name is already being used by another field in this table.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldDescription_maxlength = "The field description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldXmlName_maxlength = "The XML field name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldTabName_maxlength = "The tab-delimited column header may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldHtmlName_maxlength = "The browser column header may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldXmlName_blank = "The XML field name cannot be blank if it can be included in the XML export file.">
<cfset Variables.lang_insertUpdateExportTableField.exportTableFieldTabName_blank = "The tab-delimited column header cannot be blank if it can be included in the tab-delimited export file.">

<cfset Variables.lang_insertUpdateExportTableField.errorTitle_insert = "The field could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateExportTableField.errorTitle_update = "The field could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateExportTableField.errorHeader = "">
<cfset Variables.lang_insertUpdateExportTableField.errorFooter = "">
