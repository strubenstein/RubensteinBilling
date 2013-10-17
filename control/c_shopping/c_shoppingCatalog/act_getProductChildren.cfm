<!--- If parent product and should list children products on this page --->
<cfset Variables.displayChildProduct_variation = 0>
<cfset Variables.displayChildProduct_upgrade = 0>
<cfset Variables.childProductHasSpec = False>

<cfif qry_selectProduct.productHasChildren is 1 and qry_selectProduct.productDisplayChildren is 1>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductLanguageVendor" ReturnVariable="qry_selectProductChildList">
		<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfif qry_selectProductChildList.RecordCount is not 0>
		<cfset Variables.displayChildProduct_variation = ListFind(ValueList(qry_selectProductChildList.productChildType), 1)>
		<cfset Variables.displayChildProduct_upgrade = ListFind(ValueList(qry_selectProductChildList.productChildType), 2)>

		<cfset Variables.productID_getSpecs = ListAppend(Variables.productID_getSpecs, ValueList(qry_selectProductChildList.productID))>
		<cfset Variables.productID_getPrice = ListAppend(Variables.productID_getPrice, ValueList(qry_selectProductChildList.productID))>
		<cfset Variables.productID_getImage = ListAppend(Variables.productID_getImage, ValueList(qry_selectProductChildList.productID))>
		<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, ValueList(qry_selectProductChildList.productID))>

		<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectProductChildList.productHasSpec))>
			<cfset Variables.childProductHasSpec = True>
		</cfif>
	</cfif>
</cfif>
