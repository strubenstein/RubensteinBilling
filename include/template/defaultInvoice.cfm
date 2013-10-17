<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" width="650">
<tr class="MainText">
	<cfif Variables.templateStruct.companyLogo is not "">
		<td valign="top"><img src="#Variables.templateStruct.companyLogo#" alt="" border="0"></td>
	</cfif>
	<td valign="bottom">
		<div class="SubTitle">#Variables.templateStruct.companyLegalName#</div>
		<cfif Variables.templateStruct.companySlogan is not ""><b><i>#Variables.templateStruct.companySlogan#</i></b><br></cfif>
		<br>
		<br>
		#Replace(Variables.templateStruct.companyAddress, Chr(10), "<br>", "ALL")#
	</td>
	<td valign="bottom">#Replace(Variables.templateStruct.companyContact, Chr(10), "<br>", "ALL")#</td>
	<td valign="bottom" align="right">
		<p><font size="5" face="Arial"><b>#Variables.templateStruct.documentTitle#</b></font></p>
		<cfif ListFind(Variables.templateStruct.invoiceFields, "invoiceDateClosed") or ListFind(Variables.templateStruct.invoiceFields, "invoiceID")>
			<table border="0" cellspacing="0" cellpadding="0" class="MainText">
			<cfif ListFind(Variables.templateStruct.invoiceFields, "invoiceDateClosed")>
				<tr>
					<td>#Variables.templateStruct.invoiceFields_invoiceDateClosed_header# &nbsp;</td>
					<td><cfif Not IsDate(qry_selectInvoice.invoiceDateClosed)>#DateFormat(Now(), Variables.templateStruct.invoiceFields_invoiceDateClosed_dateFormat)#<cfelse>#DateFormat(qry_selectInvoice.invoiceDateClosed, Variables.templateStruct.invoiceFields_invoiceDateClosed_dateFormat)#</cfif></td>
				</tr>
			</cfif>
			<cfif ListFind(Variables.templateStruct.invoiceFields, "invoiceID")>
				<tr valign="bottom">
					<td>#Variables.templateStruct.invoiceFields_invoiceID_header# &nbsp;</td>
					<td>
						<cfswitch expression="#Variables.templateStruct.invoiceFields_invoiceIDorCustomID#">
						<cfcase value="invoiceID">#Variables.invoiceID#</cfcase>
						<cfcase value="invoiceID_custom">#qry_selectInvoice.invoiceID_custom#</cfcase>
						<cfcase value="invoiceIDorCustom"><cfif qry_selectInvoice.invoiceID_custom is "">#Variables.invoiceID#<cfelse>#qry_selectInvoice.invoiceID_custom#</cfif></cfcase>
						</cfswitch>
					</td>
				</tr>
			</cfif>
			<cfif ListFind(Variables.templateStruct.invoiceFields, "invoiceDateDue") and IsDate(qry_selectInvoice.invoiceDateDue)>
				<tr>
					<td>#Variables.templateStruct.invoiceFields_invoiceDateDue_header# &nbsp;</td>
					<td>#DateFormat(qry_selectInvoice.invoiceDateDue, Variables.templateStruct.invoiceFields_invoiceDateDue_dateFormat)#</td>
				</tr>
			</cfif>
			</table>
		</cfif>
	</td>
</tr>
</table>
<img src="#Application.billingSecureUrl#/images/aline.gif" width="650" height="2" alt="" border="0">

<cfif ListFind(Variables.templateStruct.companyFields, "companyName") or ListFind(Variables.templateStruct.companyFields, "companyID") or ListFind(Variables.templateStruct.userFields, "fullName")
		or (qry_selectInvoice.addressID_billing is not 0 and ListFind(Variables.templateStruct.invoiceFields, "addressID_billing"))
		or (qry_selectInvoice.addressID_shipping is not 0 and ListFind(Variables.templateStruct.invoiceFields, "addressID_shipping"))>
	<p><table border="0" cellspacing="0" cellpadding="0" width="650">
	<tr class="MainText" valign="top">
	<cfif ListFind(Variables.templateStruct.companyFields, "companyName") or ListFind(Variables.templateStruct.companyFields, "companyID") or ListFind(Variables.templateStruct.userFields, "fullName")>
		<td>
		<cfif ListFind(Variables.templateStruct.companyFields, "companyName")>
			<cfif Variables.templateStruct.companyFields_companyName_header is not ""><b>#Variables.templateStruct.companyFields_companyName_header#</b><br></cfif>
			<cfswitch expression="#Variables.templateStruct.companyFields_companyNameOrDBA#">
			<cfcase value="companyName"><cfif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<br></cfif></cfcase>
			<cfcase value="companyDBA"><cfif qry_selectCompany.companyDBA is not "">#qry_selectCompany.companyDBA#<br></cfif></cfcase>
			<cfcase value="companyNameThenDBA"><cfif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<br><cfelseif qry_selectCompany.companyDBA is not "">#qry_selectCompany.companyDBA#<br></cfif></cfcase>
			<cfcase value="companyDBAThenName"><cfif qry_selectCompany.companyDBA is not "">#qry_selectCompany.companyDBA#<br><cfelseif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<br></cfif></cfcase>
			<cfcase value="companyNameAndDBA"><cfif qry_selectCompany.companyName is not "">#qry_selectCompany.companyName#<br></cfif><cfif qry_selectCompany.companyDBA is not "">#qry_selectCompany.companyDBA#<br></cfif></cfcase>
			</cfswitch>
		</cfif>

		<cfif ListFind(Variables.templateStruct.companyFields, "companyID")>
			#Variables.templateStruct.companyFields_companyID_header# 
			<cfswitch expression="#Variables.templateStruct.companyFields_companyIDOrCustomID#">
			<cfcase value="companyID">#qry_selectCompany.companyID#<br></cfcase>
			<cfcase value="companyID_custom">#qry_selectCompany.companyID_custom#<br></cfcase>
			<cfcase value="companyIDorCustom"><cfif qry_selectCompany.companyID_custom is not "">#qry_selectCompany.companyID_custom#<cfelse>#qry_selectCompany.companyID#</cfif></cfcase>
			</cfswitch>
		</cfif>

		<cfif ListFind(Variables.templateStruct.userFields, "fullName") and qry_selectInvoice.userID is not 0>
			#Variables.templateStruct.userFields_fullName_header# #qry_selectUser.firstName# #qry_selectUser.lastName#<br>
		</cfif>
		</td>
	</cfif>
	<cfif qry_selectInvoice.addressID_billing is not 0 and ListFind(Variables.templateStruct.invoiceFields, "addressID_billing")>
		<td width="25">&nbsp;</td>
		<td>
			<cfif Variables.templateStruct.invoiceFields_addressID_billing_header is not "">#Variables.templateStruct.invoiceFields_addressID_billing_header#<br></cfif>
			#qry_selectBillingAddress.address#<br>
			<cfif qry_selectBillingAddress.address2 is not "">#qry_selectBillingAddress.address2#<br></cfif>
			<cfif qry_selectBillingAddress.address3 is not "">#qry_selectBillingAddress.address3#<br></cfif>
			#qry_selectBillingAddress.city#, #qry_selectBillingAddress.state# #qry_selectBillingAddress.zipCode#<cfif qry_selectBillingAddress.zipCodePlus4 is not "">-#qry_selectBillingAddress.zipCodePlus4#</cfif><br>
			<cfif qry_selectBillingAddress.country is not "" and Not ListFindNoCase("US,USA,United States", qry_selectBillingAddress.country)>#qry_selectBillingAddress.country#</cfif>
		</td>
	</cfif>
	<cfif qry_selectInvoice.addressID_shipping is not 0 and ListFind(Variables.templateStruct.invoiceFields, "addressID_shipping")>
		<td width="25">&nbsp;</td>
		<td>
			<cfif Variables.templateStruct.invoiceFields_addressID_shipping_header is not "">#Variables.templateStruct.invoiceFields_addressID_shipping_header#<br></cfif>
			<cfif Variables.templateStruct.invoiceFields_addressID_Shipping_header is not "">#Variables.templateStruct.invoiceFields_addressID_Shipping_header#<br></cfif>
			#qry_selectShippingAddress.address#<br>
			<cfif qry_selectShippingAddress.address2 is not "">#qry_selectShippingAddress.address2#<br></cfif>
			<cfif qry_selectShippingAddress.address3 is not "">#qry_selectShippingAddress.address3#<br></cfif>
			#qry_selectShippingAddress.city#, #qry_selectShippingAddress.state# #qry_selectShippingAddress.zipCode#<cfif qry_selectShippingAddress.zipCodePlus4 is not "">-#qry_selectShippingAddress.zipCodePlus4#</cfif><br>
			<cfif Not ListFindNoCase("US,USA,United States", qry_selectShippingAddress.country)>#qry_selectShippingAddress.country#</cfif>
		</td>
	</cfif>
	</tr>
	</table>
	</p>
</cfif>

<!--- payments since last invoice --->
<cfif ListFind(Variables.templateStruct.invoiceFields, "paymentSinceLastInvoice") and qry_selectLastInvoice.RecordCount is 1 and qry_selectPaymentsSinceLastInvoice.RecordCount is not 0>
	<p class="MainText" style="width: 650">
	<cfif Variables.templateStruct.invoiceFields_paymentSinceLastInvoice_header is not ""><b>#Variables.templateStruct.invoiceFields_paymentSinceLastInvoice_header#</b><br></cfif>
	<cfloop Query="qry_selectPaymentsSinceLastInvoice">
		#DateFormat(qry_selectPaymentsSinceLastInvoice.paymentDateReceived, "mmmm dd, yyyy")# - #DollarFormat(qry_selectPaymentsSinceLastInvoice.paymentAmount)#<br>
	</cfloop>
	</p>
</cfif>

<!--- refunds since last invoice --->
<cfif ListFind(Variables.templateStruct.invoiceFields, "paymentRefundSinceLastInvoice") and qry_selectLastInvoice.RecordCount is 1 and qry_selectPaymentRefundsSinceLastInvoice.RecordCount is not 0>
	<p class="MainText" style="width: 650">
	<cfif Variables.templateStruct.invoiceFields_paymentRefundSinceLastInvoice_header is not ""><b>#Variables.templateStruct.invoiceFields_paymentRefundSinceLastInvoice_header#</b><br></cfif>
	<cfloop Query="qry_selectPaymentRefundsSinceLastInvoice">
		#DateFormat(qry_selectPaymentRefundsSinceLastInvoice.paymentDateReceived, "mmmm dd, yyyy")# - #DollarFormat(qry_selectPaymentRefundsSinceLastInvoice.paymentAmount)#<br>
	</cfloop>
	</p>
</cfif>

<!--- display invoice line items and invoice totals --->
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.templateStruct.invoiceLineItemFields))>
<cfif Variables.columnCount gt 0>
	<p>
	<table border="0" cellspacing="0" cellpadding="0" width="650">
	<tr><td colspan="#Variables.columnCount#"><img src="#Application.billingSecureUrl#/images/aline.gif" width="100%" height="2" alt="" border="0"></td></tr>

	<tr class="MainText" valign="bottom">
	<cfset Variables.isFirstColumn = True>
	<cfloop Index="field" List="#Variables.templateStruct.invoiceLineItemFields_order#">
		<cfif Variables.isFirstColumn is True><cfset Variables.isFirstColumn = False><cfelse><td width="5">&nbsp;</td></cfif>
		<th align="left"><cfif Variables.templateStruct["invoiceLineItemFields_#field#_header"] is "">&nbsp;<cfelse>#Variables.templateStruct["invoiceLineItemFields_#field#_header"]#</cfif></th>
	</cfloop>
	</tr>
	<tr><td height="10" colspan="#Variables.columnCount#"><img src="#Application.billingSecureUrl#/images/aline.gif" width="100%" height="2" alt="" border="0"></td></tr>

	<!--- invoice line items --->
	<cfloop Query="qry_selectInvoiceLineItemList">
		<cfset Variables.lineItemRow = qry_selectInvoiceLineItemList.CurrentRow>
		<cfset Variables.isFirstColumn = True>

		<tr class="TableText" valign="top">
		<cfloop Index="field" List="#Variables.templateStruct.invoiceLineItemFields_order#">
			<cfif Variables.isFirstColumn is True><cfset Variables.isFirstColumn = False><cfelse><td width="5">&nbsp;</td></cfif>
			<cfswitch expression="#field#">
			<cfcase value="invoiceLineItemOrder"><td>#qry_selectInvoiceLineItemList.invoiceLineItemOrder[Variables.lineItemRow]#</td></cfcase>
			<cfcase value="invoiceLineItemProductID_custom"><td><cfif qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom[Variables.lineItemRow] is "">&nbsp;<cfelse>#qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom[Variables.lineItemRow]#</cfif></td></cfcase>
			<cfcase value="invoiceLineItemName"><td>#qry_selectInvoiceLineItemList.invoiceLineItemName[Variables.lineItemRow]#</td></cfcase>
			<cfcase value="invoiceLineItemQuantity"><td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectInvoiceLineItemList.invoiceLineItemQuantity[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemDateBegin"><td nowrap><cfif Not IsDate(qry_selectInvoiceLineItemList.invoiceLineItemDateBegin[Variables.lineItemRow])>&nbsp;<cfelse>#DateFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateBegin[Variables.lineItemRow], "mm-dd-yy")#</cfif></td></cfcase>
			<cfcase value="invoiceLineItemDateEnd"><td nowrap><cfif Not IsDate(qry_selectInvoiceLineItemList.invoiceLineItemDateEnd[Variables.lineItemRow])>&nbsp;<cfelse>#DateFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateEnd[Variables.lineItemRow], "mm-dd-yy")#</cfif></td></cfcase>
			<cfcase value="invoiceLineItemPriceNormal"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemPriceNormal[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemPriceUnit"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemPriceUnit[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemSubTotal"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemSubTotal[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemDiscount"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemDiscount[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemTotalTax"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemTotalTax[Variables.lineItemRow])#</td></cfcase>
			<cfcase value="invoiceLineItemTotal"><td>#DollarFormat(qry_selectInvoiceLineItemList.invoiceLineItemTotal[Variables.lineItemRow])#</td></cfcase>
			</cfswitch>
		</cfloop>
		</tr>
		<tr><td height="10" colspan="#Variables.columnCount#"><img src="#Application.billingSecureUrl#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
	</cfloop>

	<!--- payment credits --->
	<cfloop Query="qry_selectInvoicePaymentCreditList">
		<cfset Variables.paymentRow = qry_selectInvoicePaymentCreditList.CurrentRow>
		<cfset Variables.isFirstColumn = True>
		<tr class="TableText">
		<cfloop Index="field" List="#Variables.templateStruct.invoiceLineItemFields_order#">
			<cfif Variables.isFirstColumn is True><cfset Variables.isFirstColumn = False><cfelse><td width="5">&nbsp;</td></cfif>
			<cfswitch expression="#field#">
			<cfcase value="invoiceLineItemName"><td>#qry_selectInvoicePaymentCreditList.invoicePaymentCreditText[Variables.paymentRow]#</td></cfcase>
			<cfcase value="invoiceLineItemTotal"><td>(#DollarFormat(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount[Variables.paymentRow])#)</td></cfcase>
			<cfdefaultcase><td>&nbsp;</td></cfdefaultcase>
			</cfswitch>
		</cfloop>
		</tr>
		<tr><td height="10" colspan="#Variables.columnCount#"><img src="#Application.billingSecureUrl#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
		</tr>
	</cfloop>

	<!--- invoice subtotals --->
	<cfloop Index="field" List="invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceTotalTax">
		<cfif ListFind(Variables.templateStruct.invoiceFields, field)>
			<tr class="MainText">
				<td align="right" colspan="#DecrementValue(Variables.columnCount)#">#Variables.templateStruct["invoiceFields_#field#_header"]# &nbsp;</td>
				<td>#DollarFormat(Evaluate("qry_selectInvoice.#field#"))#</td>
			</tr>
		</cfif>
	</cfloop>

	<!--- invoice total --->
	<cfif ListFind(Variables.templateStruct.invoiceFields, "invoiceTotal")>
		<tr class="SubTitle">
			<td align="right" colspan="#DecrementValue(Variables.columnCount)#">#Variables.templateStruct.invoiceFields_invoiceTotal_header# &nbsp;</td>
			<td>#DollarFormat(qry_selectInvoice.invoiceTotal)#</td>
		</tr>
	</cfif>
	</table>
	</p>
</cfif>

<!--- payments received for this invoice --->
<cfif ListFind(Variables.templateStruct.invoiceFields, "paymentForThisInvoice") and qry_selectInvoicePaymentList.RecordCount is not 0>
	<p class="MainText" style="width: 650">
	<cfif Variables.templateStruct.invoiceFields_paymentForThisInvoice_header is not "">#Variables.templateStruct.invoiceFields_paymentForThisInvoice_header#<br></cfif>
	<cfloop Query="qry_selectInvoicePaymentList">
		#DateFormat(qry_selectInvoicePaymentList.paymentDateReceived, "mmmm dd, yyyy")# - #DollarFormat(qry_selectInvoicePaymentList.paymentAmount)#<br>
	</cfloop>
	</p>
</cfif>

<!--- shipping method, instructions --->
<cfif (qry_selectInvoice.invoiceShippingMethod is not "" and ListFind(Variables.templateStruct.invoiceFields, "invoiceShippingMethod"))
		or (qry_selectInvoice.invoiceInstructions is not "" and ListFind(Variables.templateStruct.invoiceFields, "invoiceInstructions"))>
	<p class="MainText" style="width: 650">
	<cfif qry_selectInvoice.invoiceShippingMethod is not "" and ListFind(Variables.templateStruct.invoiceFields, "invoiceShippingMethod")>
		#Variables.templateStruct.invoiceFields_invoiceShippingMethod_header# #qry_selectInvoice.invoiceShippingMethod#<br>
	</cfif>
	<cfif qry_selectInvoice.invoiceInstructions is not "" and ListFind(Variables.templateStruct.invoiceFields, "invoiceInstructions")>
		#Variables.templateStruct.invoiceFields_invoiceInstructions_header# #qry_selectInvoice.invoiceInstructions#
	</cfif>
	</p>
</cfif>

<!--- display payment information --->
<cfset Variables.paymentDisplayed = False>
<cfif qry_selectInvoicePaymentList.RecordCount is 1>
	<cfif Not IsDate(qry_selectInvoicePaymentList.paymentDateScheduled)>
		<cfset Variables.paymentDateScheduled = "">
	<cfelse>
		<cfset Variables.paymentDateScheduled = DateFormat(qry_selectInvoicePaymentList.paymentDateScheduled, Variables.templateStruct.paymentDateScheduled_dateFormat)>
	</cfif>

	<!--- credit card --->
	<cfif qry_selectInvoicePaymentList.creditCardID is not 0 and Variables.templateStruct.paymentMethod_creditCardID_text is not "">
		<cfset Variables.paymentDisplayed = True>
		<cfset Variables.paymentText = ReplaceNoCase(Variables.templateStruct.paymentMethod_creditCardID_text, "<<paymentDateScheduled>>", Variables.paymentDateScheduled, "ALL")>
		<cfset Variables.creditCardRow = ListFind(ValueList(qry_selectCreditCardList.creditCardID), qry_selectInvoicePaymentList.creditCardID)>
		<cfif Variables.creditCardRow is not 0>
			<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<creditCardType>>", qry_selectCreditCardList.creditCardType[Variables.creditCardRow], "ALL")>
			<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<creditCardNumberLast4>>", Right(qry_selectCreditCardList.creditCardID[Variables.creditCardRow], 4), "ALL")>
		</cfif>
		<p class="MainText" style="width: 650">#Variables.paymentText#</p>

	<!--- bank --->
	<cfelseif qry_selectInvoicePaymentList.bankID is not 0 and Variables.templateStruct.paymentMethod_bankID_text is not "">
		<cfset Variables.paymentDisplayed = True>
		<cfset Variables.paymentText = ReplaceNoCase(Variables.templateStruct.paymentMethod_bankID_text, "<<paymentDateScheduled>>", Variables.paymentDateScheduled, "ALL")>
		<cfset Variables.bankRow = ListFind(ValueList(qry_selectBankList.bankID), qry_selectInvoicePaymentList.bankID)>
		<cfif Variables.bankRow is not 0>
			<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankName>>", qry_selectBankList.bankName[Variables.bankRow], "ALL")>
			<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankAccountNumberLast4>>", Right(qry_selectBankList.bankAccountNumber[Variables.bankRow], 4), "ALL")>
			<cfif qry_selectBankList.bankCheckingOrSavings[Variables.bankRow] is 0>
				<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankCheckingOrSavings>>", "checking", "ALL")>
			<cfelse>
				<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankCheckingOrSavings>>", "savings", "ALL")>
			</cfif>
			<cfif qry_selectBankList.bankPersonalOrCorporate[Variables.bankRow] is 0>
				<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankCheckingOrSavings>>", "personal", "ALL")>
			<cfelse>
				<cfset Variables.paymentText = ReplaceNoCase(Variables.paymentText, "<<bankCheckingOrSavings>>", "corporate", "ALL")>
			</cfif>
		</cfif>
		<p class="MainText" style="width: 650">#Variables.paymentText#</p>
	</cfif>
</cfif>
<!--- other payment --->
<cfif Variables.paymentDisplayed is False and Variables.templateStruct.paymentMethod_other_text is not "">
	<cfset Variables.paymentText = ReplaceNoCase(Variables.templateStruct.paymentMethod_other_text, "<<paymentMethod>>", qry_selectInvoicePaymentList.paymentMethod, "ALL")>
	<p class="MainText" style="width: 650">#Variables.paymentText#</p>
</cfif>

<!--- footer --->
<cfif Variables.templateStruct.documentFooter is not "">
	<p class="MainText" style="width: 650">#Variables.templateStruct.documentFooter#</p>
</cfif>
</cfoutput>
