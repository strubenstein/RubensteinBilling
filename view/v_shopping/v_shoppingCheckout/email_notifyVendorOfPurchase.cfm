<cfmail
	From="#Variables.emailFrom#"
	To="""#qry_selectUserList.firstName[Variables.userRow]# #qry_selectUserList.lastName[Variables.userRow]#"" <#qry_selectUserList.email[Variables.userRow]#>"
	Subject="#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailSubject]#"
	CC="#Trim(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailCC])#"
	BCC="#Trim(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailBCC])#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#"
	Type="html">
<cfmailparam Name="Reply-To" Value="#qry_selectContentCompanyList.contentCompanyHtml[Variables.contentCodeRow.confirmVendorEmailReplyTo]#">
<html><body bgcolor="white">
<cfif qry_selectContentCompanyList.contentCompanyHtml[Variables.contentCodeRow.confirmVendorEmailHeader] is 1>
	#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailHeader]#
<cfelse>
	#Replace(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailHeader], Chr(10), "<br>", "ALL")#
</cfif>

<p>Customer:<br>
<cfif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<br></cfif>
#qry_selectUser.firstName# #qry_selectUser.lastName#<br>
<a href="mailto:#qry_selectUser.email#">#qry_selectUser.email#</a>
</p>

<table border="1" cellspacing="2" cellpadding="2">
<tr valign="bottom" bgcolor="dddddd">
	<th>ID</th>
	<th>Product</th>
	<th>Price</th>
	<th>Quantity</th>
</tr>
<cfloop Query="qry_selectVendorsFromInvoice" StartRow="#Variables.lineItemRowBegin#" EndRow="#Variables.lineItemRowEnd#">
	<tr valign="top">
	<td><cfif qry_selectVendorsFromInvoice.invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#qry_selectVendorsFromInvoice.invoiceLineItemProductID_custom#</cfif></td>
	<td>#qry_selectVendorsFromInvoice.invoiceLineItemName#<!--- <cfif qry_selectProductsInCart.productParameters[count] is not ""><br>#qry_selectProductsInCart.productParameters[count]#</cfif> ---></td>
	<td>#DollarFormat(qry_selectVendorsFromInvoice.invoiceLineItemPriceUnit)#</td>
	<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectVendorsFromInvoice.invoiceLineItemQuantity)#</td>
	</tr>
</cfloop>
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

<cfif qry_selectContentCompanyList.contentCompanyHtml[Variables.contentCodeRow.confirmVendorEmailFooter] is 1>
	#qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailFooter]#
<cfelse>
	#Replace(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmVendorEmailFooter], ",", "<br>", "ALL")#
</cfif>

</body></html>
</cfmail>

