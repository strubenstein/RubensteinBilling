<cfquery Name="qry_selectPriceVolumeDiscount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT priceVolumeDiscountID, priceStageID, priceVolumeDiscountQuantityMinimum,
		priceVolumeDiscountQuantityIsMaximum, priceVolumeDiscountAmount,
		priceVolumeDiscountIsTotalPrice
	FROM avPriceVolumeDiscount
	WHERE 
		<cfif StructKeyExists(Arguments, "priceStageID")>
			priceStageID IN (#Arguments.priceStageID#)
		<cfelse>
			priceStageID IN 
				(
				SELECT priceStageID
				FROM avPriceStage
				WHERE priceID IN (#Arguments.priceID#)
				)
		</cfif>
	ORDER BY priceStageID, priceVolumeDiscountQuantityIsMaximum, priceVolumeDiscountQuantityMinimum
</cfquery>
