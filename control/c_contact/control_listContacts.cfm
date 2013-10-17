<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_listContacts.cfm">

<cfif Variables.userID is 0 and Variables.companyID is 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplateList" ReturnVariable="qry_selectContactTemplateList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="returnContactTemplateMessage" Value="False">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopicList" ReturnVariable="qry_selectContactTopicList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<!--- 
<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("contactID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>
--->

<cfset Variables.formName = "listContacts">
<cfset Variables.formAction = "index.cfm?method=#URL.method##Variables.urlParameters#">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_contact/form_listContacts.cfm">

<cfinclude template="../../view/v_contact/lang_listContacts.cfm">
<cfinclude template="formValidate_listContacts.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#" & Variables.urlParameters>
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID>
	<cfif IsDefined("Form.userID_author") and Trim(Form.userID_author) is not "">
		<cfset qryParamStruct.userID_author = Form.userID_author>
	</cfif>
	<cfif Variables.companyID is not 0>
		<cfset qryParamStruct.companyID_target = Variables.companyID>
	</cfif>
	<cfif Variables.userID is not 0>
		<cfset qryParamStruct.userID_target = Variables.userID>
	</cfif>
	<cfif Variables.primaryTargetID is not 0>
		<cfset qryParamStruct.primaryTargetID = Variables.primaryTargetID>
	</cfif>
	<cfif Variables.targetID is not 0>
		<cfset qryParamStruct.targetID = Variables.targetID>
	</cfif>
	<cfloop Index="field" List="searchText,searchTextType,searchEmail,searchEmailType,contactDateType,contactSubject,contactMessage,contactFromName,contactReplyTo,contactTo,contactCC,contactBCC,contactID_custom">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="groupID,contactTemplateID,contactTopicID,statusID,contactID_orig">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="affiliateID,cobrandID">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field]) and URL.control is not Left(field, Len(field) - 2)>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="contactDateFrom,contactDateTo,contactDateCreated_from,contactDateCreated_to,contactDateUpdated_from,contactDateUpdated_to,contactDateSent_from,contactDateSent_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="contactByCustomer,contactIsSent,contactHasCustomID,contactIsReply,contactReplied,contactStatus,contactHtml,contactToMultiple,contactHasCC,contactHasBCC,contactEmail,contactFax">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.Contact" Method="selectContactList" ReturnVariable="qry_selectContactList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="returnContactMessage" Value="#Form.returnContactMessage#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>
		<!--- 
		<cfinvokeargument Name="queryDisplayResults" Value="True">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryViewAction" Value="#Variables.queryViewAction#">
		--->

	<cfinvoke Component="#Application.billingMapping#data.Contact" Method="selectContactCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
	<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
	<cfset Variables.totalRecords = qryTotalRecords>
	<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
	<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
		<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
	<cfelse>
		<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
	</cfif>

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewProduct,viewCompany,viewUser,updateContactStatus1,updateContactStatus0,updateContact,viewContact,replyToContact")>

	<!--- 
	<cfset Variables.columnHeaderList = "Sender<br>Company^Sender<br>Name^Subject^Recipient<br>Company^Recipient<br>Name^Sent To^Status^Date<br>Sent^Action">
	<cfset Variables.columnOrderByList = "False^False^contactSubject^False^False^contactTo^contactStatus^contactDateSent^False">
	--->
	<cfset Variables.columnHeaderList = Variables.lang_listContacts_title.contactFrom
			& "^" & Variables.lang_listContacts_title.contactSubject
			& "^" & Variables.lang_listContacts_title.contactTo
			& "^" & Variables.lang_listContacts_title.contactStatus
			& "^" & Variables.lang_listContacts_title.contactDateSent>
	<cfset Variables.columnOrderByList = "False^contactSubject^False^contactStatus^contactDateSent">

	<cfif ListFind(Variables.permissionActionList, "updateContact") or ListFind(Variables.permissionActionList, "viewContact")>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listContacts_title.viewContact>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
	</cfif>

	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectContactList.contactID_custom))>
		<cfset Variables.displayCustomID = True>
		<cfset Variables.columnHeaderList = Variables.lang_listContacts_title.contactID_custom & "^" & Variables.columnHeaderList>
		<cfset Variables.columnOrderByList = "contactID_custom^" & Variables.columnOrderByList>
	<cfelse>
		<cfset Variables.displayCustomID = False>
	</cfif>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

	<cfinclude template="../../view/v_contact/dsp_selectContactList.cfm">
</cfif>

