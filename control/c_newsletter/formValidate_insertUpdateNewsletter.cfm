<!--- 
<cfset errorMessage_fields = StructNew()>

<cfif Len(Form.newsletterDescription) gt maxlength_Newsletter.newsletterDescription>
	<cfset errorMessage_fields.newsletterDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateNewsletter.newsletterDescription_maxlength, "<<MAXLENGTH>>", maxlength_Newsletter.newsletterDescription, "ALL"), "<<LEN>>", Len(Form.newsletterDescription), "ALL")>
</cfif>
--->

<cfif Len(Form.newsletterDescription) gt maxlength_Newsletter.newsletterDescription>
	<cfset Form.newsletterDescription = Left(Form.newsletterDescription, maxlength_Newsletter.newsletterDescription)>
</cfif>

