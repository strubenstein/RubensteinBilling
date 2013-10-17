<cfcomponent DisplayName="WSProduct" Hint="Manages all product web services">

<cffunction Name="insertProduct" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new product. Returns productID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="userID_manager" Type="numeric">
	<cfargument Name="userID_manager_custom" Type="string">
	<cfargument Name="vendorID" Type="numeric">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="productCode" Type="string">
	<cfargument Name="productName" Type="string">
	<cfargument Name="productPrice" Type="numeric">
	<cfargument Name="productPriceCallForQuote" Type="boolean">
	<cfargument Name="productIsBundle" Type="boolean">
	<cfargument Name="productID_parent" Type="numeric">
	<cfargument Name="productID_parent_custom" Type="string">
	<cfargument Name="productChildType" Type="numeric">
	<cfargument Name="productChildSeparate" Type="boolean">
	<cfargument Name="productDisplayChildren" Type="boolean">
	<cfargument Name="productStatus" Type="boolean">
	<cfargument Name="productWeight" Type="numeric">
	<cfargument Name="productCatalogPageNumber" Type="numeric">
	<cfargument Name="productListedOnSite" Type="boolean">
	<cfargument Name="productCanBePurchased" Type="boolean">
	<cfargument Name="productInWarehouse" Type="boolean">
	<cfargument Name="productLanguageName" Type="string">
	<cfargument Name="productLanguageLineItemName" Type="string">
	<cfargument Name="productLanguageLineItemDescription" Type="string">
	<cfargument Name="productLanguageLineItemDescriptionHtml" Type="boolean">
	<cfargument Name="productLanguageSummaryHtml" Type="boolean">
	<cfargument Name="productLanguageSummary" Type="string">
	<cfargument Name="productLanguageDescription" Type="string">
	<cfargument Name="productLanguageDescriptionHtml" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID_manager")>
	<cfset var qry_selectVendorList = QueryNew("vendorID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_product/ws_insertProduct.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateProduct" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing product. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="productID" Type="numeric">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="userID_manager" Type="numeric">
	<cfargument Name="userID_manager_custom" Type="string">
	<cfargument Name="vendorID" Type="numeric">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="productCode" Type="string">
	<cfargument Name="productName" Type="string">
	<cfargument Name="productPrice" Type="numeric">
	<cfargument Name="productPriceCallForQuote" Type="boolean">
	<cfargument Name="productWeight" Type="numeric">
	<cfargument Name="productCatalogPageNumber" Type="numeric">
	<cfargument Name="productID_parent" Type="numeric">
	<cfargument Name="productID_parent_custom" Type="string">
	<cfargument Name="productChildType" Type="numeric">
	<cfargument Name="productChildSeparate" Type="boolean">
	<cfargument Name="productDisplayChildren" Type="boolean">
	<cfargument Name="productStatus" Type="boolean">
	<cfargument Name="productListedOnSite" Type="boolean">
	<cfargument Name="productCanBePurchased" Type="boolean">
	<cfargument Name="productInWarehouse" Type="boolean">
	<cfargument Name="productLanguageName" Type="string">
	<cfargument Name="productLanguageLineItemName" Type="string">
	<cfargument Name="productLanguageLineItemDescription" Type="string">
	<cfargument Name="productLanguageLineItemDescriptionHtml" Type="boolean">
	<cfargument Name="productLanguageSummaryHtml" Type="boolean">
	<cfargument Name="productLanguageSummary" Type="string">
	<cfargument Name="productLanguageDescription" Type="string">
	<cfargument Name="productLanguageDescriptionHtml" Type="boolean">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID_manager")>
	<cfset var qry_selectVendorList = QueryNew("vendorID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var primaryTargetKey = "">
	<cfset var targetID = 0>
	<cfset var fieldArchiveArray = ArrayNew(1)>

	<cfinclude template="ws_product/ws_updateProduct.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectProduct" Access="remote" Output="No" ReturnType="query" Hint="Selects one or more existing products. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_product/ws_selectProduct.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectProductList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns number of products that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="categoryID" Type="string">
	<cfargument Name="categoryCode" Type="string">
	<cfargument Name="categoryID_sub" Type="boolean">
	<cfargument Name="categoryID_multiple" Type="boolean">
	<cfargument Name="userID_manager" Type="numeric">
	<cfargument Name="userID_manager_custom" Type="string">
	<cfargument Name="vendorID" Type="numeric">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="productStatus" Type="boolean">
	<cfargument Name="productHasImage" Type="boolean">
	<cfargument Name="productListedOnSite" Type="boolean">
	<cfargument Name="productHasSpec" Type="boolean">
	<cfargument Name="productCanBePurchased" Type="boolean">
	<cfargument Name="productID_parent" Type="numeric">
	<cfargument Name="productID_parent_custom" Type="string">
	<cfargument Name="productInBundle" Type="boolean">
	<cfargument Name="productIsBundle" Type="boolean">
	<cfargument Name="productIsRecommended" Type="boolean">
	<cfargument Name="productHasRecommendation" Type="boolean">
	<cfargument Name="productIsDateRestricted" Type="boolean">
	<cfargument Name="productIsDateAvailable" Type="boolean">
	<cfargument Name="productHasChildren" Type="boolean">
	<cfargument Name="productHasCustomPrice" Type="boolean">
	<cfargument Name="productPriceCallForQuote" Type="boolean">
	<cfargument Name="productCatalogPageNumber" Type="string">
	<cfargument Name="productPrice_min" Type="numeric">
	<cfargument Name="productPrice_max" Type="numeric">
	<cfargument Name="productName" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="productCode" Type="string">
	<cfargument Name="productLanguageSummary" Type="string">
	<cfargument Name="productLanguageDescription" Type="string">
	<cfargument Name="productInWarehouse" Type="boolean">
	<cfargument Name="productWeight_min" Type="numeric">
	<cfargument Name="productWeight_max" Type="numeric">
	<cfargument Name="productHasParameter" Type="boolean">
	<cfargument Name="productHasParameterException" Type="boolean">
	<cfargument Name="productIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var categoryID_list = "">
	<cfset var beginRow = 0>
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_product/ws_selectProductList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectProductList" Access="remote" Output="No" ReturnType="query" Hint="Select product list. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="categoryID" Type="string">
	<cfargument Name="categoryCode" Type="string">
	<cfargument Name="categoryID_sub" Type="boolean">
	<cfargument Name="categoryID_multiple" Type="boolean">
	<cfargument Name="userID_manager" Type="numeric">
	<cfargument Name="userID_manager_custom" Type="string">
	<cfargument Name="vendorID" Type="numeric">
	<cfargument Name="vendorID_custom" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="productStatus" Type="boolean">
	<cfargument Name="productHasImage" Type="boolean">
	<cfargument Name="productListedOnSite" Type="boolean">
	<cfargument Name="productHasSpec" Type="boolean">
	<cfargument Name="productCanBePurchased" Type="boolean">
	<cfargument Name="productID_parent" Type="numeric">
	<cfargument Name="productID_parent_custom" Type="string">
	<cfargument Name="productInBundle" Type="boolean">
	<cfargument Name="productIsBundle" Type="boolean">
	<cfargument Name="productIsRecommended" Type="boolean">
	<cfargument Name="productHasRecommendation" Type="boolean">
	<cfargument Name="productIsDateRestricted" Type="boolean">
	<cfargument Name="productIsDateAvailable" Type="boolean">
	<cfargument Name="productHasChildren" Type="boolean">
	<cfargument Name="productHasCustomPrice" Type="boolean">
	<cfargument Name="productPriceCallForQuote" Type="boolean">
	<cfargument Name="productCatalogPageNumber" Type="string">
	<cfargument Name="productPrice_min" Type="numeric">
	<cfargument Name="productPrice_max" Type="numeric">
	<cfargument Name="productName" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="productCode" Type="string">
	<cfargument Name="productLanguageSummary" Type="string">
	<cfargument Name="productLanguageDescription" Type="string">
	<cfargument Name="productInWarehouse" Type="boolean">
	<cfargument Name="productWeight_min" Type="numeric">
	<cfargument Name="productWeight_max" Type="numeric">
	<cfargument Name="productHasParameter" Type="boolean">
	<cfargument Name="productHasParameterException" Type="boolean">
	<cfargument Name="productIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var categoryID_list = "">
	<cfset var beginRow = 0>
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_product/ws_selectProductList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateProductIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether product records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="productID_custom" Type="string" Required="Yes">
	<cfargument Name="productIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_product/ws_updateProductIsExported.cfm">
	<cfreturn returnValue>
</cffunction>


<!--- Product Category --->
<cffunction Name="selectProductCategory" Access="remote" Output="No" ReturnType="query" Hint="Selects the category(s) in which the specified product(s) is listed. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_product/ws_selectProductCategory.cfm">
	<cfreturn returnValue>
</cffunction>


</cfcomponent>

