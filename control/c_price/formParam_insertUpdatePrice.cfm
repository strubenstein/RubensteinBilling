<cfif ListFind("updatePrice,viewPrice", Variables.doAction) and IsDefined("qry_selectPrice") and Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.priceName" Default="#qry_selectPrice.priceName#">
	<cfparam Name="Form.priceDescription" Default="#qry_selectPrice.priceDescription#">
	<cfparam Name="Form.priceID_custom" Default="#qry_selectPrice.priceID_custom#">
	<cfparam Name="Form.priceCode" Default="#qry_selectPrice.priceCode#">
	<cfparam Name="Form.priceCodeRequired" Default="#qry_selectPrice.priceCodeRequired#">

	<cfparam Name="Form.priceAppliesToAllCustomers" Default="#qry_selectPrice.priceAppliesToAllCustomers#">
	<cfparam Name="Form.priceAppliesToProductChildren" Default="#qry_selectPrice.priceAppliesToProductChildren#">
	<cfparam Name="Form.priceAppliesToCategoryChildren" Default="#qry_selectPrice.priceAppliesToCategoryChildren#">

	<cfparam Name="Form.priceAppliesToAllProducts" Default="#qry_selectPrice.priceAppliesToAllProducts#">
	<cfparam Name="Form.priceAppliesToInvoice" Default="#qry_selectPrice.priceAppliesToInvoice#">
	<cfif Form.priceAppliesToAllProducts is 1>
		<cfparam Name="Form.priceAppliesToAllProductsOrInvoices" Default="priceAppliesToAllProducts">
	<cfelseif Form.priceAppliesToInvoice is 1>
		<cfparam Name="Form.priceAppliesToAllProductsOrInvoices" Default="priceAppliesToInvoice">
	</cfif>

	<cfparam Name="Form.priceStatus" Default="#qry_selectPrice.priceStatus#">
	<cfparam Name="Form.priceApproved" Default="#qry_selectPrice.priceApproved#">
	<cfparam Name="Form.priceDateApproved" Default="#qry_selectPrice.priceDateApproved#">
	<!--- <cfparam Name="Form.userID_approved" Default="#qry_selectPrice.userID_approved#"> --->

	<cfparam Name="Form.priceQuantityMinimumPerOrder" Default="#Iif(qry_selectPrice.priceQuantityMinimumPerOrder is 0, De(""), qry_selectPrice.priceQuantityMinimumPerOrder)#">
	<cfparam Name="Form.priceQuantityMaximumAllCustomers" Default="#Iif(qry_selectPrice.priceQuantityMaximumAllCustomers is 0, De(''), qry_selectPrice.priceQuantityMaximumAllCustomers)#">
	<cfparam Name="Form.priceQuantityMaximumPerCustomer" Default="#Iif(qry_selectPrice.priceQuantityMaximumPerCustomer is 0, De(''), qry_selectPrice.priceQuantityMaximumPerCustomer)#">
	<cfparam Name="Form.priceBillingMethod" Default="#qry_selectPrice.priceBillingMethod#">

	<cfparam Name="Form.priceDateBegin_date" Default="#DateFormat(qry_selectPrice.priceDateBegin, 'mm/dd/yyyy')#">
	<cfparam Name="Form.priceDateBegin_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectPrice.priceDateBegin)), '|')#">
	<cfparam Name="Form.priceDateBegin_mm" Default="#Minute(qry_selectPrice.priceDateBegin)#">
	<cfparam Name="Form.priceDateBegin_tt" Default="#TimeFormat(qry_selectPrice.priceDateBegin, 'tt')#">

	<cfif IsDate(qry_selectPrice.priceDateEnd)>
		<cfparam Name="Form.priceDateEnd_date" Default="#DateFormat(qry_selectPrice.priceDateEnd, 'mm/dd/yyyy')#">
		<cfparam Name="Form.priceDateEnd_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectPrice.priceDateEnd)), '|')#">
		<cfparam Name="Form.priceDateEnd_mm" Default="#Minute(qry_selectPrice.priceDateEnd)#">
		<cfparam Name="Form.priceDateEnd_tt" Default="#TimeFormat(qry_selectPrice.priceDateEnd, 'tt')#">
	</cfif>

	<cfparam Name="Form.priceStageCount" Default="#qry_selectPrice.RecordCount#">

	<cfloop Query="qry_selectPrice">
		<cfif qry_selectPrice.priceStageVolumeDiscount is 0>
			<cfset Variables.priceStageAmountField = "priceStageAmount#CurrentRow#_#qry_selectPrice.priceStageDollarOrPercent#_#qry_selectPrice.priceStageNewOrDeduction#">
			<cfif qry_selectPrice.priceStageDollarOrPercent is 0>
				<cfparam Name="Form.#Variables.priceStageAmountField#" Default="#Iif(qry_selectPrice.priceStageVolumeDiscount is 0, qry_selectPrice.priceStageAmount, De(''))#">
			<cfelse>
				<cfparam Name="Form.#Variables.priceStageAmountField#" Default="#Iif(qry_selectPrice.priceStageVolumeDiscount is 0, 100 * qry_selectPrice.priceStageAmount, De(''))#">
			</cfif>
		</cfif>

		<cfparam Name="Form.priceStageDollarOrPercent_priceStageNewOrDeduction#CurrentRow#" Default="#qry_selectPrice.priceStageDollarOrPercent#_#qry_selectPrice.priceStageNewOrDeduction#">
		<cfparam Name="Form.priceStageVolumeDiscount#CurrentRow#" Default="#qry_selectPrice.priceStageVolumeDiscount#">
		<cfparam Name="Form.priceStageVolumeDollarOrQuantity#CurrentRow#" Default="#qry_selectPrice.priceStageVolumeDollarOrQuantity#">
		<cfparam Name="Form.priceStageVolumeStep#CurrentRow#" Default="#qry_selectPrice.priceStageVolumeStep#">
		<cfparam Name="Form.priceStageInterval#CurrentRow#" Default="#qry_selectPrice.priceStageInterval#">
		<cfparam Name="Form.priceStageIntervalType#CurrentRow#" Default="#qry_selectPrice.priceStageIntervalType#">
		<cfparam Name="Form.priceStageText#CurrentRow#" Default="#qry_selectPrice.priceStageText#">
		<cfparam Name="Form.priceStageDescription#CurrentRow#" Default="#qry_selectPrice.priceStageDescription#">
	</cfloop>

	<cfset Variables.maxVolumeCount = 0>
	<cfset volumeCount = 0>
	<cfloop Query="qry_selectPriceVolumeDiscount">
		<cfif qry_selectPriceVolumeDiscount.CurrentRow is 1 or qry_selectPriceVolumeDiscount.priceStageID is not qry_selectPriceVolumeDiscount.priceStageID[CurrentRow - 1]>
			<cfset volumeCount = 1>
			<cfset Variables.priceStageRow = ListFind(ValueList(qry_selectPrice.priceStageID), qry_selectPriceVolumeDiscount.priceStageID)>
			<cfif Variables.priceStageRow is 0>
				<cfset thisPriceStageOrder = 0>
			<cfelse>
				<cfset thisPriceStageOrder = qry_selectPrice.priceStageOrder[Variables.priceStageRow]>
			</cfif>
		<cfelse>
			<cfset volumeCount = volumeCount + 1>
		</cfif>

		<cfset Variables.maxVolumeCount = Max(Variables.maxVolumeCount, volumeCount)>

		<cfif qry_selectPrice.priceStageDollarOrPercent[Variables.thisPriceStageOrder] is 0>
			<cfparam Name="Form.priceVolumeDiscountAmount#thisPriceStageOrder#_#volumeCount#" Default="#qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount#">
		<cfelse>
			<cfparam Name="Form.priceVolumeDiscountAmount#thisPriceStageOrder#_#volumeCount#" Default="#Evaluate(100 * qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#">
		</cfif>

		<cfparam Name="Form.priceVolumeDiscountQuantityMinimum#thisPriceStageOrder#_#volumeCount#" Default="#qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum#">
		<cfparam Name="Form.priceVolumeDiscountIsTotalPrice#thisPriceStageOrder#_#volumeCount#" Default="#qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice#">
	</cfloop>
	<cfparam Name="Form.priceVolumeDiscountCount" Default="#Variables.maxVolumeCount#">
</cfif>

<cfparam Name="Form.priceName" Default="">
<cfparam Name="Form.priceDescription" Default="">
<cfparam Name="Form.priceID_custom" Default="">
<cfparam Name="Form.priceCode" Default="">
<cfparam Name="Form.priceCodeRequired" Default="0">

<cfparam Name="Form.priceAppliesToProductChildren" Default="0">
<cfparam Name="Form.priceAppliesToCategoryChildren" Default="0">
<cfparam Name="Form.priceAppliesToAllCustomers" Default="0">
<cfparam Name="Form.priceAppliesToInvoice" Default="0">
<cfparam Name="Form.priceAppliesToAllProducts" Default="0">
<cfparam Name="Form.priceAppliesToAllProductsOrInvoices" Default="priceAppliesToAllProducts">

<cfparam Name="Form.priceStatus" Default="1">
<cfparam Name="Form.priceApproved" Default="1">
<cfparam Name="Form.priceDateApproved" Default="">
<!--- <cfparam Name="Form.userID_approved" Default=""> --->

<cfparam Name="Form.priceQuantityMinimumPerOrder" Default="">
<cfparam Name="Form.priceQuantityMaximumAllCustomers" Default="">
<cfparam Name="Form.priceQuantityMaximumPerCustomer" Default="">
<cfparam Name="Form.priceBillingMethod" Default="">

<cfparam Name="Form.priceDateBegin_now" Default="0">
<cfparam Name="Form.priceDateBegin_date" Default="#DateFormat(Now(), 'mm/dd/yyyy')#">
<cfparam Name="Form.priceDateBegin_hh" Default="12">
<cfparam Name="Form.priceDateBegin_mm" Default="00">
<cfparam Name="Form.priceDateBegin_tt" Default="am">

<cfparam Name="Form.priceDateEnd_now" Default="0">
<cfparam Name="Form.priceDateEnd_date" Default="">
<cfparam Name="Form.priceDateEnd_hh" Default="12">
<cfparam Name="Form.priceDateEnd_mm" Default="00">
<cfparam Name="Form.priceDateEnd_tt" Default="am">

<cfparam Name="Form.priceStageCount" Default="1">
<cfif Not Application.fn_IsIntegerPositive(Form.priceStageCount) or Form.priceStageCount gt 255>
	<cfset Form.priceStageCount = 1>
</cfif>

<cfparam Name="Form.priceVolumeDiscountCount" Default="5">
<cfif Not Application.fn_IsIntegerPositive(Form.priceVolumeDiscountCount)>
	<cfset Form.priceVolumeDiscountCount = 5>
</cfif>

<cfloop Index="stageCount" From="1" To="#Form.priceStageCount#">
	<cfparam Name="Form.priceStageAmount#stageCount#_0_0" Default="">
	<cfparam Name="Form.priceStageAmount#stageCount#_0_1" Default="">
	<cfparam Name="Form.priceStageAmount#stageCount#_1_0" Default="">
	<cfparam Name="Form.priceStageAmount#stageCount#_1_1" Default="">
	<cfparam Name="Form.priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#" Default="1_1">
	<cfparam Name="Form.priceStageVolumeDiscount#stageCount#" Default="0">
	<cfparam Name="Form.priceStageVolumeDollarOrQuantity#stageCount#" Default="1">
	<cfparam Name="Form.priceStageVolumeStep#stageCount#" Default="0">
	<cfparam Name="Form.priceStageInterval#stageCount#" Default="">
	<cfif Form["priceStageInterval#stageCount#"] is 0>
		<cfset Form["priceStageInterval#stageCount#"] = "">
	</cfif>
	<cfparam Name="Form.priceStageIntervalType#stageCount#" Default="">
	<cfparam Name="Form.priceStageText#stageCount#" Default="">
	<cfparam Name="Form.priceStageDescription#stageCount#" Default="">

	<cfset thisStageCount = stageCount>
	<cfloop Index="volumeCount" From="1" To="#Form.priceVolumeDiscountCount#">
		<cfparam Name="Form.priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#" Default="">
		<cfparam Name="Form.priceVolumeDiscountAmount#thisStageCount#_#volumeCount#" Default="">
		<cfparam Name="Form.priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#" Default="0">
	</cfloop>
</cfloop>
