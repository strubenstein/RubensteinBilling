<!--- get regions --->
<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
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
<cfinclude template="../../view/v_price/var_priceStageIntervalTypeList.cfm">
<cfinclude template="formParam_listPrices.cfm">

<cfset Variables.formName = "listPrices">
<cfset Variables.formAction = "index.cfm?method=#URL.control#.listPrices">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_price/form_listPrices.cfm">

<cfinclude template="../../view/v_price/lang_listPrices.cfm">
<cfinclude template="formValidate_listPrices.cfm">

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

	<cfset Variables.queryViewAction = "index.cfm?method=#URL.control#.listPrices&queryDisplayPerPage=#Form.queryDisplayPerPage#">
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

	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPriceList" ReturnVariable="qry_selectPriceList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPriceCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
	<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
	<cfset Variables.totalRecords = qryTotalRecords>
	<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
	<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
		<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
	<cfelse>
		<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
	</cfif>

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewPrice,updatePrice,updatePriceStatus,viewProduct")>

	<cfif URL.categoryID is not 0>
		<cfset Variables.normalPrice = "0">
	<cfelseif URL.productID is not 0>
		<cfset Variables.normalPrice = qry_selectProduct.productPrice>
	<cfelse>
		<cfset Variables.normalPrice = "0">
	</cfif>

	<cfset Variables.priceColumnList = "">

	<cfset Variables.displayPriceCode = False>
	<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPriceList.priceCode))>
		<cfset Variables.displayPriceCode = True>
		<cfset Variables.priceColumnList = Variables.lang_listPrices_title.priceCode & "^">
	</cfif>

	<cfset Variables.priceColumnList = Variables.priceColumnList & Variables.lang_listPrices_title.priceName
			& "^" &  Variables.lang_listPrices_title.priceAmount
			& "^" &  Variables.lang_listPrices_title.priceDateBegin
			& "^" &  Variables.lang_listPrices_title.priceDateEnd
			& "^" &  Variables.lang_listPrices_title.priceStatus
			& "^" &  Variables.lang_listPrices_title.priceAppliedStatus
			& "^" &  Variables.lang_listPrices_title.priceDateCreated
			& "^" &  Variables.lang_listPrices_title.priceDateUpdated
			& "^" &  Variables.lang_listPrices_title.viewPrice>
	<cfset Variables.priceColumnCount = DecrementValue(2 * ListLen(priceColumnList, "^"))>

	<cfif qry_selectPriceList.RecordCount is not 0>
		<cfif Not REFindNoCase("[1|true]", ValueList(qry_selectPriceList.priceStageVolumeDiscount))>
			<cfset Variables.isVolumeDiscount = False>
		<cfelse>
			<cfset Variables.isVolumeDiscount = True>
			<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
				<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPriceList.priceStageID)#">
			</cfinvoke>
		</cfif>
	</cfif>

	<cfif ListFind("product,category", URL.control)>
		<cfset Variables.priceControl = URL.control>
	<cfelse>
		<cfset Variables.priceControl = "price">
	</cfif>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
	<cfinclude template="../../view/v_price/dsp_selectPriceList.cfm">
</cfif>

