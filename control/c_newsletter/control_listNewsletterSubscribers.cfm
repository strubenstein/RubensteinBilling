<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_listNewsletterSubscribers.cfm">

<cfif Variables.doAction is "listNewsletterSubscribers">
	<cfset Variables.formAction = "index.cfm?method=#URL.method#">
	<cfset Variables.formName = "listNewsletterSubscribers">

	<cfinclude template="../../include/function/fn_listObjects.cfm">
	<cfinclude template="../../view/v_newsletter/form_listNewsletterSubscribers.cfm">
</cfif>

<cfinclude template="../../view/v_newsletter/lang_listNewsletterSubscribers.cfm">
<cfinclude template="formValidate_listNewsletterSubscribers.cfm">

<!--- 
Form.subscriberIsUser is 0:
	avNewsletterSubscriber only
	newsletterSubscriberRegistered,

Form.subscriberIsUser is 1:
	avUser only
	groupID,invoiceDateClosed_first,invoiceDateClosed_last
	companyIsCustomer,companyIsTaxExempt,companyIsCobrand,companyIsVendor,companyIsAffiliate,companyHasMultipleUsers
	companyHasCustomPricing,userIsSalesperson,userIsInMyCompany,companyHasCustomID,userHasCustomID,

Form.subscriberIsUser is NULL: Both
	affiliateID,cobrandID
	newsletterSubscriberDateType,newsletterSubscriberDateFrom,newsletterSubscriberDateTo
	newsletterSubscriberEmail,newsletterSubscriberHtml,newsletterSubscriberStatus,
--->

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset Variables.returnNewsletterSubscribers = False>
	<cfset Variables.returnUsers = False>
	<cfset qryParamStruct = StructNew()>

	<cfif Form.subscriberIsUser is 1><!--- registered users only --->
		<cfset Variables.returnNewsletterSubscribers = False>
	<cfelse><!--- subscribers --->
		<cfset Variables.returnNewsletterSubscribers = True>
		<cfset qryParamStruct.companyID_author = Session.companyID_author>
		<cfloop Index="field" List="newsletterSubscriberEmail,newsletterSubscriberDateType">
			<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				<cfset qryParamStruct[field] = Form[field]>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="affiliateID,cobrandID">
			<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				<cfset qryParamStruct[field] = Form[field]>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="newsletterSubscriberDateFrom,newsletterSubscriberDateTo,newsletterSubscriberDateExported_from,newsletterSubscriberDateExported_to">
			<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				<cfset qryParamStruct[field] = Form[field]>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="newsletterSubscriberHtml,newsletterSubscriberStatus,newsletterSubscriberRegistered">
			<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				<cfset qryParamStruct[field] = Form[field]>
			</cfif>
		</cfloop>
		<cfif IsDefined("Form.newsletterSubscriberIsExported") and (Form.newsletterSubscriberIsExported is "" or ListFind("0,1", Form.newsletterSubscriberIsExported))>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&newsletterSubscriberIsExported=#URLEncodedFormat(Form.newsletterSubscriberIsExported)#">
			<cfset qryParamStruct.newsletterSubscriberIsExported = Form.newsletterSubscriberIsExported>
		</cfif>
	</cfif>

	<cfif Form.subscriberIsUser is 0><!--- subscribers only --->
		<cfset Variables.returnUsers = False>
	<cfelse><!--- registered users --->
		<cfset Variables.returnUsers = True>
		<cfset qryParamStruct.companyID_author = Session.companyID>
		<cfloop Index="field" List="email,newsletterSubscriberEmail,newsletterSubscriberDateType">
			<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
				<cfset qryParamStruct[field] = Form[field]>
				<cfif Not Find(field, Variables.queryViewAction)>
					<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				</cfif>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="affiliateID,cobrandID,groupID">
			<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
				<cfset qryParamStruct[field] = Form[field]>
				<cfif Not Find(field, Variables.queryViewAction)>
					<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				</cfif>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="newsletterSubscriberDateFrom,newsletterSubscriberDateTo">
			<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
				<cfset qryParamStruct[field] = Form[field]>
				<cfif Not Find(field, Variables.queryViewAction)>
					<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				</cfif>
			</cfif>
		</cfloop>
		<cfloop Index="field" List="newsletterSubscriberStatus,newsletterSubscriberHtml,companyIsCustomer,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyIsAffiliate,userNewsletterHtml,userNewsletterStatus,companyHasCustomPricing,companyHasMultipleUsers,userIsSalesperson,userIsInMyCompany,companyHasCustomID,userHasCustomID">
			<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field]) and Not Find(field, Variables.queryViewAction)>
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
				<cfset qryParamStruct[field] = Form[field]>
			</cfif>
		</cfloop>
	</cfif>

	<cfif Variables.doAction is "listNewsletterSubscribers">
		<!--- Determine whether results are being displayed or exported --->
		<cfset Variables.exportResults = False>
		<cfset Variables.updateExportStatus = False>
		<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportNewsletterSubscribers")
				and IsDefined("URL.queryDisplayResults") and URL.queryDisplayResults is False
				and IsDefined("Form.exportResultsMethod") and ListFind("excel,iif,ab,xml", Form.exportResultsMethod)
				and IsDefined("Form.exportResultsFormat") and ListFind("data,display", Form.exportResultsFormat)
				and IsDefined("Form.exportFunction") and ListFind("exportOnly,exportAndStatus,statusOnly", Form.exportFunction)>
			<cfif ListFind("exportOnly,exportAndStatus", Form.exportFunction)>
				<cfset Variables.exportResults = True>
				<cfset Form.queryDisplayPerPage = 0>
			</cfif>
			<cfif ListFind("exportAndStatus,statusOnly", Form.exportFunction) and IsDefined("Form.targetIsExported") and (Form.targetIsExported is "" or ListFind("0,1", Form.targetIsExported))>
				<cfset Variables.updateExportStatus = True>
			</cfif>
		</cfif>
	</cfif>

	<cfif Variables.doAction is "listNewsletterSubscribers" or IsDefined("Form.isFormSubmitted")>
		<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="selectNewsletterSubscriberList" ReturnVariable="qry_selectNewsletterSubscriberList" argumentCollection="#qryParamStruct#">
			<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
			<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
			<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
			<cfinvokeargument Name="returnNewsletterSubscribers" value="#Variables.returnNewsletterSubscribers#">
			<cfinvokeargument Name="returnUsers" Type="boolean" value="#Variables.returnUsers#">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="selectNewsletterSubscriberCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="returnNewsletterSubscribers" value="#Variables.returnNewsletterSubscribers#">
		<cfinvokeargument Name="returnUsers" Type="boolean" value="#Variables.returnUsers#">
	</cfinvoke>

	<cfif Variables.doAction is "listNewsletterSubscribers">
		<!--- update export status of all results --->
		<cfif Variables.updateExportStatus is True>
			<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="updateNewsletterSubscriberIsExported" ReturnVariable="isNewsletterSubscriberExportStatusUpdated">
				<cfinvokeargument Name="newsletterSubscriberID" Value="#ValueList(qry_selectNewsletterSubscriberList.newsletterSubscriberID)#">
				<cfinvokeargument Name="newsletterSubscriberIsExported" Value="#Form.targetIsExported#">
			</cfinvoke>
		</cfif>

		<!--- export results --->
		<cfif Variables.exportResults is True>
			<cfinclude template="act_exportNewsletterSubscriberList.cfm">

		<!--- reload list after updating exporting status --->
		<cfelseif Variables.updateExportStatus is True>
			<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_newsletterSubscriber=updateNewsletterSubscriberIsExported" AddToken="No">

		<!--- display results in browser --->
		<cfelse>
			<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
			<cfset Variables.queryOrderBy = Form.queryOrderBy>
			<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
			<cfset Variables.totalRecords = qryTotalRecords>
			<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
			<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
				<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
			<cfelse>
				<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
			</cfif>

			<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateNewsletterSubscriber,updateCompany,updateUser")>
			<cfset Variables.columnHeaderList = Variables.lang_listNewsletterSubscribers_title.companyName
					& "^" & Variables.lang_listNewsletterSubscribers_title.lastName
					& "^" & Variables.lang_listNewsletterSubscribers_title.email
					& "^" & Variables.lang_listNewsletterSubscribers_title.status
					& "^" & Variables.lang_listNewsletterSubscribers_title.html
					& "^" & Variables.lang_listNewsletterSubscribers_title.dateSubscribed>
			<cfset Variables.columnOrderByList = "companyName^lastName^email^False^False^dateSubscribed">

			<cfif ListFind(Variables.permissionActionList, "updateNewsletterSubscriber") or ListFind(Variables.permissionActionList, "updateCompany") or ListFind(Variables.permissionActionList, "updateUser")>
				<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listNewsletterSubscribers_title.updateNewsletterSubscriber>
				<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			</cfif>

			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

			<cfinclude template="../../view/v_newsletter/dsp_selectNewsletterSubscriberList.cfm">
		</cfif><!--- export results or display results in browser--->
	</cfif>
</cfif>

