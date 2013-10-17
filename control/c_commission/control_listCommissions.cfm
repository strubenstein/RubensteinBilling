<!--- get regions --->
<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
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

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("commissionID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_commission/var_commissionPeriodIntervalTypeList.cfm">
<cfinclude template="../../view/v_commission/var_commissionStageIntervalTypeList.cfm">
<cfinclude template="formParam_listCommissions.cfm">

<cfset Variables.formName = "listCommissions">
<cfset Variables.formAction = "index.cfm?method=#URL.control#.listCommissions">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_commission/form_listCommissions.cfm">

<cfinclude template="../../view/v_commission/lang_listCommissions.cfm">
<cfinclude template="formValidate_listCommissions.cfm">

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

	<cfset Variables.queryViewAction = "index.cfm?method=#URL.control#.listCommissions&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfif Application.fn_IsIntegerList(Variables.categoryID_list)>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&categoryID=#Variables.categoryID_list#">
		<cfset qryParamStruct.categoryID = Variables.categoryID_list>
	</cfif>
	<cfloop Index="field" List="#Variables.fields_integerList#">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_integer#">
		<cfif IsDefined("Form.#field#") and Application.fn_IsInteger(Form[field])>
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

	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionList" ReturnVariable="qry_selectCommissionList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="returnCompanyFields" Value="True">
	</cfinvoke>

	<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
	<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
	<cfset Variables.totalRecords = qryTotalRecords>
	<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
	<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
		<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
	<cfelse>
		<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
	</cfif>

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCommission,updateCommission,updateCommissionStatus,viewProduct")>

	<cfset Variables.columnHeaderList = "">

	<cfset Variables.displayCommissionID_custom = False>
	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectCommissionList.commissionID_custom))>
		<cfset Variables.displayCommissionID_custom = True>
		<cfset Variables.columnHeaderList = Variables.lang_listCommissions_title.commissionID_custom & "^">
	</cfif>

	<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listCommissions_title.commissionID_custom
			& "^" & Variables.lang_listCommissions_title.commissionName
			& "^" & Variables.lang_listCommissions_title.commissionPeriodIntervalType
			& "^" & Variables.lang_listCommissions_title.commissionDateBegin
			& "^" & Variables.lang_listCommissions_title.commissionDateEnd
			& "^" & Variables.lang_listCommissions_title.commissionStatus
			& "^" & Variables.lang_listCommissions_title.commissionAppliedStatus
			& "^" & Variables.lang_listCommissions_title.commissionDateCreated
			& "^" & Variables.lang_listCommissions_title.commissionDateUpdated
			& "^" & Variables.lang_listCommissions_title.viewCommission>
	<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

	<cfif qry_selectCommissionList.RecordCount is not 0>
		<cfif Not REFindNoCase("[1|true]", ValueList(qry_selectCommissionList.commissionStageVolumeDiscount))>
			<cfset Variables.isVolumeDiscount = False>
		<cfelse>
			<cfset Variables.isVolumeDiscount = True>
			<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionVolumeDiscount" ReturnVariable="qry_selectCommissionVolumeDiscount">
				<cfinvokeargument Name="commissionStageID" Value="#ValueList(qry_selectCommissionList.commissionStageID)#">
			</cfinvoke>
		</cfif>
	</cfif>

	<cfif ListFind("product,category", URL.control)>
		<cfset Variables.commissionControl = URL.control>
	<cfelse>
		<cfset Variables.commissionControl = "commission">
	</cfif>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfinclude template="../../include/function/fn_DisplayPrice.cfm">

	<cfinclude template="../../view/v_commission/var_commissionStageIntervalTypeList.cfm">
	<cfinclude template="../../view/v_commission/dsp_selectCommissionList.cfm">
</cfif>

