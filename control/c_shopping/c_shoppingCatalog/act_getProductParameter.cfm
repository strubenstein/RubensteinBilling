<!--- select product parameter(s) if necessary --->
<cfset Variables.displayProductParameter = False>
<cfset Variables.displayProductParameterException = False>

<cfif qry_selectProduct.productHasParameter is 1 or qry_selectProduct.productID_parent is not 0>
	<cfif qry_selectProduct.productID_parent is 0>
		<cfset Variables.productID_parameter = URL.productID>
	<cfelse>
		<cfset Variables.productID_parameter = URL.productID & "," & qry_selectProduct.productID_parent>
	</cfif>

	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductParameterList" ReturnVariable="qry_selectProductParameterList">
		<cfinvokeargument Name="productID" Value="#Variables.productID_parameter#">
	</cfinvoke>

	<cfif qry_selectProductParameterList.RecordCount is not 0>
		<cfset Variables.displayProductParameter = True>
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductParameterOptionList" ReturnVariable="qry_selectProductParameterOptionList">
			<cfinvokeargument Name="productParameterID" Value="#ValueList(qry_selectProductParameterList.productParameterID)#">
		</cfinvoke>

		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductParameterExceptionList" ReturnVariable="qry_selectProductParameterExceptionList">
			<cfinvokeargument Name="productID" Value="#Variables.productID_parameter#">
		</cfinvoke>

		<cfif qry_selectProductParameterExceptionList.RecordCount is not 0>
			<cfset Variables.displayProductParameterException = True>
		</cfif>
	</cfif>
</cfif>
