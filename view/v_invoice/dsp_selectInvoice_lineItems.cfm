<cfset Variables.totalQuantity = 0>
<cfset Variables.totalSubTotal = 0>
<cfset Variables.totalTax = 0>
<cfset Variables.totalTotal = 0>

<cfoutput>
#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.invoiceLineItemColumnCount, 0, 0, 0, Variables.invoiceLineItemColumnList, "", True)#
<cfloop Query="qry_selectInvoiceLineItemList">
	<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><cfif qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom#</cfif></td>
	<td>&nbsp;</td>
	<td>
		<cfif qry_selectInvoiceLineItemList.vendorID is 0 or Variables.displayVendor is False>
			&nbsp;
		<cfelse>
			<cfset Variables.vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), qry_selectInvoiceLineItemList.vendorID)>
			<cfif Variables.vendorRow is 0>
				&nbsp;
			<cfelse>
				<cfif qry_selectVendorList.vendorCode[Variables.vendorRow] is not "">#qry_selectVendorList.vendorCode[Variables.vendorRow]#. </cfif>
				#qry_selectVendorList.vendorName[Variables.vendorRow]#<cfif ListFind(Variables.permissionActionList, "viewVendor")> (<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectInvoiceLineItemList.vendorID#" class="plainlink">go</a>)</cfif>
			</cfif>
		</cfif>
	</td>
	<td>&nbsp;</td>
	<td>
		#qry_selectInvoiceLineItemList.invoiceLineItemName# 
		<cfif qry_selectInvoiceLineItemList.productID is 0>
			(<font class="SmallText"><i>custom</i></font>)
		<cfelseif ListFind(Variables.permissionActionList, "viewProduct")>
			(<a href="index.cfm?method=product.viewProduct&productID=#qry_selectInvoiceLineItemList.productID#" class="plainlink">go</a>)
		</cfif>
		<cfif qry_selectInvoiceLineItemList.priceStageText is not ""><div class="SmallText"><i>Price</i>: #qry_selectInvoiceLineItemList.priceStageText#</div></cfif>
	</td>
	<td>&nbsp;</td>
	<td>
		$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemPriceUnit)#
		<cfif qry_selectInvoiceLineItemList.priceID is not 0 and ListFind(Variables.permissionActionList, "listPrices")>
			(<a href="index.cfm?method=product.listPrices&productID=#qry_selectInvoiceLineItemList.productID#&priceID=#qry_selectInvoiceLineItemList.priceID#" class="plainlink">go</a>)
		</cfif>
	</td>
	<td>&nbsp;</td>
	<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectInvoiceLineItemList.invoiceLineItemQuantity)#</td>
	<td>&nbsp;</td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemSubTotal)#</td>
	<td>&nbsp;</td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemTotalTax)#</td>
	<td>&nbsp;</td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemTotal)#</td>
	</tr>

	<cfset Variables.totalQuantity = Variables.totalQuantity + qry_selectInvoiceLineItemList.invoiceLineItemQuantity>
	<cfset Variables.totalSubTotal = Variables.totalSubTotal + qry_selectInvoiceLineItemList.invoiceLineItemSubTotal>
	<cfset Variables.totalTax = Variables.totalTax + qry_selectInvoiceLineItemList.invoiceLineItemTotalTax>
	<cfset Variables.totalTotal = Variables.totalTotal + qry_selectInvoiceLineItemList.invoiceLineItemTotal>
</cfloop>

<cfif Variables.displayPaymentCredits is True>
	<tr class="TableHeader"><td colspan="#Variables.invoiceLineItemColumnCount#">Invoice &amp; Payment Credits</td></tr>
	<cfloop Query="qry_selectInvoicePaymentCreditList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif qry_selectInvoicePaymentCreditList.paymentCreditID_custom is "">&nbsp;<cfelse>#qry_selectInvoicePaymentCreditList.paymentCreditID_custom#</cfif></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectInvoicePaymentCreditList.invoicePaymentCreditText is "">(<i>blank</i>)<cfelse>#qry_selectInvoicePaymentCreditList.invoicePaymentCreditText#</cfif></td>
		<td>&nbsp;</td>
		<td>(#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount)#)</td>
		<td>&nbsp;</td>
		<td>1</td>
		<td>&nbsp;</td>
		<td>(#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount)#)</td>
		<td>&nbsp;</td>
		<td>-</td>
		<td>&nbsp;</td>
		<td>(#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount)#)</td>
		</tr>

		<cfset Variables.totalSubTotal = Variables.totalSubTotal - qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount>
		<cfset Variables.totalTotal = Variables.totalTotal - qry_selectInvoicePaymentCreditList.invoicePaymentCreditAmount>
	</cfloop>
</cfif>

<tr bgcolor="66FF99" class="MainText">
	<td colspan="8">&nbsp;</td>
	<td><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.totalQuantity)#</b></td>
	<td>&nbsp;</td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.totalSubTotal)#</b></td>
	<td>&nbsp;</td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.totalTax)#</b></td>
	<td>&nbsp;</td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.totalTotal)#</b></td>
</tr>
</table>
<!--- invoiceLineItemID, invoiceLineItemDescription, invoiceLineItemDescriptionHtml, invoiceLineItemOrder --->
</cfoutput>