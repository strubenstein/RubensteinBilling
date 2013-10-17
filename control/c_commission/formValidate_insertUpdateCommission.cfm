<cfset errorMessage_fields = StructNew()>

<!--- commissionAppliesToExistingProducts,commissionAppliesToCustomProducts, --->
<cfloop Index="field" List="commissionStatus,commissionAppliesToInvoice,commissionTargetsAllUsers,commissionTargetsAllGroups,commissionTargetsAllAffiliates,commissionTargetsAllCobrands,commissionTargetsAllCompanies,commissionTargetsAllVendors">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdateCommission[field]>
	</cfif>
</cfloop>

<cfif Not ListFind("1_1,0_1,1_0", Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts)>
	<cfset errorMessage_fields.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts = Variables.lang_insertUpdateCommission.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts>
</cfif>

<cfif Len(Form.commissionName) gt maxlength_Commission.commissionName>
	<cfset errorMessage_fields.commissionName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionName_maxlength, "<<MAXLENGTH>>", maxlength_Commission.commissionName, "ALL"), "<<LEN>>", Len(Form.commissionName), "ALL")>
</cfif>

<cfif Len(Form.commissionDescription) gt maxlength_Commission.commissionDescription>
	<cfset errorMessage_fields.commissionDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionDescription_maxlength, "<<MAXLENGTH>>", maxlength_Commission.commissionDescription, "ALL"), "<<LEN>>", Len(Form.commissionDescription), "ALL")>
</cfif>

<cfif Len(Form.commissionID_custom) gt maxlength_Commission.commissionID_custom>
	<cfset errorMessage_fields.commissionID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Commission.commissionID_custom, "ALL"), "<<LEN>>", Len(Form.commissionID_custom), "ALL")>
</cfif>

<cfif Form.commissionPeriodIntervalType is not "" and Not ListFind(Variables.commissionPeriodIntervalTypeList_value, Form.commissionPeriodIntervalType)>
	<cfset errorMessage_fields.commissionPeriodIntervalType = Variables.lang_insertUpdateCommission.commissionPeriodIntervalType>
</cfif>

<cfset Form.commissionDateBegin = "">
<cfif Not ListFind("0,1", Form.commissionDateBegin_now)>
	<cfset errorMessage_fields.commissionDateBegin_now = Variables.lang_insertUpdateCommission.commissionDateBegin_now>
<cfelseif Form.commissionDateBegin_now is 1>
	<cfset Form.commissionDateBegin = fn_NowDateTimeIn5MinuteInterval()>
<cfelse>
	<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "commissionDateBegin_date", Form.commissionDateBegin_date, "commissionDateBegin_hh", Form.commissionDateBegin_hh, "commissionDateBegin_mm", Form.commissionDateBegin_mm, "commissionDateBegin_tt", Form.commissionDateBegin_tt)>
	<cfif IsDate(Variables.dateBeginResponse)>
		<cfset Form.commissionDateBegin = Variables.dateBeginResponse>
	<cfelse><!--- IsStruct(Variables.dateBeginResponse) --->
		<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfset Form.commissionDateEnd = "">
<cfif Not ListFind("0,1", Form.commissionDateEnd_now)>
	<cfset errorMessage_fields.commissionDateEnd_now = Variables.lang_insertUpdateCommission.commissionDateEnd_now>
<cfelseif Form.commissionDateEnd_now is 1>
	<cfset Form.commissionDateBegin = fn_NowDateTimeIn5MinuteInterval()>
<cfelse>
	<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "commissionDateEnd_date", Form.commissionDateEnd_date, "commissionDateEnd_hh", Form.commissionDateEnd_hh, "commissionDateEnd_mm", Form.commissionDateEnd_mm, "commissionDateEnd_tt", Form.commissionDateEnd_tt)>
	<cfif Variables.dateEndResponse is "" or IsDate(Variables.dateEndResponse)>
		<cfset Form.commissionDateEnd = Variables.dateEndResponse>
	<cfelse><!--- IsStruct(Variables.dateEndResponse) --->
		<cfloop Collection="#Variables.dateEndResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfif IsDate(Form.commissionDateBegin) and IsDate(Form.commissionDateEnd) and DateCompare(Form.commissionDateBegin, Form.commissionDateEnd) is not -1>
	<cfset errorMessage_fields.commissionDateBeginEnd = Variables.lang_insertUpdateCommission.commissionDateBeginEnd>
</cfif>

<cfset Variables.commissionStageCount_real = 0>
<cfset Variables.isLastCommissionStage = False>
<cfloop Index="stageCount" From="1" To="#Form.commissionStageCount#">
	<cfset thisStageCount = stageCount>

	<cfif Len(Form["commissionStageText#stageCount#"]) gt maxlength_CommissionStage.commissionStageText>
		<cfset errorMessage_fields["commissionStageText#stageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageText_maxlength, "<<MAXLENGTH>>", maxlength_CommissionStage.commissionStageText, "ALL"), "<<LEN>>", Len(Form["commissionStageText#stageCount#"]), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Len(Form["commissionStageDescription#stageCount#"]) gt maxlength_CommissionStage.commissionStageDescription>
		<cfset errorMessage_fields["commissionStageDescription#stageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageDescription_maxlength, "<<MAXLENGTH>>", maxlength_CommissionStage.commissionStageDescription, "ALL"), "<<LEN>>", Len(Form["commissionStageDescription#stageCount#"]), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Form["commissionStageAmountMinimum#stageCount#"] is not "">
		<cfif Not IsNumeric(Form["commissionStageAmountMinimum#stageCount#"])>
			<cfset errorMessage_fields["commissionStageAmountMinimum#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmountMinimum_numeric, "<<STAGE>>", stageCount, "ALL")>
		<cfelseif Find(".", Form["commissionStageAmountMinimum#stageCount#"]) and Len(ListLast(Form["commissionStageAmountMinimum#stageCount#"], ".")) gt maxlength_CommissionStage.commissionStageAmountMinimum>
			<cfset errorMessage_fields["commissionStageAmountMinimum#stageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmountMinimum_maxlength, "<<STAGE>>", stageCount, "ALL"), "<<MAXLENGTH>>", maxlength_CommissionStage.commissionStageAmountMinimum, "ALL")>
		</cfif>
	</cfif>

	<cfif Form["commissionStageAmountMaximum#stageCount#"] is not "">
		<cfif Not IsNumeric(Form["commissionStageAmountMaximum#stageCount#"])>
			<cfset errorMessage_fields["commissionStageAmountMaximum#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_numeric, "<<STAGE>>", stageCount, "ALL")>
		<cfelseif Find(".", Form["commissionStageAmountMaximum#stageCount#"]) and Len(ListLast(Form["commissionStageAmountMaximum#stageCount#"], ".")) gt maxlength_CommissionStage.commissionStageAmountMaximum>
			<cfset errorMessage_fields["commissionStageAmountMaximum#stageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_maxlength, "<<STAGE>>", stageCount, "ALL"), "<<MAXLENGTH>>", maxlength_CommissionStage.commissionStageAmountMinimum, "ALL")>
		<cfelseif IsNumeric(Form["commissionStageAmountMinimum#stageCount#"]) and Form["commissionStageAmountMinimum#stageCount#"] gte Form["commissionStageAmountMaximum#stageCount#"]>
			<cfset errorMessage_fields["commissionStageAmountMaximum#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_minimum, "<<STAGE>>", stageCount, "ALL")>
		</cfif>
	</cfif>

	<cfif Trim(Form["commissionStageInterval#stageCount#"]) is "">
		<cfset Variables.isLastCommissionStage = True>
		<cfset Variables.commissionStageCount_real = stageCount>
	<cfelseif Not Application.fn_IsIntegerPositive(Form["commissionStageInterval#stageCount#"])>
		<cfset errorMessage_fields["commissionStageInterval#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageInterval_integer, "<<STAGE>>", thisStageCount, "ALL")>
	<cfelseif stageCount is Form.commissionStageCount>
		<cfset errorMessage_fields["commissionStageInterval#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageInterval_lastBlank, "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Form["commissionStageIntervalType#stageCount#"] is not "" and Not ListFind(Variables.commissionStageIntervalTypeList_value, Form["commissionStageIntervalType#stageCount#"])>
		<cfset errorMessage_fields["commissionStageIntervalType#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageIntervalType_valid, "<<STAGE>>", thisStageCount, "ALL")>
	<cfelseif Form["commissionStageIntervalType#stageCount#"] is "" and Variables.isLastCommissionStage is False>
		<cfset errorMessage_fields["commissionStageIntervalType#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageIntervalType_blank, "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfloop Index="field" List="commissionStageDollarOrPercent,commissionStageVolumeDiscount,commissionStageVolumeDollarOrQuantity,commissionStageVolumeStep">
		<cfif Not ListFind("0,1", Form["#field##thisStageCount#"])>
			<cfset errorMessage_fields["#field##thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission[field], "<<STAGE>>", thisStageCount, "ALL")>
		</cfif>
	</cfloop>

	<cfset Form["commissionStageAmount#stageCount#"] = 0>
	<cfset Form["commissionVolumeDiscountCount_real#stageCount#"] = 0>

	<cfif Form["commissionStageVolumeDiscount#stageCount#"] is 0>
		<cfset Variables.commissionStageAmountField = "commissionStageAmount" & stageCount & "_" & Form["commissionStageDollarOrPercent#stageCount#"]>
		<cfif Not IsNumeric(Form[Variables.commissionStageAmountField])>
			<cfset errorMessage_fields["commissionStageAmount#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmount_numeric, "<<STAGE>>", stageCount, "ALL")>
		<cfelseif Find(".", Form[Variables.commissionStageAmountField]) and Len(ListLast(Form[Variables.commissionStageAmountField], ".")) gt maxlength_CommissionStage.commissionStageAmount>
			<cfset errorMessage_fields["commissionStageAmount#stageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionStageAmount_maxlength, "<<MAXLENGTH>>", maxlength_CommissionStage.commissionStageAmount, "ALL"), "<<STAGE>>", stageCount, "ALL")>
		<cfelse>
			<cfset Form["commissionStageAmount#stageCount#"] = Form[Variables.commissionStageAmountField]>
		</cfif>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.commissionVolumeDiscountCount) or Form.commissionVolumeDiscountCount lt 2>
		<cfset errorMessage_fields.commissionVolumeDiscountCount = Variables.lang_insertUpdateCommission.commissionVolumeDiscountCount>
	<cfelse>
		<!--- 
		if quantity is blank
			if first row, return error: use standard price instead
		else validate volume discount level
			if commission is not numeric, return error
			elseif quantity or commission are not numeric: return error
			elseif quantity lte previous quantity: return error
		--->

		<cfloop Index="volumeCount" From="1" To="#Form.commissionVolumeDiscountCount#">
			<cfif Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"] is "">
				<cfif volumeCount is 1>
					<cfset errorMessage_fields["commissionVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_single, "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				</cfif>
			<cfelse><!--- not blank quantity --->
				<cfif Not IsNumeric(Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["commissionVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_quantity, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif Find(".", Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"]) and Len(ListLast(Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"], ".")) gt maxlength_CommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum>
					<cfset errorMessage_fields["commissionVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_maxlength, "<<MAXLENGTH>>", maxlength_CommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif volumeCount gt 1 and Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"] lte Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#DecrementValue(volumeCount)#"]>
					<cfset errorMessage_fields["commissionVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_increase, "<<COUNT>>", volumeCount, "ALL"), "<<COUNTMINUS1>>", DecrementValue(volumeCount), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				</cfif>

				<cfif Not IsNumeric(Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["commissionVolumeDiscountAmount#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountAmount_numeric, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif Find(".", Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"]) and Len(ListLast(Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"], ".")) gt maxlength_CommissionVolumeDiscount.commissionVolumeDiscountAmount>
					<cfset errorMessage_fields["commissionVolumeDiscountAmount#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountAmount_maxlength, "<<MAXLENGTH>>", maxlength_CommissionVolumeDiscount.commissionVolumeDiscountAmount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				</cfif>

				<cfif Not ListFind("0,1", Form["commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["commissionVolumeDiscountIsTotalCommission#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_valid, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<!--- must be using straight dollar amount and step method if using total commission method --->
				<cfelseif Form["commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#"] is 1>
					<cfif Form["commissionStageDollarOrPercent#stageCount#"] is not 0>
						<cfset errorMessage_fields["commissionVolumeDiscountIsTotalCommission#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_commission, "<<STAGE>>", thisStageCount, "ALL")>
						<cfbreak>
					<cfelseif Form["commissionStageVolumeStep#stageCount#"] is not 1>
						<cfset errorMessage_fields["commissionVolumeDiscountIsTotalCommission#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_step, "<<STAGE>>", thisStageCount, "ALL")>
						<cfbreak>
					</cfif>
				</cfif>

				<cfset Form["commissionVolumeDiscountCount_real#stageCount#"] = Form["commissionVolumeDiscountCount_real#stageCount#"] + 1>
			</cfif><!--- /not blank quantity --->
		</cfloop>

		<cfif Form["commissionVolumeDiscountCount_real#stageCount#"] lt 2>
			<cfset errorMessage_fields["commissionVolumeDiscountCount_real#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdateCommission.commissionVolumeDiscountCount_real, "<<STAGE>>", thisStageCount, "ALL")>
		</cfif>
	</cfif>

	<cfif Variables.isLastCommissionStage is True>
		<cfbreak>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCommission">
		<cfset errorMessage_title = Variables.lang_insertUpdateCommission.errorTitle_insert>
	<cfelse><!--- updateCommission --->
		<cfset errorMessage_title = Variables.lang_insertUpdateCommission.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateCommission.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateCommission.errorFooter>
</cfif>
