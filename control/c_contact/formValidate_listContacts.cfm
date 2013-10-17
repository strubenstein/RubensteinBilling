<cfset errorMessage_fields = StructNew()>

<cfif IsDefined("Form.affiliateID") and Application.fn_IsIntegerPositive(Form.affiliateID) and URL.control is not "affiliate">
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listContacts.affiliateID>
	</cfif>
</cfif>

<cfif IsDefined("Form.cobrandID") and Application.fn_IsIntegerPositive(Form.cobrandID) and URL.control is not "cobrand">
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listContacts.cobrandID>
	</cfif>
</cfif>

<cfif IsDefined("Form.groupID") and Application.fn_IsIntegerPositive(Form.groupID) and URL.control is not "group">
	<cfif Not ListFind(ValueList(qry_selectGroupList.groupID), Form.groupID)>
		<cfset errorMessage_fields.groupID = Variables.lang_listContacts.groupID>
	</cfif>
</cfif>

<cfif IsDefined("Form.userID_author") and Trim(Form.userID_author) is not "" and Not Application.fn_IsIntegerList(Form.userID_author)>
	<cfset errorMessage_fields.userID_author = Variables.lang_listContacts.userID_author>
</cfif>

<cfif IsDefined("Form.contactTemplateID") and Trim(Form.contactTemplateID) is not "">
	<cfloop Index="templateID" List="#Form.contactTemplateID#">
		<cfif templateID is not 0 and Not ListFind(ValueList(qry_selectContactTemplateList.contactTemplateID), templateID)>
			<cfset errorMessage_fields.contactTemplateID = Variables.lang_listContacts.contactTemplateID>
		</cfif>
	</cfloop>
</cfif>

<cfif IsDefined("Form.contactTopicID") and Trim(Form.contactTopicID) is not "">
	<cfloop Index="topicID" List="#Form.contactTopicID#">
		<cfif topicID is not 0 and Not ListFind(ValueList(qry_selectContactTopicList.contactTopicID), topicID)>
			<cfset errorMessage_fields.contactTopicID = Variables.lang_listContacts.contactTopicID>
		</cfif>
	</cfloop>
</cfif>

<!--- 
<cfif Form.statusID is not "" and Form.statusID is not 0>
	<cfif Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
		<cfset errorMessage_fields.statusID = Variables.lang_listContacts.statusID>
	</cfif>
</cfif>
--->

<cfloop Index="field" List="contactDateCreated_from,contactDateCreated_to,contactDateUpdated_from,contactDateUpdated_to,contactDateSent_from,contactDateSent_to">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listContacts[field]>
	</cfif>
</cfloop>

<cfset Form.contactDateFrom = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "contactDateFrom_date", Form.contactDateFrom_date, "contactDateFrom_hh", Form.contactDateFrom_hh, "contactDateFrom_mm", Form.contactDateFrom_mm, "contactDateFrom_tt", Form.contactDateFrom_tt)>
<cfif IsDate(Variables.dateBeginResponse)>
	<cfset Form.contactDateFrom = Variables.dateBeginResponse>
<cfelseif IsStruct(Variables.dateBeginResponse)>
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.contactDateTo = "">
<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "contactDateTo_date", Form.contactDateTo_date, "contactDateTo_hh", Form.contactDateTo_hh, "contactDateTo_mm", Form.contactDateTo_mm, "contactDateTo_tt", Form.contactDateTo_tt)>
<cfif IsDate(Variables.dateEndResponse)>
	<cfset Form.contactDateTo = Variables.dateEndResponse>
<cfelseif IsStruct(Variables.dateEndResponse)>
	<cfloop Collection="#Variables.dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.contactDateFrom) and IsDate(Form.contactDateTo)
		and DateCompare(Form.contactDateFrom, Form.contactDateTo) is not -1>
	<cfset errorMessage_fields.contactDateTo = Variables.lang_listContacts.contactDateTo>
</cfif>

<cfloop Index="field" List="contactByCustomer,contactIsSent,contactHasCustomID,contactIsReply,contactReplied,contactStatus,contactHtml,contactToMultiple,contactHasCC,contactHasBCC,contactEmail,contactFax">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listContacts[field]>
	</cfif>
</cfloop>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listContacts.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listContacts.queryPage>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listContacts.errorTitle>
	<cfset errorMessage_header = Variables.lang_listContacts.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listContacts.errorFooter>
</cfif>

