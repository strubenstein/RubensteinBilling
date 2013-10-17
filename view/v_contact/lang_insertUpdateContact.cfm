<cfset Variables.lang_insertUpdateContact = StructNew()>
<cfset Variables.lang_insertUpdateContact_title = StructNew()>

<cfset Variables.lang_insertUpdateContact.contactStatus = "You did not select a valid message status.">
<cfset Variables.lang_insertUpdateContact.contactSubject_maxlength = "The subject may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactHtml = "You did not select a valid option for whether this message is in html format.">
<cfset Variables.lang_insertUpdateContact.contactFax = "You did not select a valid option for whether this message is being faxed.">
<cfset Variables.lang_insertUpdateContact.contactEmail = "You did not select a valid option for whether this message is being emailed.">
<cfset Variables.lang_insertUpdateContact.contactReplied = "You did not select a valid option for whether this message has been replied to.">
<cfset Variables.lang_insertUpdateContact.contactID_custom_maxlength = "The message custom ID may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactTemplateID = "You did not select a valid message template.">
<cfset Variables.lang_insertUpdateContact.contactFromName_maxlength = "The name of the person/company this message is from may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactFromName_blank = "The name of the person/company this message is from may not be blank.">
<cfset Variables.lang_insertUpdateContact.contactReplyTo_maxlength = "The email address that this message is from may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactReplyTo_blank = "The email address that this message is from may not be blank.">
<cfset Variables.lang_insertUpdateContact.contactReplyTo_valid = "The email address that this message is from is not a valid email address.">
<cfset Variables.lang_insertUpdateContact.contactTo_maxlength = "The email address(es) this message is being sent to may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactTo_blank = "The email address this message is being sent to may not be blank.">
<cfset Variables.lang_insertUpdateContact.contactTo_valid = "The email address(es) this message is being sent to is (are) not valid.">
<cfset Variables.lang_insertUpdateContact.contactCC_maxlength = "The CC'd email address(es) may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactCC_valid = "The CC'd email address(es) is (are) not valid.">
<cfset Variables.lang_insertUpdateContact.contactBCC_maxlength = "The BCC'd email address(es) may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateContact.contactBCC_valid = "The BCC'd email address(es) is (are) not valid.">

<cfset Variables.lang_insertUpdateContact.partnerTarget_valid = "You did not select a valid salesperson or partner.">
<cfset Variables.lang_insertUpdateContact.partnerTarget_affiliate = "You did not select a valid affiliate partner.">
<cfset Variables.lang_insertUpdateContact.partnerTarget_cobrand = "You did not select a valid cobrand partner.">
<cfset Variables.lang_insertUpdateContact.partnerTarget_salesperson = "You did not select a valid salesperson.">
<cfset Variables.lang_insertUpdateContact.partnerTarget_vendor = "You did not select a valid vendor partner.">

<cfset Variables.lang_insertUpdateContact_title.formSubmitValue_send = "Send Message">
<cfset Variables.lang_insertUpdateContact_title.formSubmitValue_save = "Save">
<cfset Variables.lang_insertUpdateContact_title.formSubmitValue_reset = "Clear">

<cfset Variables.lang_insertUpdateContact.errorTitle_send = "The contact management message could not be sent for the following reason(s):">
<cfset Variables.lang_insertUpdateContact.errorTitle_save = "The contact management message could not be saved for the following reason(s):">
<cfset Variables.lang_insertUpdateContact.errorHeader = "">
<cfset Variables.lang_insertUpdateContact.errorFooter = "">
