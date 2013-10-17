<cfset thisPriceStageID = qry_selectPriceListForTarget.priceStageID[priceRow]>
<cfset beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), thisPriceStageID)>

<!--- 
parameter exception price premium
quantities less than initial minimum
priceStageVolumeDollarOrQuantity
price starting at 0
--->

<cfif beginRow is not 0><!--- volume options exist --->
	<cfset counter = 1>
	<cfset priceUnitOriginal = lineItemArray[1].priceUnit>
	<cfset quantityOriginal = lineItemArray[1].quantity>

	<!--- steps are based on quantity --->
	<cfif qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity[priceRow] is 1>
		<cfset quantityRemaining = lineItemArray[1].quantity>

		<!--- if first quantity is not 0, use normal price --->
		<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum[beginRow] is 0 and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[beginRow] gte 2>
			<cfset lineItemArray[counter].priceVolumeDiscountID = 0>
			<cfset lineItemArray[counter].quantity = Min(quantityRemaining, qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[beginRow] - 1)>
			<cfset quantityRemaining = quantityRemaining - lineItemArray[counter].quantity>
			<cfset lineItemArray[counter].priceUnit = priceUnitOriginal>
			<cfset lineItemArray[counter].subTotal = priceUnitOriginal * lineItemArray[counter].quantity>
			<cfset lineItemArray[counter].discount = 0>
			<cfset lineItemArray[counter].totalTax = 0>
			<cfset counter = counter + 1>
		</cfif>

		<cfif quantityRemaining is not 0>
			<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
				<cfif counter gt 1>
					<cfset lineItemArray[counter] = StructNew()>
				</cfif>
				<cfset lineItemArray[counter].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>

				<!--- Determine quantity. If last step, use remaining quantity --->
				<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
						or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
						or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not thisPriceStageID
						or (quantityRemaining lt (qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)
							and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is not 0)>
					<cfset lineItemArray[counter].quantity = quantityRemaining>
					<cfset quantityRemaining = 0>
				<!--- Not last step. Quantity based on minimum amount of next level --->
				<cfelseif qry_selectPriceVolumeDiscount.CurrentRow is beginRow and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is 0>
					<cfset lineItemArray[counter].quantity = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum - 1>
					<cfset quantityRemaining = quantityRemaining - lineItemArray[counter].quantity>
				<cfelse>
					<cfset lineItemArray[counter].quantity = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum>
					<cfset quantityRemaining = quantityRemaining - lineItemArray[counter].quantity>
				</cfif>

				<!--- if using total price at step regardless of quantity --->
				<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>
					<cfset lineItemArray[counter].priceUnit = 0>
					<cfset lineItemArray[counter].subTotal = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
				<cfelse>
					<cfswitch expression="#qry_selectPriceListForTarget.priceStageNewOrDeduction[priceRow]#_#qry_selectPriceListForTarget.priceStageDollarOrPercent[priceRow]#">
					<cfcase value="0_0"><cfset lineItemArray[counter].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + productParameterExceptionPricePremium></cfcase>
					<cfcase value="0_1"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_0"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_1"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
					</cfswitch>

					<cfset lineItemArray[counter].subTotal = lineItemArray[counter].priceUnit * lineItemArray[counter].quantity>
				</cfif>

				<cfset lineItemArray[counter].discount = 0>
				<cfset lineItemArray[counter].totalTax = 0>
				<cfset counter = counter + 1>
				<cfif quantityRemaining is 0><cfbreak></cfif>
			</cfloop>
		</cfif><!--- /if remaining quantity is not 0 because first step was not 0 --->

	<!--- steps are based on dollar value (quantity * normal price) --->
	<cfelse>
		<cfset subTotalRemaining = lineItemArray[1].subTotal>

		<cfif ListLen(lineItemArray[1].quantity, ".") is 1>
			<cfset quantityPrecision = 2>
		<cfelse>
			<cfset quantityPrecision = 1 + Len(ListGetAt(lineItemArray[1].quantity, 2, "."))>
		</cfif>

		<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
			<cfif counter gt 1>
				<cfset lineItemArray[counter] = StructNew()>
			</cfif>
			<cfset lineItemArray[counter].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>

			<!--- Determine quantity. If last step, use remaining quantity --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
					or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
					or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not thisPriceStageID
					or (subTotalRemaining lt (qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)
						and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is not 0)>
				<cfset quantityBasis = subTotalRemaining>
				<cfset subTotalRemaining = 0>
			<!--- Not last step. Quantity based on minimum amount of next level --->
			<cfelse>
				<cfset quantityBasis = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum>
				<cfset subTotalRemaining = subTotalRemaining - lineItemArray[counter].quantity>
			</cfif>
			<cfset lineItemArray[counter].quantity = Application.fn_setDecimalPrecision(quantityBasis / lineItemArray[1].priceUnit, quantityPrecision)>

			<!--- if using total step at step regardless of quantity --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>
				<cfset lineItemArray[counter].priceUnit = 0>
				<cfset lineItemArray[counter].subTotal = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
			<cfelse>
				<cfswitch expression="#qry_selectPriceListForTarget.priceStageNewOrDeduction[priceRow]#_#qry_selectPriceListForTarget.priceStageDollarOrPercent[priceRow]#">
				<cfcase value="0_0"><cfset lineItemArray[counter].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + productParameterExceptionPricePremium></cfcase>
				<cfcase value="0_1"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				<cfcase value="1_0"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				<cfcase value="1_1"><cfset lineItemArray[counter].priceUnit = lineItemArray[counter].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
				</cfswitch>

				<cfset lineItemArray[counter].subTotal = lineItemArray[counter].priceUnit * lineItemArray[counter].quantity>
			</cfif>

			<cfset lineItemArray[counter].discount = 0>
			<cfset lineItemArray[counter].totalTax = 0>
			<cfset counter = counter + 1>
			<cfif subTotalRemaining is 0><cfbreak></cfif>
		</cfloop>
	</cfif>

	<cfif Form.invoiceLineItemDiscount is not 0 or Form.invoiceLineItemTotalTax is not 0>
		<cfset subTotal = 0>
		<cfloop Index="count" From="1" To="#ArrayLen(lineItemArray)#">
			<cfset subTotal = subTotal + (lineItemArray[count].quantity * lineItemArray[count].priceUnit)>
		</cfloop>

		<!--- split discount and tax based on dollar value at each price; rounded to 2 decimal places --->
		<cfset discountRemaining = Form.invoiceLineItemDiscount>
		<cfset taxRemaining = Form.invoiceLineItemTotalTax>

		<cfloop Index="count" From="1" To="#ArrayLen(lineItemArray)#">
			<cfif count is ArrayLen(lineItemArray)>
				<cfset lineItemArray[count].discount = discountRemaining>
				<cfset lineItemArray[count].totalTax = taxRemaining>
			<cfelse>
				<cfset thisDiscount = Application.fn_setDecimalPrecision(Form.invoiceLineItemDiscount * (lineItemArray[count].subTotal / subTotal), 2)>
				<cfset thisTax = Application.fn_setDecimalPrecision(Form.invoiceLineItemTotalTax * (lineItemArray[count].subTotal / subTotal), 2)>

				<cfset lineItemArray[count].discount = Min(discountRemaining, thisDiscount)>
				<cfset lineItemArray[count].totalTax = Min(taxRemaining, thisTax)>

				<cfset discountRemaining = discountRemaining - thisDiscount>
				<cfset taxRemaining = taxRemaining - thisTax>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
