<!--- if product is bundle, select products in this bundle; otherwise, select bundles that include this product --->
<cfset Variables.displayProductsInThisBundle = False>
<cfset Variables.displayProductBundleWithThisProduct = False>

<cfif qry_selectProduct.productIsBundle is 1>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductBundleProductList" ReturnVariable="qry_selectProductBundleProductList">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<cfif qry_selectProductBundleProductList.RecordCount is not 0>
		<cfset Variables.displayProductsInThisBundle = True>
		<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, ValueList(qry_selectProductBundleProductList.productID))>
		<cfset Variables.productID_getPrice = ListAppend(Variables.productID_getPrice, ValueList(qry_selectProductBundleProductList.productID))>
		<cfloop Query="qry_selectProductBundleProductList">
			<cfif qry_selectProductBundleProductList.productID_parent is not 0>
				<cfset Variables.productID_parent_getPrice = ListAppend(Variables.productID_parent_getPrice, qry_selectProductBundleProductList.productID_parent)>
				<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, qry_selectProductBundleProductList.productID_parent)>
			</cfif>
		</cfloop>
	</cfif>

<cfelseif qry_selectProduct.productInBundle is 1>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductBundleList" ReturnVariable="qry_selectProductBundleList">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<cfif qry_selectProductBundleList.RecordCount is not 0>
		<cfset Variables.displayProductBundleWithThisProduct = True>
		<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, ValueList(qry_selectProductBundleList.productID))>
		<cfset Variables.productID_getPrice = ListAppend(Variables.productID_getPrice, ValueList(qry_selectProductBundleList.productID))>
		<cfloop Query="qry_selectProductBundleList">
			<cfif qry_selectProductBundleList.productID_parent is not 0>
				<cfset Variables.productID_parent_getPrice = ListAppend(Variables.productID_parent_getPrice, qry_selectProductBundleList.productID_parent)>
				<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, qry_selectProductBundleList.productID_parent)>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
