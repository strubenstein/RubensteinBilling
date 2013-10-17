<cfset errorMessage_fields = StructNew()>

<cfif Not IsDefined("Form.exportTableFieldID_in") or Trim(Form.exportTableFieldID_in) is "" or Not Application.fn_IsIntegerList(Form.exportTableFieldID_in)>
	<cfset errorMessage_fields.exportTableFieldID_in = Variables.lang_insertExportQueryField.exportTableFieldID_in_blank>
<cfelseif Not IsDefined("URL.exportTableID") or Not IsDefined("qry_selectExportTableFieldList")>
	<cfset errorMessage_fields.exportTableID = Variables.lang_insertExportQueryField.exportTableID_blank>
<cfelse>
	<cfloop Index="fieldID" List="#Form.exportTableFieldID_in#">
		<!--- 
		<cfif ListFind(ValueList(qry_selectExportQueryFieldList.exportTableFieldID), fieldID)>
			<cfset errorMessage_fields.exportTableFieldID_in = Variables.lang_insertExportQueryField.exportTableFieldID_in_repeat>
		--->
		<cfif Not ListFind(ValueList(qry_selectExportTableFieldList.exportTableFieldID), fieldID)>
			<cfset errorMessage_fields.exportTableFieldID_in = Variables.lang_insertExportQueryField.exportTableFieldID_in_exist>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertExportQueryField.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertExportQueryField.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertExportQueryField.errorFooter>
</cfif>

