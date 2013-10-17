<cfset Variables.lang_insertUpdateExportTable = StructNew()>

<cfset Variables.lang_insertUpdateExportTable.exportTableOrder = "You did not select a valid table order.">
<cfset Variables.lang_insertUpdateExportTable.primaryTargetID_exist = "You did not select a valid primary target for this table.">
<cfset Variables.lang_insertUpdateExportTable.primaryTargetID_unique = "The primary target you selected is already being used by another export table.">
<cfset Variables.lang_insertUpdateExportTable.exportTableStatus = "You did not select a valid table status.">
<cfset Variables.lang_insertUpdateExportTable.exportTableName_blank = "The table name cannot be blank.">
<cfset Variables.lang_insertUpdateExportTable.exportTableName_maxlength = "The table name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateExportTable.exportTableName_unique = "The table name is already being used by another table.">
<cfset Variables.lang_insertUpdateExportTable.exportTableDescription_maxlength = "The table description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">

<cfset Variables.lang_insertUpdateExportTable.errorTitle_insert = "The export table could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateExportTable.errorTitle_update = "The export table could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateExportTable.errorHeader = "">
<cfset Variables.lang_insertUpdateExportTable.errorFooter = "">
