<!--- Inserts product into categories. Separate file so can be called from extended product form --->
<cfloop Index="loopCategoryID" List="#Form.categoryID_insert#">
	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="insertProductCategory" ReturnVariable="isProductCategoryInserted">
		<cfinvokeargument Name="categoryID" Value="#loopCategoryID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productCategoryStatus" Value="1">
		<cfif Not IsDate(Form["productCategoryDateBegin#loopCategoryID#"])>
			<cfinvokeargument Name="productCategoryDateBegin" Value="#CreateODBCDateTime(Now())#">
		<cfelse>
			<cfinvokeargument Name="productCategoryDateBegin" Value="#Form["productCategoryDateBegin#loopCategoryID#"]#">
		</cfif>
		<cfif IsDate(Form["productCategoryDateEnd#loopCategoryID#"])>
			<cfinvokeargument Name="productCategoryDateEnd" Value="#Form["productCategoryDateEnd#loopCategoryID#"]#">
		</cfif>
	</cfinvoke>
</cfloop>

<cfloop Index="loopCategoryID" List="#Form.categoryID_updateStatusTrue#">
	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="updateProductCategory" ReturnVariable="isProductCategoryUpdated">
		<cfinvokeargument Name="categoryID" Value="#loopCategoryID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productCategoryStatus" Value="1">
		<cfif Not IsDate(Form["productCategoryDateBegin#loopCategoryID#"])>
			<cfinvokeargument Name="productCategoryDateBegin" Value="#CreateODBCDateTime(Now())#">
		<cfelse>
			<cfinvokeargument Name="productCategoryDateBegin" Value="#Form["productCategoryDateBegin#loopCategoryID#"]#">
		</cfif>
		<cfif IsDate(Form["productCategoryDateEnd#loopCategoryID#"])>
			<cfinvokeargument Name="productCategoryDateEnd" Value="#Form["productCategoryDateEnd#loopCategoryID#"]#">
		</cfif>
	</cfinvoke>
</cfloop>

<cfloop Index="loopCategoryID" List="#Form.categoryID_updateStatusFalse#">
	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="updateProductCategory" ReturnVariable="isProductCategoryUpdated">
		<cfinvokeargument Name="categoryID" Value="#loopCategoryID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productCategoryStatus" Value="0">
	</cfinvoke>
</cfloop>
