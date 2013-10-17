<cfif ListFind("updateCommission,viewCommission", Variables.doAction) and IsDefined("qry_selectCommission") and Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.commissionName" Default="#qry_selectCommission.commissionName#">
	<cfparam Name="Form.commissionID_custom" Default="#qry_selectCommission.commissionID_custom#">
	<cfparam Name="Form.commissionDescription" Default="#qry_selectCommission.commissionDescription#">
	<cfparam Name="Form.commissionStatus" Default="#qry_selectCommission.commissionStatus#">

	<cfparam Name="Form.commissionAppliesToInvoice" Default="#qry_selectCommission.commissionAppliesToInvoice#">
	<cfparam Name="Form.commissionPeriodIntervalType" Default="#qry_selectCommission.commissionPeriodIntervalType#">
	<!--- <cfparam Name="Form.commissionPeriodOrInvoiceBased" Default="#qry_selectCommission.commissionPeriodOrInvoiceBased#"> --->

	<cfparam Name="Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts" Default="#qry_selectCommission.commissionAppliesToExistingProducts#_#qry_selectCommission.commissionAppliesToCustomProducts#">
	<!--- 
	<cfparam Name="Form.commissionAppliesToExistingProducts" Default="#qry_selectCommission.commissionAppliesToExistingProducts#">
	<cfparam Name="Form.commissionAppliesToCustomProducts" Default="#qry_selectCommission.commissionAppliesToCustomProducts#">
	--->

	<cfparam Name="Form.commissionDateBegin_date" Default="#DateFormat(qry_selectCommission.commissionDateBegin, 'mm/dd/yyyy')#">
	<cfparam Name="Form.commissionDateBegin_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectCommission.commissionDateBegin)), '|')#">
	<cfparam Name="Form.commissionDateBegin_mm" Default="#Minute(qry_selectCommission.commissionDateBegin)#">
	<cfparam Name="Form.commissionDateBegin_tt" Default="#TimeFormat(qry_selectCommission.commissionDateBegin, 'tt')#">

	<cfif IsDate(qry_selectCommission.commissionDateEnd)>
		<cfparam Name="Form.commissionDateEnd_date" Default="#DateFormat(qry_selectCommission.commissionDateEnd, 'mm/dd/yyyy')#">
		<cfparam Name="Form.commissionDateEnd_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectCommission.commissionDateEnd)), '|')#">
		<cfparam Name="Form.commissionDateEnd_mm" Default="#Minute(qry_selectCommission.commissionDateEnd)#">
		<cfparam Name="Form.commissionDateEnd_tt" Default="#TimeFormat(qry_selectCommission.commissionDateEnd, 'tt')#">
	</cfif>

	<cfparam Name="Form.commissionStageCount" Default="#qry_selectCommission.RecordCount#">

	<cfloop Query="qry_selectCommission">
		<cfif qry_selectCommission.commissionStageVolumeDiscount is 0>
			<cfif qry_selectCommission.commissionStageDollarOrPercent is 0>
				<cfparam Name="Form.commissionStageAmount#CurrentRow#_#qry_selectCommission.commissionStageDollarOrPercent#" Default="#Iif(qry_selectCommission.commissionStageVolumeDiscount is 0, qry_selectCommission.commissionStageAmount, De(''))#">
			<cfelse>
				<cfparam Name="Form.commissionStageAmount#CurrentRow#_#qry_selectCommission.commissionStageDollarOrPercent#" Default="#Iif(qry_selectCommission.commissionStageVolumeDiscount is 0, 100 * qry_selectCommission.commissionStageAmount, De(''))#">
			</cfif>
		</cfif>

		<cfparam Name="Form.commissionStageAmountMinimum#CurrentRow#" Default="#qry_selectCommission.commissionStageAmountMinimum#">
		<cfparam Name="Form.commissionStageAmountMaximum#CurrentRow#" Default="#qry_selectCommission.commissionStageAmountMaximum#">
		<cfparam Name="Form.commissionStageDollarOrPercent#CurrentRow#" Default="#qry_selectCommission.commissionStageDollarOrPercent#">
		<cfparam Name="Form.commissionStageVolumeDiscount#CurrentRow#" Default="#qry_selectCommission.commissionStageVolumeDiscount#">
		<cfparam Name="Form.commissionStageVolumeDollarOrQuantity#CurrentRow#" Default="#qry_selectCommission.commissionStageVolumeDollarOrQuantity#">
		<cfparam Name="Form.commissionStageVolumeStep#CurrentRow#" Default="#qry_selectCommission.commissionStageVolumeStep#">
		<cfparam Name="Form.commissionStageInterval#CurrentRow#" Default="#qry_selectCommission.commissionStageInterval#">
		<cfparam Name="Form.commissionStageIntervalType#CurrentRow#" Default="#qry_selectCommission.commissionStageIntervalType#">
		<cfparam Name="Form.commissionStageText#CurrentRow#" Default="#qry_selectCommission.commissionStageText#">
		<cfparam Name="Form.commissionStageDescription#CurrentRow#" Default="#qry_selectCommission.commissionStageDescription#">
	</cfloop>

	<cfloop Query="qry_selectCommissionTarget">
		<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectCommissionTarget.primaryTargetID)#">
		<cfcase value="userID"><cfparam Name="Form.commissionTargetsAllUsers" Default="1"></cfcase>
		<cfcase value="companyID"><cfparam Name="Form.commissionTargetsAllCompanies" Default="1"></cfcase>
		<cfcase value="affiliateID"><cfparam Name="Form.commissionTargetsAllAffiliates" Default="1"></cfcase>
		<cfcase value="cobrandID"><cfparam Name="Form.commissionTargetsAllCobrands" Default="1"></cfcase>
		<cfcase value="vendorID"><cfparam Name="Form.commissionTargetsAllVendors" Default="1"></cfcase>
		<cfcase value="groupID"><cfparam Name="Form.commissionTargetsAllGroups" Default="1"></cfcase>
		</cfswitch>
	</cfloop>

	<cfset Variables.maxVolumeCount = 0>
	<cfset volumeCount = 0>
	<cfloop Query="qry_selectCommissionVolumeDiscount">
		<cfif qry_selectCommissionVolumeDiscount.CurrentRow is 1 or qry_selectCommissionVolumeDiscount.commissionStageID is not qry_selectCommissionVolumeDiscount.commissionStageID[CurrentRow - 1]>
			<cfset volumeCount = 1>
			<cfset Variables.commissionStageRow = ListFind(ValueList(qry_selectCommission.commissionStageID), qry_selectCommissionVolumeDiscount.commissionStageID)>
			<cfif Variables.commissionStageRow is 0>
				<cfset thisCommissionStageOrder = 0>
			<cfelse>
				<cfset thisCommissionStageOrder = qry_selectCommission.commissionStageOrder[Variables.commissionStageRow]>
			</cfif>
		<cfelse>
			<cfset volumeCount = volumeCount + 1>
		</cfif>

		<cfset Variables.maxVolumeCount = Max(Variables.maxVolumeCount, volumeCount)>

		<cfif qry_selectCommission.commissionStageDollarOrPercent[Variables.thisCommissionStageOrder] is 0>
			<cfparam Name="Form.commissionVolumeDiscountAmount#thisCommissionStageOrder#_#volumeCount#" Default="#qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount#">
		<cfelse>
			<cfparam Name="Form.commissionVolumeDiscountAmount#thisCommissionStageOrder#_#volumeCount#" Default="#Evaluate(100 * qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount)#">
		</cfif>

		<cfparam Name="Form.commissionVolumeDiscountQuantityMinimum#thisCommissionStageOrder#_#volumeCount#" Default="#qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum#">
		<cfparam Name="Form.commissionVolumeDiscountIsTotalCommission#thisCommissionStageOrder#_#volumeCount#" Default="#qry_selectCommissionVolumeDiscount.commissionVolumeDiscountIsTotalCommission#">
	</cfloop>

	<cfparam Name="Form.commissionVolumeDiscountCount" Default="#Variables.maxVolumeCount#">
</cfif>

<cfparam Name="Form.commissionName" Default="">
<cfparam Name="Form.commissionID_custom" Default="">
<cfparam Name="Form.commissionDescription" Default="">
<cfparam Name="Form.commissionStatus" Default="1">
<!--- 
<cfparam Name="Form.commissionAppliesToExistingProducts" Default="0">
<cfparam Name="Form.commissionAppliesToCustomProducts" Default="0">
--->
<cfparam Name="Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts" Default="1_1">
<cfparam Name="Form.commissionAppliesToInvoice" Default="0">
<cfparam Name="Form.commissionPeriodIntervalType" Default="">
<!--- <cfparam Name="Form.commissionPeriodOrInvoiceBased" Default="0"> --->

<cfparam Name="Form.commissionDateBegin_now" Default="0">
<cfparam Name="Form.commissionDateBegin_date" Default="#DateFormat(Now(), 'mm/dd/yyyy')#">
<cfparam Name="Form.commissionDateBegin_hh" Default="12">
<cfparam Name="Form.commissionDateBegin_mm" Default="00">
<cfparam Name="Form.commissionDateBegin_tt" Default="am">

<cfparam Name="Form.commissionDateEnd_now" Default="0">
<cfparam Name="Form.commissionDateEnd_date" Default="">
<cfparam Name="Form.commissionDateEnd_hh" Default="12">
<cfparam Name="Form.commissionDateEnd_mm" Default="00">
<cfparam Name="Form.commissionDateEnd_tt" Default="am">

<cfparam Name="Form.commissionStageCount" Default="1">

<cfparam Name="Form.commissionTargetsAllUsers" Default="0">
<cfparam Name="Form.commissionTargetsAllGroups" Default="0">
<cfparam Name="Form.commissionTargetsAllAffiliates" Default="0">
<cfparam Name="Form.commissionTargetsAllCobrands" Default="0">
<cfparam Name="Form.commissionTargetsAllCompanies" Default="0">
<cfparam Name="Form.commissionTargetsAllVendors" Default="0">

<cfif Not Application.fn_IsIntegerPositive(Form.commissionStageCount) or Form.commissionStageCount gt 255>
	<cfset Form.commissionStageCount = 1>
</cfif>

<cfparam Name="Form.commissionVolumeDiscountCount" Default="5">
<cfif Not Application.fn_IsIntegerPositive(Form.commissionVolumeDiscountCount)>
	<cfset Form.commissionVolumeDiscountCount = 5>
</cfif>

<cfloop Index="stageCount" From="1" To="#Form.commissionStageCount#">
	<cfparam Name="Form.commissionStageAmount#stageCount#_0" Default="">
	<cfparam Name="Form.commissionStageAmount#stageCount#_1" Default="">
	<cfparam Name="Form.commissionStageAmountMinimum#stageCount#" Default="">
	<cfparam Name="Form.commissionStageAmountMaximum#stageCount#" Default="">
	<cfparam Name="Form.commissionStageDollarOrPercent#stageCount#" Default="1">
	<cfparam Name="Form.commissionStageVolumeDiscount#stageCount#" Default="0">
	<cfparam Name="Form.commissionStageVolumeDollarOrQuantity#stageCount#" Default="0">
	<cfparam Name="Form.commissionStageVolumeStep#stageCount#" Default="0">
	<cfparam Name="Form.commissionStageInterval#stageCount#" Default="">
	<cfif Form["commissionStageInterval#stageCount#"] is 0>
		<cfset Form["commissionStageInterval#stageCount#"] = "">
	</cfif>
	<cfparam Name="Form.commissionStageIntervalType#stageCount#" Default="">
	<cfparam Name="Form.commissionStageText#stageCount#" Default="">
	<cfparam Name="Form.commissionStageDescription#stageCount#" Default="">

	<cfif Form["commissionStageAmountMinimum#stageCount#"] is 0>
		<cfset Form["commissionStageAmountMinimum#stageCount#"] = "">
	</cfif>
	<cfif Form["commissionStageAmountMaximum#stageCount#"] is 0>
		<cfset Form["commissionStageAmountMaximum#stageCount#"] = "">
	</cfif>

	<cfset thisStageCount = stageCount>
	<cfloop Index="volumeCount" From="1" To="#Form.commissionVolumeDiscountCount#">
		<cfparam Name="Form.commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#" Default="">
		<cfparam Name="Form.commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#" Default="">
		<cfparam Name="Form.commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#" Default="0">
	</cfloop>
</cfloop>
