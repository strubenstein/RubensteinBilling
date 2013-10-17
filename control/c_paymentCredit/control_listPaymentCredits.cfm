<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_listPaymentCredits.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="paymentCategoryType" Value="credit">
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

<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="selectPaymentCreditAuthorList" ReturnVariable="qry_selectPaymentCreditAuthorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
</cfinvoke>

<cfset Variables.formName = "listPaymentCredits">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_paymentCredit/form_listPaymentCredits.cfm">

<cfinclude template="../../view/v_paymentCredit/lang_listPaymentCredits.cfm">
<cfinclude template="formValidate_listPaymentCredits.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#" & Variables.urlParameters>
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
	<cfif IsDefined("Form.paymentCreditID") and Form.paymentCreditID is not 0 and Application.fn_IsIntegerList(Form.paymentCreditID)>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&paymentCreditID=#Form.paymentCreditID#">
		<cfset qryParamStruct.paymentCreditID = Form.paymentCreditID>
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
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.paymentCreditIsExported") and (Form.paymentCreditIsExported is "" or ListFind("0,1", Form.paymentCreditIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&paymentCreditIsExported=#URLEncodedFormat(Form.paymentCreditIsExported)#">
		<cfset qryParamStruct.paymentCreditIsExported = Form.paymentCreditIsExported>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults")
			and Application.fn_IsUserAuthorized("exportPaymentCredits")
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

	<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="selectPaymentCreditList" ReturnVariable="qry_selectPaymentCreditList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="updatePaymentCreditIsExported" ReturnVariable="isPaymentCreditExportStatusUpdated">
			<cfinvokeargument Name="paymentCreditID" Value="#ValueList(qry_selectPaymentCreditList.paymentCreditID)#">
			<cfinvokeargument Name="paymentCreditIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportPaymentCreditList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_paymentCredit=updatePaymentCreditIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="selectPaymentCreditCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewPaymentCredit,updatePaymentCredit,viewUser,viewCompany,viewInvoice,viewPayment,applyPaymentCreditsToInvoice")>

		<cfset Variables.columnHeaderList = "">
		<cfset Variables.columnOrderByList = "">

		<cfif Not REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPaymentCreditList.paymentCreditID_custom))>
			<cfset Variables.displayPaymentCreditID_custom = False>
		<cfelse>
			<cfset Variables.displayPaymentCreditID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listPaymentCredits_title.paymentCreditID_custom & "^">
			<cfset Variables.columnOrderByList = "paymentCreditID_custom^">
		</cfif>

		<cfif Not REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPaymentCreditList.paymentCreditName))>
			<cfset Variables.displayPaymentCreditName = False>
		<cfelse>
			<cfset Variables.displayPaymentCreditName = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listPaymentCredits_title.paymentCreditName & "^">
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "paymentCreditName^">
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listPaymentCredits_title.targetCompanyName
				& "^" &  Variables.lang_listPaymentCredits_title.paymentCreditAmount
				& "^" &  Variables.lang_listPaymentCredits_title.paymentCreditAppliedMaximum
				& "^" &  Variables.lang_listPaymentCredits_title.paymentCreditDateBegin
				& "^" &  Variables.lang_listPaymentCredits_title.paymentCreditDateBegin
				& "^" &  Variables.lang_listPaymentCredits_title.paymentDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "targetCompanyName^paymentCreditAmount^paymentCreditAppliedMaximum^paymentCreditDateBegin^paymentCreditDateBegin^paymentDateCreated">

		<cfif ListFind(Variables.permissionActionList, "updatePaymentCredit") or ListFind(Variables.permissionActionList, "viewPaymentCredit") or Variables.doAction is "applyPaymentCreditsToInvoice">
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPaymentCredits_title.viewPaymentCredit>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">

			<cfif Variables.doAction is "applyPaymentCreditsToInvoice">
				<cfset Variables.manageURL = "#Variables.insertInvoicePaymentCreditAction#&paymentCreditID_list">
				<cfset Variables.manageText = Variables.lang_listPaymentCredits_title.applyPaymentCreditsToInvoice>
			<cfelse>
				<cfset Variables.manageURL = "index.cfm?method=#URL.control#.viewPaymentCredit#Variables.urlParameters#&paymentCreditID">
				<cfset Variables.manageText = Variables.lang_listPaymentCredits_title.listPaymentCredits>
			</cfif>
		</cfif>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">
		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../view/v_paymentCredit/dsp_selectPaymentCreditList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

