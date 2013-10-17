<!--- generate array of structures for stages and volume discount settings --->
<cfset Variables.priceStageAmount = ArrayNew(1)>
<cfset Variables.priceStageDollarOrPercent = ArrayNew(1)>
<cfset Variables.priceStageNewOrDeduction = ArrayNew(1)>
<cfset Variables.priceStageVolumeDiscount = ArrayNew(1)>
<cfset Variables.priceStageVolumeDollarOrQuantity = ArrayNew(1)>
<cfset Variables.priceStageVolumeStep = ArrayNew(1)>
<cfset Variables.priceStageInterval = ArrayNew(1)>
<cfset Variables.priceStageIntervalType = ArrayNew(1)>
<cfset Variables.priceStageText = ArrayNew(1)>
<cfset Variables.priceStageDescription = ArrayNew(1)>
<cfset Variables.priceVolumeDiscountQuantityMinimum = ArrayNew(2)>
<cfset Variables.priceVolumeDiscountAmount = ArrayNew(2)>
<cfset Variables.priceVolumeDiscountIsTotalPrice = ArrayNew(2)>

<cfloop Index="stageCount" From="1" To="#Variables.priceStageCount_real#">
	<cfset thisStageCount = stageCount>
	<cfif Form["priceStageInterval#stageCount#"] is "">
		<cfset temp = ArrayAppend(Variables.priceStageInterval, 0)>
	<cfelse>
		<cfset temp = ArrayAppend(Variables.priceStageInterval, Form["priceStageInterval#stageCount#"])>
	</cfif>

	<cfloop Index="field" List="priceStageDollarOrPercent,priceStageNewOrDeduction,priceStageVolumeDiscount,priceStageVolumeDollarOrQuantity,priceStageVolumeStep,priceStageIntervalType,priceStageText,priceStageDescription">
		<cfset temp = ArrayAppend(Variables[field], Form["#field##stageCount#"])>
	</cfloop>

	<cfif Form["priceStageVolumeDiscount#stageCount#"] is 0>
		<cfset Variables.priceVolumeDiscountQuantityMinimum[stageCount][1] = 0>
		<cfset Variables.priceVolumeDiscountIsTotalPrice[stageCount][1] = 0>
		<cfset Variables.priceVolumeDiscountAmount[stageCount][1] = 0>

		<cfif Form["priceStageDollarOrPercent#stageCount#"] is 0>
			<cfset temp = ArrayAppend(Variables.priceStageAmount, Form["priceStageAmount#stageCount#"])>
		<cfelse>
			<cfset temp = ArrayAppend(Variables.priceStageAmount, Form["priceStageAmount#stageCount#"] / 100)>
		</cfif>

	<cfelse><!--- Form["priceVolumeDiscountCount_real#stageCount#"] gt 0 --->
		<cfset temp = ArrayAppend(Variables.priceStageAmount, 0)>
		<cfloop Index="volumeCount" From="1" To="#Form["priceVolumeDiscountCount_real#stageCount#"]#">
			<cfset Variables.priceVolumeDiscountQuantityMinimum[thisStageCount][volumeCount] = Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"]>
			<cfset Variables.priceVolumeDiscountIsTotalPrice[thisStageCount][volumeCount] = Form["priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#"]>

			<cfif Form["priceStageDollarOrPercent#thisStageCount#"] is 0>
				<cfset Variables.priceVolumeDiscountAmount[thisStageCount][volumeCount] = Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"]>
			<cfelse>
				<cfset Variables.priceVolumeDiscountAmount[thisStageCount][volumeCount] = Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"] / 100>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>
