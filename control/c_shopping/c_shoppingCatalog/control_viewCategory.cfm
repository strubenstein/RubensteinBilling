<cfparam Name="URL.categoryID" Default="0">
<cfset URL.error_shopping = "">

<!--- verify that this is a valid category for this site --->
<cfif Not Application.fn_IsIntegerPositive(URL.categoryID)>
	<cfset URL.error_shopping = "invalidCategory">
<cfelse>
	<!--- if valid integer, select this category information --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectCategory" ReturnVariable="qry_selectCategory">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
	</cfinvoke>

	<cfif qry_selectCategory.RecordCount is 0>
		<cfset URL.error_shopping = "invalidCategory">
	<cfelse>
		<!--- select category path to this category --->
		<cfif qry_selectCategory.categoryID_parentList is "">
			<cfset Variables.displayCategoryPath = False>
		<cfelse>
			<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectCategoryList" ReturnVariable="qry_selectParentCategoryList">
				<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				<cfinvokeargument Name="categoryID" Value="#qry_selectCategory.categoryID_parentList#">
			</cfinvoke>
			<cfset Variables.displayCategoryPath = True>
		</cfif>

		<!--- select sub-categories of this category --->
		<cfif qry_selectCategory.categoryHasChildren is 0>
			<cfset Variables.displaySubCategoryList = False>
		<cfelse>
			<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectCategoryList" ReturnVariable="qry_selectSubCategoryList">
				<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				<cfinvokeargument Name="categoryID_parent" Value="#URL.categoryID#">
				<cfinvokeargument Name="categoryLevel" Value="#IncrementValue(qry_selectCategory.categoryLevel)#">
			</cfinvoke>
			<cfset Variables.displaySubCategoryList = True>
		</cfif>

		<cfset Variables.displayCategoryHeader = 0>
		<cfset Variables.displayCategoryFooter = 0>
		<cfif qry_selectCategory.headerFooterID_header is not 0 or qry_selectCategory.headerFooterID_footer is not 0>
			<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectHeaderFooterList" ReturnVariable="qry_selectHeaderFooterList">
				<cfinvokeargument Name="headerFooterID" Value="#qry_selectCategory.headerFooterID_header#,#qry_selectCategory.headerFooterID_footer#">
			</cfinvoke>

			<cfloop Query="qry_selectHeaderFooterList">
				<cfif qry_selectHeaderFooterList.headerFooterIndicator is 0>
					<cfset Variables.displayCategoryHeader = qry_selectHeaderFooterList.CurrentRow>
				<cfelse>
					<cfset Variables.displayCategoryFooter = qry_selectHeaderFooterList.CurrentRow>
				</cfif>
			</cfloop>
		</cfif>

		<cfparam Name="URL.showImage" Default="True">
		<!--- select featured products in this category --->
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList" ReturnVariable="qry_selectFeaturedList">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="queryOrderBy" Value="RANDOM">
			<cfinvokeargument Name="queryDisplayPerPage" Value="10">
			<cfif URL.showImage is True>
				<cfinvokeargument Name="queryDisplayProductImage" Value="True">
			</cfif>
		</cfinvoke>

		<!--- select products in this category --->
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList_count" ReturnVariable="totalProductCount">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		</cfinvoke>

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

		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList" ReturnVariable="qry_selectProductList">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="queryOrderBy" Value="#URL.queryOrderBy#">
			<cfinvokeargument Name="queryPage" Value="#URL.queryPage#">
			<cfinvokeargument Name="queryDisplayPerPage" Value="#URL.queryDisplayPerPage#">
			<cfif URL.showImage is True>
				<cfinvokeargument Name="queryDisplayProductImage" Value="True">
			</cfif>
		</cfinvoke>

		<!--- select custom prices for products in this category --->
		<cfset Variables.productID_getPrice = ValueList(qry_selectProductList.productID)>
		<cfset Variables.productID_parent_getPrice = "">
		<cfset Variables.categoryID_getPrice = URL.categoryID>
		<cfset Variables.categoryID_parent_getPrice = qry_selectCategory.categoryID_parentList>

		<!--- determine whether each product has a custom price --->
		<cfinclude template="act_findProductPrice.cfm">

		<!--- products displayed on this page and action for next/previous pages --->
		<cfset Variables.queryViewAction_orderBy = "index.cfm?method=category.viewCategory&categoryID=#URL.categoryID#&queryOrderBy=#URLEncodedFormat(URL.queryOrderBy)#">

		<cfset Variables.firstRecord = (URL.queryDisplayPerPage * DecrementValue(URL.queryPage)) + 1>
		<cfset Variables.lastRecord = Min(URL.queryDisplayPerPage * URL.queryPage, totalProductCount)>
		<cfif (totalProductCount mod URL.queryDisplayPerPage) is 0>
			<cfset Variables.totalProductPages = totalProductCount \ URL.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalProductPages = (totalProductCount \ URL.queryDisplayPerPage) + 1>
		</cfif>

		<cfif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilePathSlash & qry_selectCategory.templateFilename)>
			<cfinclude template="../../../include/template/defaultCategory.cfm">
		<cfelse>
			<cfinclude template="../../../include/template/#qry_selectCategory.templateFilename#">
		</cfif>
	</cfif>
</cfif>

<cfif URL.error_shopping is not "">
	<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
</cfif>

