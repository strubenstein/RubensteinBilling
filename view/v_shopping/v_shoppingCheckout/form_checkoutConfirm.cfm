<cfoutput>

<cfif Not IsDefined("Form.submitCheckoutConfirm")>
	<form method="post" name="checkoutConfirm" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">

	<p class="SubTitle">Confirm Your Order</p>
	<p class="MainText">Please confirm your order details below and click the submit button to confirm your order.</p>

	<p><table width="600"><tr><td align="center">
	<input type="submit" name="submitCheckoutConfirm" value="Confirm Order">
	</td></tr></table></p>
<cfelse>
	<p class="ConfirmationMessage">Your order has been successfully processed.</p>
	<p class="SubTitle">Order Receipt - #DateFormat(Now(), "mm/dd/yyyy")#</p>
	<p class="MainText"><b>Please print receipt for your own records.</b></p>
</cfif>

<table border="0" cellspacing="0" cellpadding="4">
<tr class="TableHeader" valign="bottom">
	<th>Code</th>
	<th>Product Name</th>
	<th>Price</th>
	<th>Quantity</th>
</tr>

<cfloop Index="count" From="1" To="#ArrayLen(Variables.theShoppingCart)#">
	<tr class="TableText" valign="top">
	<td><cfif Variables.theShoppingCart[count].invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#Variables.theShoppingCart[count].invoiceLineItemProductID_custom#</cfif></td>
	<td>#qry_selectProductsInCart.productLanguageLineItemName[count]#<cfif qry_selectProductsInCart.productParameters[count] is not ""><br>#qry_selectProductsInCart.productParameters[count]#</cfif></td>
	<td>#DollarFormat(Variables.theShoppingCart[count].invoiceLineItemPriceUnit)#</td>
	<td>#Variables.theShoppingCart[count].invoiceLineItemQuantity#</td>
	</tr>
</cfloop>

<cfloop Query="qry_selectPaymentCreditsInCart">
	<tr class="TableText" valign="top">
	<td><cfif qry_selectPaymentCreditsInCart.paymentCreditID_custom is "">&nbsp;<cfelse>#qry_selectPaymentCreditsInCart.paymentCreditID_custom#</cfif></td>
	<td>#qry_selectPaymentCreditsInCart.paymentCreditName#</td>
	<td>(#DollarFormat(qry_selectPaymentCreditsInCart.paymentCreditAmount)#)</td>
	<td>1</td>
	</tr>
</cfloop>

<cfif Variables.invoiceTotalShipping is not 0>
	<tr class="TableText">
	<td>&nbsp;</td>
	<td>Shipping Costs</td>
	<td>#DollarFormat(Variables.invoiceTotalShipping)#</td>
	<td>&nbsp;</td>
	</tr>
</cfif>

<cfif Variables.invoiceTotalTax is not 0>
	<tr class="TableText">
	<td>&nbsp;</td>
	<td>Sales Tax</td>
	<td>#DollarFormat(Variables.invoiceTotalTax)#</td>
	<td>&nbsp;</td>
	</tr>
</cfif>
</table>

<p class="MainText"><b>Total: #DollarFormat(Variables.invoiceTotal)#</b></p>

<table border="0" cellspacing="0" cellpadding="4">
<tr valign="bottom">
	<th class="TableHeader">Shipping Address</th>
	<th width="25" rowspan="2">&nbsp;</th>
	<th class="TableHeader">Billing Address</th>
	<th width="25" rowspan="2">&nbsp;</th>
	<th class="TableHeader">Credit Card Info</th>
</tr>
<tr class="TableText" valign="top">
	<td>
		#qry_selectShippingAddressList.addressName#<br>
		#qry_selectShippingAddressList.address#<br>
		<cfif qry_selectShippingAddressList.address2 is not "">#qry_selectShippingAddressList.address2#<br></cfif>
		<cfif qry_selectShippingAddressList.address3 is not "">#qry_selectShippingAddressList.address3#<br></cfif>
		#qry_selectShippingAddressList.city#, #qry_selectShippingAddressList.state# #qry_selectShippingAddressList.zipCode#<cfif qry_selectShippingAddressList.zipCodePlus4 is not "">-#qry_selectShippingAddressList.zipCodePlus4#</cfif>
		<cfif Not ListFind("US,USA,United States", qry_selectShippingAddressList.country) and qry_selectShippingAddressList.country is not ""><br>#qry_selectShippingAddressList.country#</cfif>
	</td>
	<td>
		<cfif qry_selectBillingAddressList.addressName is not "">#qry_selectBillingAddressList.addressName#<br></cfif>
		#qry_selectBillingAddressList.address#<br>
		<cfif qry_selectBillingAddressList.address2 is not "">#qry_selectBillingAddressList.address2#<br></cfif>
		<cfif qry_selectBillingAddressList.address3 is not "">#qry_selectBillingAddressList.address3#<br></cfif>
		#qry_selectBillingAddressList.city#, #qry_selectBillingAddressList.state# #qry_selectBillingAddressList.zipCode#<cfif qry_selectBillingAddressList.zipCodePlus4 is not "">-#qry_selectBillingAddressList.zipCodePlus4#</cfif>
		<cfif Not ListFind("US,USA,United States", qry_selectBillingAddressList.country) and qry_selectBillingAddressList.country is not ""><br>#qry_selectBillingAddressList.country#</cfif>
	</td>
	<td>
		<cfif qry_selectBillingAddressList.creditCardName is not "">Name: #qry_selectBillingAddressList.creditCardName#</cfif>
		<cfif qry_selectBillingAddressList.creditCardType is not ""><br>Type: #qry_selectBillingAddressList.creditCardType#</cfif>
		<cfif qry_selectBillingAddressList.creditCardNumber is not ""><br>Card ##: **** #Right(qry_selectBillingAddressList.creditCardNumber, 4)#</cfif>
		<cfif qry_selectBillingAddressList.creditCardExpirationMonth is not "" and qry_selectBillingAddressList.creditCardExpirationYear is not "">
			<br>Exp. Date: #qry_selectBillingAddressList.creditCardExpirationMonth#/#qry_selectBillingAddressList.creditCardExpirationYear#
		</cfif>
	</td>
</tr>
</table>

<p>
<cfif qry_selectInvoice.invoiceShippingMethod is not "">Shipping Method: #qry_selectInvoice.invoiceShippingMethod#<br></cfif>
<cfif qry_selectInvoice.invoiceInstructions is not "">
	Special Instructions:
	<table border="0" cellspacing="0" cellpadding="0" width="400"><tr><td class="MainText">
	#qry_selectInvoice.invoiceInstructions#
	</td></tr></table>
</cfif>
</p>

<cfif Not IsDefined("Form.submitCheckoutConfirm")>
	<p><table width="600"><tr><td align="center">
	<input type="submit" name="submitCheckoutConfirm" value="Confirm Order">
	</td></tr></table></p>
	</form>
</cfif>
</cfoutput>

