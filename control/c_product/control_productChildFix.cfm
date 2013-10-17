<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductChildList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
	<cfinvokeargument Name="queryOrderBy" Value="productChildOrder">
</cfinvoke>

<cfif qry_selectProductChildList.RecordCount is 0>
	<cflocation url="#Variables.exitURL#&error_product=noChildProduct" AddToken="No">
</cfif>

<cfloop Query="qry_selectProductChildList">
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
		<cfinvokeargument Name="productID" Value="#qry_selectProductChildList.productID#">
		<cfinvokeargument Name="productChildOrder" Value="#CurrentRow#">
	</cfinvoke>
</cfloop>

<cflocation url="#Variables.exitURL#&confirm_product=#URL.action#" AddToken="No">

