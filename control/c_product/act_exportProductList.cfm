<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="products">
	<cfinvokeargument name="xmlTagSingle" value="product">
	<cfinvokeargument name="fileNamePrefix" value="products">
	<cfinvokeargument name="exportQueryName" value="qry_selectProductList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectProductList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="productPrice,productPriceCallForQuote,productWeight,productStatus,productListedOnSite,productCanBePurchased,productDisplayChildren,productChildType,productCatalogPageNumber,productChildOrder,productChildSeparate,productInWarehouse,productDateCreated,productDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="productPrice">
	</cfif>
</cfinvoke>

