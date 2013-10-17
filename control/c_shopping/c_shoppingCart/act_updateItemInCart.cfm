<cfif itemPositionInCart is 0>
	<cfset insertItemInCart(Arguments.productID, Arguments.invoiceLineItemPriceUnit, Arguments.priceID, Arguments.invoiceLineItemQuantity, Arguments.invoiceLineItemProductID_custom, Arguments.productParameterOptionID_list, Arguments.productParameterExceptionID)>
<cfelse>
	<cfif StructKeyExists(Arguments, "invoiceLineItemQuantity")>
		<cfset theShoppingCart[itemPositionInCart].invoiceLineItemQuantity = Arguments.invoiceLineItemQuantity>
	</cfif>
	<cfif StructKeyExists(Arguments, "priceID")>
		<cfset theShoppingCart[itemPositionInCart].priceID = Arguments.priceID>
	</cfif>
	<cfif StructKeyExists(Arguments, "invoiceLineItemPriceUnit")>
		<cfset theShoppingCart[itemPositionInCart].invoiceLineItemPriceUnit = Arguments.invoiceLineItemPriceUnit>
	</cfif>
	<cfif StructKeyExists(Arguments, "invoiceLineItemProductID_custom")>
		<cfset theShoppingCart[itemPositionInCart].invoiceLineItemProductID_custom = Arguments.invoiceLineItemProductID_custom>
	</cfif>
	<cfif StructKeyExists(Arguments, "productParameterOptionID_list")>
		<cfset theShoppingCart[itemPositionInCart].productParameterOptionID_list = Arguments.productParameterOptionID_list>
	</cfif>
	<cfif StructKeyExists(Arguments, "productParameterExceptionID")>
		<cfset theShoppingCart[itemPositionInCart].productParameterExceptionID = Arguments.productParameterExceptionID>
	</cfif>

	<cfset saveCartToSession(theShoppingCart)>
</cfif>
