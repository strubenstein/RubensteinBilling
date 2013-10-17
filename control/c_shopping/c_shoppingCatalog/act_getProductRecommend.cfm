<!--- select products recommended by this product --->
<cfset Variables.displayProductRecommend = False>
<cfif qry_selectProduct.productHasRecommendation is 1>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductRecommendList" ReturnVariable="qry_selectProductRecommendList">
		<cfinvokeargument Name="productID_target" Value="#URL.productID#">
	</cfinvoke>

	<cfif qry_selectProductRecommendList.RecordCount is not 0>
		<cfset Variables.displayProductRecommend = True>
		<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, ValueList(qry_selectProductRecommendList.productID))>
		<cfset Variables.productID_getPrice = ListAppend(Variables.productID_getPrice, ValueList(qry_selectProductRecommendList.productID))>
		<cfloop Query="qry_selectProductRecommendList">
			<cfif qry_selectProductRecommendList.productID_parent is not 0>
				<cfset Variables.productID_parent_getPrice = ListAppend(Variables.productID_parent_getPrice, qry_selectProductRecommendList.productID_parent)>
				<cfset Variables.productID_getCategory = ListAppend(Variables.productID_getCategory, qry_selectProductRecommendList.productID_parent)>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
