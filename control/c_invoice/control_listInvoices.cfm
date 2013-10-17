<cfif URL.displayInvoiceSpecial is not "">
	<cfset Form.invoiceClosed = 1>
	<cfset Form.invoiceDateType = "invoiceDateClosed">
	<cfset Form.invoiceDateFrom_hh = 12>
	<cfset Form.invoiceDateFrom_mm = 0>
	<cfset Form.invoiceDateFrom_tt = "am">
	<cfset Form.invoiceDateTo_hh = 12>
	<cfset Form.invoiceDateTo_mm = 0>
	<cfset Form.invoiceDateTo_tt = "am">

	<cfswitch expression="#URL.displayInvoiceSpecial#">
	<cfcase value="yesterday">
		<cfset Form.invoiceDateFrom_date = DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")>
		<cfset Form.invoiceDateTo_date = DateFormat(Now(), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="today">
		<cfset Form.invoiceDateFrom_date = DateFormat(Now(), "mm/dd/yyyy")>
		<cfset Form.invoiceDateTo_date = DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="thisWeek">
		<cfset Variables.thisWeekSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(Now())), Now())>
		<cfset Form.invoiceDateFrom_date = DateFormat(Variables.thisWeekSunday, "mm/dd/yyyy")>
		<cfset Form.invoiceDateTo_date = DateFormat(DateAdd("d", 7, Variables.thisWeekSunday), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="thisMonth">
		<cfset Form.invoiceDateFrom_date = DateFormat(CreateDate(Year(Now()), Month(Now()), 1), "mm/dd/yyyy")>
		<cfset Form.invoiceDateTo_date = DateFormat(DateAdd("d", 1, CreateDate(Year(Now()), Month(Now()), DaysInMonth(Now()))), "mm/dd/yyyy")>
	</cfcase>
	</cfswitch>
</cfif>

<cfinclude template="formParam_listInvoices.cfm">
<cfinclude template="../../view/v_shipping/var_shippingMethodList.cfm">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("invoiceID")#">
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

<cfinclude template="../../include/function/fn_datetime.cfm">

<cfset Variables.formName = "listInvoices">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_invoice/form_listInvoices.cfm">

<cfinclude template="../../view/v_invoice/lang_listInvoices.cfm">
<cfinclude template="formValidate_listInvoices.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfif ListFind("company,subscription", URL.control)>
		<cfset qryParamStruct.companyID = URL.companyID>
	<cfelseif URL.control is "user">
		<cfset qryParamStruct.userID = URL.userID>
		<cfif URL.companyID is not 0>
			<cfset qryParamStruct.companyID = URL.companyID>
		</cfif>
	</cfif>
	<cfif IsDefined("Form.invoiceID_not") and Application.fn_IsIntegerList(Form.invoiceID_not)>
		<cfset qryParamStruct.invoiceID_not = Form.invoiceID_not>
	</cfif>
	<cfloop Index="field" List="statusID,affiliateID,cobrandID,payflowID,subscriberID,productID,priceID">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="invoiceClosed,invoicePaid,invoiceStatus,invoiceShipped,invoiceCompleted,invoiceHasMultipleItems,invoiceHasCustomPrice,invoiceHasCustomID,invoiceManual,invoiceSent,invoiceHasInstructions,invoiceHasPaymentCredit">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="invoiceDateFrom,invoiceDateTo,invoiceDateExported_from,invoiceDateExported_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="invoiceTotal_min,invoiceTotal_max">
		<cfif IsDefined("Form.#field#") and IsNumeric(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="invoiceShippingMethod,invoiceDateType">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.invoiceIsExported") and (Form.invoiceIsExported is "" or ListFind("0,1", Form.invoiceIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&invoiceIsExported=#URLEncodedFormat(Form.invoiceIsExported)#">
		<cfset qryParamStruct.invoiceIsExported = Form.invoiceIsExported>
	</cfif>

	<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True>
		<cfinclude template="act_graphInvoiceList.cfm">
		<cfinclude template="../../view/v_invoice/dsp_graphInvoiceList.cfm">
		<cfinclude template="../../view/v_adminMain/footer_admin.cfm">
		<cfabort>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportInvoices")
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

	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectInvoiceList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoiceIsExported" ReturnVariable="isInvoiceExportStatusUpdated">
			<cfinvokeargument Name="invoiceID" Value="#ValueList(qry_selectInvoiceList.invoiceID)#">
			<cfinvokeargument Name="invoiceIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportInvoiceList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_invoice=updateInvoiceIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfset Variables.displayAlphabet = False>

		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,viewInvoice")>
		<cfset Variables.columnHeaderList = Variables.lang_listInvoices_title.invoiceID_custom
				& "^" & Variables.lang_listInvoices_title.companyName
				& "^" & Variables.lang_listInvoices_title.lastName
				& "^" & Variables.lang_listInvoices_title.invoiceTotal
				& "^" & Variables.lang_listInvoices_title.invoiceClosed
				& "^" & Variables.lang_listInvoices_title.invoicePaid>
		<cfset Variables.columnOrderByList = "invoiceID^companyName^lastName^invoiceTotal^invoiceClosed^invoicePaid">

		<cfset Variables.displayShipping = False>
		<cfif REFind("[0-1]", ValueList(qry_selectInvoiceList.invoiceShipped))>
			<cfset Variables.displayShipping = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listInvoices_title.invoiceShippingMethod & "^" & Variables.lang_listInvoices_title.invoiceShipped>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^invoiceShippingMethod^invoiceShipped">
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listInvoices_title.invoiceDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^invoiceDateCreated">

		<cfif ListFind(Variables.permissionActionList, "viewInvoice") or URL.action is "applyInvoicesToPayment">
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listInvoices_title.viewInvoice>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			<cfif URL.action is "applyInvoicesToPayment">
				<cfset Variables.manageURL = "#Variables.insertInvoicePaymentAction#&invoiceID">
				<cfset Variables.manageText = Variables.lang_listInvoices_title.applyInvoicesToPayment_text>
			<cfelse>
				<cfset Variables.manageURL = "index.cfm?method=invoice.viewInvoice&invoiceID">
				<cfset Variables.manageText = Variables.lang_listInvoices_title.viewInvoice_text>
			</cfif>
		</cfif>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

		<cfinclude template="../../view/v_invoice/dsp_selectInvoiceList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

