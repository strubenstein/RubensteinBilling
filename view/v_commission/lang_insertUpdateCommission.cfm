<cfset Variables.lang_insertUpdateCommission = StructNew()>

<cfset Variables.lang_insertUpdateCommission.commissionStatus = "You did not select a valid option for the current status of this commission.">
<!--- 
<cfset Variables.lang_insertUpdateCommission.commissionAppliesToExistingProducts = "You did not select a valid option for whether the commission applies to existing products.">
<cfset Variables.lang_insertUpdateCommission.commissionAppliesToCustomProducts = "You did not select a valid option for whether the commission applies to custom products.">
--->
<cfset Variables.lang_insertUpdateCommission.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts = "You did not select a valid option for whether the commission applies to existing and/or custom products.">
<cfset Variables.lang_insertUpdateCommission.commissionAppliesToInvoice = "You did not select a valid option for whether the commission can apply to the entire invoice.">
<cfset Variables.lang_insertUpdateCommission.commissionName_maxlength = "The commission name must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCommission.commissionDescription_maxlength = "The commission description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCommission.commissionID_custom_maxlength = "The commission custom ID must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCommission.commissionPeriodIntervalType = "You did not select a valid option for whether the commission is calculated based on each individual invoice or all invoices from a particular time period.">
<cfset Variables.lang_insertUpdateCommission.commissionDateBegin_now = "You did not select a valid option for whether the commission begins now.">
<cfset Variables.lang_insertUpdateCommission.commissionDateEnd_now = "You did not select a valid option for whether the commission ends now.">
<cfset Variables.lang_insertUpdateCommission.commissionDateBeginEnd = "The end date/time must be after the begin date/time.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllUsers = "You did not select a valid option for whether the commission applies to all salespeople/users.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllGroups = "You did not select a valid option for whether the commission applies to all groups.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllAffiliates = "You did not select a valid option for whether the commission applies to all affiliates.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllCobrands = "You did not select a valid option for whether the commission applies to all cobrands.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllCompanies = "You did not select a valid option for whether the commission applies to all companies.">
<cfset Variables.lang_insertUpdateCommission.commissionTargetsAllVendors = "You did not select a valid option for whether the commission applies to all vendors.">

<cfset Variables.lang_insertUpdateCommission.commissionStageText_maxlength = "For stage ##<<STAGE>>, the commission text must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCommission.commissionStageDescription_maxlength = "For stage ##<<STAGE>>, the commission description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmountMinimum_numeric = "For stage ##<<STAGE>>, the minimum commission must be a number.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmountMinimum_maxlength = "For stage ##<<STAGE>>, the minimum commission may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_numeric = "For stage ##<<STAGE>>, the maximum commission must be a number.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_maxlength = "For stage ##<<STAGE>>, the maximum commission may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmountMaximum_minimum = "For stage ##<<STAGE>>, the maximum commission must be greater than the minimum.">
<cfset Variables.lang_insertUpdateCommission.commissionStageInterval_integer = "For stage ##<<STAGE>>, the interval length must be a positive integer.">
<cfset Variables.lang_insertUpdateCommission.commissionStageInterval_lastBlank = "The interval length for the last commission stage must be blank. The subscription length is set separately from the commission length.">
<cfset Variables.lang_insertUpdateCommission.commissionStageIntervalType_valid = "For stage ##<<STAGE>>, you did not select a valid interval type.">
<cfset Variables.lang_insertUpdateCommission.commissionStageIntervalType_blank = "For stage ##<<STAGE>>, you must select an interval type unless it is the last (or only) interval.">
<cfset Variables.lang_insertUpdateCommission.commissionStageDollarOrPercent = "For stage ##<<STAGE>>, you did not select a valid option for whether the commission is based on dollars or percentage of the revenue.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmount_numeric = "For stage ##<<STAGE>>, the commission amount must be a valid number.">
<cfset Variables.lang_insertUpdateCommission.commissionStageAmount_maxlength = "For stage ##<<STAGE>>, the commission amount may have only <<MAXLENGTH>> decimal places.">

<cfset Variables.lang_insertUpdateCommission.commissionStageVolumeDiscount = "For stage ##<<STAGE>>, you did not select a valid option for whether the commission is based on quantity ordered.">
<cfset Variables.lang_insertUpdateCommission.commissionStageVolumeDollarOrQuantity = "For stage ##<<STAGE>>, you did not select a valid option for whether the commission is bsaed on dollar amount or quantity ordered.">
<cfset Variables.lang_insertUpdateCommission.commissionStageVolumeStep = "For stage ##<<STAGE>>, you did not select a valid option for whether the volume-based commission is applied in steps.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountCount = "The number of volume-based settings must be at least 2.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_single = "For stage ##<<STAGE>>, if you are only using a single volume setting, do not use the volume option.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_quantity = "For stage ##<<STAGE>>, you did not enter a valid quantity for volume option ##<<COUNT>>.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_maxlength = "For stage ##<<STAGE>>, the volume quantity may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountQuantityMinimum_increase = "For stage ##<<STAGE>>, the volume quantity for option ##<<COUNT>> must be greater than the quantity for ##<<COUNTMINUS1>>.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountAmount_numeric = "For stage ##<<STAGE>>, you did not enter a valid commission for volume discount option ##<<COUNT>>.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountAmount_maxlength = "For stage ##<<STAGE>>, the commission amount may have only <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_valid = "For stage ##<<STAGE>>, you did not select a valid option for whether the amount is total commission for all quantity for option ##<<COUNT>>.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_commission = "For stage ##<<STAGE>>, to use the total amount option, the commission must be stated as a straight dollar amount (the last option).">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountIsTotalCommission_step = "For stage ##<<STAGE>>, to use the total amount option, you must be using step method.">
<cfset Variables.lang_insertUpdateCommission.commissionVolumeDiscountCount_real = "For stage ##<<STAGE>>, if you are only using a single volume setting, do not use the volume option.">

<cfset Variables.lang_insertUpdateCommission.formSubmitValue_insert = "Create Commission Plan">
<cfset Variables.lang_insertUpdateCommission.formSubmitValue_update = "Update Commission Plan">

<cfset Variables.lang_insertUpdateCommission.errorTitle_insert = "The commission could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateCommission.errorTitle_update = "The commission could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateCommission.errorHeader = "">
<cfset Variables.lang_insertUpdateCommission.errorFooter = "">
