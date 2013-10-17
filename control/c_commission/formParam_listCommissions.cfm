<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="10">

<cfparam Name="Form.commissionSearchText" Default="">
<cfparam Name="Form.commissionSearchField" Default="">
<cfparam Name="Form.productSearchText" Default="">
<cfparam Name="Form.productSearchField" Default="">

<cfparam Name="Form.categoryID" Default="">
<cfparam Name="Form.categoryID_sub" Default="">
<cfparam Name="Form.vendorID" Default="">
<cfparam Name="Form.vendorID_product" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.regionID" Default="">
<cfparam Name="Form.statusID" Default="">

<cfparam Name="Form.commissionDateType" Default="">
<cfparam Name="Form.commissionDateFrom_date" Default="">
<cfparam Name="Form.commissionDateFrom_hh" Default="12">
<cfparam Name="Form.commissionDateFrom_mm" Default="00">
<cfparam Name="Form.commissionDateFrom_tt" Default="am">
<cfparam Name="Form.commissionDateTo_date" Default="">
<cfparam Name="Form.commissionDateTo_hh" Default="12">
<cfparam Name="Form.commissionDateTo_mm" Default="00">
<cfparam Name="Form.commissionDateTo_tt" Default="am">

<cfparam Name="Form.commissionStageInterval_min" Default="">
<cfparam Name="Form.commissionStageInterval_max" Default="">
<cfparam Name="Form.commissionStageIntervalType" Default="">
<cfparam Name="Form.commissionPeriodIntervalType" Default="">

<cfparam Name="Form.commissionStageDollarOrPercent" Default="">
<cfparam Name="Form.commissionStatus" Default="">
<cfparam Name="Form.commissionAppliedStatus" Default="">
<cfparam Name="Form.commissionAppliesToCategory" Default="">
<cfparam Name="Form.commissionAppliesToCategoryChildren" Default="">
<cfparam Name="Form.commissionAppliesToProduct" Default="">
<cfparam Name="Form.commissionAppliesToProductChildren" Default="">
<cfparam Name="Form.commissionAppliesToExistingProducts" Default="">
<cfparam Name="Form.commissionAppliesToCustomProducts" Default="">
<cfparam Name="Form.commissionAppliesToInvoice" Default="">
<cfparam Name="Form.commissionTargetsAllUsers" Default="">
<cfparam Name="Form.commissionTargetsAllGroups" Default="">
<cfparam Name="Form.commissionTargetsAllAffiliates" Default="">
<cfparam Name="Form.commissionTargetsAllCobrands" Default="">
<cfparam Name="Form.commissionTargetsAllCompanies" Default="">
<cfparam Name="Form.commissionTargetsAllVendors" Default="">
<cfparam Name="Form.commissionHasMultipleStages" Default="">
<cfparam Name="Form.commissionHasCustomID" Default="">
<cfparam Name="Form.commissionBeforeBeginDate" Default="">
<cfparam Name="Form.commissionHasEndDate" Default="">
<cfparam Name="Form.commissionStageVolumeDiscount" Default="">
<cfparam Name="Form.commissionStageVolumeDollarOrQuantity" Default="">
<cfparam Name="Form.commissionStageVolumeStep" Default="">
<cfparam Name="Form.commissionIsParent" Default="">
<cfparam Name="Form.commissionHasGroupTarget" Default="">
<cfparam Name="Form.commissionHasAffiliateTarget" Default="">
<cfparam Name="Form.commissionHasCobrandTarget" Default="">
<cfparam Name="Form.commissionHasCompanyTarget" Default="">
<cfparam Name="Form.commissionHasUserTarget" Default="">
<cfparam Name="Form.commissionHasVendorTarget" Default="">

<!--- categoryID --->
<cfset Variables.fields_text = "commissionDateType,commissionSearchText,commissionSearchField,productSearchText,productSearchField,commissionStageIntervalType,commissionPeriodIntervalType">
<cfset Variables.fields_boolean = "categoryID_sub,commissionStageDollarOrPercent,commissionStatus,commissionAppliedStatus,commissionAppliesToCategory,commissionAppliesToCategoryChildren,commissionAppliesToProduct,commissionAppliesToProductChildren,commissionAppliesToExistingProducts,commissionAppliesToCustomProducts,commissionAppliesToInvoice,commissionTargetsAllUsers,commissionTargetsAllGroups,commissionTargetsAllAffiliates,commissionTargetsAllCobrands,commissionTargetsAllCompanies,commissionHasMultipleStages,commissionHasCustomID,commissionBeforeBeginDate,commissionHasEndDate,commissionStageVolumeDiscount,commissionStageVolumeDollarOrQuantity,commissionStageVolumeStep,commissionIsParent,commissionHasGroupTarget,commissionHasAffiliateTarget,commissionHasCobrandTarget,commissionHasCompanyTarget,commissionHasUserTarget,commissionHasVendorTarget,commissionTargetsAllVendors,commissionPeriodOrInvoiceBased">
<cfset Variables.fields_integerList = "vendorID,vendorID_product,groupID,affiliateID,cobrandID,regionID,companyID,userID,productID,commissionID,commissionID_parent,commissionID_trend,statusID">
<cfset Variables.fields_integer = "commissionStageInterval_min,commissionStageInterval_max">
<cfset Variables.fields_numeric = "">
<cfset Variables.fields_date = "commissionDateFrom,commissionDateTo">
