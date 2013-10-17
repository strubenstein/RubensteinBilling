<cfset URL.error_shopping = "">
<!--- verify that this is a valid product for this site --->
<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
	<cfset URL.error_shopping = "invalidProduct">
<cfelse>
	<!--- if valid integer, select this product information --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductLanguageVendor" ReturnVariable="qry_selectProduct">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<!--- ensure this product exists and is currently available --->
	<cfif qry_selectProduct.RecordCount is 0>
		<cfset URL.error_shopping = "invalidProduct">
	<cfelseif qry_selectProduct.productIsDateRestricted is 1 and qry_selectProduct.productIsDateAvailable is 0
			and Not FindNoCase("admin#Application.billingFilePathSlash#index.cfm", GetBaseTemplatePath())>
		<cfset URL.error_shopping = "productNotAvailable">
	<cfelse>
		<cfset Variables.productID_getPrice = URL.productID>
		<cfif qry_selectProduct.productID_parent is not 0>
			<cfset Variables.productID_parent_getPrice = qry_selectProduct.productID_parent>
		<cfelse>
			<cfset Variables.productID_parent_getPrice = "">
		</cfif>

		<cfset Variables.productID_getSpecs = URL.productID>
		<cfset Variables.productID_getImage = URL.productID>
		<cfset Variables.productID_getCategory = URL.productID>
		<cfset Variables.categoryID_getPrice = "">
		<cfset Variables.categoryID_parent_getPrice = "">

		<!--- if called from shopping cart, no need to get bundle, recommend, images or specs --->
		<cfif URL.control is not "cart">
			<cfset Variables.ignoreProductInfo = "">
		<cfelse>
			<cfset Variables.ignoreProductInfo = "bundle,recommend,image,spec">

			<cfset Variables.displayProductsInThisBundle = False>
			<cfset Variables.displayProductBundleWithThisProduct = False>
			<cfset Variables.displayProductRecommend = False>
			<cfset Variables.displayProductImage = False>
			<cfset Variables.displayProductSpec = False>
			<cfset Variables.displayProductSpec_parent = False>
			<cfset Variables.displayProductSpec_child = False>
		</cfif>

		<cfinclude template="act_getProductChildren.cfm">

		<cfif Not ListFind(Variables.ignoreProductInfo, "bundle")>
			<cfinclude template="act_getProductBundle.cfm">
		</cfif>
		<cfif Not ListFind(Variables.ignoreProductInfo, "recommend")>
			<cfinclude template="act_getProductRecommend.cfm">
		</cfif>

		<cfinclude template="act_getProductCategory.cfm">

		<cfif Not ListFind(Variables.ignoreProductInfo, "image")>
			<cfinclude template="act_getProductImage.cfm">
		</cfif>

		<cfif Not ListFind(Variables.ignoreProductInfo, "price")>
			<cfinclude template="act_getProductPrice.cfm">
		</cfif>

		<cfif Not ListFind(Variables.ignoreProductInfo, "spec")>
			<cfinclude template="act_getProductSpec.cfm">
		</cfif>

		<cfinclude template="act_getProductParameter.cfm">
	</cfif>
</cfif>

<cfif URL.error_shopping is not "">
	<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
</cfif>
