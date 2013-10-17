<cfcomponent DisplayName="WSSubscription" Hint="Manages all subscriber and subscription web services">

<cffunction Name="insertSubscriber" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new subscriber. Returns subscriberID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberName" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriberStatus" Type="boolean">
	<cfargument Name="subscriberCompleted" Type="boolean">
	<cfargument Name="subscriberDateProcessNext" Type="string">
	<cfargument Name="addressID_billing" Type="numeric">
	<cfargument Name="addressID_shipping" Type="numeric">
	<cfargument Name="bankID" Type="numeric">
	<cfargument Name="creditCardID" Type="numeric">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var hour_ampm = 0>
	<cfset var dateResponse = "">

	<cfinclude template="ws_subscription/ws_insertSubscriber.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSubscriber" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing subscriber. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberName" Type="string">
	<cfargument Name="subscriberStatus" Type="boolean">
	<cfargument Name="subscriberCompleted" Type="boolean">
	<cfargument Name="subscriberDateProcessLast" Type="string">
	<cfargument Name="subscriberDateProcessNext" Type="string">
	<cfargument Name="addressID_billing" Type="numeric">
	<cfargument Name="addressID_shipping" Type="numeric">
	<cfargument Name="bankID" Type="numeric">
	<cfargument Name="creditCardID" Type="numeric">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var hour_ampm = 0>
	<cfset var dateResponse = "">

	<cfinclude template="ws_subscription/ws_updateSubscriber.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertSubscriberNotify" Access="remote" Output="No" ReturnType="boolean" Hint="Inserts new subscriber notification or updates existing subscriber notification. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressID" Type="numeric">
	<cfargument Name="phoneID" Type="numeric">
	<cfargument Name="subscriberNotifyEmail" Type="boolean">
	<cfargument Name="subscriberNotifyEmailHtml"  Type="boolean">
	<cfargument Name="subscriberNotifyPdf"  Type="boolean">
	<cfargument Name="subscriberNotifyDoc"  Type="boolean">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var subscriberNotifyStatus = 0>
	<cfset var notifyMethod = "">

	<cfinclude template="ws_subscription/ws_insertSubscriberNotify.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscriber" Access="remote" Output="No" ReturnType="query" Hint="Select existing subscriber">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var subscriberRow = 0>
	<cfset var subscriberPaymentCreditCardID = ArrayNew(1)>
	<cfset var subscriberPaymentBankID = ArrayNew(1)>

	<cfinclude template="ws_subscription/ws_selectSubscriber.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscriberList_count" Access="remote" ReturnType="numeric" Hint="Returns number of subscribers that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="statusID_subscriber" Type="string">
	<cfargument Name="statusID_custom_subscriber" Type="string">
	<cfargument Name="statusID_subscription" Type="string">
	<cfargument Name="statusID_custom_subscription" Type="string">
	<cfargument Name="commissionID" Type="string">
	<cfargument Name="commissionID_custom" Type="string">
	<cfargument Name="subscriberDateProcessNext" Type="string">
	<cfargument Name="subscriberDateProcessLast" Type="string">
	<cfargument Name="subscriberDateCreated" Type="string">
	<cfargument Name="subscriptionDateProcessNext" Type="string">
	<cfargument Name="subscriptionDateProcessLast" Type="string">
	<cfargument Name="subscriptionDateBegin" Type="string">
	<cfargument Name="subscriptionDateEnd" Type="string">
	<cfargument Name="subscriptionDateCreated" Type="string">
	<cfargument Name="subscriberName" Type="string">
	<cfargument Name="subscriptionName" Type="string">
	<cfargument Name="subscriptionProductID_custom" Type="string">
	<cfargument Name="subscriptionDescription" Type="string">
	<cfargument Name="subscriptionIntervalType" Type="string">
	<cfargument Name="subscriptionQuantity_min" Type="numeric">
	<cfargument Name="subscriptionQuantity_max" Type="numeric">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric">
	<cfargument Name="subscriptionTotal_min" Type="numeric">
	<cfargument Name="subscriptionTotal_max" Type="numeric">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric">
	<cfargument Name="subscriptionInterval_min" Type="numeric">
	<cfargument Name="subscriptionInterval_max" Type="numeric">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric">
	<cfargument Name="subscriberStatus" Type="boolean">
	<cfargument Name="subscriberCompleted" Type="boolean">
	<cfargument Name="subscriberPaymentHasBankID" Type="boolean">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="boolean">
	<cfargument Name="subscriberNotifyEmail" Type="boolean">
	<cfargument Name="subscriberNotifyEmailHtml" Type="boolean">
	<cfargument Name="subscriberNotifyPdf" Type="boolean">
	<cfargument Name="subscriberNotifyDoc" Type="boolean">
	<cfargument Name="subscriberNotifyPhoneID" Type="boolean">
	<cfargument Name="subscriberNotifyAddressID" Type="boolean">
	<cfargument Name="subscriptionCompleted" Type="boolean">
	<cfargument Name="subscriptionIsCustomProduct" Type="boolean">
	<cfargument Name="subscriptionQuantityVaries" Type="boolean">
	<cfargument Name="subscriberHasCustomID" Type="boolean">
	<cfargument Name="subscriptionHasCustomID" Type="boolean">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="boolean">
	<cfargument Name="subscriptionHasEndDate" Type="boolean">
	<cfargument Name="subscriptionHasMaximum" Type="boolean">
	<cfargument Name="subscriptionStatus" Type="boolean">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="boolean">
	<cfargument Name="subscriberIsExported" Type="string">
	<cfargument Name="subscriptionIsRollup" Type="boolean">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_subscription/ws_selectSubscriberList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscriberList" Access="remote" ReturnType="query" Hint="Returns subscribers based on query criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="statusID_subscriber" Type="string">
	<cfargument Name="statusID_custom_subscriber" Type="string">
	<cfargument Name="statusID_subscription" Type="string">
	<cfargument Name="statusID_custom_subscription" Type="string">
	<cfargument Name="commissionID" Type="string">
	<cfargument Name="commissionID_custom" Type="string">
	<cfargument Name="subscriberDateProcessNext" Type="string">
	<cfargument Name="subscriberDateProcessLast" Type="string">
	<cfargument Name="subscriberDateCreated" Type="string">
	<cfargument Name="subscriptionDateProcessNext" Type="string">
	<cfargument Name="subscriptionDateProcessLast" Type="string">
	<cfargument Name="subscriptionDateBegin" Type="string">
	<cfargument Name="subscriptionDateEnd" Type="string">
	<cfargument Name="subscriptionDateCreated" Type="string">
	<cfargument Name="subscriberName" Type="string">
	<cfargument Name="subscriptionName" Type="string">
	<cfargument Name="subscriptionProductID_custom" Type="string">
	<cfargument Name="subscriptionDescription" Type="string">
	<cfargument Name="subscriptionIntervalType" Type="string">
	<cfargument Name="subscriptionQuantity_min" Type="numeric">
	<cfargument Name="subscriptionQuantity_max" Type="numeric">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric">
	<cfargument Name="subscriptionTotal_min" Type="numeric">
	<cfargument Name="subscriptionTotal_max" Type="numeric">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric">
	<cfargument Name="subscriptionInterval_min" Type="numeric">
	<cfargument Name="subscriptionInterval_max" Type="numeric">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric">
	<cfargument Name="subscriberStatus" Type="boolean">
	<cfargument Name="subscriberCompleted" Type="boolean">
	<cfargument Name="subscriberPaymentHasBankID" Type="boolean">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="boolean">
	<cfargument Name="subscriberNotifyEmail" Type="boolean">
	<cfargument Name="subscriberNotifyEmailHtml" Type="boolean">
	<cfargument Name="subscriberNotifyPdf" Type="boolean">
	<cfargument Name="subscriberNotifyDoc" Type="boolean">
	<cfargument Name="subscriberNotifyPhoneID" Type="boolean">
	<cfargument Name="subscriberNotifyAddressID" Type="boolean">
	<cfargument Name="subscriptionCompleted" Type="boolean">
	<cfargument Name="subscriptionIsCustomProduct" Type="boolean">
	<cfargument Name="subscriptionQuantityVaries" Type="boolean">
	<cfargument Name="subscriberHasCustomID" Type="boolean">
	<cfargument Name="subscriptionHasCustomID" Type="boolean">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="boolean">
	<cfargument Name="subscriptionHasEndDate" Type="boolean">
	<cfargument Name="subscriptionHasMaximum" Type="string">
	<cfargument Name="subscriptionStatus" Type="boolean">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="boolean">
	<cfargument Name="subscriberIsExported" Type="string">
	<cfargument Name="subscriptionIsRollup" Type="boolean">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var subscriberRow = 0>
	<cfset var subscriberPaymentCreditCardID = ArrayNew(1)>
	<cfset var subscriberPaymentBankID = ArrayNew(1)>
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_subscription/ws_selectSubscriberList.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Subscription --->
<cffunction Name="insertSubscription" Access="remote" ReturnType="numeric" Hint="Inserts new subscription. Returns subscriptionID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="productID" Type="numeric">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="productParameter" Type="string">
	<cfargument Name="priceID" Type="numeric">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="customField" Type="string">
	<cfargument Name="statusID" Type="numeric">
	<cfargument Name="statusID_custom" Type="string">
	<cfargument Name="statusHistoryComment" Type="string">
	<cfargument Name="subscriptionDateBegin" Type="string">
	<cfargument Name="subscriptionDateEnd" Type="string">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="boolean">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string">
	<cfargument Name="subscriptionAppliedMaximum" Type="numeric">
	<cfargument Name="subscriptionIntervalType" Type="string">
	<cfargument Name="subscriptionInterval" Type="numeric">
	<cfargument Name="subscriptionName" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="subscriptionProductID_custom" Type="string">
	<cfargument Name="subscriptionQuantity" Type="numeric">
	<cfargument Name="subscriptionQuantityVaries" Type="boolean">
	<cfargument Name="subscriptionDescription" Type="string">
	<cfargument Name="subscriptionDescriptionHtml" Type="boolean">
	<cfargument Name="subscriptionPriceNormal" Type="string">
	<cfargument Name="subscriptionPriceUnit" Type="string">
	<cfargument Name="subscriptionDiscount" Type="numeric">
	<cfargument Name="subscriptionDateProcessNext" Type="string">
	<cfargument Name="subscriptionProRate" Type="boolean">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriptionID_rollup" Type="numeric">
	<cfargument Name="subscriptionID_rollup_custom" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">

	<cfset var productParameterOptionID_list = "">
	<cfset var productParameterXml = 0>
	<cfset var productParameterXmlCount = 0>
	<cfset var productParameterID_list = "">
	<cfset var productParameterXmlName = "">
	<cfset var productParameterXmlValue = "">
	<cfset var parameterRow = 0>
	<cfset var isOptionExist = False>

	<cfset var displayProductParameter = False>
	<cfset var displayProductParameterException = False>
	<cfset var displayCustomPrice = False>
	<cfset var displayCustomPriceVolumeDiscount = False>
	<cfset var displayPriceQuantityMaximumPerCustomer = False>
	<cfset var displayPriceQuantityMaximumAllCustomers = False>
	<cfset var productID_list = "">
	<cfset var categoryID_price = "">
	<cfset var categoryID_parentList_price = "">
	<cfset var displayPriceCode = False>
	<cfset var displayPriceName = False>
	<cfset var quantityMaximumPerCustomer = StructNew()>
	<cfset var quantityMaximumAllCustomers = StructNew()>

	<cfset var productParameterExceptionID = 0>
	<cfset var productParameterExceptionPricePremium = 0>
	<cfset var hour_ampm = "">
	<cfset var multipleLineItem_priceStageVolumeStep = False>
	<cfset var multipleLineItem_priceQuantityMaxPerCustomer = False>
	<cfset var multipleLineItem_priceQuantityMaxAllCustomers = False>

	<cfset var errorMessage_fields = StructNew()>
	<cfset var priceRow = False>
	<cfset var sumQuantity = 0>
	<cfset var remainderPerCustomer = 0>
	<cfset var invoiceLineItemProductID_customArray = ArrayNew(1)>
	<cfset var isParameterOption = False>
	<cfset var thisParameterID = 0>
	<cfset var thisCodeStatus = "">
	<cfset var thisCodeOrder = 0>
	<cfset var dateBeginOrEnd = "end">
	<cfset var dateResponse = "">
	<cfset var isAllFormFieldsOk = False>
	<cfset var qry_selectUserCompanyList_company = QueryNew("userID")>
	<cfset var rollupRow = 0>

	<cfinclude template="ws_subscription/ws_insertSubscription.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSubscriptionStatus" Access="remote" ReturnType="boolean" Hint="Updates status existing subscription to 0 (inactive). Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriptionID" Type="numeric">
	<cfargument Name="subscriptionID_custom" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_subscription/ws_updateSubscriptionStatus.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscription" Access="remote" Output="No" ReturnType="query" Hint="Select existing subscription">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var subscriptionParameterValueArray = ArrayNew(1)>
	<cfset var subscriptionUserArray = ArrayNew(1)>
	<cfset var subscriptionRow = 0>
	<cfset var parameterOptionRow = 0>

	<cfinclude template="ws_subscription/ws_selectSubscription.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscriptionList" Access="remote" Output="No" ReturnType="query" Hint="Select existing subscriptions for a designated subscriber">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var subscriptionParameterValueArray = ArrayNew(1)>
	<cfset var subscriptionUserArray = ArrayNew(1)>
	<cfset var subscriptionRow = 0>
	<cfset var parameterOptionRow = 0>

	<cfinclude template="ws_subscription/ws_selectSubscriptionList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSubscriberIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether subscriber records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="subscriberID_custom" Type="string" Required="Yes">
	<cfargument Name="subscriberIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_subscription/ws_updateSubscriberIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
