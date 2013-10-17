<!--- generate array of structures for stages and volume discount settings --->
<cfset Variables.commissionStageAmount = ArrayNew(1)>
<cfset Variables.commissionStageAmountMinimum = ArrayNew(1)>
<cfset Variables.commissionStageAmountMaximum = ArrayNew(1)>
<cfset Variables.commissionStageDollarOrPercent = ArrayNew(1)>
<cfset Variables.commissionStageVolumeDiscount = ArrayNew(1)>
<cfset Variables.commissionStageVolumeDollarOrQuantity = ArrayNew(1)>
<cfset Variables.commissionStageVolumeStep = ArrayNew(1)>
<cfset Variables.commissionStageInterval = ArrayNew(1)>
<cfset Variables.commissionStageIntervalType = ArrayNew(1)>
<cfset Variables.commissionStageText = ArrayNew(1)>
<cfset Variables.commissionStageDescription = ArrayNew(1)>
<cfset Variables.commissionVolumeDiscountQuantityMinimum = ArrayNew(2)>
<cfset Variables.commissionVolumeDiscountAmount = ArrayNew(2)>
<cfset Variables.commissionVolumeDiscountIsTotalCommission = ArrayNew(2)>

<cfloop Index="stageCount" From="1" To="#Variables.commissionStageCount_real#">
	<cfset thisStageCount = stageCount>
	<cfif Form["commissionStageInterval#stageCount#"] is "">
		<cfset temp = ArrayAppend(Variables.commissionStageInterval, 0)>
	<cfelse>
		<cfset temp = ArrayAppend(Variables.commissionStageInterval, Form["commissionStageInterval#stageCount#"])>
	</cfif>

	<cfloop Index="field" List="commissionStageDollarOrPercent,commissionStageVolumeDiscount,commissionStageVolumeDollarOrQuantity,commissionStageVolumeStep,commissionStageIntervalType,commissionStageText,commissionStageDescription">
		<cfset temp = ArrayAppend(Variables[field], Form["#field##stageCount#"])>
	</cfloop>

	<cfloop Index="field" List="commissionStageAmountMinimum,commissionStageAmountMaximum">
		<cfif Form["#field##stageCount#"] is "">
			<cfset temp = ArrayAppend(Variables[field], 0)>
		<cfelse>
			<cfset temp = ArrayAppend(Variables[field], Form["#field##stageCount#"])>
		</cfif>
	</cfloop>

	<cfif Form["commissionStageVolumeDiscount#stageCount#"] is 0>
		<cfset Variables.commissionVolumeDiscountQuantityMinimum[stageCount][1] = 0>
		<cfset Variables.commissionVolumeDiscountIsTotalCommission[stageCount][1] = 0>
		<cfset Variables.commissionVolumeDiscountAmount[stageCount][1] = 0>

		<cfif Form["commissionStageDollarOrPercent#stageCount#"] is 0>
			<cfset temp = ArrayAppend(Variables.commissionStageAmount, Form["commissionStageAmount#stageCount#"])>
		<cfelse>
			<cfset temp = ArrayAppend(Variables.commissionStageAmount, Form["commissionStageAmount#stageCount#"] / 100)>
		</cfif>

	<cfelse><!--- Form["commissionVolumeDiscountCount_real#stageCount#"] gt 0 --->
		<cfset temp = ArrayAppend(Variables.commissionStageAmount, 0)>
		<cfloop Index="volumeCount" From="1" To="#Form["commissionVolumeDiscountCount_real#stageCount#"]#">
			<cfset Variables.commissionVolumeDiscountQuantityMinimum[thisStageCount][volumeCount] = Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"]>
			<cfset Variables.commissionVolumeDiscountIsTotalCommission[thisStageCount][volumeCount] = Form["commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#"]>

			<cfif Form["commissionStageDollarOrPercent#thisStageCount#"] is 0>
				<cfset Variables.commissionVolumeDiscountAmount[thisStageCount][volumeCount] = Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"]>
			<cfelse>
				<cfset Variables.commissionVolumeDiscountAmount[thisStageCount][volumeCount] = Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"] / 100>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>
