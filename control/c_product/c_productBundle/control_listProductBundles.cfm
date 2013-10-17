<cfif IsDefined("URL.error_product")>
	<cfinclude template="../../../view/v_product/error_product.cfm">
</cfif>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("listProductBundles,insertProductBundle,moveProductBundleDown,moveProductBundleUp,deleteProductBundle,updateProductBundle")>

<cfif qry_selectProduct.productIsBundle is 1><!--- display products in this bundle --->
	<cfset Variables.isDisplayForm = False>
	<cfif qry_selectProduct.productStatus is 0>
		<cfset Variables.isDisplayForm = True>
	</cfif>

	<cfinclude template="../../../view/v_product/v_productBundle/nav_productBundle.cfm">
	<cfinclude template="../../../view/v_product/v_productBundle/dsp_selectProductBundleProductList.cfm">

<cfelse><!--- display bundles that include this product --->
	<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="selectProductBundle" ReturnVariable="qry_selectProductBundleList">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>
	<cfinclude template="../../../view/v_product/v_productBundle/dsp_selectProductBundleList.cfm">
</cfif>
