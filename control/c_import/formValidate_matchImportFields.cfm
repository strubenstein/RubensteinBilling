<cfset errorMessage_fields = StructNew()>

<cfset Variables.importFieldList_actual = "">
<cfset Variables.importFieldsArray = ArrayNew(1)>

<cfloop Index="colCount" From="1" To="#Variables.importColumnCount#">
	<cfif Trim(Form["field#colCount#"]) is "">
		<cfset Variables.importFieldList_actual = ListAppend(Variables.importFieldList_actual, " ")>
		<cfset Variables.importFieldsArray[colCount] = "">
	<cfelseif Not ListFind(Variables.importFieldList_value, Form["field#colCount#"])>
		<cfset errorMessage_fields["field#colCount#"] = ReplaceNoCase(Variables.lang_matchImportFields.field_exist, "<<COUNT>>", colCount, "ALL")>
	<cfelseif ListFindNoCase(Variables.importFieldList_actual, Form["field#colCount#"])>
		<cfset errorMessage_fields["field#colCount#"] = ReplaceNoCase(Variables.lang_matchImportFields.field_repeat, "<<COUNT>>", colCount, "ALL")>
	<cfelse>
		<cfset Variables.importFieldList_actual = ListAppend(Variables.importFieldList_actual, Form["field#colCount#"])>
		<cfset Variables.importFieldsArray[colCount] = Form["field#colCount#"]>
	</cfif>
</cfloop>

<cfif ArrayLen(Variables.importFieldsArray) is 0>
	<cfset errorMessage_fields.noFields = Variables.lang_matchImportFields.noFields>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_matchImportFields.errorTitle>
	<cfset errorMessage_header = Variables.lang_matchImportFields.errorHeader>
	<cfset errorMessage_footer = Variables.lang_matchImportFields.errorFooter>
</cfif>
