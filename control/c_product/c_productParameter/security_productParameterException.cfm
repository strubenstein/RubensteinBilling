<cfif Variables.doAction is "insertProductParameterException">
	<cfset URL.productParameterExceptionID = 0>
<cfelseif Not IsDefined("URL.productParameterExceptionID") or Not Application.fn_IsIntegerPositive(URL.productParameterExceptionID)>
	<cflocation url="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#&error_product=invalidProductParameterException" AddToken="No">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterException" ReturnVariable="qry_selectProductParameterException">
		<cfinvokeargument Name="productParameterExceptionID" Value="#URL.productParameterExceptionID#">
	</cfinvoke>

	<cfif qry_selectProductParameterException.RecordCount is 0 or qry_selectProductParameterException.productID is not URL.productID>
		<cflocation url="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#&error_product=invalidProductParameterException" AddToken="No">
	</cfif>
</cfif>
