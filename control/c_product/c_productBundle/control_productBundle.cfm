<!--- if product is not bundle, can only view list of bundles that include product --->
<cfif Not ListFind("listProductBundles", Variables.doAction)>
	<cfif qry_selectProduct.productIsBundle is not 1>
		<cfset Variables.doAction = "listProductBundles">
		<cfset URL.error_product = "productNotBundle">
	<cfelseif qry_selectProduct.productStatus is not 0>
		<cfset Variables.doAction = "listProductBundles">
		<cfset URL.error_product = "productBundleStatus">
	</cfif>
</cfif>

<cfset currentProductBundleID = 0>
<cfif qry_selectProduct.productIsBundle is 1>
	<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="selectProductBundle" ReturnVariable="qry_selectProductBundle">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productBundleStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectProductBundle.RecordCount is 1>
		<cfset currentProductBundleID = qry_selectProductBundle.productBundleID>
		<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="selectProductBundleProductList" ReturnVariable="qry_selectProductBundleProductList">
			<cfinvokeargument Name="productBundleID" Value="#qry_selectProductBundle.productBundleID#">
		</cfinvoke>
	<cfelse>
		<cfset qry_selectProductBundleProductList = QueryNew("productBundleID,productID")>
	</cfif>
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listProductBundles">
	<cfinclude template="control_listProductBundles.cfm">
</cfcase>

<cfcase value="insertProductBundle">
	<cfinclude template="control_insertProductBundle.cfm">
</cfcase>

<cfcase value="updateProductBundle">
	<cfinclude template="control_updateProductBundle.cfm">
</cfcase>

<cfcase value="moveProductBundleUp,moveProductBundleDown">
	<cfinclude template="control_moveProductBundle.cfm">
</cfcase>

<cfcase value="deleteProductBundle">
	<cfif IsDefined("URL.productID_bundle") and ListFind(ValueList(qry_selectProductBundleProductList.productID), URL.productID_bundle)>
		<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="checkProductIsBundleChanged" ReturnVariable="currentProductBundleID">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
			<cfinvokeargument Name="productIsBundleChanged" Value="#qry_selectProduct.productIsBundleChanged#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="deleteProductBundleProduct" ReturnVariable="isProductBundleProductDeleted">
			<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
			<cfinvokeargument Name="productID" Value="#URL.productID_bundle#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&error_product=#URL.action#" AddToken="No">
	</cfif>
</cfcase>
</cfswitch>

