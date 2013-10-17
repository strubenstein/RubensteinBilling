<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="formParam_listPayments.cfm">
<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="paymentCategoryType" Value="payment,refund">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="merchantAccountStatus" Value="1">
	<cfinvokeargument Name="returnMerchantFields" Value="True">
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

<cfset Variables.formName = "listPayments">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_payment/form_listPayments.cfm">

<cfinclude template="../../view/v_payment/lang_listPayments.cfm">
<cfinclude template="formValidate_listPayments.cfm">

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
	<cfif IsDefined("Form.paymentID") and Form.paymentID is not 0 and Application.fn_IsIntegerList(Form.paymentID)>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&paymentID=#Form.paymentID#">
		<cfset qryParamStruct.paymentID = Form.paymentID>
	</cfif>
	<cfloop Index="field" List="paymentApproved,paymentIsExported">
		<cfif IsDefined("Form.#field#") and (Form[field] is "" or ListFind("0,1", Form[field]))>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
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
			<cfif field is not "paymentID_not">
				<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			</cfif>
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

	<cfif IsDefined("Form.showGraphicsResults") and Form.showGraphicsResults is True>
		<cfinclude template="act_graphPaymentList.cfm">
		<cfinclude template="../../view/v_payment/dsp_graphPaymentList.cfm">
		<cfinclude template="../../view/v_adminMain/footer_admin.cfm">
		<cfabort>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults")
			and ((Variables.doAction is "listPayments" and Application.fn_IsUserAuthorized("exportPayments"))
				 or (Variables.doAction is "listPaymentRefunds" and Application.fn_IsUserAuthorized("exportPaymentRefunds")))
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

	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentList" ReturnVariable="qry_selectPaymentList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePaymentIsExported" ReturnVariable="isPaymentExportStatusUpdated">
			<cfinvokeargument Name="paymentID" Value="#ValueList(qry_selectPaymentList.paymentID)#">
			<cfinvokeargument Name="paymentIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportPaymentList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_payment=updatePaymentIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewPayment,updatePayment,viewUser,viewCompany,viewInvoice,applyPaymentsToInvoice")>

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPaymentList.paymentID_custom))>
			<cfset Variables.displayPaymentID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listPayments_title.paymentID_custom & "^">
			<cfset Variables.columnOrderByList = "paymentID_custom^">
		<cfelse>
			<cfset Variables.displayPaymentID_custom = False>
			<cfset Variables.columnHeaderList = "">
			<cfset Variables.columnOrderByList = "">
		</cfif>

		<cfif Variables.doAction is "listPayments">
			<cfset Variables.dateReceivedHeader = Variables.lang_listPayments_title.paymentDateReceived>
		<cfelse><!--- listPaymentRefunds --->
			<cfset Variables.dateReceivedHeader = Variables.lang_listPayments_title.refundDateReceived>
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listPayments_title.targetCompanyName
			& "^" & Variables.lang_listPayments_title.targetLastName
			& "^" & Variables.lang_listPayments_title.paymentApproved
			& "^" & Variables.paymentOrRefundTextUcase & Variables.lang_listPayments_title.paymentAmount
			& "^" & Variables.lang_listPayments_title.paymentDetails
			& "^" & Variables.dateReceivedHeader
			& "^" & Variables.lang_listPayments_title.paymentDateScheduled>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "targetCompanyName^targetLastName^paymentApproved^paymentAmount^False^paymentDateReceived^paymentDateScheduled">

		<cfif ListFind(Variables.permissionActionList, "updatePayment") or ListFind(Variables.permissionActionList, "viewPayment") or Variables.doAction is "applyPaymentsToInvoice">
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayments_title.viewPayment>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">

			<cfswitch expression="#Variables.doAction#">
			<cfcase value="applyPaymentsToInvoice">
				<cfset Variables.manageURL = "#Variables.insertInvoicePaymentAction#&paymentID_list">
				<cfset Variables.manageText = Variables.lang_listPayments_title.applyPaymentsToInvoice>
			</cfcase>
			<cfcase value="listPaymentRefunds">
				<cfset Variables.manageURL = "index.cfm?method=#URL.control#.viewPaymentRefund#Variables.urlParameters#&paymentID">
				<cfset Variables.manageText = Variables.lang_listPayments_title.listPaymentRefunds>
			</cfcase>
			<cfdefaultcase><!--- listPayments --->
				<cfset Variables.manageURL = "index.cfm?method=#URL.control#.viewPayment#Variables.urlParameters#&paymentID">
				<cfset Variables.manageText = Variables.lang_listPayments_title.listPayments>
			</cfdefaultcase>
			</cfswitch>
		</cfif>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">
		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../view/v_payment/dsp_selectPaymentList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

