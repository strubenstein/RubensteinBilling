<!--- Custom Price: volume discount with step method --->
<cfset Variables.thisPriceStageID = loopPriceStageID>
<cfset Variables.beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.thisPriceStageID)>

<!--- 
parameter exception price premium
quantities less than initial minimum
priceStageVolumeDollarOrQuantity
price starting at 0
--->

<cfif Variables.beginRow is not 0><!--- volume options exist --->
	<cfset Variables.counter = 1>
	<cfset Variables.priceUnitOriginal = Variables.lineItemArray[1].priceUnit>
	<cfset Variables.quantityOriginal = Variables.lineItemArray[1].quantity>

	<!--- steps are based on quantity --->
	<cfif qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 1>
		<cfset Variables.quantityRemaining = Variables.lineItemArray[1].quantity>

		<!--- if first quantity is not 0, use normal price --->
		<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum[Variables.beginRow] is 0 and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[Variables.beginRow] gte 2>
			<cfset Variables.lineItemArray[Variables.counter].priceVolumeDiscountID = 0>
			<cfset Variables.lineItemArray[Variables.counter].quantity = Min(Variables.quantityRemaining, qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[Variables.beginRow] - 1)>
			<cfset Variables.quantityRemaining = Variables.quantityRemaining - Variables.lineItemArray[counter].quantity>
			<cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.priceUnitOriginal>
			<cfset Variables.lineItemArray[Variables.counter].subTotal = Variables.priceUnitOriginal * Variables.lineItemArray[counter].quantity>
			<cfset Variables.lineItemArray[Variables.counter].discount = 0>
			<cfset Variables.lineItemArray[Variables.counter].totalTax = 0>
			<cfset Variables.counter = Variables.counter + 1>
		</cfif>

		<cfif Variables.quantityRemaining is not 0>
			<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.beginRow#"><!--- loop thru volume options --->
				<cfif Variables.counter gt 1>
					<cfset Variables.lineItemArray[Variables.counter] = StructNew()>
				</cfif>
				<cfset Variables.lineItemArray[Variables.counter].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>

				<!--- Determine quantity. If last step, use remaining quantity --->
				<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
						or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
						or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not Variables.thisPriceStageID
						or (Variables.quantityRemaining lt (qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)
							and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is not 0)>
					<cfset Variables.lineItemArray[Variables.counter].quantity = Variables.quantityRemaining>
					<cfset Variables.quantityRemaining = 0>
				<!--- Not last step. Quantity based on minimum amount of next level --->
				<cfelseif qry_selectPriceVolumeDiscount.CurrentRow is Variables.beginRow and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is 0>
					<cfset Variables.lineItemArray[Variables.counter].quantity = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum - 1>
					<cfset Variables.quantityRemaining = Variables.quantityRemaining - Variables.lineItemArray[Variables.counter].quantity>
				<cfelse>
					<cfset Variables.lineItemArray[Variables.counter].quantity = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum>
					<cfset Variables.quantityRemaining = Variables.quantityRemaining - Variables.lineItemArray[Variables.counter].quantity>
				</cfif>

				<!--- if using total price at step regardless of quantity --->
				<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>
					<cfset Variables.lineItemArray[Variables.counter].priceUnit = 0>
					<cfset Variables.lineItemArray[Variables.counter].subTotal = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
				<cfelse>
					<cfswitch expression="#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]#_#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]#">
					<cfcase value="0_0"><cfset Variables.lineItemArray[Variables.counter].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + Variables.productParameterExceptionPricePremium></cfcase>
					<cfcase value="0_1"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_0"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_1"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
					</cfswitch>

					<cfset Variables.lineItemArray[Variables.counter].subTotal = Variables.lineItemArray[Variables.counter].priceUnit * Variables.lineItemArray[Variables.counter].quantity>
				</cfif>

				<cfset Variables.lineItemArray[Variables.counter].discount = 0>
				<cfset Variables.lineItemArray[Variables.counter].totalTax = 0>
				<cfset Variables.counter = Variables.counter + 1>
				<cfif Variables.quantityRemaining is 0><cfbreak></cfif>
			</cfloop>
		</cfif><!--- /if remaining quantity is not 0 because first step was not 0 --->

	<!--- steps are based on dollar value (quantity * normal price) --->
	<cfelse>
		<cfset Variables.subTotalRemaining = Variables.lineItemArray[1].subTotal>

		<cfif ListLen(Variables.lineItemArray[1].quantity, ".") is 1>
			<cfset Variables.quantityPrecision = 2>
		<cfelse>
			<cfset Variables.quantityPrecision = 1 + Len(ListGetAt(Variables.lineItemArray[1].quantity, 2, "."))>
		</cfif>

		<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.beginRow#"><!--- loop thru volume options --->
			<cfif Variables.counter gt 1>
				<cfset Variables.lineItemArray[Variables.counter] = StructNew()>
			</cfif>
			<cfset Variables.lineItemArray[Variables.counter].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>

			<!--- Determine quantity. If last step, use remaining quantity --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
					or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
					or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not Variables.thisPriceStageID
					or (Variables.quantityRemaining lt (qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)
						and qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum is not 0)>
				<cfset Variables.quantityBasis = Variables.subTotalRemaining>
				<cfset Variables.subTotalRemaining = 0>
			<!--- Not last step. Quantity based on minimum amount of next level --->
			<cfelse>
				<cfset Variables.quantityBasis = qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow] - qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum>
				<cfset Variables.subTotalRemaining = Variables.subTotalRemaining - Variables.lineItemArray[Variables.counter].quantity>
			</cfif>
			<cfset Variables.lineItemArray[Variables.counter].quantity = Application.fn_setDecimalPrecision(Variables.quantityBasis / Variables.lineItemArray[1].priceUnit, Variables.quantityPrecision)>

			<!--- if using total step at step regardless of quantity --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>
				<cfset Variables.lineItemArray[Variables.counter].priceUnit = 0>
				<cfset Variables.lineItemArray[Variables.counter].subTotal = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
			<cfelse>
				<cfswitch expression="#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]#_#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]#">
				<cfcase value="0_0"><cfset Variables.lineItemArray[Variables.counter].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + Variables.productParameterExceptionPricePremium></cfcase>
				<cfcase value="0_1"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				<cfcase value="1_0"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				<cfcase value="1_1"><cfset Variables.lineItemArray[Variables.counter].priceUnit = Variables.lineItemArray[Variables.counter].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
				</cfswitch>

				<cfset Variables.lineItemArray[Variables.counter].subTotal = Variables.lineItemArray[Variables.counter].priceUnit * Variables.lineItemArray[Variables.counter].quantity>
			</cfif>

			<cfset Variables.lineItemArray[Variables.counter].discount = 0>
			<cfset Variables.lineItemArray[Variables.counter].totalTax = 0>
			<cfset Variables.counter = Variables.counter + 1>
			<cfif Variables.subTotalRemaining is 0><cfbreak></cfif>
		</cfloop>
	</cfif>

	<cfif Variables.theSubscriptionDiscount is not 0 or Variables.theSubscriptionTax is not 0>
		<cfset Variables.subTotal = 0>
		<cfloop Index="count" From="1" To="#ArrayLen(Variables.lineItemArray)#">
			<cfset Variables.subTotal = Variables.subTotal + (Variables.lineItemArray[count].quantity * Variables.lineItemArray[count].priceUnit)>
		</cfloop>

		<!--- split discount and tax based on dollar value at each price; rounded to 2 decimal places --->
		<cfset Variables.discountRemaining = Variables.theSubscriptionDiscount>
		<cfset Variables.taxRemaining = Variables.theSubscriptionTax>

		<cfloop Index="count" From="1" To="#ArrayLen(Variables.lineItemArray)#">
			<cfif count is ArrayLen(Variables.lineItemArray)>
				<cfset Variables.lineItemArray[count].discount = Variables.discountRemaining>
				<cfset Variables.lineItemArray[count].totalTax = Variables.taxRemaining>
			<cfelse>
				<cfset Variables.thisDiscount = Application.fn_setDecimalPrecision(Variables.theSubscriptionDiscount * ((Variables.lineItemArray[count].quantity * Variables.lineItemArray[count].priceUnit) / Variables.subTotal), 2)>
				<cfset Variables.thisTax = Application.fn_setDecimalPrecision(Variables.theSubscriptionTax * ((Variables.lineItemArray[count].quantity * Variables.lineItemArray[count].priceUnit) / Variables.subTotal), 2)>

				<cfset Variables.lineItemArray[count].discount = Min(Variables.discountRemaining, Variables.thisDiscount)>
				<cfset Variables.lineItemArray[count].totalTax = Min(Variables.taxRemaining, Variables.thisTax)>

				<cfset Variables.discountRemaining = Variables.discountRemaining - Variables.thisDiscount>
				<cfset Variables.taxRemaining = Variables.taxRemaining - Variables.thisTax>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

