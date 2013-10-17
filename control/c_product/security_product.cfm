<cfif Not Application.fn_IsIntegerNonNegative(URL.productID)>
	<cflocation url="index.cfm?method=product.listProducts&error_product=noProduct" AddToken="No">
<cfelseif URL.productID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isProductPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=product.listProducts&error_product=invalidProduct" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listProducts,insertProduct", Variables.doAction)>
	<cflocation url="index.cfm?method=product.listProducts&error_product=noProduct" AddToken="No">
</cfif>
