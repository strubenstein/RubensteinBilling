<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listProductRecommends")><a href="index.cfm?method=product.listProductRecommends&productID=#URL.productID#" title="List existing products recommendations" class="SubNavLink<cfif Variables.doAction is "listProductRecommends">On</cfif>">Existing Product Recommendations</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProductRecommend")> | <a href="index.cfm?method=product.insertProductRecommend&productID=#URL.productID#" title="Add new product recommendation" class="SubNavLink<cfif Variables.doAction is "insertProductRecommend">On</cfif>">Add New Product Recommendation(s)</a></cfif>
</div><br>
</cfoutput>
