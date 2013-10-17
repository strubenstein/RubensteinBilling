<cfset Variables.lang_updateStatusTarget = StructNew()>

<cfset Variables.lang_updateStatusTarget.formSubmitValue = "Update Status Export Options">

<cfset Variables.lang_updateStatusTarget.statusTargetExportXmlStatus = "For target type <<TYPE>>, you did not select a valid option for whether to include the custom status in the XML export.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportXmlName_blank = "For target type <<TYPE>>, the XML variable name cannot be blank if the custom status is being exported.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportXmlName_default = "For target type <<TYPE>>, the custom status XML variable name conflicts with the default status variable name. Please select another name.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportXmlName_maxlength = "For target type <<TYPE>>, the maximum length of the XML variable name is <<MAXLENGTH>>. It currently has <<LEN>> characters.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportXmlName_valid = "For target type <<TYPE>>, you must enter a valid variable name if the custom status is being exported via XML.<br>The name may be include A-Z, 0-9 and underscore (_) only and must begin with a letter.">

<cfset Variables.lang_updateStatusTarget.statusTargetExportTabStatus = "For target type <<TYPE>>, you did not select a valid option for whether to include the custom status in the tab-delimited export.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportTabName_blank = "For target type <<TYPE>>, the tab-delimited column header cannot be blank if the custom status is being exported.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportTabName_default = "For target type <<TYPE>>, the tab-delimited column header conflicts with the default status variable name. Please select another name.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportTabName_maxlength = "For target type <<TYPE>>, the maximum length of the tab-delimited column header is <<MAXLENGTH>>. It currently has <<LEN>> characters.">

<cfset Variables.lang_updateStatusTarget.statusTargetExportHtmlStatus = "For target type <<TYPE>>, you did not select a valid option for whether to include the custom status in the browser display.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportHtmlName_blank = "For target type <<TYPE>>, the browser display column header cannot be blank if the custom status is being exported.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportHtmlName_default = "For target type <<TYPE>>, the browser display column header conflicts with the default status variable name. Please select another name.">
<cfset Variables.lang_updateStatusTarget.statusTargetExportHtmlName_maxlength = "For target type <<TYPE>>, the maximum length of the browser display column header is <<MAXLENGTH>>. It currently has <<LEN>> characters.">

<cfset Variables.lang_updateStatusTarget.errorTitle = "The status export options could not be updated for the following reason(s):">
<cfset Variables.lang_updateStatusTarget.errorHeader = "">
<cfset Variables.lang_updateStatusTarget.errorFooter = "">
