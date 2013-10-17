<cfif Not IsDefined("URL.productID") and IsDefined("isFormSubmitted")>
	<cfloop INDEX="nextVar" LIST="#StructKeyList(URL)#">
		<cfif REFindNoCase("product[0-9]", nextVar)>
			<cfset URL.productID = REReplaceNoCase(ListFirst(nextVar, "."), "[^0-9]", "", "ALL")>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfif IsDefined("URL.productID") and IsDefined("URL.quantity#URL.productID#") and Application.fn_IsIntegerPositive(URL["quantity#URL.productID#"])>
		<cfset URL.quantity = URL["quantity#URL.productID#"]>
	</cfif>
</cfif>

<cfparam Name="URL.productID" Default="0">
<cfparam Name="URL.quantity" Default="1">

<cfinclude template="../c_shoppingCatalog/control_getProduct.cfm">

<!--- if parameters, verify that all valid parameters were submitted, check for exclude/price exceptions and generate custom ID --->
<cfif URL.error_shopping is "">
	<cfset Variables.productParameterOptionID_list = "">
	<cfset Variables.productParameterExceptionID = 0>
	<cfset Variables.productParameterExceptionPricePremium = 0>
	<cfset Variables.invoiceLineItemProductID_custom = qry_selectProduct.productID_custom>
	<cfset Variables.invoiceLineItemProductID_customArray = ArrayNew(1)>
</cfif>

<cfif URL.error_shopping is "" and Variables.displayProductParameter is True and qry_selectProduct.productChildType is not 2>
	<cfset temp = ArraySet(Variables.invoiceLineItemProductID_customArray, 1, qry_selectProductParameterList.RecordCount, "")>
	<cfinclude template="act_validateParameters.cfm">
</cfif>

<cfif URL.error_shopping is not "">
	<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
<cfelse>
	<cfif Not ArrayIsEmpty(Variables.invoiceLineItemProductID_customArray)>
		<cfloop Index="count" From="1" To="#ArrayLen(Variables.invoiceLineItemProductID_customArray)#">
			<cfset Variables.invoiceLineItemProductID_custom = Variables.invoiceLineItemProductID_custom & Variables.invoiceLineItemProductID_customArray[count]>
		</cfloop>
	</cfif>

	<cfinclude template="act_determinePrice.cfm">

	<!--- if parameter price premium, add to price --->
	<cfif Variables.productParameterExceptionPricePremium is not 0>
		<cfset Variables.price = Variables.price + Variables.productParameterExceptionPricePremium>
	</cfif>

	<!--- add to cart --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="insertItemInCart">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="invoiceLineItemQuantity" Value="#URL.quantity#"><!--- quantity --->
		<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#Variables.price#"><!--- price --->
		<cfinvokeargument Name="priceID" Value="#Variables.priceID#">
		<cfinvokeargument Name="invoiceLineItemProductID_custom" Value="#Variables.invoiceLineItemProductID_custom#">
		<cfinvokeargument Name="productParameterOptionID_list" Value="#Variables.productParameterOptionID_list#">
		<cfinvokeargument Name="productParameterExceptionID" Value="#Variables.productParameterExceptionID#">
	</cfinvoke>

	<cfif Not IsDefined("Form.addToCartMultiple") or (IsDefined("Variables.doNotDisplayCart") and Variables.doNotDisplayCart is False)>
		<cfinclude template="../../../view/v_shopping/v_shoppingCart/confirm_addToCart.cfm">
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="viewCartItemList" />
	</cfif>
</cfif>