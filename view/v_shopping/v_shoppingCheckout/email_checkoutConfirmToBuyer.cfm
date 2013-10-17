<cfmail
	From="#Variables.emailFrom#"
	To="""#qry_selectUser.firstName# #qry_selectUser.lastName#"" <#qry_selectUser.email#>"
	Subject="#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailSubject]#"
	CC="#Trim(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailCC])#"
	BCC="#Trim(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailBCC])#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="html">
<cfmailparam Name="Reply-To" Value="#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailReplyTo]#">
<html><body bgcolor="white">
<cfif qry_selectContentCompanyList.contentCompanyHtml[Variables.contentCodeRow.confirmBuyerEmailHeader] is 1>
	#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailHeader]#
<cfelse>
	#Replace(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailHeader], Chr(10), "<br>", "ALL")#
</cfif>

<p><b>Total: #DollarFormat(Variables.invoiceTotal)#</b></p>

<table border="1" cellspacing="2" cellpadding="2">
<tr valign="bottom" bgcolor="dddddd">
	<th>ID</th>
	<th>Product</th>
	<th>Price</th>
	<th>Quantity</th>
</tr>
<cfloop Index="count" From="1" To="#ArrayLen(Variables.theShoppingCart)#">
	<tr valign="top">
	<td><cfif Variables.theShoppingCart[count].invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#Variables.theShoppingCart[count].invoiceLineItemProductID_custom#</cfif></td>
	<td>#qry_selectProductsInCart.productLanguageLineItemName[count]#<cfif qry_selectProductsInCart.productParameters[count] is not ""><br>#qry_selectProductsInCart.productParameters[count]#</cfif></td>
	<td>#DollarFormat(Variables.theShoppingCart[count].invoiceLineItemPriceUnit)#</td>
	<td>#Variables.theShoppingCart[count].invoiceLineItemQuantity#</td>
	</tr>
</cfloop>
<cfloop Query="qry_selectPaymentCreditsInCart">
	<tr valign="top">
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

<p>
Shipping Information:<br>
<cfif qry_selectInvoice.invoiceShippingMethod is not "">Shipping Method: #qry_selectInvoice.invoiceShippingMethod#<br><br></cfif>
#qry_selectShippingAddressList.addressName#<br>
#qry_selectShippingAddressList.address#<br>
<cfif qry_selectShippingAddressList.address2 is not "">#qry_selectShippingAddressList.address2#<br></cfif>
<cfif qry_selectShippingAddressList.address3 is not "">#qry_selectShippingAddressList.address3#<br></cfif>
#qry_selectShippingAddressList.city#, #qry_selectShippingAddressList.state# #qry_selectShippingAddressList.zipCode#<cfif qry_selectShippingAddressList.zipCodePlus4 is not "">-#qry_selectShippingAddressList.zipCodePlus4#</cfif>
<cfif Not ListFind("US,USA,United States", qry_selectShippingAddressList.country) and qry_selectShippingAddressList.country is not ""><br>#qry_selectShippingAddressList.country#</cfif>
</p>

<cfif qry_selectInvoice.invoiceInstructions is not ""><p>Special Instructions:<br>#qry_selectInvoice.invoiceInstructions#</p></cfif>

<cfif qry_selectContentCompanyList.contentCompanyHtml[Variables.contentCodeRow.confirmBuyerEmailFooter] is 1>
	#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailFooter]#
<cfelse>
	#Replace(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailFooter], ",", "<br>", "ALL")#
</cfif>

</body></html>
</cfmail>

