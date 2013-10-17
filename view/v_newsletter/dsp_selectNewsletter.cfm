<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"><tr valign="top"><td>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectContact.contactTemplateID is not 0 and IsDefined("qry_selectContactTemplate") and qry_selectContactTemplate.RecordCount is not 0>
	<tr>
		<td>Template: </td>
		<td>#qry_selectContactTemplate.contactTemplateName#</td>
	</tr>
</cfif>
<cfif qry_selectContact.contactID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectContact.contactID_custom#</td>
	</tr>
</cfif>

<cfif qry_selectNewsletter.newsletterDescription is not "">
	<tr>
		<td>Description: </td>
		<td>#qry_selectNewsletter.newsletterDescription#</td>
	</tr>
</cfif>

<tr>
	<td>Date Sent: </td>
	<td><cfif Not IsDate(qry_selectContact.contactDateSent)>n/a<cfelse>#DateFormat(qry_selectContact.contactDateSent, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectContact.contactDateSent, "hh:mm tt")#</cfif></td>
</tr>
<tr>
	<td>## Recipients: </td>
	<td><cfif Not IsDate(qry_selectContact.contactDateSent)>n/a<cfelse>#qry_selectNewsletter.newsletterRecipientCount#</cfif></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Subject: </td>
	<td>#qry_selectContact.contactSubject#</td>
</tr>
<tr>
	<td>From Name: </td>
	<td>#qry_selectContact.contactFromName#</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td>#qry_selectContact.contactReplyTo#</td>
</tr>
<tr>
	<td><b>Message:</b> </td>
	<td><cfif qry_selectContact.contactHtml is 1>(sent in html format)</cfif></td>
</tr>
</table>

<table border="1" cellspacing="0" cellpadding="2" class="TableText" width="750"><tr><td>
<cfif qry_selectContact.contactHtml is 0>
	#Replace(HTMLEditFormat(qry_selectContact.contactMessage), Chr(10), "<br>", "ALL")#
<cfelse>
	#qry_selectContact.contactMessage#
	</td></tr><tr><td>
	<p class="MainText"><b>HTML Code:</b></p>
	#Replace(HTMLEditFormat(qry_selectContact.contactMessage), Chr(10), "<br>", "ALL")#
</cfif>
</td></tr></table>

</td><td width="15">&nbsp;</td><td>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
</cfoutput>

<cfinclude template="../../view/v_newsletter/form_listNewsletterSubscribers.cfm">

<cfoutput>
</form>
</td></tr></table>
</cfoutput>
