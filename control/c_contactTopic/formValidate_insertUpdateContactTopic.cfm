<cfset errorMessage_fields = StructNew()>

<cfif Not Application.fn_IsIntegerNonNegative(Form.contactTopicOrder) or Form.contactTopicOrder gt qry_selectContactTopicList.RecordCount>
	<cfset errorMessage_fields.contactTopicOrder = Variables.lang_insertUpdateContactTopic.contactTopicOrder>
</cfif>

<cfif Not ListFind("0,1", Form.contactTopicStatus)>
	<cfset errorMessage_fields.contactTopicStatus = Variables.lang_insertUpdateContactTopic.contactTopicStatus>
</cfif>

<cfif Trim(Form.contactTopicName) is "">
	<cfset errorMessage_fields.contactTopicName = Variables.lang_insertUpdateContactTopic.contactTopicName_blank>
<cfelseif Len(Form.contactTopicName) gt maxlength_ContactTopic.contactTopicName>
	<cfset errorMessage_fields.contactTopicName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTopic.contactTopicName_maxlength, "<<MAXLENGTH>>", maxlength_ContactTopic.contactTopicName, "ALL"), "<<LEN>>", Len(Form.contactTopicName), "ALL")>
<cfelse>
	<cfset Variables.topicRow = ListFind(ValueList(qry_selectContactTopicList.contactTopicName), Form.contactTopicName)>
	<cfif Variables.topicRow is not 0 and qry_selectContactTopicList.contactTopicID[Variables.topicRow] is not URL.contactTopicID>
		<cfset errorMessage_fields.contactTopicName = Variables.lang_insertUpdateContactTopic.contactTopicName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.contactTopicTitle) is "">
	<cfset errorMessage_fields.contactTopicTitle = Variables.lang_insertUpdateContactTopic.contactTopicTitle_blank>
<cfelseif Len(Form.contactTopicTitle) gt maxlength_ContactTopic.contactTopicTitle>
	<cfset errorMessage_fields.contactTopicTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTopic.contactTopicTitle_maxlength, "<<MAXLENGTH>>", maxlength_ContactTopic.contactTopicTitle, "ALL"), "<<LEN>>", Len(Form.contactTopicTitle), "ALL")>
<cfelse>
	<cfset Variables.topicRow = ListFind(ValueList(qry_selectContactTopicList.contactTopicTitle), Form.contactTopicTitle)>
	<cfif Variables.topicRow is not 0 and qry_selectContactTopicList.contactTopicID[Variables.topicRow] is not URL.contactTopicID>
		<cfset errorMessage_fields.contactTopicTitle = Variables.lang_insertUpdateContactTopic.contactTopicTitle_unique>
	</cfif>
</cfif>

<cfif Len(Form.contactTopicEmail) gt maxlength_ContactTopic.contactTopicEmail>
	<cfset errorMessage_fields.contactTopicEmail = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateContactTopic.contactTopicEmail_maxlength, "<<MAXLENGTH>>", maxlength_ContactTopic.contactTopicEmail, "ALL"), "<<LEN>>", Len(Form.contactTopicEmail), "ALL")>
<cfelse>
	<cfloop Index="thisEmail" List="#Form.contactTopicEmail#" Delimiters=",">
		<cfif Not fn_IsValidEmail(thisEmail)>
			<cfset errorMessage_fields.contactTopicEmail = Variables.lang_insertUpdateContactTopic.contactTopicEmail_valid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.contactTopicID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdateContactTopic.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateContactTopic.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateContactTopic.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateContactTopic.errorFooter>
</cfif>

