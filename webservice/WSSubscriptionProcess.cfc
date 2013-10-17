<cfcomponent DisplayName="WSSubcriptionProcess" Hint="Manages all subscription processing web services">

<cffunction Name="selectSubscriberListByProcessDate" Access="remote" ReturnType="query" Hint="Returns subscribers scheduled to be processed on a given date.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="subscriberDateProcessNext" Type="date">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_subscription/ws_subscriptionProcess/ws_selectSubscriberListByProcessDate.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSubscriptionListToProcess" Access="remote" ReturnType="query" Hint="Returns variable-quantity subscriptions for subscriber scheduled to be processed on a given date along with date ranges and custom price stages.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriptionProcessQuantityFinal" Type="string">
	<cfargument Name="subscriberID" Type="numeric">
	<cfargument Name="subscriberID_custom" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var qry_selectSubscriptionProcessList = QueryNew("subscriberID,subscriptionID,subscriptionID_custom,subscriptionName,productID,priceID,priceID_custom,priceName,priceStageID,priceStageOrder,priceStageText,priceStageDescription,subscriptionPriceStageDateBegin,subscriptionPriceStageDateEnd,subscriptionQuantity,subscriptionQuantityVaries,subscriptionPriceUnit,subscriptionPriceNormal,subscriptionDiscount,subscriptionDateBegin,subscriptionDateEnd,subscriptionAppliedMaximum,subscriptionAppliedCount,subscriptionIntervalType,subscriptionInterval,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionOrder,subscriptionProductID_custom,subscriptionProRate,subscriptionEndByDateOrAppliedMaximum,subscriptionContinuesAfterEnd,vendorID,productCode,productID_custom,productName,productPrice")>
	<cfset var subscriptionID_list = "">
	<cfset var thisSubscriptionRow = 0>
	<cfset var subscriptionID_priceStageIDList = StructNew()>
	<cfset var priceStageStruct = StructNew()>
	<cfset var subscriptionPriceStageDateBegin = Now()>
	<cfset var subscriptionPriceStageDateEnd = "">
	<cfset var priceStageRow = 0>
	<cfset var priceRow = 0>
	<cfset var thisPriceID = 0>
	<cfset var thisSubscriptionID = 0>
	<cfset var subscriptionRow = 0>
	<cfset var maxEndDate = Now()>

	<cfinclude template="ws_subscription/ws_subscriptionProcess/ws_selectSubscriptionListToProcess.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSubscriptionProcess" Access="remote" Output="No" ReturnType="boolean" Hint="Updates quantity for a variable-quantity subscription for current billing period.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="subscriptionID" Type="numeric">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="priceStageID" Type="numeric">
	<!--- 
	<cfargument Name="subscriptionProcessDateBegin" Type="string">
	<cfargument Name="subscriptionProcessDateEnd" Type="string">
	--->
	<cfargument Name="subscriptionProcessQuantity" Type="numeric">
	<cfargument Name="subscriptionProcessQuantityFinal" Type="boolean">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var subscriberProcessID = 0>
	<cfset var thisMethod = "">
	<cfset var thisSubscriptionID = 0>
	<cfset var thisSubscriptionOrder = 0>

	<cfinclude template="ws_subscription/ws_subscriptionProcess/ws_updateSubscriptionProcess.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>


