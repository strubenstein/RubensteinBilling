<!--- Custom Price, but not volume discount --->
<cfswitch expression="#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceStageRow]#_#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceStageRow]#">
<cfcase value="0_0"><cfset Variables.lineItemArray[1].priceUnit = qry_selectPriceList.priceStageAmount[Variables.priceStageRow]></cfcase>
<cfcase value="0_1"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit * qry_selectPriceList.priceStageAmount[Variables.priceStageRow]></cfcase>
<cfcase value="1_0"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit - qry_selectPriceList.priceStageAmount[Variables.priceStageRow]></cfcase>
<cfcase value="1_1"><cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit * (1 - qry_selectPriceList.priceStageAmount[Variables.priceStageRow])></cfcase>
</cfswitch>

<cfset Variables.lineItemArray[1].priceUnit = Variables.lineItemArray[1].priceUnit + Variables.productParameterExceptionPricePremium>
<cfset Variables.lineItemArray[1].subTotal = Variables.lineItemArray[1].priceUnit * Variables.thisSubscriptionQuantity>
