<!--- select product pricing --->
<cfset Variables.displayCustomPrice = False>
<cfset Variables.displayCustomPriceVolumeDiscount = False>
<cfset Variables.productID_customPriceRow = StructNew()>
<cfset Variables.productID_customPriceAmount = StructNew()>

<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectPriceList" ReturnVariable="qry_selectPriceList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="productID" Value="#Variables.productID_getPrice#">
	<cfinvokeargument Name="productID_parent" Value="#productID_parent_getPrice#">
	<cfinvokeargument Name="categoryID" Value="#Variables.categoryID_getPrice#">
	<cfinvokeargument Name="categoryID_parent" Value="#Variables.categoryID_parent_getPrice#">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="groupID" Value="#Session.groupID#">
	<cfinvokeargument Name="regionID" Value="0"><!--- #Session.regionID# --->
	<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID#">
	<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID#">
	<cfinvokeargument Name="returnPriceVolumeDiscountMinimum" Value="True">
	<cfinvokeargument Name="priceHasMultipleStages" Value="0">
</cfinvoke>

<!--- product template uses its own code to loop thru the list of products via the category instead of each individual product query 
but what about products that are not in a category?
--->
<cfif qry_selectPriceList.RecordCount is not 0>
	<cfset Variables.displayCustomPrice = True>

	<!--- for each product, get category(s) and parent category(s) for determining custom pricing --->
	<cfinclude template="act_findProductCategory.cfm">

	<!--- the main product being viewed --->
	<cfset Variables.queryPriceLoopList = "qry_selectProduct">

	<!--- child products --->
	<cfif Variables.displayChildProduct_variation is not 0 or Variables.displayChildProduct_upgrade is not 0>
		<cfset Variables.queryPriceLoopList = ListAppend(Variables.queryPriceLoopList, "qry_selectProductChildList")>
	</cfif>

	<!--- recommended products --->
	<cfif Variables.displayProductRecommend is True>
		<cfset Variables.queryPriceLoopList = ListAppend(Variables.queryPriceLoopList, "qry_selectProductRecommendList")>
	</cfif>

	<!--- product in this bundle --->
	<cfif Variables.displayProductsInThisBundle is True>
		<cfset Variables.queryPriceLoopList = ListAppend(Variables.queryPriceLoopList, "qry_selectProductBundleProductList")>
	</cfif>

	<!--- bundles that include this product --->
	<cfif Variables.displayProductBundleWithThisProduct is True>
		<cfset Variables.queryPriceLoopList = ListAppend(Variables.queryPriceLoopList, "qry_selectProductBundleProductList")>
	</cfif>

	<cfloop Index="priceQuery" List="#Variables.queryPriceLoopList#">
		<cfloop Query="#priceQuery#">
			<cfset Variables.thisProductID = Evaluate("#priceQuery#.productID")>
			<cfset Variables.thisProductID_parent = Evaluate("#priceQuery#.productID_parent")>
			<cfset Variables.thisProductPrice = Evaluate("#priceQuery#.productPrice")>

			<cfif Not StructKeyExists(Variables.productCategoryID, "product#Variables.thisProductID#")>
				<cfset Variables.thisCategoryID = "">
			<cfelse>
				<cfset Variables.thisCategoryID = Variables.productCategoryID["product#Variables.thisProductID#"]>
			</cfif>
			<cfif Not StructKeyExists(Variables.productCategoryID_parent, "product#Variables.thisProductID#")>
				<cfset Variables.thisCategoryID_parentList = "">
			<cfelse>
				<cfset Variables.thisCategoryID_parentList = Variables.productCategoryID_parent["product#Variables.thisProductID#"]>
			</cfif>

			<cfinclude template="act_findProductPricePriority.cfm">
		</cfloop>
	</cfloop>

	<!--- select volume discount levels if necessary --->
	<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectPriceList.priceStageVolumeDiscount))>
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
			<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPriceList.priceStageID)#">
		</cfinvoke>

		<cfif qry_selectPriceVolumeDiscount.RecordCount is not 0>
			<cfset Variables.displayCustomPriceVolumeDiscount = False>
		</cfif>
	</cfif>
</cfif>



	<!--- 
	<!--- loop thru and determine which price(s) applies to each product --->
	<cfloop Query="qry_selectProductCategoryList">
		<cfset Variables.thisProductID = qry_selectProductCategoryList.productID>
		<cfset Variables.thisCategoryID = qry_selectProductCategoryList.categoryID>
		<cfset Variables.thisCategoryID_parentList = qry_selectProductCategoryList.categoryID_parentList>

		<!--- determine the parent of this product (could be more efficient) --->
		<cfif qry_selectProductCategoryList.productID is URL.productID><!--- is main product --->
			<cfset Variables.thisProductID_parent = qry_selectProduct.productID_parent>
		<!--- is child of main product --->
		<cfelseif (Variables.displayChildProduct_variation is not 0 or Variables.displayChildProduct_upgrade is not 0)
				and IsDefined("qry_selectProductChildList") and ListFind(ValueList(qry_selectProductChildList.productID), qry_selectProductCategoryList.productID)>
			<cfset Variables.thisProductID_parent = qry_selectProductChildList.productID_parent[ListFind(ValueList(qry_selectProductChildList.productID), qry_selectProductCategoryList.productID)]>
		<!--- is recommended by main product --->
		<cfelseif Variables.displayProductRecommend is True and ListFind(ValueList(qry_selectProductRecommendList.productID), qry_selectProductCategoryList.productID)>
			<cfset Variables.thisProductID_parent = qry_selectProductChildList.productID_parent[ListFind(ValueList(qry_selectProductRecommendList.productID), qry_selectProductCategoryList.productID)]>
		<!--- is in the main product bundle --->
		<cfelseif Variables.displayProductsInThisBundle is True and ListFind(ValueList(qry_selectProductBundleProductList.productID), qry_selectProductCategoryList.productID)>
			<cfset Variables.thisProductID_parent = qry_selectProductChildList.productID_parent[ListFind(ValueList(qry_selectProductBundleProductList.productID), qry_selectProductCategoryList.productID)]>
		<!--- is a bundle product which contains the main product --->
		<cfelseif Variables.displayProductBundleWithThisProduct is True and ListFind(ValueList(qry_selectProductBundleProductList.productID), qry_selectProductBundleList.productID)>
			<cfset Variables.thisProductID_parent = qry_selectProductChildList.productID_parent[ListFind(ValueList(qry_selectProductBundleProductList.productID), qry_selectProductCategoryList.productID)]>
		<!--- ??? --->
		<cfelse>
			<cfset Variables.thisProductID_parent = 0>
		</cfif>

		<cfinclude template="act_findProductPricePriority.cfm">
	</cfloop>
	--->

