<!--- INSERT PRODUCTCATEGORYORDER WHEN ADD PRODUCT TO CATEGORY!!! --->

<!--- validate category --->
<cfif Not IsDefined("URL.categoryID") or Not Application.fn_IsIntegerPositive(URL.categoryID)>
	<cfset URL.error_product = "invalidProductCategory">
	<cfinclude template="../../../view/v_product/error_product.cfm">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<!--- validate that product is listed in category --->
	<cfif qry_selectProductCategory.RecordCount is 0 or Not ListFind(ValueList(qry_selectProductCategory.categoryID), URL.categoryID)>
		<cfset URL.error_product = "invalidProductCategory">
		<cfinclude template="../../../view/v_product/error_product.cfm">
	<cfelse>
		<!--- update productCategoryOrder --->
		<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="switchProductCategoryOrder" ReturnVariable="isProductCategoryOrderSwitched">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="productCategoryOrder_direction" Value="#Variables.doAction#">
		</cfinvoke>

		<!--- redirect based on passed-in URL or jus basic product list --->
		<cfif IsDefined("URL.redirectURL") and Trim(URL.redirectURL) is not "">
			<cflocation url="#URL.redirectURL#&confirm_product=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.listProducts&categoryID=#URL.categoryID#&confirm_product=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

