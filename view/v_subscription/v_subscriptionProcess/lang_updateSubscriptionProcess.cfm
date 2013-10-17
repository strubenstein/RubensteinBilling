<cfset Variables.lang_updateSubscriptionProcess = StructNew()>
<cfset Variables.lang_updateSubscriptionProcess_title = StructNew()>

<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionOrder = "##">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionName = "Subscription">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionDateBegin = "Begin<br>Date">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionDateEnd = "End<br>Date">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionPriceUnit = "Unit<br>Price">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionQuantity = "Default<br>Quantity">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionProcessQuantity = "Quantity For<br>This Period">
<cfset Variables.lang_updateSubscriptionProcess_title.subscriptionProcessQuantityFinal = "Final?">

<cfset Variables.lang_updateSubscriptionProcess.subscriptionQuantity_numeric = "For subscription ##<<COUNT>>, the quantity must be a number.">
<cfset Variables.lang_updateSubscriptionProcess.subscriptionQuantity_negative = "For subscription ##<<COUNT>>, the quantity cannot be negative.">
<cfset Variables.lang_updateSubscriptionProcess.subscriptionProcessQuantity_maxlength = "For subscription ##<<COUNT>>, the quantity may have only <<MAXLENGTH>> decimal places.">

<cfset Variables.lang_updateSubscriptionProcess.errorTitle = "The subscription quantities for this billing period could not be updated for the following reasons:">
<cfset Variables.lang_updateSubscriptionProcess.errorHeader = "">
<cfset Variables.lang_updateSubscriptionProcess.errorFooter = "">

