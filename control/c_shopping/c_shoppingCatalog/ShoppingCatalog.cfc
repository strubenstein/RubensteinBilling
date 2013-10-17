<cfcomponent DisplayName="ShoppingCatalog" Hint="Manages features for displaying categories and products in the shopping site front-end.">

<cffunction Name="selectCategoryList" Access="public" Output="No" ReturnType="query" Hint="Select list of categories">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryLevel" Type="numeric" Required="No">
	<cfargument Name="categoryID_parent" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryOrderByManual" Type="boolean" Required="No" Default="False">

	<cfset var selectCategoryList = QueryNew("blank")>

	<cfinclude template="qry_selectCategoryList.cfm">
	<cfreturn qry_selectCategoryList>
</cffunction>

<cffunction Name="selectCategory" Access="public" Output="No" ReturnType="query" Hint="Selects existing category">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">

	<cfset var qry_selectCategory = QueryNew("blank")>

	<cfinclude template="qry_selectCategory.cfm">
	<cfreturn qry_selectCategory>
</cffunction>

<cffunction Name="selectHeaderFooterList" Access="public" Output="No" ReturnType="query" Hint="Return existing header(s) and/or footer(s) for particular category or cobrand">
	<cfargument Name="headerFooterID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="numeric" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="headerFooterIndicator" Type="numeric" Required="No">

	<cfset var qry_selectHeaderFooterList = QueryNew("blank")>

	<cfinclude template="qry_selectHeaderFooterList.cfm">
	<cfreturn qry_selectHeaderFooterList>
</cffunction>

<cffunction Name="selectProductLanguageVendor" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="productID_parent" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="returnUserInfo" Type="numeric" Required="No" Default="False">

	<cfset var qry_selectProductLanguageVendor = QueryNew("blank")>

	<cfinclude template="qry_selectProductLanguageVendor.cfm">
	<cfreturn qry_selectProductLanguageVendor>
</cffunction>

<cffunction Name="selectProductCategoryList" Access="public" Output="No" ReturnType="query" Hint="Select Category(s) That Contain Product(s)">
	<cfargument Name="productID" Type="string" Required="Yes">

	<cfset var qry_selectProductCategoryList = QueryNew("blank")>

	<cfinclude template="qry_selectProductCategoryList.cfm">
	<cfreturn qry_selectProductCategoryList>
</cffunction>

<cffunction Name="selectImageList" Access="public" Output="No" ReturnType="query" Hint="Select product images">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="imageHasThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageIsThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageOrder_from" Type="numeric" Required="No">
	<cfargument Name="imageOrder_to" Type="numeric" Required="No">

	<cfset var qry_selectImageList = QueryNew("blank")>

	<cfinclude template="qry_selectImageList.cfm">
	<cfreturn qry_selectImageList>
</cffunction>

<cffunction Name="selectProductSpecList" Access="public" Output="No" ReturnType="query" Hint="Select product specs">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No">

	<cfset var qry_selectProductSpecList = QueryNew("blank")>

	<cfinclude template="qry_selectProductSpecList.cfm">
	<cfreturn qry_selectProductSpecList>
</cffunction>

<cffunction Name="selectProductBundleList" Access="public" Output="No" ReturnType="query" Hint="Select Bundles that Include Product">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfset var qry_selectProductBundleList = QueryNew("blank")>

	<cfinclude template="qry_selectProductBundleList.cfm">
	<cfreturn qry_selectProductBundleList>
</cffunction>

<cffunction Name="selectProductBundleProductList" Access="public" Output="No" ReturnType="query" Hint="Select Products Included in Product Bundle">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfset var qry_selectProductBundleProductList = QueryNew("blank")>

	<cfinclude template="qry_selectProductBundleProductList.cfm">
	<cfreturn qry_selectProductBundleProductList>
</cffunction>

<cffunction Name="selectProductRecommendList" Access="public" Output="No" ReturnType="query" Hint="Select recommended products for product">
	<cfargument Name="productID_target" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfset var qry_selectProductRecommendList = QueryNew("blank")>

	<cfinclude template="qry_selectProductRecommendList.cfm">
	<cfreturn qry_selectProductRecommendList>
</cffunction>

<cffunction Name="selectPriceList" Access="public" Output="No" ReturnType="query" Hint="Select Existing Prices For Category or Product">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="productID_parent" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryID_parent" Type="string" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="groupID" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="numeric" Required="No">
	<cfargument Name="regionID" Type="numeric" Required="No">
	<cfargument Name="returnPriceVolumeDiscountMinimum" Type="boolean" Required="No" Default="False">
	<cfargument Name="priceAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="priceHasMultipleStages" Type="numeric" Required="No">

	<cfset var qry_selectPriceList = QueryNew("blank")>
	<cfset var qry_selectPriceMinimum = QueryNew("blank")>
	<cfset var volumeRow = 0>
	<cfset var volumeList = "">
	<cfset var priceVolumeDiscountMinimumArray = ArrayNew(1)>

	<cfinclude template="qry_selectPriceList.cfm">
	<cfreturn qry_selectPriceList>
</cffunction>

<cffunction Name="selectProductPrice" Access="public" Output="No" ReturnType="query" Hint="Select Existing Product Price For Changing Quantity in Shopping Cart">
	<cfargument Name="productID" Type="string" Required="Yes">

	<cfset var qry_selectProductPrice = QueryNew("blank")>

	<cfinclude template="qry_selectProductPrice.cfm">
	<cfreturn qry_selectProductPrice>
</cffunction>

<cffunction Name="selectPrice" Access="public" Output="No" ReturnType="query" Hint="Select Existing Price For Changing Quantity in Shopping Cart">
	<cfargument Name="priceID" Type="numeric" Required="Yes">
	<!--- <cfargument Name="quantity" Type="numeric" Required="Yes"> --->

	<cfset var qry_selectPrice = QueryNew("blank")>

	<cfinclude template="qry_selectPrice.cfm">
	<cfreturn qry_selectPrice>
</cffunction>

<cffunction Name="selectPriceVolumeDiscount" Access="public" Output="No" ReturnType="query" Hint="Select Existing Price Volume Discount">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfset var qry_selectPriceVolumeDiscount = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "priceStageID") and Not StructKeyExists(Arguments, "priceID")>
		<cfset Arguments.priceStageID = 0>
	<cfelseif StructKeyExists(Arguments, "priceStageID") and Not Application.fn_IsIntegerList(Arguments.priceStageID)>
		<cfset Arguments.priceStageID = 0>
	<cfelseif StructKeyExists(Arguments, "priceID") and Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfset Arguments.priceStageID = 0>
	</cfif>

	<cfinclude template="qry_selectPriceVolumeDiscount.cfm">
	<cfreturn qry_selectPriceVolumeDiscount>
</cffunction>

<cffunction Name="selectProductList_count" Access="public" ReturnType="numeric" Hint="Select number of products that meet query parameters">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">

	<cfset var qry_selectProductList_count = QueryNew("blank")>

	<cfinclude template="qry_selectProductList_count.cfm">
	<cfreturn qry_selectProductList_count.totalRecords>
</cffunction>

<cffunction Name="selectProductList" Access="public" ReturnType="query" Hint="Select product list based on query parameters">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorCode" Type="string" Required="No">
	<cfargument Name="productCatalogPageNumber" Type="string" Required="No">
	<cfargument Name="productPrice_min" Type="numeric" Required="No">
	<cfargument Name="productPrice_max" Type="numeric" Required="No">
	<cfargument Name="productIsBundle" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="productName" Type="string" Required="No">
	<cfargument Name="productID_custom" Type="string" Required="No">
	<cfargument Name="productCode" Type="string" Required="No">
	<cfargument Name="productLanguageSummary" Type="string" Required="No">
	<cfargument Name="productLanguageDescription" Type="string" Required="No">
	<cfargument Name="productInWarehouse" Type="numeric" Required="No">
	<cfargument Name="productWeight_min" Type="numeric" Required="No">
	<cfargument Name="productWeight_max" Type="numeric" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="productName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryDisplayProductImage" Type="boolean" Required="No" Default="True">
	<cfargument Name="returnUserInfo" Type="boolean" Required="No" Default="False">

	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">
	<cfset var qry_selectProductList = QueryNew("blank")>

	<cfinclude template="qryOrderBy_selectProductList.cfm">
	<cfinclude template="qry_selectProductList.cfm">

	<cfreturn qry_selectProductList>
</cffunction>

<cffunction Name="selectProductParameterList" Access="public" Output="No" ReturnType="query" Hint="Select product parameters for product">
	<cfargument Name="productID" Type="string" Required="Yes">

	<cfset var qry_selectProductParameterList = QueryNew("blank")>

	<cfinclude template="qry_selectProductParameterList.cfm">
	<cfreturn qry_selectProductParameterList>
</cffunction>

<cffunction Name="selectProductParameterOptionList" Access="public" Output="No" ReturnType="query" Hint="Select product parameter options for product">
	<cfargument Name="productParameterID" Type="string" Required="Yes">

	<cfset var qry_selectProductParameterOptionList = QueryNew("blank")>

	<cfinclude template="qry_selectProductParameterOptionList.cfm">
	<cfreturn qry_selectProductParameterOptionList>
</cffunction>

<cffunction Name="selectProductParameterExceptionList" Access="public" Output="No" ReturnType="query" Hint="Select exceptions for product parameters for product">
	<cfargument Name="productID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductParameterExceptionList = QueryNew("blank")>

	<cfinclude template="qry_selectProductParameterExceptionList.cfm">
	<cfreturn qry_selectProductParameterExceptionList>
</cffunction>

</cfcomponent>

