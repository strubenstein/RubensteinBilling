<cfset invoiceTotalTax = 0>
<cfset customerIsTaxed = False>

<!--- 
IF Customer shipping address is in Texas:
	CHARGE 8.25% tax for physical products (CDs)
	Subtract payment credits for CD's before calculating
--->

<cfif Session.userID gt 0 and StructKeyExists(Session, "invoiceID") and Session.invoiceID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
		<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
	</cfinvoke>

	<cfif qry_selectInvoice.RecordCount is 1 and qry_selectInvoice.addressID_shipping is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
			<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#">
		</cfinvoke>

		<cfif ListFindNoCase("Texas,TX", qry_selectAddress.state)>
			<cfset customerIsTaxed = True>
		</cfif>
	</cfif>
</cfif>

<cfif customerIsTaxed is True>
	<cfset totalShipped = 0>
	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfif ListLen(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is 2
				and Left(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), 6) is "course"
				and Application.fn_IsIntegerPositive(Replace(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), "course", "", "ALL"))
				and ListLast(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is "cd">
			<cfset totalShipped = totalShipped + (theShoppingCart[count].invoiceLineItemPriceUnit * theShoppingCart[count].invoiceLineItemQuantity)>
		</cfif>
	</cfloop>

	<cfif totalShipped gt 0>
		<cfset qry_selectPaymentCreditsInCart = selectPaymentCreditsInCart()>
		<cfif qry_selectPaymentCreditsInCart.RecordCount is not 0>
			<cfloop Query="qry_selectPaymentCreditsInCart">
				<cfif qry_selectPaymentCreditsInCart.paymentCreditID_custom is "credit3cd">
					<cfset totalShipped = totalShipped - qry_selectPaymentCreditsInCart.paymentCreditAmount>
				</cfif>
			</cfloop>
		</cfif>

		<cfset invoiceTotalTax = Application.fn_LimitPaddedDecimalZerosDollar(totalShipped * 0.0825)>
	</cfif>
</cfif>
