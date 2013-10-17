<cfif Not Application.fn_IsIntegerNonNegative(URL.productParameterID)>
	<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&error_product=noProductParameter" AddToken="No">
<cfelseif URL.productParameterID is not 0>
	<cfif Not ListFind(ValueList(qry_selectProductParameterList.productParameterID), URL.productParameterID)>
		<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&error_product=invalidProductParameter" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listProductParameters,insertProductParameter,listProductParameterExceptions,insertProductParameterException,updateProductParameterException,updateProductParameterExceptionStatus", Variables.doAction)>
	<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&error_product=noProductParameter" AddToken="No">
</cfif>

