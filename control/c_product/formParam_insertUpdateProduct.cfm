<cfif URL.productID is not 0 and IsDefined("qry_selectProduct")>
	<cfparam Name="Form.productStatus" Default="#qry_selectProduct.productStatus#">
	<cfparam Name="Form.productListedOnSite" Default="#qry_selectProduct.productListedOnSite#">
	<cfparam Name="Form.productCanBePurchased" Default="#qry_selectProduct.productCanBePurchased#">
	<cfparam Name="Form.productDisplayChildren" Default="#qry_selectProduct.productDisplayChildren#">
	<cfparam Name="Form.productID_parent" Default="#qry_selectProduct.productID_parent#">
	<cfparam Name="Form.productChildType" Default="#qry_selectProduct.productChildType#">
	<cfparam Name="Form.productName" Default="#qry_selectProduct.productName#">
	<cfparam Name="Form.productPrice" Default="#qry_selectProduct.productPrice#">
	<cfparam Name="Form.userID_manager" Default="#qry_selectProduct.userID_manager#">
	<cfparam Name="Form.productID_custom" Default="#qry_selectProduct.productID_custom#">
	<cfparam Name="Form.vendorID" Default="#qry_selectProduct.vendorID#">
	<cfparam Name="Form.productCode" Default="#qry_selectProduct.productCode#">
	<cfparam Name="Form.productWeight" Default="#qry_selectProduct.productWeight#">
	<cfparam Name="Form.productCatalogPageNumber" Default="#qry_selectProduct.productCatalogPageNumber#">
	<cfparam Name="Form.templateFilename" Default="#qry_selectProduct.templateFilename#">
	<cfparam Name="Form.productInWarehouse" Default="#qry_selectProduct.productInWarehouse#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.productIsBundle" Default="#qry_selectProduct.productIsBundle#">
		<cfparam Name="Form.productPriceCallForQuote" Default="#qry_selectProduct.productPriceCallForQuote#">
	</cfif>
</cfif>

<cfparam Name="Form.productStatus" Default="1">
<cfparam Name="Form.productListedOnSite" Default="1">
<cfparam Name="Form.productCanBePurchased" Default="1">
<cfparam Name="Form.productDisplayChildren" Default="0">

<cfif IsDefined("URL.productID_parent") and IsNumeric(URL.productID_parent)>
	<cfparam Name="Form.productID_parent" Default="#URL.productID_parent#">
	<cfparam Name="Form.productChildType" Default="1">
<cfelse>
	<cfparam Name="Form.productID_parent" Default="">
	<cfparam Name="Form.productChildType" Default="0">
</cfif>

<cfparam Name="Form.productIsBundle" Default="0">
<cfparam Name="Form.productName" Default="">
<cfparam Name="Form.productPrice" Default="0.00">
<cfparam Name="Form.productPriceCallForQuote" Default="0">
<cfparam Name="Form.userID_manager" Default="0">
<cfparam Name="Form.productID_custom" Default="">
<cfparam Name="Form.vendorID" Default="0">
<cfparam Name="Form.productCode" Default="">
<cfparam Name="Form.productWeight" Default="0.00">
<cfparam Name="Form.productCatalogPageNumber" Default="">
<cfparam Name="Form.templateFilename" Default="">
<cfparam Name="Form.productInWarehouse" Default="0">

<cfif Form.productCatalogPageNumber is 0>
	<cfset Form.productCatalogPageNumber = "">
</cfif>
<cfif Form.productID_parent is 0>
	<cfset Form.productID_parent = "">
</cfif>

