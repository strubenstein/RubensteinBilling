<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.cobrandHeaderHtml)>
	<cfset errorMessage_fields.cobrandHeaderHtml = Variables.lang_insertCobrandHeader.cobrandHeaderHtml>
</cfif>

<cfif Not ListFind("0,1", Form.cobrandFooterHtml)>
	<cfset errorMessage_fields.cobrandFooterHtml = Variables.lang_insertCobrandHeader.cobrandFooterHtml>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertCobrandHeader.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertCobrandHeader.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertCobrandHeader.errorFooter>
</cfif>

