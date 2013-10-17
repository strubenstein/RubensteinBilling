<cfoutput>
<cfif qry_selectPaymentRefundProductList.RecordCount is 0>
	<p class="ErrorMessage">There are no products specified for this payment refund.</p>
<cfelse>
	<p class="SubTitle">Products Specified For This Refund</p>

	<cfloop Query="qry_selectPaymentRefundProductList">
		<p>
		<table border="1" cellspacing="0" cellpadding="2" class="TableText">
		<cfif qry_selectPaymentRefundProductList.productID is not 0>
			<tr valign="top">
				<td><b>Product:</b> </td>
				<td>
					<cfif qry_selectPaymentRefundProductList.productID_custom is "">#qry_selectPaymentRefundProductList.productID#<cfelse>#qry_selectPaymentRefundProductList.productID_custom#</cfif>. 
					#qry_selectPaymentRefundProductList.productName#<br>
					Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentRefundProductList.productPrice)#
					<cfif ListFind(Variables.permissionActionList, "viewProduct")>
						<div class="SmallText">[ <a href="index.cfm?method=product.viewProduct&productID=#qry_selectPaymentRefundProductList.productID#" class="plainlink">View Product</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>

		<cfif qry_selectPaymentRefundProductList.subscriptionID is not 0>
			<tr valign="top">
				<td><b>Subscription:</b> </td>
				<td>
					<cfif qry_selectPaymentRefundProductList.subscriptionID_custom is not "">#qry_selectPaymentRefundProductList.subscriptionID_custom#. </cfif>
					#qry_selectPaymentRefundProductList.subscriptionName#<br>
					Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentRefundProductList.subscriptionPriceUnit)#<br>
					Quantity: <cfif qry_selectPaymentRefundProductList.subscriptionQuantityVaries is 1>Varies<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(subscriptionQuantity)#</cfif>
					Status: <cfif qry_selectPaymentRefundProductList.subscriptionStatus is 0>Inactive<cfelseif qry_selectPaymentRefundProductList.subscriptionCompleted is 0>Active<cfelse>Completed</cfif><br>
					Dates: #DateFormat(qry_selectPaymentRefundProductList.subscriptionDateBegin, "mm-dd-yyyy")# - 
						<cfif Not IsDate(qry_selectPaymentRefundProductList.subscriptionDateEnd)>(no end date)<cfelse>#DateFormat(qry_selectPaymentRefundProductList.subscriptionDateEnd, "mm-dd-yyyy")#</cfif>
					<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
						<div class="SmallText">[ <a href="index.cfm?method=subscription.subscriberID&subscriberID=#qry_selectPaymentRefundProductList.subscriberID#" class="plainlink">View Subscriber</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>

		<cfif qry_selectPaymentRefundProductList.invoiceLineItemID is not 0>
			<tr valign="top">
				<td><b>Invoice<br>Line Item: </b></td>
				<td>
					<cfif qry_selectPaymentRefundProductList.invoiceLineItemStatus is 0><i>This line item is not active or has been updated, and thus replaced.</i><br></cfif>
					#qry_selectPaymentRefundProductList.invoiceLineItemName#<br>
					Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPaymentRefundProductList.invoiceLineItemPriceUnit)#<br>
					Quantity: #Application.fn_LimitPaddedDecimalZerosQuantity(invoiceLineItemQuantity)#<br>
					Total: #DollarFormat(invoiceLineItemSubTotal)#<br>
					<cfif ListFind(Variables.permissionActionList, "viewInvoice")>
						<div class="SmallText">[ <a href="index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectPaymentRefundProductList.invoiceID#" class="plainlink">View Invoice</a> ]</div>
					</cfif>
				</td>
			</tr>
		</cfif>
		</table>
		</p>
	</cfloop>
</cfif>
</cfoutput>
