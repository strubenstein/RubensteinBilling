<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listProductBundles")><a href="index.cfm?method=product.listProductBundles&productID=#URL.productID#" title="List existing products in this bundle" class="SubNavLink<cfif Variables.doAction is "listProductBundles">On</cfif>">Existing Product Bundles</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProductBundle")>
	<cfif Variables.isDisplayForm is True>
		 | <a href="index.cfm?method=product.insertProductBundle&productID=#URL.productID#" title="Add product(s) to this bundle" class="SubNavLink<cfif Variables.doAction is "insertProductBundle">On</cfif>">Add Product(s) to Bundle</a>
	<cfelse>
		 | Product must be inactive to add products to this bundle
		 <cfif Application.fn_IsUserAuthorized("updateProduct")>
		 	 - <a href="index.cfm?method=product.updateProduct&productID=#URL.productID#" title="Update main product information" class="SubNavLink<cfif Variables.doAction is "updateProduct">On</cfif>">Update Product</a>
		 </cfif>
	</cfif>
</cfif>
</div><br>
</cfoutput>
