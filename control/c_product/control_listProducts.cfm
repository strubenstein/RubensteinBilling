<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductManagerList" ReturnVariable="qry_selectProductManagerList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("productID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinclude template="formParam_listProducts.cfm">

<!---
search/filter form
count total number of records
return X records
display X per page
on page X / display X-Y of Z
go to page number
display items
--->

<cfset Variables.formName = "productList">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_product/form_listProducts.cfm">

<cfinclude template="../../view/v_product/lang_listProducts.cfm">
<cfinclude template="formValidate_listProducts.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.categoryID_list = Form.categoryID>
	<cfif Form.categoryID gt 0 and Form.categoryID_sub is 1>
		<cfset Variables.beginRow = ListFind(ValueList(qry_selectCategoryList.categoryID), Form.categoryID) + 1>
		<cfif Variables.beginRow gt 1 and Variables.beginRow lte qry_selectCategoryList.RecordCount>
			<cfloop Query="qry_selectCategoryList" StartRow="#Variables.beginRow#">
				<cfif ListFind(qry_selectCategoryList.categoryID_parentList, Form.categoryID)>
					<cfset Variables.categoryID_list = ListAppend(Variables.categoryID_list, qry_selectCategoryList.categoryID)>
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfset Variables.displayProductCategoryOrder = False>
	<cfset Variables.displaySwitchProductCategoryOrder = False>
	<cfif IsDefined("URL.categoryID") and Application.fn_IsIntegerPositive(URL.categoryID) and Not ListFind("insertProductRecommend,insertProductBundle", URL.action)>
		<cfset Variables.displayProductCategoryOrder = True>
		<cfif ListFind("productCategoryOrder,productCategoryOrder_d", Form.queryOrderBy)>
			<cfset Variables.displaySwitchProductCategoryOrder = True>
		<cfelse>
			<cfset Variables.displaySwitchProductCategoryOrder = False>
		</cfif>
	</cfif>

	<cfset Variables.queryViewAction = "index.cfm?method=#URL.control#.#URL.action#&queryDisplayPerPage=#Form.queryDisplayPerPage#">
	<cfset qryParamStruct = StructNew()>

	<cfif IsDefined("URL.productID") and URL.productID is not 0>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&productID=#URL.productID#">
	</cfif>

	<cfset qryParamStruct.companyID = Session.companyID>
	<cfif Variables.categoryID_list is not "">
		<cfset qryParamStruct.categoryID_list = Variables.categoryID_list>
	</cfif>
	<cfif Form.categoryID_sub is 1>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&categoryID_sub=#Form.categoryID_sub#">
		<cfset qryParamStruct.categoryID_sub = Form.categoryID_sub>
	</cfif>
	<cfif Form.categoryID_multiple is 1>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&categoryID_multiple=#Form.categoryID_multiple#">
		<cfset qryParamStruct.categoryID_multiple = Form.categoryID_multiple>
	</cfif>
	<cfloop Index="field" List="categoryID,productID_parent">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="userID_manager,vendorID,statusID">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerNonNegative(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="productCatalogPageNumber,productPrice_min,productPrice_max,productWeight_min,productWeight_max">
		<cfif IsDefined("Form.#field#") and IsNumeric(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="searchText,searchField,productName,productID_custom,productCode,productLanguageSummary,productLanguageDescription,templateFilename">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="productStatus,productHasImage,productListedOnSite,productInBundle,productIsBundle,productIsRecommended,productHasRecommendation,productIsDateRestricted,productHasChildren,productHasCustomPrice,productHasSpec,productCanBePurchased,productInWarehouse,productPriceCallForQuote,productWeight,productHasParameter,productHasParameterException">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfswitch expression="#URL.action#">
	  <cfcase value="insertProductRecommend"><cfset qryParamStruct.productID_not = URL.productID></cfcase>
	  <cfcase value="insertProductBundle"><cfset qryParamStruct.productID_not = Variables.productID_notList></cfcase>
	  <!--- 
	  <cfcase value="insertInvoiceLineItem"><cfset qryParamStruct.invoiceID = URL.invoiceID></cfcase>
	  <cfcase value="insertSubscription"><cfset qryParamStruct.subscriberID = URL.subscriberID></cfcase>
	  --->
	  <cfcase value="insertCommissionProduct"><cfset qryParamStruct.commissionID_not = URL.commissionID></cfcase>
	  <cfcase value="listCommissionProducts"><cfset qryParamStruct.commissionID = URL.commissionID></cfcase>
	</cfswitch>
	<cfloop Index="field" List="productDateExported_from,productDateExported_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.productIsExported") and (Form.productIsExported is "" or ListFind("0,1", Form.productIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&productIsExported=#URLEncodedFormat(Form.productIsExported)#">
		<cfset qryParamStruct.productIsExported = Form.productIsExported>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportProducts")
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

	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
		</cfif>
		<cfif Variables.displayProductCategoryOrder is True>
			<cfinvokeargument Name="displayProductCategoryOrder" Value="#Variables.displayProductCategoryOrder#">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
		</cfif>
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProductIsExported" ReturnVariable="isProductExportStatusUpdated">
			<cfinvokeargument Name="productID" Value="#ValueList(qry_selectProductList.productID)#">
			<cfinvokeargument Name="productIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportProductList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_product=updateProductIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfif Not ListFind("productName,productName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList_alphabet" ReturnVariable="qry_selectProductList_alphabet" argumentCollection="#qryParamStruct#" />

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectProductList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
				<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
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

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfset Variables.includeProductChildren = False>
		<cfset Variables.formSubmitValueChildren = "">
		<cfset Variables.productsWithChildren = "">

		<cfswitch expression="#URL.action#">
		<cfcase value="insertProductRecommend">
			<!--- list products recommended by this product --->
			<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="selectProductRecommendList" ReturnVariable="qry_selectProductRecommendList_recommend">
				<cfinvokeargument Name="productID_target" Value="#Variables.productID_not#">
				<cfinvokeargument Name="productID_recommend" Value="0">
				<cfinvokeargument Name="productRecommendStatus" Value="1">
			</cfinvoke>
			<cfset Variables.productID_recommendList = ValueList(qry_selectProductRecommendList_recommend.productID_recommend)>

			<!--- list products that recommend this product --->
			<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="selectProductRecommendList" ReturnVariable="qry_selectProductRecommendList_target">
				<cfinvokeargument Name="productID_target" Value="0">
				<cfinvokeargument Name="productID_recommend" Value="#Variables.productID_not#">
				<cfinvokeargument Name="productRecommendStatus" Value="1">
			</cfinvoke>
			<cfset Variables.productID_targetList = ValueList(qry_selectProductRecommendList_target.productID_target)>

			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.productRecommends
					& "^" & Variables.lang_listProducts_title.productIsRecommended>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/v_productRecommend/form_productRecommend.cfm">
		</cfcase>

		<cfcase value="insertProductBundle">
			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.insertProductBundle>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/v_productBundle/form_productBundle.cfm">
		</cfcase>

		<cfcase value="insertInvoiceLineItem">
			<cfset Variables.insertName = "invoice">
			<cfset Variables.insertURL = "index.cfm?method=invoice.insertInvoiceLineItem&invoiceID=#URL.invoiceID#">
			<cfset Variables.formSubmitValue = Variables.lang_listProducts_title.formSubmitValue_insertInvoiceLineItem>
			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.insertInvoiceLineItem>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/dsp_selectProductList_insert.cfm">
		</cfcase>

		<cfcase value="insertSubscription">
			<cfset Variables.insertName = "subscriber">
			<cfset Variables.insertURL = "index.cfm?method=subscription.insertSubscription&subscriberID=#URL.subscriberID#">
			<cfset Variables.formSubmitValue = Variables.lang_listProducts_title.formSubmitValue_insertSubscription>

			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.insertSubscription>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/dsp_selectProductList_insert.cfm">
		</cfcase>

		<cfcase value="insertCommissionProduct">
			<cfset Variables.insertName = "commission">
			<cfset Variables.insertURL = "index.cfm?method=commission.insertCommissionProduct&commissionID=#Variables.commissionID_not#">
			<cfset Variables.formSubmitValue = Variables.lang_listProducts_title.formSubmitValue_insertCommissionProduct>
			<cfset Variables.includeProductChildren = True>
			<cfset Variables.formSubmitValueChildren = Variables.lang_listProducts_title.formSubmitValueChildren>
			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.insertCommissionProduct>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/dsp_selectProductList_insert.cfm">
		</cfcase>

		<cfcase value="listCommissionProducts">
			<cfif qry_selectProductList.RecordCount is not 0>
				<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="selectCommissionProduct" ReturnVariable="qry_selectCommissionProduct">
					<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
					<cfinvokeargument Name="commissionProductChildren" Value="1">
					<cfinvokeargument Name="commissionProductStatus" Value="1">
					<cfinvokeargument Name="productID" Value="#ValueList(qry_selectProductList.productID)#">
				</cfinvoke>

				<cfif qry_selectCommissionProduct.RecordCount is not 0>
					<cfset Variables.includeProductChildren = True>
					<cfset Variables.productsWithChildren = ValueList(qry_selectCommissionProduct.productID)>
				</cfif>
			</cfif>

			<cfset Variables.insertName = "commission">
			<cfset Variables.insertURL = "index.cfm?method=commission.updateCommissionProduct&commissionID=#URL.commissionID#">
			<cfset Variables.formSubmitValue = Variables.lang_listProducts_title.formSubmitValue_listCommissionProducts>
			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated
					& "^" & Variables.lang_listProducts_title.listCommissionProducts>
			<cfset Variables.columnOrderByList = "productID^productName^productPrice^productListedOnSite^productDateCreated^False">
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

			<cfinclude template="../../view/v_product/dsp_selectProductList_insert.cfm">
		</cfcase>

		<cfdefaultcase><!--- list --->
			<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.productID
					& "^" & Variables.lang_listProducts_title.productName
					& "^" & Variables.lang_listProducts_title.productPrice
					& "^" & Variables.lang_listProducts_title.productListedOnSite
					& "^" & Variables.lang_listProducts_title.productDateCreated>
			<cfset Variables.columnOrderByList = "productID_custom^productName^productPrice^productListedOnSite^productDateCreated">
			<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveProductCategoryDown,moveProductCategoryUp,viewProduct")>

			<cfif Not REFind("[1-9]", ValueList(qry_selectProductList.productViewCount))>
				<cfset Variables.displayProductViewCount = False>
			<cfelse>
				<cfset Variables.displayProductViewCount = True>
				<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProducts_title.productViewCount>
				<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^productViewCount">
			</cfif>

			<cfif Variables.displayProductCategoryOrder is True and ListFind(Variables.permissionActionList, "moveProductCategoryDown") and ListFind(Variables.permissionActionList, "moveProductCategoryUp")>
				<cfset Variables.columnHeaderList = Variables.lang_listProducts_title.switchProductCategoryOrder & "^" & Variables.columnHeaderList & "^" & Variables.lang_listProducts_title.productCategoryOrder>
				<cfset Variables.columnOrderByList = "productCategoryOrder^" & Variables.columnOrderByList & "^False">
				<cfset Variables.redirectURL = URLEncodedFormat(Variables.queryViewAction & "&queryOrderBy=" & Form.queryOrderBy)>
			</cfif>

			<cfif ListFind(Variables.permissionActionList, "viewProduct")>
				<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProducts_title.viewProduct>
				<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			</cfif>

			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfinclude template="../../view/v_product/dsp_selectProductList.cfm">
		</cfdefaultcase>
		</cfswitch>
	</cfif><!--- export results or display results in browser--->
</cfif>

