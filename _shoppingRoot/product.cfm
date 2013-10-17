<cfparam Name="URL.productID" Default="0">
<cfinclude template="control/c_shopping/c_shoppingCatalog/control_getProduct.cfm">

<!--- vendor code / vendorID OR does productID_custom include vendorCode anyway? --->
<!--- get all avProduct/avProductLanguage in a single query instead of so many joins? --->

<cfif URL.error_shopping is "">
	<cfif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilepathSlash & qry_selectProduct.templateFilename)>
		<cfinclude template="include/template/defaultProduct.cfm">
	<cfelse>
		<cfinclude template="include/template/#qry_selectProduct.templateFilename#">
	</cfif>

	<!--- add to list of last X products viewed --->
	<cfinclude template="control/c_shopping/c_shoppingCatalog/control_lastProductsViewed.cfm">
</cfif>
