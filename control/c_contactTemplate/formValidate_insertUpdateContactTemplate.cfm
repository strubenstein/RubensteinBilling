<cfset errorMessage_fields = StructNew()>

<cfif Form.primaryTargetID is not 0 and Not ListFind(ValueList(qry_selectPrimaryTargetList.primaryTargetID), Form.primaryTargetID)>
	<cfset errorMessage_fields.primaryTargetID = Variables.lang_insertUpdateContactTemplate.primaryTargetID>
</cfif>

<cfif Variables.doAction is "insertContactTemplate">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.contactTemplateOrder)>
		<cfset errorMessage_fields.contactTemplateOrder = Variables.lang_insertUpdateContactTemplate.contactTemplateOrder_numeric>
	<cfelseif Not StructKeyExists(errorMessage_fields, "primaryTargetID")>
		<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectMaxContactTemplateOrder" ReturnVariable="maxContactTemplateOrder">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
		</cfinvoke>

		<cfif Form.contactTemplateOrder gt maxContactTemplateOrder>
			<cfset errorMessage_fields.contactTemplateOrder = Variables.lang_insertUpdateContactTemplate.contactTemplateOrder_range>
		</cfif>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.contactTemplateStatus)>
	<cfset errorMessage_fields.contactTemplateStatus = Variables.lang_insertUpdateContactTemplate.contactTemplateStatus>
</cfif>

<cfif Not ListFind("0,1", Form.contactTemplateHtml)>
	<cfset errorMessage_fields.contactTemplateHtml = Variables.lang_insertUpdateContactTemplate.contactTemplateHtml>
</cfif>

<cfif Trim(Form.contactTemplateName) is "">
	<cfset errorMessage_fields.contactTemplateName = Variables.lang_insertUpdateContactTemplate.contactTemplateName_blank>
<cfelseif Len(Form.contactTemplateName) gt maxlength_ContactTemplate.contactTemplateName>
	<cfset errorMessage_fields.contactTemplateName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateName_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateName, "ALL"), "<<LEN>>", Len(Form.contactTemplateName), "ALL")>
<cfelseif Not StructKeyExists(errorMessage_fields, "primaryTargetID")>
	<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="checkContactTemplateNameIsUnique" ReturnVariable="isContactTemplateNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="contactTemplateName" Value="#Form.contactTemplateName#">
		<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
		<cfinvokeargument Name="primaryTargetID" Value="#Form.primaryTargetID#">
	</cfinvoke>

	<cfif isContactTemplateNameUnique is False>
		<cfset errorMessage_fields.contactTemplateName = Variables.lang_insertUpdateContactTemplate.contactTemplateName_unique>
	</cfif>
</cfif>

<cfif Len(Form.contactTemplateFromName) gt maxlength_ContactTemplate.contactTemplateFromName>
	<cfset errorMessage_fields.contactTemplateFromName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateFromName_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateFromName, "ALL"), "<<LEN>>", Len(Form.contactTemplateFromName), "ALL")>
</cfif>

<cfif Len(Form.contactTemplateReplyTo) gt maxlength_ContactTemplate.contactTemplateReplyTo>
	<cfset errorMessage_fields.contactTemplateReplyTo = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateReplyTo_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateReplyTo, "ALL"), "<<LEN>>", Len(Form.contactTemplateReplyTo), "ALL")>
<cfelseif Trim(Form.contactTemplateReplyTo) is not "" and Not fn_IsValidEmail(Form.contactTemplateReplyTo)>
	<cfset errorMessage_fields.contactTemplateReplyTo = Variables.lang_insertUpdateContactTemplate.contactTemplateReplyTo_valid>
</cfif>

<cfif Len(Form.contactTemplateCC) gt maxlength_ContactTemplate.contactTemplateCC>
	<cfset errorMessage_fields.contactTemplateCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateCC_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateCC, "ALL"), "<<LEN>>", Len(Form.contactTemplateCC), "ALL")>
<cfelseif Trim(Form.contactTemplateCC) is not "">
	<cfloop Index="thisEmail" List="#Form.contactTemplateCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactTemplateCC = Variables.lang_insertUpdateContactTemplate.contactTemplateCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Len(Form.contactTemplateBCC) gt maxlength_ContactTemplate.contactTemplateBCC>
	<cfset errorMessage_fields.contactTemplateBCC = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateBCC_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateBCC, "ALL"), "<<LEN>>", Len(Form.contactTemplateBCC), "ALL")>
<cfelseif Trim(Form.contactTemplateBCC) is not "">
	<cfloop Index="thisEmail" List="#Form.contactTemplateBCC#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactTemplateBCC = Variables.lang_insertUpdateContactTemplate.contactTemplateBCC_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Len(Form.contactTemplateSubject) gt maxlength_ContactTemplate.contactTemplateSubject>
	<cfset errorMessage_fields.contactTemplateSubject = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTemplate.contactTemplateSubject_maxlength, "<<MAXLENGTH>>", maxlength_ContactTemplate.contactTemplateSubject, "ALL"), "<<LEN>>", Len(Form.contactTemplateSubject), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.contactTemplateID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdateContactTemplate.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateContactTemplate.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateContactTemplate.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateContactTemplate.errorFooter>
</cfif>

