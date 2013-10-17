<!--- custom price: volume discount, but not step method --->
<cfset Variables.thisPriceStageID = loopPriceStageID>
<cfset Variables.beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.thisPriceStageID)>

<cfif Variables.beginRow is not 0><!--- volume options exist --->
	<!--- if quantity at first volume step is greater than purchased quantity, price = 0 --->
	<cfif (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 1 and Variables.lineItemArray[1].quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[Variables.beginRow])
			or (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 0 and (Variables.lineItemArray[1].quantity * Variables.lineItemArray[1].priceUnit) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[Variables.beginRow])>
		<!--- <cfset Variables.lineItemArray[1].priceUnit = 0> --->
		<cfset Variables.lineItemArray[1].priceVolumeDiscountID = 0>
	<cfelse>
		<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.beginRow#"><!--- loop thru volume options --->
			<cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
					or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
					or qry_selectPriceVolumeDiscount.priceStageID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not Variables.thisPriceStageID
					or (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 1
							and Variables.lineItemArray[1].quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])
					or (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 0
							and (Variables.lineItemArray[1].quantity * Variables.lineItemArray[1].priceUnit) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])>

				<cfswitch expression="#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]#_#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]#">
				  <cfcase value="0_0"><cfset Variables.lineItemArray[1].priceUnit = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount + Variables.productParameterExceptionPricePremium></cfcase>
				  <cfcase value="0_1"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				  <cfcase value="1_0"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
				  <cfcase value="1_1"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
				</cfswitch>

				<cfset Variables.lineItemArray[1].priceVolumeDiscountID = qry_selectPriceVolumeDiscount.priceVolumeDiscountID>
				<cfbreak>
			</cfif><!--- /if last step for this price stage OR purchased quantity is less than quantity at next volume step --->
		</cfloop><!--- /loop thru volume discount options --->
	</cfif><!--- /if quantity at first volume step is greater than purchased quantity --->

	<cfset Variables.lineItemArray[1].subTotal = Variables.lineItemArray[1].priceUnit * Variables.thisSubscriptionQuantity>
</cfif>
