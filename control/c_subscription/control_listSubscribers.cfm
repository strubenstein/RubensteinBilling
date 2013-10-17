<cfif URL.displaySubscriberSpecial is not "">
	<cfset Form.subscriberStatus = 1>
	<cfset Form.subscriberDateFrom_hh = 12>
	<cfset Form.subscriberDateFrom_mm = 0>
	<cfset Form.subscriberDateFrom_tt = "am">
	<cfset Form.subscriberDateTo_hh = 11>
	<cfset Form.subscriberDateTo_mm = 59>
	<cfset Form.subscriberDateTo_tt = "pm">

	<cfset Variables.thisWeekSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(Now())), Now())>
	<cfswitch expression="#URL.displaySubscriberSpecial#">
	<cfcase value="lastWeek">
		<cfset Form.subscriberDateFrom_date = DateFormat(DateAdd("d", -14, Variables.thisWeekSunday), "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", -8, Variables.thisWeekSunday), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", -7, Variables.thisWeekSunday), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessLast">
	</cfcase>
	<cfcase value="yesterday">
		<cfset Form.subscriberDateFrom_date = DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(Now(), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessLast">
	</cfcase>
	<cfcase value="today">
		<cfset Form.subscriberDateFrom_date = DateFormat(Now(), "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(Now(), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessLast,subscriberDateProcessNext">
	</cfcase>
	<cfcase value="tomorrow">
		<cfset Form.subscriberDateFrom_date = DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 2, Now()), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessNext">
	</cfcase>
	<cfcase value="thisWeek">
		<cfset Form.subscriberDateFrom_date = DateFormat(Variables.thisWeekSunday, "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 6, Variables.thisWeekSunday), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 7, Variables.thisWeekSunday), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessLast,subscriberDateProcessNext">
	</cfcase>
	<cfcase value="nextWeek">
		<cfset Form.subscriberDateFrom_date = DateFormat(DateAdd("d", 7, Variables.thisWeekSunday), "mm/dd/yyyy")>
		<cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 13, Variables.thisWeekSunday), "mm/dd/yyyy")>
		<!--- <cfset Form.subscriberDateTo_date = DateFormat(DateAdd("d", 14, Variables.thisWeekSunday), "mm/dd/yyyy")> --->
		<cfset Form.subscriberDateType = "subscriberDateProcessNext">
	</cfcase>
	</cfswitch>
</cfif>

<cfinclude template="formParam_listSubscribers.cfm">
<cfinclude template="../../view/v_subscription/var_subscriptionIntervalTypeList.cfm">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList_subscriber">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("subscriberID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList_subscription">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("subscriptionID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../include/function/fn_datetime.cfm">

<cfset Variables.formName = "listSubscribers">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_subscription/form_listSubscribers.cfm">

<cfinclude template="../../view/v_subscription/lang_listSubscribers.cfm">
<cfinclude template="formValidate_listSubscribers.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.categoryID_list = Form.categoryID>
	<cfif Form.categoryID gt 0 and Form.categoryID_sub is 1>
		<cfset Variables.beginRow = ListFind(ValueList(qry_selectCategoryList.categoryID), Form.categoryID) + 1>
		<cfif Variables.beginRow gt 1 and Variables.beginRow lte qry_selectCategoryList.RecordCount>
			<cfloop Query="qry_selectCategoryList" StartRow="#Variables.beginRow#">
				<cfif ListFind(qry_selectCategoryList.categoryID_parentList, Form.categoryID)>
					<cfset Variables.categoryID_list = ListAppend(categoryID_list, qry_selectCategoryList.categoryID)>
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfif URL.control is "company">
		<cfset qryParamStruct.companyID = URL.companyID>
	<cfelseif URL.control is "user">
		<cfset qryParamStruct.userID = URL.userID>
		<cfif URL.companyID is not 0>
			<cfset qryParamStruct.companyID = URL.companyID>
		</cfif>
	</cfif>
	<cfif IsDefined("Form.subscriberID") and Form.subscriberID is not 0 and Application.fn_IsIntegerList(Form.subscriberID)>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&subscriberID=#Form.subscriberID#">
		<cfset qryParamStruct.subscriberID = Form.subscriberID>
	</cfif>
	<cfif categoryID_list is not "">
		<cfset qryParamStruct.categoryID_list = categoryID_list>
	</cfif>
	<cfif Form.categoryID_sub is 1>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&categoryID_sub=#Form.categoryID_sub#">
		<cfset qryParamStruct.categoryID_sub = Form.categoryID_sub>
	</cfif>
	<cfloop Index="field" List="#Variables.fields_text#">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_numeric#">
		<cfif IsDefined("Form.#field#") and IsNumeric(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_integer#">
		<cfif IsDefined("Form.#field#") and Application.fn_IsInteger(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_integerList#">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_boolean#">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_date#">
		<cfif IsDefined("Form.#field#") and (Form[field] is "" or IsDate(Form[field]))>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.subscriberIsExported") and (Form.subscriberIsExported is "" or ListFind("0,1", Form.subscriberIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&subscriberIsExported=#URLEncodedFormat(Form.subscriberIsExported)#">
		<cfset qryParamStruct.subscriberIsExported = Form.subscriberIsExported>
	</cfif>


	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset Variables.queryFirstLetter_field = "avCompany.companyName"></cfcase>
		<cfcase value="subscriberName,subscriberName_d"><cfset Variables.queryFirstLetter_field = "avSubscriber.subscriberName"></cfcase>
		<cfdefaultcase><cfset Form.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportSubscribers")
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

	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
			<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
		</cfif>
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="updateSubscriberIsExported" ReturnVariable="isSubscriberExportStatusUpdated">
			<cfinvokeargument Name="subscriberID" Value="#ValueList(qry_selectSubscriberList.subscriberID)#">
			<cfinvokeargument Name="subscriberIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- if managing a company that has no subscribers, redirect to create subscriber --->
	<cfif qry_selectSubscriberList.RecordCount is 0 and URL.control is "company" and Not IsDefined("Form.isFormSubmitted") and Application.fn_IsUserAuthorized("insertSubscriber")>
		<cflocation url="index.cfm?method=company.insertSubscriber&companyID=#URL.companyID#&error_subscription=listSubscribers" AddToken="No">

	<!--- if managing a company that has one subscriber, redirect to view subscriber --->
	<cfelseif qry_selectSubscriberList.RecordCount is 1 and URL.control is "company" and Not IsDefined("Form.isFormSubmitted") and Application.fn_IsUserAuthorized("viewSubscriber")>
		<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_selectSubscriberList.subscriberID#" AddToken="No">

	<!--- export results --->
	<cfelseif Variables.exportResults is True>
		<cfinclude template="act_exportSubscriberList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_subscription=updateSubscriberIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfif Not ListFind("lastName,lastName_d,companyName,companyName_d,subscriberName,subscriberName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfif ListFind("companyName,companyName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avCompany.companyName">
			<cfelseif ListFind("lastName,lastName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avUser.lastName">
			<cfelse>
				<cfset Variables.alphabetField = "avSubscriber.subscriberName">
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList_alphabet" ReturnVariable="qry_selectSubscriberList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectSubscriberList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "" and Variables.queryFirstLetter_field is not "">
				<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
					<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
					<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
				</cfinvoke>

				<cfset Form.queryPage = 1 + (recordCountBeforeAlphabet \ Form.queryDisplayPerPage)>
			</cfif>
		</cfif>

		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewUser,viewCompany,viewSubscriber,viewSubscriber,updateSubscription")>
		<cfset Variables.columnHeaderList = Variables.lang_listSubscribers_title.companyName
				& "^" & Variables.lang_listSubscribers_title.subscriberName
				& "^" & Variables.lang_listSubscribers_title.lastName
				& "^" & Variables.lang_listSubscribers_title.subscriberLineItemCount
				& "^" & Variables.lang_listSubscribers_title.subscriberLineItemTotal
				& "^" & Variables.lang_listSubscribers_title.subscriberDateCreated
				& "^" & Variables.lang_listSubscribers_title.subscriberDateProcessLast
				& "^" & Variables.lang_listSubscribers_title.subscriberDateProcessNext>
		<cfset Variables.columnOrderByList = "companyName^subscriberName^lastName^subscriberLineItemCount^subscriberLineItemTotal^subscriberDateCreated^subscriberDateProcessLast^subscriberDateProcessNext"><!--- subscriberCompleted^ --->

		<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listSubscribers_title.viewSubscriber>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
		</cfif>

		<cfset Variables.displaySubscription = False>
		<cfset Form.priceID = 1>
		<cfloop Index="field" List="priceID,productID">
			<cfif IsDefined("Form.#field#") and Form[field] is not "" and Form[field] is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList_special" ReturnVariable="qry_selectSubscriptionList">
					<cfinvokeargument Name="#field#" Value="#Form[field]#">
					<cfinvokeargument Name="subscriptionStatus" Value="1">
					<cfinvokeargument Name="subscriptionCompleted" Value="0">
				</cfinvoke>

				<cfif qry_selectSubscriptionList.RecordCount is not 0>
					<cfset Variables.displaySubscription = True>
					<cfset Variables.displaySubscriptionBasis = field>
				</cfif>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

		<cfinclude template="../../view/v_subscription/dsp_selectSubscriberList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

