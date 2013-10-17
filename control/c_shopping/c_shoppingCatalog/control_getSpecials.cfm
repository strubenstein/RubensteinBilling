<!--- select 5 random special items --->
<cfset URL.categoryID = 63>
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList" ReturnVariable="qry_selectProductList">
	<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="queryOrderBy" Value="RANDOM">
	<cfinvokeargument Name="queryPage" Value="1">
	<cfinvokeargument Name="queryDisplayPerPage" Value="6">
	<cfinvokeargument Name="queryDisplayProductImage" Value="True">
</cfinvoke>

<cfif qry_selectProductList.RecordCount is 0>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductList" ReturnVariable="qry_selectProductList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="queryOrderBy" Value="RANDOM">
		<cfinvokeargument Name="queryPage" Value="1">
		<cfinvokeargument Name="queryDisplayPerPage" Value="5">
		<cfinvokeargument Name="queryDisplayProductImage" Value="True">
	</cfinvoke>
</cfif>

<!--- select custom prices for products in this category --->
<cfset Variables.productID_getPrice = ValueList(qry_selectProductList.productID)>
<cfset Variables.productID_parent_getPrice = "">
<cfset Variables.categoryID_getPrice = URL.categoryID>
<cfset Variables.categoryID_parent_getPrice = "">

<!--- determine whether each product has a custom price --->
<cfinclude template="act_findProductPrice.cfm">

