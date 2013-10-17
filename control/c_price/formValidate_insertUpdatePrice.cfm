<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.priceStatus)>
	<cfset errorMessage_fields.priceStatus = Variables.lang_insertUpdatePrice.priceStatus>
</cfif>

<cfif Len(Form.priceName) gt maxlength_Price.priceName>
	<cfset errorMessage_fields.priceName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceName_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceName, "ALL"), "<<LEN>>", Len(Form.priceName), "ALL")>
</cfif>

<cfif Len(Form.priceDescription) gt maxlength_Price.priceDescription>
	<cfset errorMessage_fields.priceDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceDescription_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceDescription, "ALL"), "<<LEN>>", Len(Form.priceDescription), "ALL")>
</cfif>

<cfif Len(Form.priceID_custom) gt maxlength_Price.priceID_custom>
	<cfset errorMessage_fields.priceID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceID_custom, "ALL"), "<<LEN>>", Len(Form.priceID_custom), "ALL")>
</cfif>

<cfif Len(Form.priceCode) gt maxlength_Price.priceCode>
	<cfset errorMessage_fields.priceCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceCode_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceCode, "ALL"), "<<LEN>>", Len(Form.priceCode), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.priceCodeRequired)>
	<cfset errorMessage_fields.priceCodeRequired = Variables.lang_insertUpdatePrice.priceCodeRequired_valid>
<cfelseif Trim(Form.priceCode) is "" and Form.priceCodeRequired is 1>
	<cfset errorMessage_fields.priceCodeRequired = Variables.lang_insertUpdatePrice.priceCodeRequired_blank>
</cfif>

<cfif Not ListFind("0,1", Form.priceAppliesToAllCustomers)>
	<cfset errorMessage_fields.priceAppliesToAllCustomers = Variables.lang_insertUpdatePrice.priceAppliesToAllCustomers>
</cfif>

<cfif Not ListFind("0,1", Form.priceAppliesToProductChildren)>
	<cfset errorMessage_fields.priceAppliesToProductChildren = Variables.lang_insertUpdatePrice.priceAppliesToProductChildren_valid>
<cfelseif Form.priceAppliesToProductChildren is 1 and URL.productID is 0>
	<cfset errorMessage_fields.priceAppliesToProductChildren = Variables.lang_insertUpdatePrice.priceAppliesToProductChildren_all>
</cfif>

<cfif Not ListFind("0,1", Form.priceAppliesToCategoryChildren)>
	<cfset errorMessage_fields.priceAppliesToCategoryChildren = Variables.lang_insertUpdatePrice.priceAppliesToCategoryChildren_valid>
<cfelseif Form.priceAppliesToCategoryChildren is 1 and URL.categoryID is 0>
	<cfset errorMessage_fields.priceAppliesToCategoryChildren = Variables.lang_insertUpdatePrice.priceAppliesToCategoryChildren_all>
</cfif>

<cfif IsDefined("Form.priceAppliesToAllProductsOrInvoices") and (URL.productID is not 0 and URL.categoryID is not 0)>
	<cfif Form.priceAppliesToAllProductsOrInvoices is "priceAppliesToAllProducts">
		<cfset Form.priceAppliesToAllProducts = 1>
		<cfset Form.priceAppliesToInvoice = 0>
	<cfelse>
		<cfset Form.priceAppliesToAllProducts = 0>
		<cfset Form.priceAppliesToInvoice = 1>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.priceAppliesToAllProducts)>
	<cfset errorMessage_fields.priceAppliesToAllProducts = Variables.lang_insertUpdatePrice.priceAppliesToAllProducts_valid>
<cfelseif Form.priceAppliesToAllProducts is 1 and (URL.productID is not 0 or URL.categoryID is not 0)>
	<cfset errorMessage_fields.priceAppliesToAllProducts = Variables.lang_insertUpdatePrice.priceAppliesToAllProducts_all>
</cfif>

<cfif Not ListFind("0,1", Form.priceAppliesToInvoice)>
	<cfset errorMessage_fields.priceAppliesToInvoice = Variables.lang_insertUpdatePrice.priceAppliesToInvoice_valid>
<cfelseif Form.priceAppliesToInvoice is 1 and (URL.productID is not 0 or URL.categoryID is not 0)>
	<cfset errorMessage_fields.priceAppliesToInvoice = Variables.lang_insertUpdatePrice.priceAppliesToInvoice_all>
</cfif>

<!--- not currently fields on the form anyway --->
<cfif Len(Form.priceBillingMethod) gt maxlength_Price.priceBillingMethod>
	<cfset errorMessage_fields.priceBillingMethod = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceBillingMethod_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceBillingMethod, "ALL"), "<<LEN>>", Len(Form.priceBillingMethod), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.priceApproved)>
	<cfset errorMessage_fields.priceApproved = Variables.lang_insertUpdatePrice.priceApproved>
</cfif>
<!--- /not currently fields on the form anyway --->

<cfif Form.priceQuantityMinimumPerOrder is not "" and (Not IsNumeric(Form.priceQuantityMinimumPerOrder) or Form.priceQuantityMinimumPerOrder lte 0)>
	<cfset errorMessage_fields.priceQuantityMinimumPerOrder = Variables.lang_insertUpdatePrice.priceQuantityMinimumPerOrder_numeric>
<cfelseif Find(".", Form.priceQuantityMinimumPerOrder) and Len(ListLast(Form.priceQuantityMinimumPerOrder, ".")) gt maxlength_Price.priceQuantityMinimumPerOrder>
	<cfset errorMessage_fields.priceQuantityMinimumPerOrder = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceQuantityMinimumPerOrder_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceQuantityMinimumPerOrder, "ALL")>
</cfif>

<cfif Form.priceQuantityMaximumPerCustomer is not "" and (Not IsNumeric(Form.priceQuantityMaximumPerCustomer) or Form.priceQuantityMaximumPerCustomer lte 0)>
	<cfset errorMessage_fields.priceQuantityMaximumPerCustomer = Variables.lang_insertUpdatePrice.priceQuantityMaximumPerCustomer_numeric>
<cfelseif Find(".", Form.priceQuantityMaximumPerCustomer) and Len(ListLast(Form.priceQuantityMaximumPerCustomer, ".")) gt maxlength_Price.priceQuantityMaximumPerCustomer>
	<cfset errorMessage_fields.priceQuantityMaximumPerCustomer = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceQuantityMaximumPerCustomer_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceQuantityMaximumPerCustomer, "ALL")>
</cfif>

<cfif Form.priceQuantityMaximumAllCustomers is not "" and (Not IsNumeric(Form.priceQuantityMaximumAllCustomers) or Form.priceQuantityMaximumAllCustomers lte 0)>
	<cfset errorMessage_fields.priceQuantityMaximumAllCustomers = Variables.lang_insertUpdatePrice.priceQuantityMaximumAllCustomers_numeric>
<cfelseif Find(".", Form.priceQuantityMaximumAllCustomers) and Len(ListLast(Form.priceQuantityMaximumAllCustomers, ".")) gt maxlength_Price.priceQuantityMaximumAllCustomers>
	<cfset errorMessage_fields.priceQuantityMaximumAllCustomers = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceQuantityMaximumAllCustomers_maxlength, "<<MAXLENGTH>>", maxlength_Price.priceQuantityMaximumAllCustomers, "ALL")>
</cfif>

<!--- maximum total or maximum per customer is greater than minimum per order --->
<cfif IsNumeric(Form.priceQuantityMinimumPerOrder)>
	<cfif IsNumeric(Form.priceQuantityMaximumPerCustomer) and Form.priceQuantityMaximumPerCustomer lt Form.priceQuantityMinimumPerOrder>
		<cfset errorMessage_fields.priceQuantityMaximum1 = Variables.lang_insertUpdatePrice.priceQuantityMaximum1>
	</cfif>

	<cfif IsNumeric(Form.priceQuantityMaximumAllCustomers) and Form.priceQuantityMaximumAllCustomers lt Form.priceQuantityMinimumPerOrder>
		<cfset errorMessage_fields.priceQuantityMaximum2 = Variables.lang_insertUpdatePrice.priceQuantityMaximum2>
	</cfif>
</cfif>

<!--- maximum total is less than maximum per customer --->
<cfif IsNumeric(Form.priceQuantityMaximumAllCustomers) and IsNumeric(Form.priceQuantityMaximumPerCustomer) and Form.priceQuantityMaximumAllCustomers lt Form.priceQuantityMaximumPerCustomer>
	<cfset errorMessage_fields.priceQuantityMaximum3 = Variables.lang_insertUpdatePrice.priceQuantityMaximum3>
</cfif>

<cfset Form.priceDateBegin = "">
<cfif Not ListFind("0,1", Form.priceDateBegin_now)>
	<cfset errorMessage_fields.priceDateBegin_now = Variables.lang_insertUpdatePrice.priceDateBegin_now>
<cfelseif Form.priceDateBegin_now is 1>
	<cfset Form.priceDateBegin = fn_NowDateTimeIn5MinuteInterval()>
<cfelse>
	<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "priceDateBegin_date", Form.priceDateBegin_date, "priceDateBegin_hh", Form.priceDateBegin_hh, "priceDateBegin_mm", Form.priceDateBegin_mm, "priceDateBegin_tt", Form.priceDateBegin_tt)>
	<cfif IsDate(Variables.dateBeginResponse)>
		<cfset Form.priceDateBegin = Variables.dateBeginResponse>
	<cfelse><!--- IsStruct(Variables.dateBeginResponse) --->
		<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfset Form.priceDateEnd = "">
<cfif Not ListFind("0,1", Form.priceDateEnd_now)>
	<cfset errorMessage_fields.priceDateEnd_now = Variables.lang_insertUpdatePrice.priceDateEnd_now>
<cfelseif Form.priceDateEnd_now is 1>
	<cfset Form.priceDateBegin = fn_NowDateTimeIn5MinuteInterval()>
<cfelse>
	<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "priceDateEnd_date", Form.priceDateEnd_date, "priceDateEnd_hh", Form.priceDateEnd_hh, "priceDateEnd_mm", Form.priceDateEnd_mm, "priceDateEnd_tt", Form.priceDateEnd_tt)>
	<cfif Variables.dateEndResponse is "" or IsDate(Variables.dateEndResponse)>
		<cfset Form.priceDateEnd = Variables.dateEndResponse>
	<cfelse><!--- IsStruct(Variables.dateEndResponse) --->
		<cfloop Collection="#Variables.dateEndResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfif IsDate(Form.priceDateBegin) and IsDate(Form.priceDateEnd) and DateCompare(Form.priceDateBegin, Form.priceDateEnd) is not -1>
	<cfset errorMessage_fields.priceDateBeginEnd = Variables.lang_insertUpdatePrice.priceDateBeginEnd>
</cfif>

<cfset Variables.priceStageCount_real = 0>
<cfset Variables.isLastPriceStage = False>
<cfloop Index="stageCount" From="1" To="#Form.priceStageCount#">
	<cfset thisStageCount = stageCount>

	<cfif Len(Form["priceStageText#stageCount#"]) gt maxlength_PriceStage.priceStageText>
		<cfset errorMessage_fields["priceStageText#stageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageText_maxlength, "<<MAXLENGTH>>", maxlength_PriceStage.priceStageText, "ALL"), "<<LEN>>", Len(Form["priceStageText#stageCount#"]), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Len(Form["priceStageDescription#stageCount#"]) gt maxlength_PriceStage.priceStageDescription>
		<cfset errorMessage_fields["priceStageDescription#stageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageDescription_maxlength, "<<MAXLENGTH>>", maxlength_PriceStage.priceStageDescription, "ALL"), "<<LEN>>", Len(Form["priceStageDescription#stageCount#"]), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Trim(Form["priceStageInterval#stageCount#"]) is "">
		<cfset Variables.isLastPriceStage = True>
		<cfset Variables.priceStageCount_real = stageCount>
	<cfelseif Not Application.fn_IsIntegerPositive(Form["priceStageInterval#stageCount#"])>
		<cfset errorMessage_fields["priceStageInterval#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageInterval_integer, "<<STAGE>>", thisStageCount, "ALL")>
	<cfelseif stageCount is Form.priceStageCount>
		<cfset errorMessage_fields["priceStageInterval#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageInterval_lastBlank, "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Form["priceStageIntervalType#stageCount#"] is not "" and Not ListFind(Variables.priceStageIntervalTypeList_value, Form["priceStageIntervalType#stageCount#"])>
		<cfset errorMessage_fields["priceStageIntervalType#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageIntervalType_valid, "<<STAGE>>", thisStageCount, "ALL")>
	<cfelseif Form["priceStageIntervalType#stageCount#"] is "" and Variables.isLastPriceStage is False>
		<cfset errorMessage_fields["priceStageIntervalType#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageIntervalType_blank, "<<STAGE>>", thisStageCount, "ALL")>
	</cfif>

	<cfif Not IsDefined("Form.priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#") or ListLen(Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"], "_") is not 2>
		<cfset Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] = "">
	</cfif>

	<cfset Form["priceStageDollarOrPercent#stageCount#"] = ListFirst(Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"], "_")>
	<cfset Form["priceStageNewOrDeduction#stageCount#"] = ListLast(Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"], "_")>

	<cfif URL.productID is 0 and Form["priceStageDollarOrPercent#stageCount#"] is 0 and Form["priceStageNewOrDeduction#stageCount#"] is 0>
		<cfset errorMessage_fields.priceStageNewOrDeduction_product = Variables.lang_insertUpdatePrice.priceStageNewOrDeduction_product>
	</cfif>

	<cfloop Index="field" List="priceStageDollarOrPercent,priceStageNewOrDeduction,priceStageVolumeDiscount,priceStageVolumeDollarOrQuantity,priceStageVolumeStep">
		<cfif Not ListFind("0,1", Form["#field##thisStageCount#"])>
			<cfset errorMessage_fields["#field##thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice[field], "<<STAGE>>", thisStageCount, "ALL")>
		</cfif>
	</cfloop>

	<cfset Form["priceStageAmount#stageCount#"] = 0>
	<cfset Form["priceVolumeDiscountCount_real#stageCount#"] = 0>

	<cfif Form["priceStageVolumeDiscount#stageCount#"] is 0>
		<cfset Variables.priceStageAmountField = "priceStageAmount" & stageCount & "_" & Form["priceStageDollarOrPercent#stageCount#"] & "_" & Form["priceStageNewOrDeduction#stageCount#"]>
		<cfif Not IsNumeric(Form[Variables.priceStageAmountField])>
			<cfset errorMessage_fields["priceStageAmount#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageAmount_numeric, "<<STAGE>>", stageCount, "ALL")>
		<cfelseif Find(".", Form[Variables.priceStageAmountField]) and Len(ListLast(Form[Variables.priceStageAmountField], ".")) gt maxlength_PriceStage.priceStageAmount>
			<cfset errorMessage_fields["priceStageAmount#stageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceStageAmount_maxlength, "<<MAXLENGTH>>", maxlength_PriceStage.priceStageAmount, "ALL"), "<<STAGE>>", stageCount, "ALL")>
		<cfelse>
			<cfset Form["priceStageAmount#stageCount#"] = Form[Variables.priceStageAmountField]>
		</cfif>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.priceVolumeDiscountCount) or Form.priceVolumeDiscountCount lt 2>
		<cfset errorMessage_fields.priceVolumeDiscountCount = Variables.lang_insertUpdatePrice.priceVolumeDiscountCount>
	<cfelse>
		<!--- 
		if quantity is blank
			if first row, return error: use standard price instead
		else validate volume discount level
			if price is not numeric, return error
			elseif quantity or price are not numeric: return error
			elseif quantity lte previous quantity: return error
		--->

		<cfloop Index="volumeCount" From="1" To="#Form.priceVolumeDiscountCount#">
			<cfif Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"] is "">
				<cfif volumeCount is 1>
					<cfset errorMessage_fields["priceVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountQuantityMinimum_single, "<<STAGE>>", thisStageCount, "ALL")>
				</cfif>
				<cfbreak>
			<cfelse><!--- not blank quantity --->
				<cfif Not IsNumeric(Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["priceVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountQuantityMinimum_quantity, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif Find(".", Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"]) and Len(ListLast(Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"], ".")) gt maxlength_PriceVolumeDiscount.priceVolumeDiscountQuantityMinimum>
					<cfset errorMessage_fields["priceVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountQuantityMinimum_maxlength, "<<MAXLENGTH>>", maxlength_PriceVolumeDiscount.priceVolumeDiscountQuantityMinimum, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif volumeCount gt 1 and Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"] lte Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#DecrementValue(volumeCount)#"]>
					<cfset errorMessage_fields["priceVolumeDiscountQuantityMinimum#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountQuantityMinimum_increase, "<<COUNT>>", volumeCount, "ALL"), "<<COUNTMINUS1>>", DecrementValue(volumeCount), "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				</cfif>

				<cfif Not IsNumeric(Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["priceVolumeDiscountAmount#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountAmount_numeric, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<cfelseif Find(".", Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"]) and Len(ListLast(Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"], ".")) gt maxlength_PriceVolumeDiscount.priceVolumeDiscountAmount>
					<cfset errorMessage_fields["priceVolumeDiscountAmount#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountAmount_maxlength, "<<MAXLENGTH>>", maxlength_PriceVolumeDiscount.priceVolumeDiscountAmount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				</cfif>

				<cfif Not ListFind("0,1", Form["priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#"])>
					<cfset errorMessage_fields["priceVolumeDiscountIsTotalPrice#thisStageCount#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountIsTotalPrice_valid, "<<COUNT>>", volumeCount, "ALL"), "<<STAGE>>", thisStageCount, "ALL")>
					<cfbreak>
				<!--- must be using straight dollar amount and step method if using total price method --->
				<cfelseif Form["priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#"] is 1>
					<cfif Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] is not "0_0">
						<cfset errorMessage_fields["priceVolumeDiscountIsTotalPrice#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountIsTotalPrice_price, "<<STAGE>>", thisStageCount, "ALL")>
						<cfbreak>
					<cfelseif Form["priceStageVolumeStep#stageCount#"] is not 1>
						<cfset errorMessage_fields["priceVolumeDiscountIsTotalPrice#thisStageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountIsTotalPrice_step, "<<STAGE>>", thisStageCount, "ALL")>
						<cfbreak>
					</cfif>
				</cfif>

				<cfset Form["priceVolumeDiscountCount_real#stageCount#"] = Form["priceVolumeDiscountCount_real#stageCount#"] + 1>
			</cfif><!--- /not blank quantity --->
		</cfloop>

		<cfif Form["priceVolumeDiscountCount_real#stageCount#"] lt 2>
			<cfset errorMessage_fields["priceVolumeDiscountCount_real#stageCount#"] = ReplaceNoCase(Variables.lang_insertUpdatePrice.priceVolumeDiscountCount_real, "<<STAGE>>", thisStageCount, "ALL")>
		</cfif>
	</cfif>

	<cfif Variables.isLastPriceStage is True>
		<cfbreak>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertPrice">
		<cfset errorMessage_title = Variables.lang_insertUpdatePrice.errorTitle_insert>
	<cfelse><!--- updatePrice --->
		<cfset errorMessage_title = Variables.lang_insertUpdatePrice.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePrice.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePrice.errorFooter>
</cfif>

