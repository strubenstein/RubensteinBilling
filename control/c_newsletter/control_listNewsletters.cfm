<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("newsletterID")>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../c_contact/formParam_listContacts.cfm">

<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfset Variables.formAction = "index.cfm?method=#URL.method#">
<cfset Variables.formName = "listNewsletters">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_newsletter/form_listNewsletters.cfm">

<cfinclude template="../../view/v_contact/lang_listContacts.cfm">
<cfinclude template="../c_contact/formValidate_listContacts.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID>
	<cfset qryParamStruct.primaryTargetID = Variables.primaryTargetID>
	<cfif IsDefined("Form.userID_author") and Trim(Form.userID_author) is not "">
		<cfset qryParamStruct.userID_author = Form.userID_author>
	</cfif>
	<cfloop Index="field" List="searchText,searchTextType,contactDateType,contactSubject,contactMessage,contactFromName">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.contactTemplateID") and Application.fn_IsIntegerList(Form.contactTemplateID)>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&contactTemplateID=#Form.contactTemplateID#">
		<cfset qryParamStruct.contactTemplateID = Form.contactTemplateID>
	</cfif>
	<cfloop Index="field" List="contactDateFrom,contactDateTo,contactDateCreated_from,contactDateCreated_to,contactDateUpdated_from,contactDateUpdated_to,contactDateSent_from,contactDateSent_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="contactIsSent,contactHtml,contactHasCustomID">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="selectNewsletterList" ReturnVariable="qry_selectNewsletterList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="returnContactMessage" Value="#Form.returnContactMessage#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Newsletter" Method="selectNewsletterCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
	<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
	<cfset Variables.totalRecords = qryTotalRecords>
	<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
	<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
		<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
	<cfelse>
		<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
	</cfif>

	<cfinclude template="../../view/v_newsletter/lang_listNewsletters.cfm">

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateNewsletter,viewNewsletter")>
	<cfset Variables.columnHeaderList = Variables.lang_listNewsletters_title.newsletterDescription
			& "^" &  Variables.lang_listNewsletters_title.newsletterAuthor
			& "^" &  Variables.lang_listNewsletters_title.contactFromName
			& "^" &  Variables.lang_listNewsletters_title.contactSubject
			& "^" &  Variables.lang_listNewsletters_title.contactDateSent
			& "^" &  Variables.lang_listNewsletters_title.newsletterAction>
	<cfset Variables.columnOrderByList = "newsletterDescription^False^contactFromName^contactSubject^contactDateSent^False">

	<cfif ListFind(Variables.permissionActionList, "updateNewsletter") or ListFind(Variables.permissionActionList, "viewNewsletter")>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listNewsletters_title.viewNewsletter>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
	</cfif>

	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectNewsletterList.contactID_custom))>
		<cfset Variables.displayCustomID = True>
		<cfset Variables.columnHeaderList = "Custom<br>ID^" & Variables.columnHeaderList>
		<cfset Variables.columnOrderByList = Variables.lang_listNewsletters_title.contactID_custom & "^" & Variables.columnOrderByList>
	<cfelse>
		<cfset Variables.displayCustomID = False>
	</cfif>

	<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

	<cfinclude template="../../view/v_newsletter/dsp_selectNewsletterList.cfm">
</cfif>

