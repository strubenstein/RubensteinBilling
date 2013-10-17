<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductBundle") and IsDefined("Form.productID_list")>
	<cfif qry_selectProductBundle.RecordCount is 1>
		<cfset currentProductBundleID = qry_selectProductBundle.productBundleID>
	<cfelse>
		<cfset currentProductBundleID = 0>
	</cfif>

	<cfset isProductBundleProductInserted = False>
	<cfinvoke component="#Application.billingMapping#data.ProductBundleProduct" method="maxlength_ProductBundleProduct" returnVariable="maxlength_ProductBundleProduct" />

	<cfloop Index="loopProductID" List="#Form.productID_list#">
		<cfif IsDefined("Form.productBundleProductQuantity#loopProductID#") and IsNumeric(Form["productBundleProductQuantity#loopProductID#"])
				and Not ListFind(ValueList(qry_selectProductBundleProductList.productID), loopProductID)
				and Len(ListRest(Form["productBundleProductQuantity#loopProductID#"], ".")) lte maxlength_ProductBundleProduct.productBundleProductQuantity>
			<cfif isProductBundleProductInserted is False>
				<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="checkProductIsBundleChanged" ReturnVariable="currentProductBundleID">
					<cfinvokeargument Name="productID" Value="#URL.productID#">
					<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
					<cfinvokeargument Name="productIsBundleChanged" Value="#qry_selectProduct.productIsBundleChanged#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
				</cfinvoke>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="insertProductBundleProduct" ReturnVariable="isProductBundleProductInserted">
				<cfinvokeargument Name="productBundleID" Value="#currentProductBundleID#">
				<cfinvokeargument Name="productID" Value="#loopProductID#">
				<cfinvokeargument Name="productBundleProductQuantity" Value="#Form['productBundleProductQuantity#loopProductID#']#">
				<cfinvokeargument Name="productBundleProductOrder" Value="0">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cfif isProductBundleProductInserted is True>
		<cfif IsDefined("Form.queryViewAction")>
			<cflocation url="#Form.queryViewAction#&confirm_product=#URL.action#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=product.insertProductBundle&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Form.productIsBundle = 0>
<cfset Variables.productID_notList = URL.productID>
<cfif qry_selectProductBundleProductList.RecordCount is not 0>
	<cfset Variables.productID_notList = ListAppend(Variables.productID_notList, ValueList(qry_selectProductBundleProductList.productID))>
</cfif>
<cfinclude template="../control_listProducts.cfm">
