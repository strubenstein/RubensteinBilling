<cfinclude template="../../view/v_newsletter/form_listNewsletterSubscribers.cfm">

<cfoutput>
<cfif IsDefined("qryTotalRecords")>
	<p class="MediumText"><b><u>Newsletter subscribers this newsletter will be sent to based on current criteria: <font class="SubTitle">#qryTotalRecords#</font></u></b></p>
</cfif>

<cfif Variables.doAction is "insertNewsletter" and qry_selectContactTemplateList.RecordCount is not 0>
	<form method="get" action="">
	<p class="TableText"><b>Select Contact Management Template: </b>
	<select name="contactTemplateID" size="1"  onChange="window.open(this.options[this.selectedIndex].value,'_main')">
	<option value="#Variables.formAction#">-- CONTACT MGMT. TEMPLATE --</option>
	<cfloop Query="qry_selectContactTemplateList">
		<option value="#Variables.formAction#&contactTemplateID=#qry_selectContactTemplateList.contactTemplateID#"<cfif URL.contactTemplateID is qry_selectContactTemplateList.contactTemplateID> selected</cfif>>#HTMLEditFormat(qry_selectContactTemplateList.contactTemplateName)#</option>
	</cfloop>
	</select><br>
	(Note: Select template <i>before</i> entering any text in the form below.)
	</p>
	</form>
</cfif>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="contactTemplateID" value="#Form.contactTemplateID#">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="contactID_custom" value="#HTMLEditFormat(Form.contactID_custom)#" size="20" maxlength="#maxlength_Contact.contactID_custom#"> (optional; for internal purposes)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="newsletterDescription" value="#HTMLEditFormat(Form.newsletterDescription)#" size="40" maxlength="#maxlength_Newsletter.newsletterDescription#"> (for internal purposes)</td>
</tr>
<tr>
	<td>Subject: </td>
	<td><input type="text" name="contactSubject" value="#HTMLEditFormat(Form.contactSubject)#" size="40" maxlength="#maxlength_Contact.contactSubject#"></td>
</tr>
<tr>
	<td>From Name: </td>
	<td><input type="text" name="contactFromName" value="#HTMLEditFormat(Form.contactFromName)#" size="40" maxlength="#maxlength_Contact.contactFromName#"> (who email is from)</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td><input type="text" name="contactReplyTo" value="#HTMLEditFormat(Form.contactReplyTo)#" size="40" maxlength="#maxlength_Contact.contactReplyTo#"> (email address)</td>
</tr>
<tr>
	<td><b>Message:</b> </td>
	<td><label><input type="checkbox" name="contactHtml" value="1"<cfif Form.contactHtml is 1> checked</cfif>> Check if message is in html format</label></td>
</tr>
<tr><td colspan="2"><textarea name="contactMessage" rows="16" cols="80" wrap="soft">#HTMLEditFormat(Form.contactMessage)#</textarea></td></tr>
<tr>
	<td class="TableText" colspan="2">
		<input type="submit" name="submitContactSend" value="#HTMLEditFormat(Variables.formSubmitValue_send)#"> 
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
		<input type="submit" name="submitContactSave" value="#HTMLEditFormat(Variables.formSubmitValue_save)#"> (to send later or preview if html)<br>
		<br>
		<input type="reset" value="#HTMLEditFormat(Variables.formSubmitValue_reset)#">
	</td>
</tr>
</table>

<cfif Form.contactHtml is 1>
	<p><div class="SubTitle">Message HTML Preview</div>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText" width="700"><tr><td>
	#qry_selectContact.contactMessage#
	</td></tr></table>
	</p>
</cfif>

</form>
</cfoutput>
