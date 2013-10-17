<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductBundleUpdate")>
	<cfset isProductBundleProductUpdated = False>
	<cfinvoke component="#Application.billingMapping#data.ProductBundleProduct" method="maxlength_ProductBundleProduct" returnVariable="maxlength_ProductBundleProduct" />

	<cfloop Query="qry_selectProductBundleProductList">
		<cfif IsDefined("Form.productBundleProductQuantity#qry_selectProductBundleProductList.productID#")
				and IsNumeric(Form["productBundleProductQuantity#qry_selectProductBundleProductList.productID#"])
				and Len(ListRest(Form["productBundleProductQuantity#qry_selectProductBundleProductList.productID#"], ".")) lte maxlength_ProductBundleProduct.productBundleProductQuantity
				and Form["productBundleProductQuantity#qry_selectProductBundleProductList.productID#"] is not qry_selectProductBundleProductList.productBundleProductQuantity>
			<cfif isProductBundleProductUpdated is False>
				<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="checkProductIsBundleChanged" ReturnVariable="currentProductBundleID">
					<cfinvokeargument Name="productID" Value="#URL.productID#">
					<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
					<cfinvokeargument Name="productIsBundleChanged" Value="#qry_selectProduct.productIsBundleChanged#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
				</cfinvoke>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="updateProductBundleProduct" ReturnVariable="isProductBundleProductUpdated">
				<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
				<cfinvokeargument Name="productID" Value="#qry_selectProductBundleProductList.productID#">
				<cfinvokeargument Name="productBundleProductQuantity" Value="#Form['productBundleProductQuantity#qry_selectProductBundleProductList.productID#']#">
			</cfinvoke>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="index.cfm?method=product.listProductBundles&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
