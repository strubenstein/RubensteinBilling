<!--- determine price --->
<cfset Variables.price = qry_selectProduct.productPrice>
<cfset Variables.priceID = 0>

<cfif StructKeyExists(Variables.productID_customPriceRow, "product#URL.productID#") and StructKeyExists(Variables.productID_customPriceAmount, "product#URL.productID#")>
	<cfset Variables.priceRow = Variables.productID_customPriceRow["product#URL.productID#"]>
	<cfset Variables.priceID = qry_selectPriceList.priceID[Variables.productID_customPriceRow["product#URL.productID#"]]>

	<cfif qry_selectPriceList.priceStageVolumeDiscount[Variables.priceRow] is 0><!--- NOT volume discount --->
		<cfset Variables.price = Variables.productID_customPriceAmount["product#URL.productID#"]>
	<cfelse><!--- determine volume discount pricing --->
		<cfset Variables.thisPriceStageID = qry_selectPriceList.priceStageID[Variables.priceRow]>
		<cfset Variables.beginRow = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), Variables.thisPriceStageID)>

		<cfif Variables.beginRow is not 0><!--- volume options exist --->
			<cfset Variables.volumePriceAmount = "">
			<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.beginRow#"><!--- loop thru volume options --->

				<cfif qry_selectPriceVolumeDiscount.CurrentRow is Variables.beginRow
						and ((qry_selectPriceList.priceVolumeDollarOrQuantity[Variables.priceRow] is 1 and URL.quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum))
							or ((qry_selectPriceList.priceVolumeDollarOrQuantity[Variables.priceRow] is 0 and (URL.quantity * Variables.price) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum))>
					<cfbreak>
				<cfelseif qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum is 1
						or qry_selectPriceVolumeDiscount.CurrentRow is qry_selectPriceVolumeDiscount.RecordCount
						or qry_selectPriceVolumeDiscount.priceID[1 + qry_selectPriceVolumeDiscount.CurrentRow] is not Variables.priceID
						or (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 1
								and URL.quantity lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])
						or (qry_selectPriceList.priceStageVolumeDollarOrQuantity[Variables.priceRow] is 0
								and (URL.quantity * Variables.price) lt qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum[1 + qry_selectPriceVolumeDiscount.CurrentRow])>
					<cfset Variables.volumePriceAmount = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount>
					<cfswitch expression="#qry_selectPriceList.priceStageNewOrDeduction[Variables.priceRow]#_#qry_selectPriceList.priceStageDollarOrPercent[Variables.priceRow]#">
					<cfcase value="0_0"><cfset Variables.price = qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="0_1"><cfset Variables.price = Variables.price * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_0"><cfset Variables.price = Variables.price - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount></cfcase>
					<cfcase value="1_1"><cfset Variables.price = Variables.price * (1 - qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)></cfcase>
					</cfswitch>
					<cfbreak>
				</cfif>
			</cfloop><!--- /loop thru volume options --->
		</cfif>
	</cfif>
</cfif>
