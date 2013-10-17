<!--- select product image(s) if necessary --->
<cfset Variables.displayProductImage = False>
<cfif qry_selectProduct.productHasImage is 1>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectImageList" ReturnVariable="qry_selectImageList">
		<cfinvokeargument Name="productID" Value="#Variables.productID_getImage#">
	</cfinvoke>
	<cfif qry_selectImageList.RecordCount is not 0>
		<cfset Variables.displayProductImage = True>
	</cfif>
</cfif>
