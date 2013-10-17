<!--- 
<cfset Session.cobrandID = 0>
<cfset Session.affiliateID = 0>
<cfset Session.userID = 0>
<cfset Session.companyID = 0>
<cfset Session.groupID = 0>

<cfset Session.shoppingCart = ArrayNew(1)>
<cfset Session.shoppingCart[1] = StructNew()>
<cfset Session.shoppingCart[1].productID = 0>
<cfset Session.shoppingCart[1].priceID = 0>
<cfset Session.shoppingCart[1].invoiceLineItemPriceUnit = 0>
<cfset Session.shoppingCart[1].invoiceLineItemQuantity = 0>
<cfset Session.shoppingCart[1].invoiceLineItemProductID_custom = "">
<cfset Session.shoppingCart[1].productParameterOptionID_list = "">
<cfset Session.shoppingCart[1].productParameterExceptionID = 0>

<cfset Session.shoppingCart = Arguments.shoppingCart>
--->

<cfcomponent DisplayName="ShoppingCart" Hint="Manages adding, updating removing and listing items in shopping cart.">

<cffunction Name="checkCartExists" Access="public" Output="No" ReturnType="any" Hint="Creates shopping cart session array variable if does not exist.">
	<cfif Not StructKeyExists(Session, "shoppingCart") or Not IsArray(Session.shoppingCart)>
		<cflock Scope="Session" Timeout="10">
			<cfset Session.shoppingCart = ArrayNew(1)>
		</cflock>
	</cfif>

	<cfreturn Session.shoppingCart>
</cffunction>

<cffunction Name="saveCartToSession" Access="public" Output="No" Hint="Saves updated shopping cart as session variable">
	<cfargument Name="shoppingCart" Type="any" Required="Yes">

	<cflock Scope="Session" Timeout="10">
		<cfset Session.shoppingCart = Arguments.shoppingCart>
	</cflock>
</cffunction>

<cffunction Name="insertItemInCart" Access="public" Output="No" Hint="Adds item to shopping cart.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemPriceUnit" Type="numeric" Required="Yes"><!--- price --->
	<cfargument Name="priceID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemQuantity" Type="numeric" Required="No" Default="1"><!--- quantity --->
	<cfargument Name="invoiceLineItemProductID_custom" Type="string" Required="No" Default="">
	<cfargument Name="productParameterOptionID_list" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="No" Default="0">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var newCartItem = StructNew()>

	<cfinclude template="act_insertItemInCart.cfm">
</cffunction>

<cffunction Name="updateItemInCart" Access="public" Output="No" Hint="Updates existing item in shopping cart. Add items if not already there.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemPriceUnit" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemQuantity" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemProductID_custom" Type="string" Required="No">
	<cfargument Name="productParameterOptionID_list" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="No">
	<!--- priceStageVolumeDollarOrQuantity, avPrice.priceStageVolumeStep --->

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var itemPositionInCart = getItemPositionInCart(Arguments.productID, Arguments.productParameterOptionID_list)>

	<cfinclude template="act_updateItemInCart.cfm">
</cffunction>

<cffunction Name="deleteItemFromCart" Access="public" Output="No" Hint="Removes item from shopping cart.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID_list" Type="string" Required="No" Default="">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var itemPositionInCart = getItemPositionInCart(Arguments.productID, Arguments.productParameterOptionID_list)>

	<cfif itemPositionInCart is not 0>
		<cfset temp = ArrayDeleteAt(theShoppingCart, itemPositionInCart)>
		<cfset saveCartToSession(theShoppingCart)>
	</cfif>
</cffunction>

<cffunction Name="deleteAllItemsFromCart" Access="public" Output="No" Hint="Removes all items from shopping cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfif ArrayLen(theShoppingCart) is not 0>
		<cfset temp = ArrayClear(theShoppingCart)>
		<cfset saveCartToSession(theShoppingCart)>
	</cfif>
</cffunction>

<cffunction Name="getItemPositionInCart" Access="public" Output="No" ReturnType="numeric" Hint="Locates position of item in shopping cart.">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID_list" Type="string" Required="No" Default="">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var currentArrayPosition = 0>
	<cfset var isParametersMatch = True>

	<cfinclude template="act_getItemPositionInCart.cfm">
	<cfreturn currentArrayPosition>
</cffunction>

<cffunction Name="selectProductsInCart" Access="public" Output="No" ReturnType="query" Hint="Displays items in shopping cart.">
	<cfargument Name="languageID" Type="string" Required="No" Default="">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var productID_list = "">
	<cfset var productParameterOptionID_list = "">
	<cfset var qry_selectProductsInCart = QueryNew("blank")>
	<cfset var parameterArray = ArrayNew(1)>
	<cfset var cartColumnList = "">
	<cfset var qry_selectProductsInCart_cartOrder = QueryNew("blank")>
	<cfset var productRow = 0>
	<cfset var thisCount = 0>
	<cfset var qry_selectProductParameterOptionsInCart = QueryNew("blank")>
	<cfset var parameterValueList = "">
	<cfset var optionRow = 0>

	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfset productID_list = ListAppend(productID_list, theShoppingCart[count].productID)>
		<cfif theShoppingCart[count].productParameterOptionID_list is not "">
			<cfset productParameterOptionID_list = ListAppend(productParameterOptionID_list, theShoppingCart[count].productParameterOptionID_list)>
		</cfif>
	</cfloop>

	<cfif productID_list is "">
		<cfset productID_list = 0>
	</cfif>
	<cfinclude template="qry_selectProductsInCart.cfm">

	<cfif qry_selectProductsInCart.RecordCount is 0 or ArrayLen(theShoppingCart) is 0>
		<cfif qry_selectProductsInCart.RecordCount is not 0>
			<cfset temp = ArraySet(parameterArray, 1, qry_selectProductsInCart.RecordCount, "")>
		</cfif>
		<cfset temp = QueryAddColumn(qry_selectProductsInCart, "productParameters", parameterArray)>

		<cfreturn qry_selectProductsInCart>
	<cfelse>
		<cfinclude template="act_selectProductsInCart.cfm">
		<cfreturn qry_selectProductsInCart_cartOrder>
	</cfif>
</cffunction>

<cffunction Name="viewCartItemList" Access="public" ReturnType="boolean" Hint="Displays items in shopping cart.">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="displayQuantityForm" Type="boolean" Required="No" Default="True">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var qry_selectProductsInCart = selectProductsInCart()>
	<cfset var qry_selectPaymentCreditsInCart = selectPaymentCreditsInCart()>
	<cfset var invoiceTotalShipping = getInvoiceTotalShippingInCart()>
	<cfset var invoiceTotalTax = getInvoiceTotalTaxInCart()>
	<cfset var invoiceTotalLineItem = getInvoiceTotalLineItemInCart()>
	<cfset var invoiceTotalPaymentCredit = getInvoiceTotalPaymentCreditInCart()>
	<cfset var invoiceTotal = invoiceTotalLineItem + invoiceTotalTax + invoiceTotalShipping - invoiceTotalPaymentCredit>

	<cfif Arguments.displayQuantityForm is True>
		<cfinclude template="../../../view/v_shopping/v_shoppingCart/form_selectProductsInCart.cfm">
	<cfelse>
		<cfinclude template="../../../view/v_shopping/v_shoppingCart/dsp_selectProductsInCart.cfm">
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="getCartUniqueItemCount" Access="public" Output="No" ReturnType="numeric" Hint="Returns number of unique items in shopping cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfreturn ArrayLen(theShoppingCart)>
</cffunction>

<cffunction Name="getCartTotalItemQuantity" Access="public" Output="No" ReturnType="numeric" Hint="Returns total number of items in shopping cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var totalQuantity = 0>

	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfset totalQuantity = totalQuantity + theShoppingCart[count].invoiceLineItemQuantity>
	</cfloop>
	<cfreturn totalQuantity>
</cffunction>

<cffunction Name="getInvoiceTotalInCart" Access="public" Output="No" ReturnType="numeric" Hint="Returns total price of items in shopping cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var invoiceTotal = getInvoiceTotalLineItemInCart() + getInvoiceTotalTaxInCart() + getInvoiceTotalShippingInCart() - getInvoiceTotalPaymentCreditInCart()>
	<cfreturn invoiceTotal>
</cffunction>

<cffunction Name="getInvoiceTotalLineItemInCart" Access="public" Output="No" ReturnType="numeric" Hint="Returns total of line items in shopping cart.">
	<cfset var theShoppingCart = checkCartExists()>

	<!--- assumes no step volume discount pricing --->
	<cfset var invoiceTotalLineItem = 0>
	<cfloop Index="count" From="1" To="#ArrayLen(Variables.theShoppingCart)#">
		<cfset invoiceTotalLineItem = invoiceTotalLineItem + (theShoppingCart[count].invoiceLineItemPriceUnit * theShoppingCart[count].invoiceLineItemQuantity)>
	</cfloop>

	<cfreturn invoiceTotalLineItem>
</cffunction>

<cffunction Name="saveCartToDatabase" Access="public" Output="No" ReturnType="numeric" Hint="Saves cart to database.">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="No" Default="0">

	<cfset var theShoppingCart = checkCartExists()>
	<cfset var qry_selectProductsInCart = QueryNew("blank")>
	<cfset var realInvoiceID = Arguments.invoiceID>
	<cfset var invoiceLineItemTotal = 0>
	<cfset var invoiceLineItemName = "">
	<cfset var invoiceTotalLineItem = 0>
	<cfset var invoiceTotalPaymentCredit = 0>
	<cfset var invoiceTotalTax = 0>
	<cfset var invoiceTotalShipping = 0>
	<cfset var invoiceTotal = 0>

	<cfinclude template="act_saveCartToDatabase.cfm">
	<cfreturn realInvoiceID>
</cffunction>

<cffunction Name="selectPaymentCreditsInCart" Access="public" Output="No" ReturnType="query" Hint="Returns query of all payment credits to add to cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var qry_selectPaymentCreditsInCart = QueryNew("paymentCategoryID,paymentCreditName,paymentCreditAmount,paymentCreditID_custom")>
	<cfset var paymentCreditStruct = StructNew()>
	<cfset var realPaymentCategoryID = 0>

	<cfinclude template="act_selectPaymentCreditsInCart.cfm">
	<cfreturn qry_selectPaymentCreditsInCart>
</cffunction>

<cffunction Name="getInvoiceTotalPaymentCreditInCart" Access="public" Output="No" ReturnType="numeric" Hint="Returns total of all payment credits in cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var invoiceTotalPaymentCredit = 0>
	<cfset var qry_selectPaymentCreditsInCart = selectPaymentCreditsInCart()>

	<cfif qry_selectPaymentCreditsInCart.RecordCount is not 0>
		<cfloop Query="qry_selectPaymentCreditsInCart">
			<cfset invoiceTotalPaymentCredit = invoiceTotalPaymentCredit + qry_selectPaymentCreditsInCart.paymentCreditAmount>
		</cfloop>
	</cfif>

	<cfreturn invoiceTotalPaymentCredit>
</cffunction>

<cffunction Name="getInvoiceTotalTaxInCart" Access="public" Output="No" ReturnType="numeric" Hint="Returns total of all taxes for all items in cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var invoiceTotalTax = 0>
	<cfset var customerIsTaxed = False>
	<cfset var totalShipped = 0>
	<cfset var qry_selectPaymentCreditsInCart = QueryNew("blank")>

	<cfinclude template="act_getInvoiceTotalTaxInCart.cfm">
	<cfreturn Variables.invoiceTotalTax>
</cffunction>

<cffunction Name="getInvoiceTotalShippingInCart" Access="public" Output="No" ReturnType="numeric" Hint="Returns total shipping costs for all items in cart.">
	<cfset var theShoppingCart = checkCartExists()>
	<cfset var quantityShipped = 0>
	<cfset var invoiceTotalShipping = 0>

	<cfinclude template="act_getInvoiceTotalShippingInCart.cfm">
	<cfreturn Variables.invoiceTotalShipping>
</cffunction>

</cfcomponent>

