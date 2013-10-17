<cfif Not IsDefined("URL.productID_bundle")>
	<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&error_product=#URL.action#" AddToken="No">
</cfif>

<cfset Variables.productRow = ListFind(ValueList(qry_selectProductBundleProductList.productID), URL.productID_bundle)>
<cfif Variables.productRow is 0
		or (Variables.productRow is 1 and Variables.doAction is "moveProductBundleUp")
		or (Variables.productRow is qry_selectProductBundleProductList.RecordCount and Variables.doAction is "moveProductBundleDown")>
	<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&error_product=#URL.action#" AddToken="No">
</cfif>

<cfif Variables.doAction is "moveProductBundleUp">
	<cfset Variables.productRow = Variables.productRow - 1>
</cfif>

<cfset Variables.isFirstRow = True>
<cfloop Query="qry_selectProductBundleProductList" StartRow="#Variables.productRow#" EndRow="#IncrementValue(Variables.productRow)#">
	<cfif Variables.isFirstRow is True>
		<cfset Variables.isFirstRow = False>
		<cfset Variables.newProductBundleProductOrder = qry_selectProductBundleProductList.productBundleProductOrder + 1>
	<cfelse>
		<cfset Variables.newProductBundleProductOrder = qry_selectProductBundleProductList.productBundleProductOrder - 1>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="updateProductBundleProduct" ReturnVariable="isProductBundleProductUpdated">
		<cfinvokeargument Name="productBundleID" Value="#qry_selectProductBundle.productBundleID#">
		<cfinvokeargument Name="productID" Value="#qry_selectProductBundleProductList.productID#">
		<cfinvokeargument Name="productBundleProductOrder" Value="#Variables.newProductBundleProductOrder#">
	</cfinvoke>
</cfloop>

<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
