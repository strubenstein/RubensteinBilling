<cfoutput>
<cfif qry_selectPaymentCreditProductList.RecordCount is 0>
	<p class="ErrorMessage">There are no products specified for this credit.</p>
<cfelse>
	<p class="SubTitle">Products Specified For This Credit</p>

	<cfloop Query="qry_selectPaymentCreditProductList">
		<p>
		<table border="1" cellspacing="0" cellpadding="2" class="TableText">
		<cfif qry_selectPaymentCreditProductList.productID is not 0>
			<tr valign="top">
				<td><b>Product:</b> </td>
				<td>
					<cfif qry_selectPaymentCreditProductList.productID_custom is "">#qry_selectPaymentCreditProductList.productID#<cfelse>#qry_selectPaymentCreditProductList.productID_custom#</cfif>. 
					#qry_selectPaymentCreditProductList.productName#<br>
					Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentCreditProductList.productPrice)#
					<cfif ListFind(Variables.permissionActionList, "viewProduct")>
						<div class="SmallText">[ <a href="index.cfm?method=product.viewProduct&productID=#qry_selectPaymentCreditProductList.productID#" class="plainlink">View Product</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>

		<cfif qry_selectPaymentCreditProductList.subscriptionID is not 0>
			<tr valign="top">
				<td><b>Subscription:</b> </td>
				<td>
					<cfif qry_selectPaymentCreditProductList.subscriptionID_custom is not "">#qry_selectPaymentCreditProductList.subscriptionID_custom#. </cfif>
					#qry_selectPaymentCreditProductList.subscriptionName#<br>
					Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentCreditProductList.subscriptionPriceUnit)#<br>
					Quantity: <cfif qry_selectPaymentCreditProductList.subscriptionQuantityVaries is 1>Varies<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(subscriptionQuantity)#</cfif>
					Status: <cfif qry_selectPaymentCreditProductList.subscriptionStatus is 0>Inactive<cfelseif qry_selectPaymentCreditProductList.subscriptionCompleted is 0>Active<cfelse>Completed</cfif><br>
					Dates: #DateFormat(qry_selectPaymentCreditProductList.subscriptionDateBegin, "mm-dd-yyyy")# - 
						<cfif Not IsDate(qry_selectPaymentCreditProductList.subscriptionDateEnd)>(no end date)<cfelse>#DateFormat(qry_selectPaymentCreditProductList.subscriptionDateEnd, "mm-dd-yyyy")#</cfif>
					<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
						<div class="SmallText">[ <a href="index.cfm?method=subscription.subscriberID&subscriberID=#qry_selectPaymentCreditProductList.subscriberID#" class="plainlink">View Subscriber</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>

		<cfif qry_selectPaymentCreditProductList.invoiceLineItemID is not 0>
			<tr valign="top">
				<td><b>Invoice<br>Line Item: </b></td>
				<td>
					<cfif qry_selectPaymentCreditProductList.invoiceLineItemStatus is 0><i>This line item is not active or has been updated, and thus replaced.</i><br></cfif>
					#qry_selectPaymentCreditProductList.invoiceLineItemName#<br>
					Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentCreditProductList.invoiceLineItemPriceUnit)#<br>
					Quantity: #Application.fn_LimitPaddedDecimalZerosQuantity(invoiceLineItemQuantity)#<br>
					Total: #DollarFormat(invoiceLineItemSubTotal)#<br>
					<cfif ListFind(Variables.permissionActionList, "viewInvoice")>
						<div class="SmallText">[ <a href="index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectPaymentCreditProductList.invoiceID#" class="plainlink">View Invoice</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>
		</table>
		</p>
	</cfloop>
</cfif>
</cfoutput>
