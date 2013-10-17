<!--- Custom Price, but not volume discount --->
<cfswitch expression="#qry_selectPriceListForTarget.priceStageNewOrDeduction[priceRow]#_#qry_selectPriceListForTarget.priceStageDollarOrPercent[priceRow]#">
<cfcase value="0_0"><cfset lineItemArray[1].priceUnit = qry_selectPriceListForTarget.priceStageAmount[priceRow]></cfcase>
<cfcase value="0_1"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit * qry_selectPriceListForTarget.priceStageAmount[priceRow]></cfcase>
<cfcase value="1_0"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit - qry_selectPriceListForTarget.priceStageAmount[priceRow]></cfcase>
<cfcase value="1_1"><cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit * (1 - qry_selectPriceListForTarget.priceStageAmount[priceRow])></cfcase>
</cfswitch>

<cfset lineItemArray[1].priceUnit = lineItemArray[1].priceUnit + productParameterExceptionPricePremium>
<cfset lineItemArray[1].subTotal = lineItemArray[1].priceUnit * Form.invoiceLineItemQuantity>
