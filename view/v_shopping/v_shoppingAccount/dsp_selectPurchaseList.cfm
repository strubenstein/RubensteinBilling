<cfoutput>
<cfif qry_selectPurchaseList.RecordCount is 0>
	<p class="ErrorMessage">You have not made any purchases.</p>
<cfelse>
	<p class="SubTitle">My Account - Purchases</p>

	<cfif qry_selectShippingList.RecordCount is not 0>
		<p class="MainText">To check that shipping status of your purchases, simply click the tracking numbers.</p>
	</cfif>

	<cfloop Query="qry_selectPurchaseList">
		<p>
		<table border="0" cellspacing="2" cellpadding="2" class="MainText">
		<tr>
			<td colspan="2"><a href="myAccount.cfm?action=viewPurchase&invoiceID=#qry_selectPurchaseList.invoiceID#">View Purchase</a></td>
		</tr>
		<tr>
			<td>Purchase Date: </td>
			<td>#DateFormat(qry_selectPurchaseList.invoiceDateClosed, "dddd, mmmm dd, yyyy")#</td>
		</tr>
		<cfif qry_selectPurchaseList.invoiceTotalLineItem is not 0>
			<tr>
				<td>Product Cost: </td>
				<td>#DollarFormat(qry_selectPurchaseList.invoiceTotalLineItem)#</td>
			</tr>
		</cfif>
		<cfif qry_selectPurchaseList.invoiceTotalPaymentCredit is not 0>
			<tr>
				<td>Credits: </td>
				<td>(#DollarFormat(qry_selectPurchaseList.invoiceTotalPaymentCredit)#)</td>
			</tr>
		</cfif>
		<cfif qry_selectPurchaseList.invoiceTotalTax is not 0>
			<tr>
				<td>Taxes: </td>
				<td>#DollarFormat(qry_selectPurchaseList.invoiceTotalTax)#</td>
			</tr>
		</cfif>
		<cfif qry_selectPurchaseList.invoiceTotalShipping is not 0>
			<tr>
				<td>Shipping Cost: </td>
				<td>#DollarFormat(qry_selectPurchaseList.invoiceTotalShipping)#</td>
			</tr>
		</cfif>
		<tr>
			<td>Total Cost: </td>
			<td>#DollarFormat(qry_selectPurchaseList.invoiceTotal)#</td>
		</tr>
		<cfif qry_selectPurchaseList.invoiceShippingMethod is not "">
			<tr>
				<td>Shipping Method: </td>
				<td>#qry_selectPurchaseList.invoiceShippingMethod#</td>
			</tr>
		</cfif>
		<cfset Variables.shippingRow = ListFind(ValueList(qry_selectShippingList.invoiceID), qry_selectPurchaseList.invoiceID)>
		<cfif Variables.shippingRow is not 0>
			<cfset Variables.thisInvoiceID = qry_selectPurchaseList.invoiceID>
			<tr>
				<td valign="top">Shipments: </td>
				<td>
				<cfloop Query="qry_selectShippingList" StartRow="#Variables.shippingRow#">
					<cfif qry_selectShippingList.invoiceID is not Variables.thisInvoiceID><cfbreak></cfif>
					<p>
					#qry_selectShippingList.shippingCarrier#
					<cfif qry_selectShippingList.shippingTrackingNumber is not "">
						 - Tracking ##: #fn_trackShipping(qry_selectShippingList.shippingCarrier, qry_selectShippingList.shippingTrackingNumber)#
					</cfif>
					<cfif IsDate(qry_selectShippingList.shippingDateSent)><br>Sent #DateFormat(qry_selectShippingList.shippingDateSent, "dddd, mmmm dd, yyyy")#</cfif>
					<cfif qry_selectShippingList.shippingWeight is not 0><br>Weight: #qry_selectShippingList.shippingWeight#</cfif>
					<cfif qry_selectShippingList.shippingInstructions is not ""><br>Instructions: #qry_selectShippingList.shippingInstructions#</cfif>
					</p>
				</cfloop>
				</td>
			</tr>
		</cfif>
		</table>
		</p>
	</cfloop>
</cfif>
</cfoutput>

