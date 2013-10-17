<cfif getItemPositionInCart(Arguments.productID, Arguments.productParameterOptionID_list) is 0>
	<cfset newCartItem.productID = Arguments.productID>
	<cfset newCartItem.invoiceLineItemQuantity = Arguments.invoiceLineItemQuantity>
	<cfset newCartItem.priceID = Arguments.priceID>
	<cfset newCartItem.invoiceLineItemPriceUnit = Arguments.invoiceLineItemPriceUnit>
	<cfset newCartItem.invoiceLineItemProductID_custom = Arguments.invoiceLineItemProductID_custom>
	<cfset newCartItem.productParameterOptionID_list = Arguments.productParameterOptionID_list>
	<cfset newCartItem.productParameterExceptionID = Arguments.productParameterExceptionID>

	<cfset theShoppingCart[ArrayLen(Variables.theShoppingCart) + 1] = newCartItem>
	<cfset saveCartToSession(theShoppingCart)>
</cfif>
