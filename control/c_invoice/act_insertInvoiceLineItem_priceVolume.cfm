<cfset thisPriceStageID = qry_selectPriceListForTarget.priceStageID[priceRow]>
<cfset beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), thisPriceStageID)>

<cfif beginRow is not 0><!--- volume options exist --->
	<!--- if quantity at first volume step is greater than purchased quantity, price = normal price --->
	<cfif (qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity[priceRow] is 1 and lineItemArray[1].quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[beginRow])
			or (qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity[priceRow] is 0 and (lineItemArray[1].quantity * lineItemArray[1].priceUnit) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[beginRow])>
		<!--- <cfset lineItemArray[1].priceUnit = 0> --->
		<cfset lineItemArray[1].priceVolumeDiscountID = 0>
	<cfelse>
		<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
					or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
					or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not thisPriceStageID
					or (qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity[priceRow] is 1
							and lineItemArray[1].quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])
					or (qry_selectPriceListForTarget.priceStageVolumeDollarOrQuantity[priceRow] is 0
							and (lineItemArray[1].quantity * lineItemArray[1].priceUnit) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])>

				<cfswitch expression="#qry_selectPriceListForTarget.priceStageNewOrDeduction[priceRow]#_#qry_selectPriceListForTarget.priceStageDollarOrPercent[priceRow]#">
				  <cfcase value="0_0"><cfset lineItemArray[1].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + productParameterExceptionPricePremium></cfcase>
				  <cfcase value="0_1"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				  <cfcase value="1_0"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				  <cfcase value="1_1"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
				</cfswitch>

				<cfset lineItemArray[1].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>
				<cfbreak>
			</cfif><!--- /if last step for this price stage OR purchased quantity is less than quantity at next volume step --->
		</cfloop><!--- /loop thru volume discount options --->
	</cfif><!--- /if quantity at first volume step is greater than purchased quantity --->

	<cfset lineItemArray[1].subTotal = lineItemArray[1].priceUnit * Form.invoiceLineItemQuantity>
</cfif><!--- /no volume options exist (use normal price instead) --->

