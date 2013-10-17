<cfinclude template="formValidate_search.cfm">

<cfinclude template="../../../view/v_shopping/v_shoppingCatalog/form_search.cfm">

<cfif URL.error_shopping is not "">
	<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
<cfelse>
	<cfset qryParamStruct = StructNew()>

	<cfset qryParamStruct.companyID = Session.companyID_author>
	<cfswitch expression="#Form.searchType#">
	 <cfcase value="vendorCode,vendorID"><cfset qryParamStruct.vendorID = ValueList(qry_selectVendorList.vendorID)></cfcase>
	 <cfcase value="productCatalogPageNumber"><cfset qryParamStruct.productCatalogPageNumber = Form.searchText></cfcase>
	<cfdefaultcase><!--- productDescription,categoryID --->
		<cfset qryParamStruct.searchText = Form.searchText>
		<cfif IsNumeric(Form.searchType) and ListFind(ValueList(qry_selectCategoryList.categoryID), Form.searchType)>
			<cfset qryParamStruct.categoryID = Form.searchType>
			<cfset qryParamStruct.searchField = "productName,productCode,productDescription">
		<cfelse>
			<cfset qryParamStruct.searchField = Form.searchType>
		</cfif>
	</cfdefaultcase>
	</cfswitch>
	<cfif IsDefined("Form.categoryID") and ListFind(ValueList(qry_selectCategoryList.categoryID), Form.categoryID)>
		<cfset qryParamStruct.categoryID = Form.categoryID>
	</cfif>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList_count" ReturnVariable="totalProductCount" argumentCollection="#qryParamStruct#" />

	<cfparam Name="URL.queryOrderBy" Default="">
	<cfparam Name="URL.queryPage" Default="1">
	<cfparam Name="URL.queryDisplayPerPage" Default="10">

	<cfif Not Application.fn_IsIntegerPositive(URL.queryDisplayPerPage)>
		<cfset URL.queryDisplayPerPage = 10>
	</cfif>
	<cfif Not Application.fn_IsIntegerPositive(URL.queryPage)>
		<cfset URL.queryPage = 1>
	<cfelseif (DecrementValue(URL.queryPage) * URL.queryDisplayPerPage) gt totalProductCount>
		<cfset URL.queryPage = 1>
	</cfif>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList" ReturnVariable="qry_selectProductList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#URL.queryOrderBy#">
		<cfinvokeargument Name="queryPage" Value="#URL.queryPage#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#URL.queryDisplayPerPage#">
		<cfinvokeargument Name="queryDisplayProductImage" Value="True">
	</cfinvoke>

	<!--- select custom prices for products in this category --->
	<cfset Variables.productID_getPrice = ValueList(qry_selectProductList.productID)>
	<cfset Variables.productID_parent_getPrice = "">
	<cfset Variables.categoryID_getPrice = "">
	<cfset Variables.categoryID_parent_getPrice = "">

	<cfparam Name="URL.categoryID" Default="0">

	<!--- determine whether each product has a custom price --->
	<cfinclude template="act_findProductPrice.cfm">

	<!--- products displayed on this page and action for next/previous pages --->
	<cfset Variables.queryViewAction_orderBy = "search.cfm?isFormSubmitted=True&searchType=#HTMLEditFormat(Form.searchType)#&searchText=#HTMLEditFormat(Form.searchText)#&submitSearch=True">

	<cfset Variables.firstRecord = (URL.queryDisplayPerPage * DecrementValue(URL.queryPage)) + 1>
	<cfset Variables.lastRecord = Min(URL.queryDisplayPerPage * URL.queryPage, totalProductCount)>
	<cfif (totalProductCount mod URL.queryDisplayPerPage) is 0>
		<cfset Variables.totalProductPages = totalProductCount \ URL.queryDisplayPerPage>
	<cfelse>
		<cfset Variables.totalProductPages = (totalProductCount \ URL.queryDisplayPerPage) + 1>
	</cfif>

	<cfinclude template="../../../view/v_shopping/v_shoppingCatalog/dsp_searchResults.cfm">
</cfif>
