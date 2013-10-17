<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.queryOrderBy" Default="subscriberName">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

<!--- 
subscriberName
subscriptionName
subscriptionProductID_custom
subscriptionDescription
--->
<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchField" Default="">

<!--- avSubscriber --->
<cfparam Name="Form.subscriberID_custom" Default=""><!--- not in form --->
<cfparam Name="Form.subscriberStatus" Default="">
<cfparam Name="Form.subscriberCompleted" Default="">
<!--- avSubscriberPayment --->
<cfparam Name="Form.subscriberPaymentExists" Default=""><!--- bankID or creditCardID --->
<cfparam Name="Form.subscriberPaymentHasBankID" Default=""><!--- bankID --->
<cfparam Name="Form.subscriberPaymentHasCreditCardID" Default=""><!--- creditCardID --->
<!--- avSubscriberNotify --->
<cfparam Name="Form.subscriberNotifyMultipleUser" Default="">
<cfparam Name="Form.subscriberNotifyEmail" Default="">
<cfparam Name="Form.subscriberNotifyEmailHtml" Default="">
<cfparam Name="Form.subscriberNotifyPdf" Default="">
<cfparam Name="Form.subscriberNotifyDoc" Default="">
<cfparam Name="Form.subscriberNotifyPhoneID" Default=""><!--- phoneID --->
<cfparam Name="Form.subscriberNotifyAddressID" Default=""><!--- subscriberNotifyAddressID --->

<cfparam Name="Form.subscriptionHasParameter" Default=""><!--- productParameterOptionID --->
<cfparam Name="Form.subscriptionHasParameterException" Default=""><!--- productParameterExceptionID --->
<cfparam Name="Form.subscriptionCompleted" Default="">
<cfparam Name="Form.subscriptionIsCustomProduct" Default=""><!--- productID --->
<cfparam Name="Form.subscriptionHasPrice" Default=""><!--- priceID --->
<cfparam Name="Form.subscriptionHasDescription" Default=""><!--- subscriptionDescription --->
<cfparam Name="Form.subscriptionDescriptionHtml" Default="">
<cfparam Name="Form.subscriberHasCustomID" Default="">
<cfparam Name="Form.subscriptionHasCustomID" Default="">
<cfparam Name="Form.subscriptionContinuesAfterEnd" Default="">
<cfparam Name="Form.subscriptionHasEndDate" Default="">
<cfparam Name="Form.subscriptionHasMaximum" Default="">
<cfparam Name="Form.subscriptionStatus" Default="">
<cfparam Name="Form.subscriberProcessAllQuantitiesEntered" Default="">
<cfparam Name="Form.subscriptionIsRollup" Default="">

<cfparam Name="Form.categoryID" Default=""><!--- select list --->
<cfparam Name="Form.categoryID_sub" Default="0">
<cfparam Name="Form.subscriptionIntervalType" Default=""><!--- select list --->
<cfparam Name="Form.subscriptionInterval" Default=""><!--- not in form --->
<cfparam Name="Form.subscriptionInterval_min" Default="">
<cfparam Name="Form.subscriptionInterval_max" Default="">

<cfparam Name="Form.subscriptionAppliedMaximum" Default=""><!--- not in form --->
<cfparam Name="Form.subscriptionAppliedMaximum_min" Default="">
<cfparam Name="Form.subscriptionAppliedMaximum_max" Default="">
<cfparam Name="Form.subscriptionAppliedRemaining" Default=""><!--- not in form --->
<cfparam Name="Form.subscriptionAppliedRemaining_min" Default="">
<cfparam Name="Form.subscriptionAppliedRemaining_max" Default="">

<cfparam Name="Form.subscriptionQuantity" Default=""><!--- not in form --->
<cfparam Name="Form.subscriptionID_custom" Default=""><!--- not in form --->
<cfparam Name="Form.subscriptionQuantityVaries" Default="">
<cfparam Name="Form.subscriptionQuantity_from" Default="">
<cfparam Name="Form.subscriptionQuantity_to" Default="">

<!---
subscriberDateProcessNext
subscriberDateProcessLast
subscriberDateCreated
subscriberDateUpdated
subscriptionDateProcessNext
subscriptionDateProcessLast
subscriptionDateBegin
subscriptionDateEnd
subscriptionDateCreated
--->
<cfparam Name="Form.subscriberDateType" Default="">
<cfparam Name="Form.subscriberDateFrom_date" Default="">
<cfparam Name="Form.subscriberDateFrom_hh" Default="12">
<cfparam Name="Form.subscriberDateFrom_mm" Default="00">
<cfparam Name="Form.subscriberDateFrom_tt" Default="am">
<cfparam Name="Form.subscriberDateTo_date" Default="">
<cfparam Name="Form.subscriberDateTo_hh" Default="11">
<cfparam Name="Form.subscriberDateTo_mm" Default="59">
<cfparam Name="Form.subscriberDateTo_tt" Default="pm">

<cfparam Name="Form.searchPrice_min" Default="">
<cfparam Name="Form.searchPrice_max" Default="">
<cfparam Name="Form.searchPriceField" Default="">

<cfparam Name="Form.affiliateID" Default="">
<cfparam Name="Form.cobrandID" Default="">
<cfparam Name="Form.statusID_subscriber" Default="">
<cfparam Name="Form.statusID_subscription" Default="">
<cfparam Name="Form.subscriberID" Default="">
<cfparam Name="Form.subscriptionID" Default="">

<cfparam Name="Form.subscriberIsExported" Default="-1">
<cfparam Name="Form.subscriberDateExported_from" Default="">
<cfparam Name="Form.subscriberDateExported_to" Default="">

<cfset Variables.fields_text = "searchText,searchField,subscriberName,subscriberID_custom,subscriptionName,subscriptionID_custom,subscriptionProductID_custom,subscriptionDescription,subscriptionIntervalType,subscriberDateType,searchPriceField,companyID_custom,userID_custom">
<cfset Variables.fields_boolean = "subscriberStatus,subscriberCompleted,subscriberPaymentExists,subscriberPaymentHasBankID,subscriberPaymentHasCreditCardID,subscriberNotifyMultipleUser,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc,subscriberNotifyPhoneID,subscriberNotifyAddressID,subscriptionHasParameter,subscriptionHasParameterException,subscriptionCompleted,subscriptionIsCustomProduct,subscriptionHasPrice,subscriptionHasDescription,subscriptionDescriptionHtml,subscriptionQuantityVaries,subscriberHasCustomID,subscriptionHasCustomID,subscriptionContinuesAfterEnd,subscriptionHasEndDate,subscriptionHasMaximum,subscriptionStatus,subscriberProcessAllQuantitiesEntered,subscriptionIsRollup">
<!--- nextProcessDateIsNull,multipleSubscription,multipleQuantity, //subscriberID  --->
<cfset Variables.fields_integerList = "subscriptionID,bankID,creditCardID,phoneID,addressID,productParameterOptionID,productParameterExceptionID,productID,priceID,priceStageID,categoryID,subscriptionInterval,subscriptionAppliedMaximum,subscriptionAppliedRemaining,affiliateID,cobrandID,statusID_subscriber,statusID_subscription">
<cfset Variables.fields_integer = "subscriptionInterval_min,subscriptionInterval_max,subscriptionAppliedMaximum_min,subscriptionAppliedMaximum_max,subscriptionAppliedRemaining_min,subscriptionAppliedRemaining_max">
<cfset Variables.fields_numeric = "subscriptionQuantity,subscriptionQuantity_min,subscriptionQuantity_max,subscriptionPriceUnit,subscriptionPriceUnit_min,subscriptionPriceUnit_max,subscriptionTotal,subscriptionTotal_min,subscriptionTotal_max,subscriberLineItemTotal,subscriberLineItemTotal_min,subscriberLineItemTotal_max,searchPrice_min,searchPrice_max">
<cfset Variables.fields_date = "subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionDateBegin,subscriptionDateEnd,subscriptionDateCreated,subscriberDateFrom,subscriberDateTo,subscriberDateExported_from,subscriberDateExported_to">

