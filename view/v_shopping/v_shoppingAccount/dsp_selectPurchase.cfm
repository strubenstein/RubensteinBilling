<cfset Variables.totalQuantity = 0>
<cfset Variables.totalSubTotal = 0>
<cfset Variables.totalTax = 0>
<cfset Variables.totalTotal = 0>

<cfoutput>
<p class="SubTitle">Purchase - #DateFormat(qry_selectPurchase.invoiceDateClosed, "dddd, mmmm dd, yyyy")#</p>

<table border="0" cellspacing="0" cellpadding="4">
<tr class="TableHeader" valign="bottom">
	<th>Product ##</th>
	<td width="15">&nbsp;</td>
	<th>Product</th>
	<td width="15">&nbsp;</td>
	<th>Price</th>
	<td width="15">&nbsp;</td>
	<th>Quantity</th>
	<td width="15">&nbsp;</td>
	<th>Sub-Total</th>
</tr>
<cfloop Query="qry_selectPurchaseLineItemList">
	<tr class="MainText" valign="top">
	<td><cfif qry_selectPurchaseLineItemList.invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#qry_selectPurchaseLineItemList.invoiceLineItemProductID_custom#</cfif></td>
	<td>&nbsp;</td>
	<td>#qry_selectPurchaseLineItemList.invoiceLineItemName#</td>
	<td>&nbsp;</td>
	<td>#DollarFormat(qry_selectPurchaseLineItemList.invoiceLineItemPriceUnit)#</td>
	<td>&nbsp;</td>
	<td>#qry_selectPurchaseLineItemList.invoiceLineItemQuantity#</td>
	<td>&nbsp;</td>
	<td>#DollarFormat(qry_selectPurchaseLineItemList.invoiceLineItemSubTotal)#</td>
	</tr>
</cfloop>
<cfloop Query="qry_selectPaymentCreditsInCart"><!--- FileCustomized by Steven Rubenstein on 12/30/2004 to display payment credits --->
	<tr class="MainText" valign="top">
	<td><cfif qry_selectPaymentCreditsInCart.paymentCreditID_custom is "">&nbsp;<cfelse>#qry_selectPaymentCreditsInCart.paymentCreditID_custom#</cfif></td>
	<td>&nbsp;</td>
	<td>#qry_selectPaymentCreditsInCart.paymentCreditName#</td>
	<td>&nbsp;</td>
	<td>(#DollarFormat(qry_selectPaymentCreditsInCart.paymentCreditAmount)#)</td>
	<td>&nbsp;</td>
	<td>1</td>
	<td>&nbsp;</td>
	<td>(#DollarFormat(qry_selectPaymentCreditsInCart.paymentCreditAmount)#)</td>
	</tr>
</cfloop><!--- /FileCustomized --->
<tr class="MainText" height="30" valign="bottom">
	<td colspan="8" align="right"><b>Sub-Total:</b> </td>
	<td>#DollarFormat(qry_selectPurchase.invoiceTotalLineItem)#</td>
</tr>
<cfif qry_selectPurchase.invoiceTotalPaymentCredit is not 0>
	<tr class="MainText">
		<td colspan="8" align="right"><b>Credits:</b> </td>
		<td>(#DollarFormat(qry_selectPurchase.invoiceTotalPaymentCredit)#)</td>
	</tr>
</cfif>
<cfif qry_selectPurchase.invoiceTotalTax is not 0>
	<tr class="MainText">
		<td colspan="8" align="right"><b>Taxes:</b> </td>
		<td>#DollarFormat(qry_selectPurchase.invoiceTotalTax)#</td>
	</tr>
</cfif>
<cfif qry_selectPurchase.invoiceTotalShipping is not 0>
	<tr class="MainText">
		<td colspan="8" align="right"><b>Shipping Cost:</b> </td>
		<td>#DollarFormat(qry_selectPurchase.invoiceTotalShipping)#</td>
	</tr>
</cfif>
<tr class="MainText">
	<td colspan="8" align="right"><b>Total:</b> </td>
	<td>#DollarFormat(qry_selectPurchase.invoiceTotal)#</td>
</tr>
</table>

<cfif qry_selectPurchase.invoiceInstructions is not "">
	<br>Special Instructions:
	<table border="0" cellspacing="0" cellpadding="0" width="400"><tr><td class="MainText">
	#qry_selectPurchase.invoiceInstructions#
	</td></tr></table>
</cfif>
</cfoutput>
