<!--- 
contactTopicID 
--->

<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.contactStatus)>
	<cfset errorMessage_fields.contactStatus = Variables.lang_insertUpdateContact.contactStatus>
</cfif>

<cfif Len(Form.contactSubject) gt maxlength_Contact.contactSubject>
	<cfset errorMessage_fields.contactSubject = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactSubject_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactSubject, "ALL"), "<<LEN>>", Len(Form.contactSubject), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.contactHtml)>
	<cfset errorMessage_fields.contactHtml = Variables.lang_insertUpdateContact.contactHtml>
</cfif>

<cfif Not ListFind("0,1", Form.contactFax)>
	<cfset errorMessage_fields.contactFax = Variables.lang_insertUpdateContact.contactFax>
</cfif>
<cfif Not ListFind("0,1", Form.contactEmail)>
	<cfset errorMessage_fields.contactEmail = Variables.lang_insertUpdateContact.contactEmail>
</cfif>

<cfif Not ListFind("0,1", Form.contactReplied)>
	<cfset errorMessage_fields.contactReplied = Variables.lang_insertUpdateContact.contactReplied>
</cfif>

<cfif Len(Form.contactID_custom) gt maxlength_Contact.contactID_custom>
	<cfset errorMessage_fields.contactID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactID_custom, "ALL"), "<<LEN>>", Len(Form.contactID_custom), "ALL")>
</cfif>

<cfif Form.contactTemplateID is not 0 and Not ListFind(ValueList(qry_selectContactTemplateList.contactTemplateID), Form.contactTemplateID)>
	<cfset errorMessage_fields.contactTemplateID = Variables.lang_insertUpdateContact.contactTemplateID>
</cfif>

<cfif Len(Form.contactFromName) gt maxlength_Contact.contactFromName>
	<cfset errorMessage_fields.contactFromName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactFromName_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactFromName, "ALL"), "<<LEN>>", Len(Form.contactFromName), "ALL")>
<cfelseif Trim(Form.contactFromName) is "" and Not IsDefined("Form.submitContactSave")>
	<cfset errorMessage_fields.contactFromName = Variables.lang_insertUpdateContact.contactFromName_blank>
</cfif>

<cfif Len(Form.contactReplyTo) gt maxlength_Contact.contactReplyTo>
	<cfset errorMessage_fields.contactReplyTo = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactReplyTo_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactReplyTo, "ALL"), "<<LEN>>", Len(Form.contactReplyTo), "ALL")>
<cfelseif Trim(Form.contactReplyTo) is "" and Not IsDefined("Form.submitContactSave")>
	<cfset errorMessage_fields.contactReplyTo = Variables.lang_insertUpdateContact.contactReplyTo_blank>
<cfelseif Trim(Form.contactReplyTo) is not "" and Not fn_IsValidEmail(Form.contactReplyTo)>
	<cfset errorMessage_fields.contactReplyTo = Variables.lang_insertUpdateContact.contactReplyTo_valid>
</cfif>

<cfif Len(Form.contactTo) gt maxlength_Contact.contactTo>
	<cfset errorMessage_fields.contactTo = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactTo_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactTo, "ALL"), "<<LEN>>", Len(Form.contactTo), "ALL")>
<cfelseif Trim(Form.contactTo) is "" and Not IsDefined("Form.submitContactSave")>
	<cfset errorMessage_fields.contactTo = Variables.lang_insertUpdateContact.contactTo_blank>
<cfelseif Trim(Form.contactTo) is not "">
	<cfloop Index="thisEmail" List="#Form.contactTo#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactTo = Variables.lang_insertUpdateContact.contactTo_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Len(Form.contactCC) gt maxlength_Contact.contactCC>
	<cfset errorMessage_fields.contactCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactCC_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactCC, "ALL"), "<<LEN>>", Len(Form.contactCC), "ALL")>
<cfelseif Trim(Form.contactCC) is not "">
	<cfloop Index="thisEmail" List="#Form.contactCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactCC = Variables.lang_insertUpdateContact.contactCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Len(Form.contactBCC) gt maxlength_Contact.contactBCC>
	<cfset errorMessage_fields.contactBCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContact.contactBCC_maxlength, "<<MAXLENGTH>>", maxlength_Contact.contactBCC, "ALL"), "<<LEN>>", Len(Form.contactBCC), "ALL")>
<cfelseif Trim(Form.contactBCC) is not "">
	<cfloop Index="thisEmail" List="#Form.contactBCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactBCC = Variables.lang_insertUpdateContact.contactBCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfset Variables.primaryTargetID_partner = 0>
<cfset Variables.targetID_partner = 0>
<cfset Variables.userID_partner = 0>

<cfif Form.primaryTargetKey_targetID_userID_partner is not "">
	<cfif Not ListLen(primaryTargetKey_targetID_userID_partner, "_") is 3
			or Not Application.fn_IsIntegerNonNegative(ListGetAt(primaryTargetKey_targetID_userID_partner, 2, "_"))
			or Not Application.fn_IsIntegerNonNegative(ListGetAt(primaryTargetKey_targetID_userID_partner, 3, "_"))>
		<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_valid>
	<cfelse>
		<cfset Variables.testPrimaryTargetID_partner = Application.fn_GetPrimaryTargetID(ListFirst(primaryTargetKey_targetID_userID_partner, "_"))>
		<cfset Variables.testTargetID_partner = ListGetAt(primaryTargetKey_targetID_userID_partner, 2, "_")>
		<cfset Variables.testUserID_partner = ListGetAt(primaryTargetKey_targetID_userID_partner, 3, "_")>

		<cfswitch expression="#ListFirst(primaryTargetKey_targetID_userID_partner, "_")#">
		<cfcase value="affiliateID">
			<cfif Variables.displayAffiliate is False or Variables.testTargetID_partner is not qry_selectCompany.affiliateID
					or Not ListFind("0,#qry_selectAffiliateList.userID#", Variables.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_affiliate>
			</cfif>
		</cfcase>
		<cfcase value="cobrandID">
			<cfif Variables.displayCobrand is False or Variables.testTargetID_partner is not qry_selectCompany.cobrandID
					or Not ListFind("0,#qry_selectCobrandList.userID#", Variables.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_cobrand>
			</cfif>
		</cfcase>
		<cfcase value="salespersonID">
			<cfif Variables.displaySalesperson is False or Variables.testTargetID_partner is not 0
					or Not ListFind(ValueList(qry_selectCommissionCustomerList.targetID), Variables.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_salesperson>
			</cfif>
		</cfcase>
		<cfcase value="vendorID">
			<cfset vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), Variables.testTargetID_partner)>
			<cfif Variables.displayVendor is False or Variables.vendorRow is 0
					or Not ListFind("0,#qry_selectVendorList.userID[vendorRow]#", Variables.testUserID_partner)>
				<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_vendor>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset errorMessage_fields.partnerTarget = Variables.lang_insertUpdateContact.partnerTarget_valid>
		</cfdefaultcase>
		</cfswitch>

		<cfif Not StructKeyExists(errorMessage_fields, "partnerTarget")>
			<cfset Variables.primaryTargetID_partner = Variables.testPrimaryTargetID_partner>
			<cfset Variables.targetID_partner = Variables.testTargetID_partner>
			<cfset Variables.userID_partner = Variables.testUserID_partner>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif IsDefined("Form.submitContactSave")>
		<cfset errorMessage_title = Variables.lang_insertUpdateContact.errorTitle_save>
	<cfelse><!--- submitContactSend --->
		<cfset errorMessage_title = Variables.lang_insertUpdateContact.errorTitle_save>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateContact.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateContact.errorFooter>
</cfif>

