<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listProductDates")><a href="index.cfm?method=product.listProductDates&productID=#URL.productID#" title="List existing products availability dates" class="SubNavLink<cfif Variables.doAction is "listProductDates">On</cfif>">Existing Product Availability Dates</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProductDate")> | <a href="index.cfm?method=product.insertProductDate&productID=#URL.productID#" title="Add new product availability dates" class="SubNavLink<cfif Variables.doAction is "insertProductDate">On</cfif>">Add New Product Availability Dates</a></cfif>
</div><br>
</cfoutput>
