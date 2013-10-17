<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="10">

<cfparam Name="Form.priceSearchText" Default="">
<cfparam Name="Form.priceSearchField" Default="">
<cfparam Name="Form.productSearchText" Default="">
<cfparam Name="Form.productSearchField" Default="">

<cfparam Name="Form.categoryID" Default="">
<cfparam Name="Form.vendorID" Default="">
<cfparam Name="Form.categoryID_sub" Default="">
<cfparam Name="Form.groupID" Default="">
<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.regionID" Default="">

<cfparam Name="Form.priceDateType" Default="">
<cfparam Name="Form.priceDateFrom_date" Default="">
<cfparam Name="Form.priceDateFrom_hh" Default="12">
<cfparam Name="Form.priceDateFrom_mm" Default="00">
<cfparam Name="Form.priceDateFrom_tt" Default="am">
<cfparam Name="Form.priceDateTo_date" Default="">
<cfparam Name="Form.priceDateTo_hh" Default="12">
<cfparam Name="Form.priceDateTo_mm" Default="00">
<cfparam Name="Form.priceDateTo_tt" Default="am">

<cfparam Name="Form.priceStageInterval_min" Default="">
<cfparam Name="Form.priceStageInterval_max" Default="">
<cfparam Name="Form.priceStageIntervalType" Default="">
<cfparam Name="Form.priceStageDollarOrPercent_priceStageNewOrDeduction" Default="">

<cfparam Name="Form.priceStatus" Default="">
<cfparam Name="Form.priceAppliedStatus" Default="">
<cfparam Name="Form.priceAppliesToCategory" Default="">
<cfparam Name="Form.priceAppliesToCategoryChildren" Default="">
<cfparam Name="Form.priceAppliesToProduct" Default="">
<cfparam Name="Form.priceAppliesToProductChildren" Default="">
<cfparam Name="Form.priceAppliesToAllProducts" Default="">
<cfparam Name="Form.priceAppliesToInvoice" Default="">
<cfparam Name="Form.priceAppliesToAllCustomers" Default="">
<cfparam Name="Form.priceHasMultipleStages" Default="">
<cfparam Name="Form.priceHasCode" Default="">
<cfparam Name="Form.priceCodeRequired" Default="">
<cfparam Name="Form.priceHasCustomID" Default="">
<cfparam Name="Form.priceBeforeBeginDate" Default="">
<cfparam Name="Form.priceHasEndDate" Default="">
<cfparam Name="Form.priceStageVolumeDiscount" Default="">
<cfparam Name="Form.priceStageVolumeDollarOrQuantity" Default="">
<cfparam Name="Form.priceStageVolumeStep" Default="">
<cfparam Name="Form.priceAppliedToSubscription" Default="">
<cfparam Name="Form.priceHasQuantityMinimumPerOrder" Default="">
<cfparam Name="Form.priceHasQuantityMaximumPerCustomer" Default="">
<cfparam Name="Form.priceHasQuantityMaximumAllCustomers" Default="">
<cfparam Name="Form.priceIsParent" Default="">
<cfparam Name="Form.priceHasGroupTarget" Default="">
<cfparam Name="Form.priceHasRegionTarget" Default="">
<cfparam Name="Form.priceHasAffiliateTarget" Default="">
<cfparam Name="Form.priceHasCobrandTarget" Default="">
<cfparam Name="Form.priceHasCompanyTarget" Default="">
<cfparam Name="Form.priceHasUserTarget" Default="">

<!--- priceStageDollarOrPercent_priceStageNewOrDeduction,categoryID --->
<cfset Variables.fields_text = "priceDateType,priceSearchText,priceSearchField,productSearchText,productSearchField,priceStageIntervalType,priceStageDollarOrPercent_priceStageNewOrDeduction">
<cfset Variables.fields_boolean = "categoryID_sub,priceStatus,priceAppliedStatus,priceAppliesToCategory,priceAppliesToCategoryChildren,priceAppliesToProduct,priceAppliesToProductChildren,priceAppliesToAllProducts,priceAppliesToInvoice,priceAppliesToAllCustomers,priceHasMultipleStages,priceHasCode,priceCodeRequired,priceHasCustomID,priceBeforeBeginDate,priceHasEndDate,priceStageVolumeDiscount,priceStageVolumeDollarOrQuantity,priceStageVolumeStep,priceAppliedToSubscription,priceHasQuantityMinimumPerOrder,priceHasQuantityMaximumPerCustomer,priceHasQuantityMaximumAllCustomers,priceIsParent,priceHasGroupTarget,priceHasRegionTarget,priceHasAffiliateTarget,priceHasCobrandTarget,priceHasCompanyTarget,priceHasUserTarget,priceStageDollarOrPercent,priceStageNewOrDeduction">
<cfset Variables.fields_integerList = "vendorID,groupID,affiliateID,cobrandID,regionID,companyID,userID,productID,priceID,priceID_parent,priceID_trend">
<cfset Variables.fields_integer = "priceStageInterval_min,priceStageInterval_max">
<cfset Variables.fields_numeric = "">
<cfset Variables.fields_date = "priceDateFrom,priceDateTo">
