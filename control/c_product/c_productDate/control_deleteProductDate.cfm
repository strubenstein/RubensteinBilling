<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductDateDelete") and IsDefined("Form.okDelete") and IsDefined("Form.productDateID")>
	<cfloop Index="dateID" List="#Form.productDateID#">
		<cfif Not ListFind(ValueList(qry_selectProductDateList.productDateID), dateID)>
			<cflocation url="index.cfm?method=product.listProductDates&error_product=noDate" AddToken="No">
		</cfif>
	</cfloop>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.ProductDate" Method="deleteProductDate" ReturnVariable="isProductDateDeleted">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productDateID" Value="#Form.productDateID#">
</cfinvoke>

<cflocation url="index.cfm?method=product.listProductDates&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
