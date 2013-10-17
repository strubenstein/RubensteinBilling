<cfset Variables.displayCustomPrice = False>
<cfset Variables.productID_customPriceRow = StructNew()>
<cfset Variables.productID_customPriceAmount = StructNew()>

<cfif qry_selectProductList.RecordCount is not 0>
	<!--- pricing that applies to parent products --->
	<cfloop Query="qry_selectProductList">
		<cfif qry_selectProductList.productID_parent is not 0>
			<cfset Variables.productID_parent_getPrice = ListAppend(Variables.productID_parent_getPrice, qry_selectProductList.productID_parent)>
		</cfif>
	</cfloop>

	<!--- determine other categories/parent categories that product is in that may affect pricing --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductCategoryList" ReturnVariable="qry_selectProductCategoryList">
		<cfif Variables.productID_parent_getPrice is "">
			<cfinvokeargument Name="productID" Value="#Variables.productID_getPrice#">
		<cfelse>
			<cfinvokeargument Name="productID" Value="#ListAppend(Variables.productID_getPrice, Variables.productID_parent_getPrice)#">
		</cfif>
	</cfinvoke>

	<cfloop Query="qry_selectProductCategoryList">
		<cfif Not ListFind(URL.categoryID, qry_selectProductCategoryList.categoryID)>
			<cfset Variables.categoryID_getPrice = ListAppend(Variables.categoryID_getPrice, qry_selectProductCategoryList.categoryID)>
			<cfif qry_selectProductCategoryList.categoryID_parentList is not "">
				<cfset Variables.categoryID_parent_getPrice = ListAppend(Variables.categoryID_parent_getPrice, qry_selectProductCategoryList.categoryID_parentList)>
			</cfif>
		</cfif>
	</cfloop>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectPriceList" ReturnVariable="qry_selectPriceList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="productID" Value="#Variables.productID_getPrice#">
		<cfinvokeargument Name="productID_parent" Value="#Variables.productID_parent_getPrice#">
		<cfinvokeargument Name="categoryID" Value="#Variables.categoryID_getPrice#">
		<cfinvokeargument Name="categoryID_parent" Value="#Variables.categoryID_parent_getPrice#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="groupID" Value="#Session.groupID#">
		<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID#">
		<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID#">
		<cfinvokeargument Name="regionID" Value="0"><!--- #Session.regionID# --->
		<cfinvokeargument Name="returnPriceVolumeDiscountMinimum" Value="True">
		<cfinvokeargument Name="priceHasMultipleStages" Value="0">
	</cfinvoke>

	<!--- determine custom price for each product--->
	<!--- 
	Pricing Priority:
	1 - this product (priceAppliesToProduct)
	2 - parent product (priceAppliesToProductChildren)
	3 - this category (priceAppliesToCategory)
	4 - parent category (priceAppliesToCategoryChildren)
	5 - all products (priceAppliesToAllProducts)
	--->

	<cfif qry_selectPriceList.RecordCount is not 0>
		<!--- indicate that custom prices exist --->
		<cfset Variables.displayCustomPrice = True>

		<!--- for each product, get category(s) and parent category(s) for determining custom pricing --->
		<cfinclude template="act_findProductCategory.cfm">

		<cfloop Query="qry_selectProductList">
			<cfset Variables.thisProductID = qry_selectProductList.productID>
			<cfset Variables.thisProductID_parent = qry_selectProductList.productID_parent>
			<cfset Variables.thisProductPrice = qry_selectProductList.productPrice>

			<cfif Not StructKeyExists(Variables.productCategoryID, "product#qry_selectProductList.productID#")>
				<cfset Variables.thisCategoryID = "">
			<cfelse>
				<cfset Variables.thisCategoryID = Variables.productCategoryID["product#qry_selectProductList.productID#"]>
			</cfif>

			<cfif Not StructKeyExists(Variables.productCategoryID_parent, "product#qry_selectProductList.productID#")>
				<cfset Variables.thisCategoryID_parentList = "">
			<cfelse>
				<cfset Variables.thisCategoryID_parentList = Variables.productCategoryID_parent["product#qry_selectProductList.productID#"]>
			</cfif>

			<cfinclude template="act_findProductPricePriority.cfm">
		</cfloop>
	</cfif>
</cfif>