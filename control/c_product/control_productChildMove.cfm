<cfif Not IsDefined("URL.productID_child") or Not Application.fn_IsIntegerPositive(URL.productID_child)>
	<cflocation url="#Variables.exitURL#&error_product=noChildProduct" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductChildList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
	<cfinvokeargument Name="queryOrderBy" Value="productChildOrder">
</cfinvoke>

<cfif qry_selectProductChildList.RecordCount is 0 or Not ListFind(ValueList(qry_selectProductChildList.productID), URL.productID_child)>
	<cflocation url="#Variables.exitURL#&error_product=invalidChildProduct" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Product" Method="switchProductChildOrder" ReturnVariable="isProductChildOrderUpdated">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productID_child" Value="#URL.productID_child#">
	<cfinvokeargument Name="productChildOrder_direction" Value="#Variables.doAction#">
</cfinvoke>

<cflocation url="#Variables.exitURL#&confirm_product=#URL.action#" AddToken="No">

