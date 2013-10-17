<cfparam Name="URL.displaySalesCommissionSpecial" Default="">
<cfif URL.displaySalesCommissionSpecial is not "">
	<cfset Form.salesCommissionFinalized = 1>
	<cfset Form.salesCommissionDateType = "salesCommissionDateFinalized">
	<cfset Form.salesCommissionDateFrom_hh = 12>
	<cfset Form.salesCommissionDateFrom_mm = 0>
	<cfset Form.salesCommissionDateFrom_tt = "am">
	<cfset Form.salesCommissionDateTo_hh = 12>
	<cfset Form.salesCommissionDateTo_mm = 0>
	<cfset Form.salesCommissionDateTo_tt = "am">

	<cfswitch expression="#URL.displaySalesCommissionSpecial#">
	<cfcase value="yesterday">
		<cfset Form.salesCommissionDateFrom_date = DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")>
		<cfset Form.salesCommissionDateTo_date = DateFormat(Now(), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="today">
		<cfset Form.salesCommissionDateFrom_date = DateFormat(Now(), "mm/dd/yyyy")>
		<cfset Form.salesCommissionDateTo_date = DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="thisWeek">
		<cfset Variables.thisWeekSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(Now())), Now())>
		<cfset Form.salesCommissionDateFrom_date = DateFormat(Variables.thisWeekSunday, "mm/dd/yyyy")>
		<cfset Form.salesCommissionDateTo_date = DateFormat(DateAdd("d", 7, Variables.thisWeekSunday), "mm/dd/yyyy")>
	</cfcase>
	<cfcase value="thisMonth">
		<cfset Form.salesCommissionDateFrom_date = DateFormat(CreateDate(Year(Now()), Month(Now()), 1), "mm/dd/yyyy")>
		<cfset Form.salesCommissionDateTo_date = DateFormat(DateAdd("d", 1, CreateDate(Year(Now()), Month(Now()), DaysInMonth(Now()))), "mm/dd/yyyy")>
	</cfcase>
	</cfswitch>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("salesCommissionID")#">
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
<cfinclude template="formParam_listSalesCommissions.cfm">

<cfset Variables.formName = "listSalesCommissions">
<cfset Variables.formAction = CGI.Script_Name & "?" & CGI.Query_String>
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_salesCommission/form_listSalesCommissions.cfm">

<cfinclude template="../../view/v_salesCommission/lang_listSalesCommissions.cfm">
<cfinclude template="formValidate_listSalesCommissions.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfif IsDefined("Form.salesCommissionPaid") and (Form.salesCommissionPaid is "" or ListFind("0,1", Form.salesCommissionPaid))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&salesCommissionPaid=#Form.salesCommissionPaid#">
		<cfset qryParamStruct.salesCommissionPaid = Form.salesCommissionPaid>
	</cfif>
	<cfloop Index="field" List="#Variables.fields_integerList#">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field]) and Form[field] is not 0>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_numeric#">
		<cfif IsDefined("Form.#field#") and IsNumeric(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_text#">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
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
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.salesCommissionIsExported") and (Form.salesCommissionIsExported is "" or ListFind("0,1", Form.salesCommissionIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&salesCommissionIsExported=#URLEncodedFormat(Form.salesCommissionIsExported)#">
		<cfset qryParamStruct.salesCommissionIsExported = Form.salesCommissionIsExported>
	</cfif>

	<cfif ListFind("targetName,targetName_d", Form.queryOrderBy)>
		<cfset Form.returnTargetName = True>
	</cfif>

	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="targetName,targetName_d"><cfset Variables.queryFirstLetter_field = "targetName"></cfcase>
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"></cfcase>
		<cfcase value="commissionName,commissionName_d"><cfset Variables.queryFirstLetter_field = "avCommission.commissionName"></cfcase>
		<cfcase value="commissionID_custom,commissionID_custom_d"><cfset Variables.queryFirstLetter_field = "avCommission.commissionID_custom"></cfcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportSalesCommissions")
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

	<!--- Determine whether updating all sales commissions as paid --->
	<cfif (Not IsDefined("Form.returnSalesCommissionSum") or Form.returnSalesCommissionSum is False)
			and Application.fn_IsUserAuthorized("updateSalesCommission")
			and IsDefined("Form.updateSalesCommissionPaidViaList") and Form.updateSalesCommissionPaidViaList is True>
		<cfset Form.queryDisplayPerPage_temp = Form.queryDisplayPerPage>
		<cfset Form.queryDisplayPerPage = 0>
	<cfelse>
		<cfset Form.updateSalesCommissionPaidViaList = False>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionList" ReturnVariable="qry_selectSalesCommissionList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
			<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
		</cfif>
		<cfif IsDefined("Form.returnTargetName") and Form.returnTargetName is True>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&returnTargetName=True">
			<cfinvokeargument Name="returnTargetName" Value="True">
		</cfif>
		<cfif IsDefined("Form.returnSalesCommissionSum") and Form.returnSalesCommissionSum is True>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&returnSalesCommissionSum=True">
			<cfinvokeargument Name="returnSalesCommissionSum" Value="True">
		</cfif>
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="updateSalesCommissionIsExported" ReturnVariable="isSalesCommissionExportStatusUpdated">
			<cfinvokeargument Name="salesCommissionID" Value="#ValueList(qry_selectSalesCommissionList.salesCommissionID)#">
			<cfinvokeargument Name="salesCommissionIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfif IsDefined("Form.returnSalesCommissionSum") and Form.returnSalesCommissionSum is True>
			<cfset Variables.tempArray = ArrayNew(1)>
			<cfset temp = ArraySet(Variables.tempArray, 1, qry_selectSalesCommissionList.RecordCount, 0)>
			<cfloop Index="field" List="salesCommissionID,commissionID,userID_author,salesCommissionBasisTotal,salesCommissionBasisQuantity,commissionStageID,commissionVolumeDiscountID,salesCommissionCalculatedAmount,commissionStatus,commissionPeriodOrInvoiceBased,commissionHasMultipleStages">
				<cfset temp = QueryAddColumn(qry_selectSalesCommissionList, field, Variables.tempArray)>
			</cfloop>

			<cfset temp = ArrayClear(Variables.tempArray)>
			<cfset temp = ArraySet(Variables.tempArray, 1, qry_selectSalesCommissionList.RecordCount, "")>
			<cfloop Index="field" List="firstName,lastName,userID_custom,commissionName,commissionID_custom,commissionDescription,salesCommissionDateFinalized,salesCommissionDatePaid,salesCommissionDateCreated,salesCommissionDateUpdated,commissionDateCreated,commissionDateUpdated,salesCommissionDateBegin,salesCommissionDateEnd">
				<cfset temp = QueryAddColumn(qry_selectSalesCommissionList, field, Variables.tempArray)>
			</cfloop>

			<cfloop Index="field" List="salesCommissionFinalized,salesCommissionPaid,salesCommissionStatus,salesCommissionManual">
				<cfset temp = ArrayClear(Variables.tempArray)>
				<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
					<cfset temp = ArraySet(Variables.tempArray, 1, qry_selectSalesCommissionList.RecordCount, Form[field])>
				<cfelse>
					<cfset temp = ArraySet(Variables.tempArray, 1, qry_selectSalesCommissionList.RecordCount, 0)>
				</cfif>
				<cfset temp = QueryAddColumn(qry_selectSalesCommissionList, field, Variables.tempArray)>
			</cfloop>
		</cfif>

		<cfinclude template="act_exportSalesCommissionList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_salesCommission=updateSalesCommissionIsExported" AddToken="No">

	<!--- update all results as paid --->
	<cfelseif Form.updateSalesCommissionPaidViaList is True>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="updateSalesCommission" ReturnVariable="isSalesCommissionUpdated">
			<cfinvokeargument Name="salesCommissionID" Value="#ValueList(qry_selectSalesCommissionList.salesCommissionID)#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="salesCommissionPaid" Value="1">
			<cfinvokeargument Name="salesCommissionDatePaid" Value="#Now()#">
		</cfinvoke>

		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_salesCommission=updateSalesCommissionPaidViaList" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<!--- targetName,targetName_d, --->
		<cfif Not ListFind("lastName,lastName_d,commissionName,commissionName_d,commissionID_custom,commissionID_custom_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfswitch expression="#Form.queryOrderBy#">
			<cfcase value="commissionName,commissionName_d"><cfset Variables.alphabetField = "avCommission.commissionName"></cfcase>
			<cfcase value="commissionID_custom,commissionID_custom_d"><cfset Variables.alphabetField = "avCommission.commissionID_custom"></cfcase>
			<cfcase value="lastName,lastName_d"><cfset Variables.alphabetField = "avUser.lastName"></cfcase>
			<cfdefaultcase><!--- targetName,targetName_d ---><cfset Variables.alphabetField = "targetName"></cfdefaultcase>
			</cfswitch>

			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionList_alphabet" ReturnVariable="qry_selectSalesCommissionList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectSalesCommissionList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "" and Variables.queryFirstLetter_field is not "">
				<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionList_alphabetPage" ReturnVariable="salesCommissionCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
					<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
					<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
				</cfinvoke>

				<cfset Form.queryPage = 1 + (userCountBeforeAlphabet \ Form.queryDisplayPerPage)>
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

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewAffiliate,viewCobrand,viewVendor,viewUser,viewCompany,viewInvoice,viewCommission,viewSalesCommission,updateSalesCommission")>

		<cfif Form.returnTargetName is True>
			<cfset Variables.columnHeaderList = Variables.lang_listSalesCommissions_title.primaryTargetID & "^" & Variables.lang_listSalesCommissions_title.targetName & "^">
			<cfset Variables.columnOrderByList = "primaryTargetID^targetName^">
		<cfelse>
			<cfset Variables.columnHeaderList = "">
			<cfset Variables.columnOrderByList = "">
		</cfif>

		<cfif IsDefined("Form.returnSalesCommissionSum") and Form.returnSalesCommissionSum is True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listSalesCommissions_title.salesCommissionAmountSum>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "salesCommissionAmount">
		<cfelse>
			<cfset Form.returnSalesCommissionSum = False>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listSalesCommissions_title.salesCommissionAmount
					& "^" & Variables.lang_listSalesCommissions_title.commissionName
					& "^" & Variables.lang_listSalesCommissions_title.salesCommissionDateFinalized
					& "^" & Variables.lang_listSalesCommissions_title.salesCommissionDatePaid
					& "^" & Variables.lang_listSalesCommissions_title.salesCommissionDateCreated>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "salesCommissionAmount^commissionName^salesCommissionDateFinalized^salesCommissionDatePaid^salesCommissionDateCreated">

			<cfif ListFind(Variables.permissionActionList, "viewSalesCommission")>
				<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listSalesCommissions_title.viewSalesCommission>
				<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			</cfif>
		</cfif>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../view/v_salesCommission/dsp_selectSalesCommissionList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

