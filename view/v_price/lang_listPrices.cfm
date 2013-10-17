<cfset Variables.lang_listPrices = StructNew()>
<cfset Variables.lang_listPrices_title = StructNew()>

<cfset Variables.lang_listPrices_title.priceCode = "Code">
<cfset Variables.lang_listPrices_title.priceName = "Name">
<cfset Variables.lang_listPrices_title.priceAmount = "Price">
<cfset Variables.lang_listPrices_title.priceDateBegin = "Date<br>Begin">
<cfset Variables.lang_listPrices_title.priceDateEnd = "Date<br>End">
<cfset Variables.lang_listPrices_title.priceStatus = "Status">
<cfset Variables.lang_listPrices_title.priceAppliedStatus = "Been<br>Used">
<cfset Variables.lang_listPrices_title.priceDateCreated = "Date<br>Created">
<cfset Variables.lang_listPrices_title.priceDateUpdated = "Date<br>Inactive">
<cfset Variables.lang_listPrices_title.viewPrice = "Manage">
<cfset Variables.lang_listPrices_title.price = "">
<cfset Variables.lang_listPrices_title.price = "">
<cfset Variables.lang_listPrices_title.price = "">


<cfset Variables.lang_listPrices.categoryID_sub = "You did not select a valid option for whether to include sub categories.">
<cfset Variables.lang_listPrices.priceDateToFrom = "The end date must be after the begin date.">
<cfset Variables.lang_listPrices.priceStageIntervalType = "You did not select a valid price stage interval type.">
<cfset Variables.lang_listPrices.priceStageInterval_min = "You did not select a valid price stage interval minimum.">
<cfset Variables.lang_listPrices.priceStageInterval_max = "You did not select a valid price stage interval minimum.">
<cfset Variables.lang_listPrices.priceStageInterval_minMax = "The price stage maximum cannot be less than the minimum.">
<cfset Variables.lang_listPrices.priceStageDollarOrPercent_priceStageNewOrDeduction = "You did not select a valid option for how the price is stated.">

<cfset Variables.lang_listPrices.priceStatus = "You did not select a valid price status.">
<cfset Variables.lang_listPrices.priceAppliedStatus = "You did not select a valid option for whether the price has been applied.">
<cfset Variables.lang_listPrices.priceAppliesToCategory = "You did not select a valid for whether the price applies to a category.">
<cfset Variables.lang_listPrices.priceAppliesToCategoryChildren = "You did not select a valid option for whether the price applies to category children.">
<cfset Variables.lang_listPrices.priceAppliesToProduct = "You did not select a valid option for whether the price applies to a product.">
<cfset Variables.lang_listPrices.priceAppliesToProductChildren = "You did not select a valid option for whether the price applies to product children.">
<cfset Variables.lang_listPrices.priceAppliesToAllProducts = "You did not select a valid option for whether the price applies to all products.">
<cfset Variables.lang_listPrices.priceAppliesToInvoice = "You did not select a valid option for whether the price applies to the full invoice.">
<cfset Variables.lang_listPrices.priceAppliesToAllCustomers = "You did not select a valid option for whether the price applies to all customers.">
<cfset Variables.lang_listPrices.priceHasMultipleStages = "You did not select a valid option for whether the price has multiple stages.">
<cfset Variables.lang_listPrices.priceHasCode = "You did not select a valid option for whether the price has a special code.">
<cfset Variables.lang_listPrices.priceCodeRequired = "You did not select a valid option for whether the price requires a special code.">
<cfset Variables.lang_listPrices.priceHasCustomID = "You did not select a valid option for whether the price has a custom ID.">
<cfset Variables.lang_listPrices.priceBeforeBeginDate = "You did not select a valid option for whether the price has not yet begun.">
<cfset Variables.lang_listPrices.priceHasEndDate = "You did not select a valid option for whether the price has a designated end date.">
<cfset Variables.lang_listPrices.priceStageVolumeDiscount = "You did not select a valid option for whether the price has at least one stage that uses volume discount pricing.">
<cfset Variables.lang_listPrices.priceStageVolumeDollarOrQuantity = "You did not select a valid for whether the price has at least one stage that uses volume discount pricing based on dollar value.">
<cfset Variables.lang_listPrices.priceStageVolumeStep = "You did not select a valid for whether the price has at least one stage that uses volume discount pricing in step fashion.">
<cfset Variables.lang_listPrices.priceAppliedToSubscription = "You did not select a valid option for whether the price has been applied to a subscription.">
<cfset Variables.lang_listPrices.priceHasQuantityMinimumPerOrder = "You did not select a valid option for whether the price has a minimum quantity required per purchase.">
<cfset Variables.lang_listPrices.priceHasQuantityMaximumPerCustomer = "You did not select a valid option for whether the price has a maimum quantity per customer.">
<cfset Variables.lang_listPrices.priceHasQuantityMaximumAllCustomers = "You did not select a valid option for whether the price has a maximum quantity across all customers.">
<cfset Variables.lang_listPrices.priceIsParent = "You did not select a valid option for whether the price has been updated.">
<cfset Variables.lang_listPrices.priceHasGroupTarget = "You did not select a valid option for whether the price has at least one group target.">
<cfset Variables.lang_listPrices.priceHasRegionTarget = "You did not select a valid option for whether the price has at least one region target.">
<cfset Variables.lang_listPrices.priceHasAffiliateTarget = "You did not select a valid option for whether the price has at least one affiliate target.">
<cfset Variables.lang_listPrices.priceHasCobrandTarget = "You did not select a valid option for whether the price has at least one cobrand target.">
<cfset Variables.lang_listPrices.priceHasCompanyTarget = "You did not select a valid option for whether the price has at least one company target.">
<cfset Variables.lang_listPrices.priceHasUserTarget = "You did not select a valid option for whether the price has at least one user target.">
<cfset Variables.lang_listPrices.priceStageDollarOrPercent = "You did not select a valid option for whether the price uses dollar or percent pricing.">
<cfset Variables.lang_listPrices.priceStageNewOrDeduction = "You did not select a valid option for whether the price is a new price or a deduction of the existing price.">

<cfset Variables.lang_listPrices.companyID = "You did not select a valid company target.">
<cfset Variables.lang_listPrices.userID = "You did not select a valid user target.">
<cfset Variables.lang_listPrices.vendorID = "You did not select a valid product vendor target.">
<cfset Variables.lang_listPrices.productID = "You did not select a valid product target.">
<cfset Variables.lang_listPrices.categoryID = "You did not select a valid category target.">
<cfset Variables.lang_listPrices.groupID = "You did not select a valid group target.">
<cfset Variables.lang_listPrices.regionID = "You did not select a valid region target.">
<cfset Variables.lang_listPrices.affiliateID = "You did not select a valid affiliate target.">
<cfset Variables.lang_listPrices.cobrandID = "You did not select a valid cobrand target.">
<cfset Variables.lang_listPrices.priceID = "You did not select a valid price.">
<cfset Variables.lang_listPrices.priceID_parent = "You did not select a valid parent price.">
<cfset Variables.lang_listPrices.priceID_trend = "You did not select a valid primary parent price.">

<cfset Variables.lang_listPrices.queryDisplayPerPage = "You did not enter a valid number of prices to display per page.">
<cfset Variables.lang_listPrices.queryPage = "You did not enter a valid page number.">

<cfset Variables.lang_listPrices.errorTitle = "The prices could not be listed for the following reason(s):">
<cfset Variables.lang_listPrices.errorHeader = "">
<cfset Variables.lang_listPrices.errorFooter = "">

