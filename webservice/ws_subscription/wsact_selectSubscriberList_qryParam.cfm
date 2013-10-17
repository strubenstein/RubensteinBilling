<cfloop Index="field" List="subscriberStatus,subscriberCompleted,subscriberPaymentHasBankID,subscriberPaymentHasCreditCardID,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc,subscriberNotifyPhoneID,subscriberNotifyAddressID,subscriptionCompleted,subscriptionIsCustomProduct,subscriptionQuantityVaries,subscriberHasCustomID,subscriptionHasCustomID,subscriptionContinuesAfterEnd,subscriptionHasEndDate,subscriptionHasMaximum,subscriptionStatus,subscriberProcessAllQuantitiesEntered,subscriptionIsRollup">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.statusID_subscription = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID_subscription, Arguments.statusID_custom_subscription, Arguments.useCustomIDFieldList, "subscriptionID")>
<cfset Arguments.statusID_subscriber = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID_subscriber, Arguments.statusID_custom_subscriber, Arguments.useCustomIDFieldList, "subscriberID")>
<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.priceID = Application.objWebServiceSecurity.ws_checkPricePermission(qry_selectWebServiceSession.companyID_author, Arguments.priceID, Arguments.priceID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.commissionID = Application.objWebServiceSecurity.ws_checkCommissionPermission(qry_selectWebServiceSession.companyID_author, Arguments.commissionID, Arguments.commissionID_custom, Arguments.useCustomIDFieldList)>

<cfset qryParamStruct.companyID_author = qry_selectWebServiceSession.companyID_author>
<!--- 
<cfif categoryID_list is not "">
	<cfset qryParamStruct.categoryID_list = categoryID_list>
</cfif>
<cfif Arguments.categoryID_sub is 1>
	<cfset qryParamStruct.categoryID_sub = Arguments.categoryID_sub>
</cfif>
--->
<cfloop Index="field" List="subscriberName,subscriptionName,subscriptionProductID_custom,subscriptionDescription,subscriptionIntervalType">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="subscriptionQuantity_min,subscriptionQuantity_max,subscriptionPriceUnit_min,subscriptionPriceUnit_max,subscriptionTotal_min,subscriptionTotal_max,subscriberLineItemTotal_min,subscriberLineItemTotal_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsNumeric(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="subscriptionInterval_min,subscriptionInterval_max,subscriptionAppliedMaximum_min,subscriptionAppliedMaximum_max,subscriptionAppliedRemaining_min,subscriptionAppliedRemaining_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Application.fn_IsInteger(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="companyID,userID,subscriberID,subscriptionID,affiliateID,cobrandID,statusID_subscriber,statusID_subscription,commissionID,productID,priceID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="subscriberStatus,subscriberCompleted,subscriberPaymentHasBankID,subscriberPaymentHasCreditCardID,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc,subscriberNotifyPhoneID,subscriberNotifyAddressID,subscriptionCompleted,subscriptionIsCustomProduct,subscriptionQuantityVaries,subscriberHasCustomID,subscriptionHasCustomID,subscriptionContinuesAfterEnd,subscriptionHasEndDate,subscriptionHasMaximum,subscriptionStatus,subscriberProcessAllQuantitiesEntered,subscriptionIsRollup">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionDateBegin,subscriptionDateEnd,subscriptionDateCreated">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsDate(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "subscriberIsExported") and StructKeyExists(Arguments, "subscriberIsExported") and (Arguments.subscriberIsExported is "" or ListFind("0,1", Arguments.subscriberIsExported))>
	<cfset qryParamStruct.subscriberIsExported = Arguments.subscriberIsExported>
</cfif>

<!--- 
<cfset Variables.fields_text = "searchText,searchField,searchPriceField,subscriberDateType">
<!--- nextProcessDateIsNull,multipleSubscription,multipleQuantity, //subscriberID  --->
<cfset Variables.fields_integerList = "subscriptionID,bankID,creditCardID,phoneID,addressID,productParameterOptionID,productParameterExceptionID,priceStageID,categoryID,subscriptionInterval,subscriptionAppliedMaximum,subscriptionAppliedRemaining">
<cfset Variables.fields_numeric = "subscriptionQuantity,subscriptionPriceUnit,subscriptionTotal,subscriberLineItemTotal,searchPrice_min,searchPrice_max">
<cfset Variables.fields_date = "subscriberDateUpdated,subscriberDateFrom,subscriberDateTo">
<cfset Variables.fields_boolean = "subscriberPaymentExists,subscriberNotifyMultipleUser,subscriptionHasParameter,subscriptionHasParameterException,subscriptionHasPrice,subscriptionHasDescription,subscriptionDescriptionHtml,">
--->

