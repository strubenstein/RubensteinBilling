<cfquery Name="qry_selectPrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avPrice.priceQuantityMinimumPerOrder, avPrice.priceQuantityMaximumAllCustomers,
		avPrice.priceQuantityMaximumPerCustomer, avPrice.priceHasMultipleStages,
		avPriceStage.priceStageID, avPriceStage.priceStageOrder, avPriceStage.priceStageAmount,
		avPriceStage.priceStageDollarOrPercent, avPriceStage.priceStageNewOrDeduction,
		avPriceStage.priceStageVolumeDiscount, avPriceStage.priceStageVolumeDollarOrQuantity,
		avPriceStage.priceStageVolumeStep, avPriceStage.priceStageInterval, avPriceStage.priceStageIntervalType,
		avPriceStage.priceStageText, avPriceStage.priceStageDescription
	FROM avPrice, avPriceStage
	WHERE avPrice.priceID = avPriceStage.priceID
		AND avPrice.priceID = #Arguments.priceID#
	ORDER BY avPriceStage.priceStageOrder
</cfquery>

