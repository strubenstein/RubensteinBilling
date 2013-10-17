<cfoutput>
<div class="SubNav">
<cfif Application.fn_IsUserAuthorized("listProductParameters")><a href="index.cfm?method=product.listProductParameters&productID=#URL.productID#" title="View existing product parameters" class="SubNavLink<cfif Variables.doAction is "listProductParameters">On</cfif>">List Existing Parameters</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProductParameter")> | <a href="index.cfm?method=product.insertProductParameter&productID=#URL.productID#" title="Add new product parameter" class="SubNavLink<cfif Variables.doAction is "insertProductParameter">On</cfif>">Add New Parameter</a></cfif>
<cfif Application.fn_IsUserAuthorized("listProductParameterExceptions")> | <a href="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#" title="View existing product parameter exceptions" class="SubNavLink<cfif Variables.doAction is "listProductParameterExceptions">On</cfif>">List Existing Exceptions</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertProductParameterException")> | <a href="index.cfm?method=product.insertProductParameterException&productID=#URL.productID#" title="Add new product parameter exception" class="SubNavLink<cfif Variables.doAction is "insertProductParameterException">On</cfif>">Add New Exception</a></cfif>
</div><br>
</cfoutput>