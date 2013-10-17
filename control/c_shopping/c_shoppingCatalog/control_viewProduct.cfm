<cfparam Name="URL.productID" Default="0">
<cfinclude template="control_getProduct.cfm">

<cfif URL.error_shopping is "">
	<cfif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilePathSlash & qry_selectProduct.templateFilename)>
		<cfinclude template="../../../include/template/defaultProduct.cfm">
	<cfelse>
		<cfinclude template="../../../include/template/#qry_selectProduct.templateFilename#">
	</cfif>

	<!--- add to list of last X products viewed --->
	<cfinclude template="control_lastProductsViewed.cfm">
</cfif>
