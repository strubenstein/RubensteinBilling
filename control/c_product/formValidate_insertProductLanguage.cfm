<cfif Variables.doAction is "insertProductLanguage" or Not IsDefined("errorMessage_fields")>
	<cfset errorMessage_fields = StructNew()>
</cfif>

<!--- languageID --->
<cfif Trim(Form.productLanguageLineItemName) is "">
	<cfset errorMessage_fields.productLanguageLineItemName = Variables.lang_insertProductLanguage.productLanguageLineItemName_blank>
<cfelseif Len(Form.productLanguageLineItemName) gt maxlength_ProductLanguage.productLanguageLineItemName>
	<cfset errorMessage_fields.productLanguageLineItemName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductLanguage.productLanguageLineItemName_maxlength, "<<MAXLENGTH>>", maxlength_ProductLanguage.productLanguageLineItemName, "ALL"), "<<LEN>>", Len(Form.productLanguageLineItemName), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.productLanguageLineItemDescriptionHtml)>
	<cfset errorMessage_fields.productLanguageLineItemDescriptionHtml = Variables.lang_insertProductLanguage.productLanguageLineItemDescriptionHtml>
</cfif>

<cfif Len(Form.productLanguageLineItemDescription) gt maxlength_ProductLanguage.productLanguageLineItemDescription>
	<cfset errorMessage_fields.productLanguageLineItemDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductLanguage.productLanguageLineItemDescription, "<<MAXLENGTH>>", maxlength_ProductLanguage.productLanguageLineItemDescription, "ALL"), "<<LEN>>", Len(Form.productLanguageLineItemDescription), "ALL")>
</cfif>

<cfif Trim(Form.productLanguageName) is "">
	<cfset errorMessage_fields.productLanguageName = Variables.lang_insertProductLanguage.productLanguageName_blank>
<cfelseif Len(Form.productLanguageName) gt maxlength_ProductLanguage.productLanguageName>
	<cfset errorMessage_fields.productLanguageName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductLanguage.productLanguageName_maxlength, "<<MAXLENGTH>>", maxlength_ProductLanguage.productLanguageName, "ALL"), "<<LEN>>", Len(Form.productLanguageName), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.productLanguageSummaryHtml)>
	<cfset errorMessage_fields.productLanguageSummaryHtml = Variables.lang_insertProductLanguage.productLanguageSummaryHtml>
</cfif>

<cfif Len(Form.productLanguageSummary) gt maxlength_ProductLanguage.productLanguageSummary>
	<cfset errorMessage_fields.productLanguageSummary = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductLanguage.productLanguageSummary, "<<MAXLENGTH>>", maxlength_ProductLanguage.productLanguageSummary, "ALL"), "<<LEN>>", Len(Form.productLanguageSummary), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.productLanguageDescriptionHtml)>
	<cfset errorMessage_fields.productLanguageDescriptionHtml = Variables.lang_insertProductLanguage.productLanguageDescriptionHtml>
</cfif>

<cfif maxlength_ProductLanguage.productLanguageDescription is not 0 and Len(Form.productLanguageDescription) gt maxlength_ProductLanguage.productLanguageDescription>
	<cfset errorMessage_fields.productLanguageDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductLanguage.productLanguageDescription, "<<MAXLENGTH>>", maxlength_ProductLanguage.productLanguageDescription, "ALL"), "<<LEN>>", Len(Form.productLanguageDescription), "ALL")>
</cfif>

<cfif Variables.doAction is "insertProductLanguage">
	<cfif StructIsEmpty(errorMessage_fields)>
		<cfset isAllFormFieldsOk = True>
	<cfelse>
		<cfset isAllFormFieldsOk = False>
		<cfset errorMessage_title = Variables.lang_insertProductLanguage.errorTitle>
		<cfset errorMessage_header = Variables.lang_insertProductLanguage.errorHeader>
		<cfset errorMessage_footer = Variables.lang_insertProductLanguage.errorFooter>
	</cfif>
</cfif>
