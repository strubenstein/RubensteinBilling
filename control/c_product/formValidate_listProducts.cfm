<cfset errorMessage_fields = StructNew()>

<cfif Form.categoryID is not "" and Form.categoryID is not 0 and Not ListFind(ValueList(qry_selectCategoryList.categoryID), Form.categoryID)>
	<cfset errorMessage_fields.categoryID = Variables.lang_listProducts.categoryID>
</cfif>

<cfif Form.categoryID_sub is not "" and Form.categoryID_sub is not 1>
	<cfset errorMessage_fields.productStatus = Variables.lang_listProducts.productStatus>
</cfif>

<cfif Form.categoryID_multiple is not "" and Form.categoryID_multiple is not 1>
	<cfset errorMessage_fields.categoryID_multiple = Variables.lang_listProducts.categoryID_multiple>
</cfif>

<cfif Form.vendorID is not "" and Form.vendorID is not 0 and Not ListFind(ValueList(qry_selectVendorList.vendorID), Form.vendorID)>
	<cfset errorMessage_fields.vendorID = Variables.lang_listProducts.vendorID>
</cfif>

<cfif Form.statusID is not "" and Form.statusID is not 0 and Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
	<cfset errorMessage_fields.statusID = Variables.lang_listProducts.statusID>
</cfif>

<cfif Form.userID_manager is not "" and Form.userID_manager is not 0 and Not ListFind(ValueList(qry_selectProductManagerList.userID_manager), Form.userID_manager)>
	<cfset errorMessage_fields.userID_manager = Variables.lang_listProducts.userID_manager>
</cfif>

<cfif Trim(Form.searchText) is not "" and Not ListFind(Form.searchField, "productName") and Not ListFind(Form.searchField, "productCode") and Not ListFind(Form.searchField, "productDescription")>
	<cfset errorMessage_fields.searchField = Variables.lang_listProducts.searchField>
</cfif>

<cfloop Index="field" List="productStatus,productListedOnSite,productHasImage,productIsBundle,productInWarehouse,productInBundle,productIsRecommended,productHasRecommendation,productHasCustomPrice,productIsDateRestricted,productHasChildren,productHasSpec,productCanBePurchased,productPriceCallForQuote,productWeight,productHasParameter,productHasParameterException">
	<cfif Trim(Form[field]) is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listProducts[field]>
	</cfif>
</cfloop>

<!--- 
<cfif Form.productStatus is not "" and Not ListFind("0,1", Form.productStatus)>
	<cfset errorMessage_fields.productStatus = Variables.lang_listProducts.productStatus>
</cfif>

<cfif Form.productListedOnSite is not "" and Not ListFind("0,1", Form.productListedOnSite)>
	<cfset errorMessage_fields.productListedOnSite = Variables.lang_listProducts.productListedOnSite>
</cfif>

<cfif Form.productHasImage is not "" and Not ListFind("0,1", Form.productHasImage)>
	<cfset errorMessage_fields.productHasImage = Variables.lang_listProducts.productHasImage>
</cfif>

<cfif Form.productIsBundle is not "" and Not ListFind("0,1", Form.productIsBundle)>
	<cfset errorMessage_fields.productIsBundle = Variables.lang_listProducts.productIsBundle>
</cfif>

<cfif Form.productInBundle is not "" and Not ListFind("0,1", Form.productInBundle)>
	<cfset errorMessage_fields.productInBundle = Variables.lang_listProducts.productInBundle>
</cfif>

<cfif Form.productIsRecommended is not "" and Not ListFind("0,1", Form.productIsRecommended)>
	<cfset errorMessage_fields.productIsRecommended = Variables.lang_listProducts.productIsRecommended>
</cfif>

<cfif Form.productHasRecommendation is not "" and Not ListFind("0,1", Form.productHasRecommendation)>
	<cfset errorMessage_fields.productHasRecommendation = Variables.lang_listProducts.productHasRecommendation>
</cfif>

<cfif Form.productHasCustomPrice is not "" and Not ListFind("0,1", Form.productHasCustomPrice)>
	<cfset errorMessage_fields.productHasCustomPrice = Variables.lang_listProducts.productHasCustomPrice>
</cfif>

<cfif Form.productIsDateRestricted is not "" and Not ListFind("0,1", Form.productIsDateRestricted)>
	<cfset errorMessage_fields.productIsDateRestricted = Variables.lang_listProducts.productIsDateRestricted>
</cfif>

<cfif Form.productHasChildren is not "" and Not ListFind("0,1", Form.productHasChildren)>
	<cfset errorMessage_fields.productHasChildren = Variables.lang_listProducts.productHasChildren>
</cfif>

<cfif Form.productHasSpec is not "" and Not ListFind("0,1", Form.productHasSpec)>
	<cfset errorMessage_fields.productHasSpec = Variables.lang_listProducts.productHasSpec>
</cfif>

<cfif Form.productCanBePurchased is not "" and Not ListFind("0,1", Form.productCanBePurchased)>
	<cfset errorMessage_fields.productCanBePurchased = Variables.lang_listProducts.productCanBePurchased>
</cfif>

<cfif Form.productPriceCallForQuote is not "" and Not ListFind("0,1", Form.productPriceCallForQuote)>
	<cfset errorMessage_fields.productPriceCallForQuote = Variables.lang_listProducts.productPriceCallForQuote>
</cfif>

<cfif Form.productWeight is not "" and Not ListFind("0,1", Form.productWeight)>
	<cfset errorMessage_fields.productWeight = Variables.lang_listProducts.productWeight>
</cfif>
--->

<cfif Form.productID_parent is not "" and Not ListFind("0,-1", Form.productID_parent)>
	<cfset errorMessage_fields.productID_parent = Variables.lang_listProducts.productID_parent>
</cfif>

<cfif Form.productPrice_min is not "" and Not IsNumeric(Form.productPrice_min)>
	<cfset errorMessage_fields.productPrice_min = Variables.lang_listProducts.productPrice_min>
</cfif>

<cfif Form.productPrice_max is not "" and Not IsNumeric(Form.productPrice_max)>
	<cfset errorMessage_fields.productPrice_max = Variables.lang_listProducts.productPrice_max>
</cfif>

<cfif Form.productPrice_min is not "" and Form.productPrice_max is not "" and StructIsEmpty(errorMessage_fields)
		and Form.productPrice_min gt Form.productPrice_max>
	<cfset errorMessage_fields.productPrice_minMax = Variables.lang_listProducts.productPrice_minMax>
</cfif>

<!--- valid catalog page numbers: 0 | a | a-b | a,b,c ---> 
<cfif Form.productCatalogPageNumber is not "">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.productCatalogPageNumber)>
		<cfif ListLen(Form.productCatalogPageNumber, "-" is 2)
				and Application.fn_IsIntegerPositive(ListFirst(Form.productCatalogPageNumber, "-")) and Application.fn_IsIntegerPositive(ListLast(Form.productCatalogPageNumber, "-"))
				and ListLast(Form.productCatalogPageNumber, "-") gt ListFirst(Form.productCatalogPageNumber, "-")>
			<cfset Variables.isOk = True>
		<cfelseif ListLen(Form.productCatalogPageNumber, ",") gt 1 and Application.fn_IsIntegerList(Form.productCatalogPageNumber)>
			<cfset Variables.isOk = True>
		<cfelse>
			<cfset errorMessage_fields.productCatalogPageNumber = Variables.lang_listProducts.productCatalogPageNumber>
		</cfif>
	</cfif>
</cfif>

<cfif Form.productWeight_min is not "" and Not IsNumeric(Form.productWeight_min)>
	<cfset errorMessage_fields.productWeight_min = Variables.lang_listProducts.productWeight_min>
</cfif>

<cfif Form.productWeight_max is not "" and Not IsNumeric(Form.productWeight_max)>
	<cfset errorMessage_fields.productWeight_max = Variables.lang_listProducts.productWeight_max>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listProducts.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listProducts.queryPage>
</cfif>

<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
	<cfif Len(Form.queryFirstLetter) gt 1 and Form.queryFirstLetter is not "0-9">
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listProducts.queryFirstLetter>
	<cfelseif Not REFindNoCase("[A-Za-z]", Form.queryFirstLetter)>
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listProducts.queryFirstLetter>
	</cfif>
</cfif>

<cfif Form.productIsExported is not "" and Not ListFind("-1,0,1", Form.productIsExported)>
	<cfset errorMessage_fields.productIsExported = Variables.lang_listProducts.productIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listProducts.errorTitle>
	<cfset errorMessage_header = Variables.lang_listProducts.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listProducts.errorFooter>
</cfif>

