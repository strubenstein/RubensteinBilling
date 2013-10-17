<cfmail
	From="#fn_EmailFrom(qry_selectContactTemplate.contactTemplateFromName, qry_selectContactTemplate.contactTemplateReplyTo)#"
	To="#qry_selectContactTopic.contactTopicEmail#"
	Subject="#Variables.theContactSubject#"
	CC="#qry_selectContactTemplate.contactTemplateCC#"
	BCC="#qry_selectContactTemplate.contactTemplateBCC#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="#fn_EmailType(qry_selectContactTemplate.contactTemplateHtml)#">
#Variables.theContactMessage#
</cfmail>

