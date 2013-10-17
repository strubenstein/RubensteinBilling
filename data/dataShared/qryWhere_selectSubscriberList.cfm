<cfoutput>
avSubscriber.companyID_author IN (<cfqueryparam value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" list="yes">)
<!--- company fields --->
<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>AND avCompany.cobrandID IN (<cfqueryparam value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>AND avCompany.affiliateID IN (<cfqueryparam value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "companyID_custom") and Trim(Arguments.companyID_custom) is not "">AND avCompany.companyID_custom LIKE <cfqueryparam value="%#Arguments.companyID_custom#%" cfsqltype="cf_sql_varchar"></cfif>
<!--- user fields --->
<cfif StructKeyExists(Arguments, "userID_custom") and Trim(Arguments.userID_custom) is not "">AND avUser.userID_custom LIKE <cfqueryparam value="%#Arguments.userID_custom#%" cfsqltype="cf_sql_varchar"></cfif>
<!--- subscriber fields --->
<cfloop Index="field" List="companyID,userID,subscriberID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>AND avSubscriber.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)</cfif></cfloop>
<cfloop Index="field" List="subscriberName,subscriberID_custom"><cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">AND avSubscriber.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"></cfif></cfloop>
<cfif StructKeyExists(Arguments, "subscriberHasCustomID") and ListFind("0,1", Arguments.subscriberHasCustomID)>AND avSubscriber.subscriberID_custom <cfif Arguments.subscriberHasCustomID is 1> =  '' <cfelse> <>  '' </cfif></cfif>
<cfloop Index="field" List="subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated,subscriberDateExported">
	<cfif StructKeyExists(Arguments, field)>
		<cfif IsDate(Arguments[field]) is "">AND avSubscriber.#field# IS NULL<cfelse>AND Year(avSubscriber.#field#) = #Year(Arguments[field])# AND Month(avSubscriber.#field#) = #Month(Arguments[field])# AND Day(avSubscriber.#field#) = #Day(Arguments[field])#</cfif>
	</cfif>
</cfloop>
<cfif (StructKeyExists(Arguments, "subscriberLineItemTotal") and IsNumeric(Arguments.subscriberLineItemTotal)) or (StructKeyExists(Arguments, "subscriberLineItemTotal_min") and IsNumeric(Arguments.subscriberLineItemTotal_min)) or (StructKeyExists(Arguments, "subscriberLineItemTotal_max") and IsNumeric(Arguments.subscriberLineItemTotal_max))>
	AND avSubscriber.subscriberID IN
		(
		SELECT subscriberID
		FROM avSubscription
		WHERE SUM(subscriptionPriceUnit * subscriptionQuantity)
		<cfif StructKeyExists(Arguments, "subscriberLineItemTotal") and IsNumeric(Arguments.subscriberLineItemTotal)>
			= <cfqueryparam value="#Arguments.subscriberLineItemTotal#" cfsqltype="cf_sql_money">
		<cfelseif StructKeyExists(Arguments, "subscriberLineItemTotal_min") and IsNumeric(Arguments.subscriberLineItemTotal_min) and StructKeyExists(Arguments, "subscriberLineItemTotal_max") and IsNumeric(Arguments.subscriberLineItemTotal_max)>
			BETWEEN <cfqueryparam value="#Arguments.subscriberLineItemTotal_min#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments.subscriberLineItemTotal_max#" cfsqltype="cf_sql_money">
		<cfelseif StructKeyExists(Arguments, "subscriberLineItemTotal_min") and IsNumeric(Arguments.subscriberLineItemTotal_min)>
			>= <cfqueryparam value="#Arguments.subscriberLineItemTotal_min#" cfsqltype="cf_sql_money">
		<cfelse>
			<= <cfqueryparam value="#Arguments.subscriberLineItemTotal_max#" cfsqltype="cf_sql_money">
		</cfif>
		GROUP BY subscriberID
		)
</cfif>
<!--- shared subscriber and subscription fields --->
<cfif StructKeyExists(Arguments, "searchText") and Trim(Arguments.searchText) is not "" and StructKeyExists(Arguments, "searchField") and Trim(Arguments.searchField) is not "">
	<cfset displayOr = False>
	<cfloop Index="field" List="#Arguments.searchField#">
		<cfif ListFind("subscriberName,subscriptionName,subscriptionProductID_custom,subscriptionDescription", field)>
			<cfif displayOr is True> OR <cfelse>AND ( <cfset displayOr = True></cfif>
			<cfif field is "subscriberName">avSubscriber.#field#<cfelse>avSubscription.#field#</cfif> LIKE <cfqueryparam value="%#Arguments.searchText#%" cfsqltype="cf_sql_varchar">
		</cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "subscriberDateType") and Trim(Arguments.subscriberDateType) is not "" and ((StructKeyExists(Arguments, "subscriberDateFrom") and IsDate(Arguments.subscriberDateFrom)) or (StructKeyExists(Arguments, "subscriberDateTo") and IsDate(Arguments.subscriberDateTo)))>
	<cfif StructKeyExists(Arguments, "subscriberDateFrom") and IsDate(Arguments.subscriberDateFrom) and StructKeyExists(Arguments, "subscriberDateTo") and IsDate(Arguments.subscriberDateTo)>
		<cfset dateClause = " BETWEEN " & CreateODBCDateTime(Arguments.subscriberDateFrom) & " AND " & CreateODBCDateTime(Arguments.subscriberDateTo)>
	<cfelseif StructKeyExists(Arguments, "subscriberDateFrom") and IsDate(Arguments.subscriberDateFrom)>
		<cfset dateClause = " >= " & CreateODBCDateTime(Arguments.subscriberDateFrom)>
	<cfelse>
		<cfset dateClause = " <= " & CreateODBCDateTime(Arguments.subscriberDateTo)>
	</cfif>

	<cfset displayOr = False>
	<cfloop Index="field" List="#Arguments.subscriberDateType#">
		<cfif ListFind("subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionDateBegin,subscriptionDateEnd,subscriptionDateCreated", field)>
			<cfif displayOr is True> OR <cfelse>AND ( <cfset displayOr = True></cfif>
			<cfif Find("subscriber", field)>avSubscriber.#field#<cfelse>avSubscription.#field#</cfif> #dateClause#
		</cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "searchPriceField") and IsNumeric(Arguments.searchPriceField) and ((StructKeyExists(Arguments, "searchPrice_min") and IsNumeric(Arguments.searchPrice_min)) or (StructKeyExists(Arguments, "searchPrice_max") and IsNumeric(Arguments.searchPrice_max)))>
	<cfif StructKeyExists(Arguments, "searchPrice_min") and IsNumeric(Arguments.searchPrice_min) and StructKeyExists(Arguments, "searchPrice_min") and IsNumeric(Arguments.searchPrice_min)>
		<cfset totalClause = " BETWEEN " & Arguments.searchPrice_min & " AND " & Arguments.searchPrice_min>
	<cfelseif StructKeyExists(Arguments, "searchPrice_min") and IsNumeric(Arguments.searchPrice_min)>
		<cfset totalClause = " >= " & Arguments.searchPrice_min>
	<cfelse>
		<cfset totalClause = " <= " & Arguments.searchPrice_min>
	</cfif>

	<cfset displayOr = False>
	<cfloop Index="field" List="#Arguments.searchPriceField#">
		<cfif ListFind("subscriptionPriceUnit,subscriptionTotal,subscriberLineItemTotal", field)>
			<cfif displayOr is True> OR <cfelse>AND ( <cfset displayOr = True></cfif>
			<cfswitch expression="#field#">
			<cfcase value="subscriptionPriceUnit">avSubscription.subscriptionPriceUnit #totalClause#</cfcase>
			<cfcase value="subscriptionTotal">(avSubscription.subscriptionPriceUnit * avSubscription.subscriptionQuantity) #totalClause#</cfcase>
			<cfcase value="subscriberLineItemTotal">AND avSubscriber.subscriberID IN (SELECT subscriberID FROM avSubscription WHERE SUM(subscriptionPriceUnit * subscriptionQuantity) #totalClause# GROUP BY subscriberID)</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	<cfif displayOr is True>)</cfif>
</cfif>
<cfloop Index="field" List="subscriberStatus,subscriberCompleted">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avSubscriber.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "statusID_subscriber") and Application.fn_IsIntegerList(Arguments.statusID_subscriber)>
	AND avSubscriber.subscriberID <cfif Arguments.statusID_subscriber is 0>NOT</cfif> IN (SELECT targetID FROM avStatusHistory WHERE statusHistoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('subscriberID')#" cfsqltype="cf_sql_integer"> <cfif Arguments.statusID_subscriber is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID_subscriber#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
</cfif>
<!--- subscription fields --->
<cfif StructKeyExists(Arguments, "subscriptionID") and Application.fn_IsIntegerList(Arguments.subscriptionID)>AND avSubscription.subscriptionID IN (<cfqueryparam value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
<cfif StructKeyExists(Arguments, "subscriptionIntervalType") and Trim(Arguments.subscriptionIntervalType) is not "">AND avSubscription.subscriptionIntervalType = <cfqueryparam value="#Arguments.subscriptionIntervalType#" cfsqltype="cf_sql_varchar"></cfif>
<cfloop Index="field" List="subscriptionName,subscriptionID_custom,subscriptionProductID_custom,subscriptionDescription">
	<cfif StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">AND avSubscription.#field# LIKE <cfqueryparam value="%#Arguments[field]#%" cfsqltype="cf_sql_varchar"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "subscriptionHasEndDate") and ListFind("0,1", Arguments.subscriptionHasEndDate)>
	<cfif Arguments.subscriptionHasEndDate is 1>AND avSubscription.subscriptionEndByDateOrAppliedMaximum = 0<cfelse>AND (avSubscription.subscriptionEndByDateOrAppliedMaximum = 1 OR avSubscription.subscriptionEndByDateOrAppliedMaximum IS NULL)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "subscriptionHasMaximum") and ListFind("0,1", Arguments.subscriptionHasMaximum)>
	<cfif Arguments.subscriptionHasMaximum is 1>AND avSubscription.subscriptionEndByDateOrAppliedMaximum = 1<cfelse>AND (avSubscription.subscriptionEndByDateOrAppliedMaximum = 0 OR avSubscription.subscriptionEndByDateOrAppliedMaximum IS NULL)</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "subscriptionEndByDateOrAppliedMaximum")>
	<cfif Arguments.subscriptionEndByDateOrAppliedMaximum is "">AND avSubscription.subscriptionEndByDateOrAppliedMaximum IS NULL<cfelseif ListFind("0,1", Arguments.subscriptionEndByDateOrAppliedMaximum)>AND avSubscription.subscriptionEndByDateOrAppliedMaximum = <cfqueryparam value="#Arguments.subscriptionEndByDateOrAppliedMaximum#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfif>
<cfif StructKeyExists(Arguments, "subscriptionContinuesAfterEnd") and ListFind("0,1", Arguments.subscriptionContinuesAfterEnd)>
	<cfif Arguments.subscriptionContinuesAfterEnd is 1>
		AND (avSubscription.subscriptionContinuesAfterEnd = 1 OR avSubscription.subscriptionEndByDateOrAppliedMaximum IS NULL)
	<cfelse>
		AND (avSubscription.subscriptionContinuesAfterEnd = 0 AND avSubscription.subscriptionEndByDateOrAppliedMaximum IS NOT NULL)
	</cfif>
</cfif>
<cfloop Index="field" List="subscriptionCompleted,subscriptionDescriptionHtml,subscriptionQuantityVaries,subscriptionStatus,subscriptionIsRollup">
	<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avSubscription.#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "subscriptionHasCustomID") and ListFind("0,1", Arguments.subscriptionHasCustomID)>AND avSubscription.subscriptionID_custom <cfif Arguments.subscriptionHasCustomID is 1> =  '' <cfelse> <>  '' </cfif></cfif>
<cfloop Index="field" List="subscriptionID,productID,priceID,categoryID,productParameterExceptionID,subscriptionInterval,subscriptionAppliedMaximum,subscriptionAppliedRemaining,priceStageID">
	<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>AND avSubscription.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "subscriptionHasParameterException") and ListFind("0,1", Arguments.subscriptionHasParameterException)>AND avSubscription.productParameterExceptionID <cfif Arguments.subscriptionHasParameterException is 0> = <cfelse> <> </cfif> 0</cfif>
<cfif StructKeyExists(Arguments, "subscriptionIsCustomProduct") and ListFind("0,1", Arguments.subscriptionIsCustomProduct)>AND avSubscription.productID <cfif Arguments.subscriptionIsCustomProduct is 1> = <cfelse> <> </cfif> 0</cfif>
<cfif StructKeyExists(Arguments, "subscriptionHasPrice") and ListFind("0,1", Arguments.subscriptionHasPrice)>AND avSubscription.priceID <cfif Arguments.subscriptionHasPrice is 0> = <cfelse> <> </cfif> 0</cfif>
<cfif StructKeyExists(Arguments, "subscriptionHasDescription") and ListFind("0,1", Arguments.subscriptionHasDescription)>AND avSubscription.subscriptionDescription <cfif Arguments.subscriptionHasDescription is 0> = <cfelse> <> </cfif> ''</cfif>
<cfloop Index="field" List="subscriptionInterval,subscriptionAppliedMaximum,subscriptionAppliedRemaining">
	<cfif field is not "subscriptionAppliedRemaining"><cfset thisField = "avSubscription." & field><cfelse><cfset thisField = "(avSubscription.subscriptionAppliedMaximum - avSubscription.subscriptionAppliedCount)"></cfif>
	<cfif StructKeyExists(Arguments, "#field#_min") and Application.fn_IsInteger(Arguments["#field#_min"]) and StructKeyExists(Arguments, "#field#_max") and Application.fn_IsInteger(Arguments["#field#_max"])><!--- total between min and max --->
		AND #thisField# BETWEEN <cfqueryparam value="#Arguments['#field#_min']#" cfsqltype="cf_sql_smallint"> AND <cfqueryparam value="#Arguments['#field#_max']#" cfsqltype="cf_sql_smallint">
	<cfelseif StructKeyExists(Arguments, "#field#_min") and Application.fn_IsInteger(Arguments["#field#_min"])><!--- total gte min --->
		AND #thisField# >= <cfqueryparam value="#Arguments['#field#_min']#" cfsqltype="cf_sql_smallint">
	<cfelseif StructKeyExists(Arguments, "#field#_max") and Application.fn_IsInteger(Arguments["#field#_max"])><!--- total lte max --->
		AND #thisField# <= <cfqueryparam value="#Arguments['#field#_max']#" cfsqltype="cf_sql_smallint">
	</cfif>
</cfloop>
<cfloop Index="field" List="subscriptionQuantity,subscriptionPriceUnit,subscriptionTotal">
	<cfif field is not "subscriptionTotal"><cfset thisField = "avSubscription." & field><cfelse><cfset thisField = "(avSubscription.subscriptionPriceUnit * avSubscription.subscriptionQuantity)"></cfif>
	<cfif StructKeyExists(Arguments, field) and IsNumeric(Arguments[field])>AND #thisField# = #Arguments[field]#</cfif>
	<cfif StructKeyExists(Arguments, "#field#_min") and IsNumeric(Arguments["#field#_min"]) and StructKeyExists(Arguments, "#field#_max") and IsNumeric(Arguments["#field#_max"])><!--- total between min and max --->
		AND #thisField# BETWEEN <cfqueryparam value="#Arguments['#field#_min']#" cfsqltype="cf_sql_money"> AND <cfqueryparam value="#Arguments['#field#_max']#" cfsqltype="cf_sql_money">
	<cfelseif StructKeyExists(Arguments, "#field#_min") and IsNumeric(Arguments["#field#_min"])><!--- total gte min --->
		AND #thisField# >= <cfqueryparam value="#Arguments['#field#_min']#" cfsqltype="cf_sql_money">
	<cfelseif StructKeyExists(Arguments, "#field#_max") and IsNumeric(Arguments["#field#_max"])><!--- total lte max --->
		AND #thisField# <= <cfqueryparam value="#Arguments['#field#_max']#" cfsqltype="cf_sql_money">
	</cfif>
</cfloop>
<cfif StructKeyExists(Arguments, "subscriptionHasParameter") and ListFind("0,1", Arguments.subscriptionHasParameter)>AND avSubscription.subscriptionID IN (SELECT subscriptionID FROM avSubscriptionParameter)</cfif>
<cfif StructKeyExists(Arguments, "productParameterOptionID") and Application.fn_IsIntegerList(Arguments.productParameterOptionID)>AND avSubscription.subscriptionID IN (SELECT subscriptionID FROM avSubscriptionParameter WHERE productParameterOptionID IN (<cfqueryparam value="#Arguments.productParameterOptionID#" cfsqltype="cf_sql_integer" list="yes">))</cfif>
<cfif StructKeyExists(Arguments, "statusID_subscription") and Application.fn_IsIntegerList(Arguments.statusID_subscription)>
	AND avSubscription.subscriptionID <cfif Arguments.statusID_subscription is 0>NOT</cfif> IN (SELECT targetID FROM avStatusHistory WHERE statusHistoryStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND primaryTargetID = <cfqueryparam value="#Application.fn_GetPrimaryTargetID('subscriptionID')#" cfsqltype="cf_sql_integer"> <cfif Arguments.statusID_subscription is not 0>AND statusID IN (<cfqueryparam value="#Arguments.statusID_subscription#" cfsqltype="cf_sql_integer" list="yes">)</cfif>)
</cfif>
<cfloop Index="field" List="subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionDateBegin,subscriptionDateEnd,subscriptionDateCreated">
	<cfif StructKeyExists(Arguments, field)><cfif IsDate(Arguments[field]) is "">AND avSubscription.#field# IS NULL<cfelse>AND Year(avSubscription.#field#) = #Year(Arguments[field])# AND Month(avSubscription.#field#) = #Month(Arguments[field])# AND Day(avSubscription.#field#) = #Day(Arguments[field])#</cfif></cfif>
</cfloop>
<!--- payment fields --->
<cfloop Index="field" List="bankID,creditCardID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>AND avSubscriberPayment.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)</cfif></cfloop>
<cfif StructKeyExists(Arguments, "subscriberPaymentExists") and ListFind("0,1", Arguments.subscriberPaymentExists)>
	<cfif Arguments.subscriberPaymentExists is 0>AND avSubscriberPayment.bankID = 0 AND avSubscriberPayment.creditCardID = 0<cfelse>AND ((avSubscriberPayment.bankID IS NOT NULL AND avSubscriberPayment.bankID > 0) OR (avSubscriberPayment.creditCardID IS NOT NULL AND AND avSubscriberPayment.creditCardID > 0))</cfif>
</cfif>
<cfif StructKeyExists(Arguments, "subscriberPaymentHasBankID") and ListFind("0,1", Arguments.subscriberPaymentHasBankID)>AND avSubscriberPayment.bankID <cfif Arguments.subscriberPaymentHasBankID is 0> = <cfelse> <> </cfif> 0</cfif>
<cfif StructKeyExists(Arguments, "subscriberPaymentHasCreditCardID") and ListFind("0,1", Arguments.subscriberPaymentHasCreditCardID)>AND avSubscriberPayment.creditCardID <cfif Arguments.subscriberPaymentHasCreditCardID is 0> = <cfelse> <> </cfif> 0</cfif>
<!--- notify fields --->
<cfloop Index="field" List="subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND avSubscriberNotify.#field# <cfif Arguments[field] is 0> = <cfelse> <> </cfif> <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfloop>
<cfif StructKeyExists(Arguments, "subscriberNotifyPhoneID") and ListFind("0,1", Arguments.subscriberNotifyPhoneID)>AND avSubscriberNotify.phoneID <cfif Arguments.subscriberNotifyPhoneID is 0> = <cfelse> <> </cfif> 0</cfif>
<cfif StructKeyExists(Arguments, "subscriberNotifyAddressID") and ListFind("0,1", Arguments.subscriberNotifyAddressID)>AND avSubscriberNotify.addressID <cfif Arguments.subscriberNotifyAddressID is 0> = <cfelse> <> </cfif> 0</cfif>
<cfloop Index="field" List="phoneID,addressID"><cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>AND avSubscriberNotify.#field# IN (<cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer" list="yes">)</cfif></cfloop>
<cfif StructKeyExists(Arguments, "subscriberNotifyMultipleUser") and ListFind("0,1", Arguments.subscriberNotifyMultipleUser)>AND avSubscriber.subscriberID IN (SELECT subscriberID FROM avSubscriberNotify WHERE subscriberNotifyStatus = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> HAVING COUNT(subscriberID) <cfif Arguments.subscriberNotifyAddressID is 0> <= <cfelse> >= </cfif> 1)</cfif>
<!--- subscription processing fields --->
<cfif StructKeyExists(Arguments, "subscriberProcessAllQuantitiesEntered") and ListFind("0,1", Arguments.subscriberProcessAllQuantitiesEntered)>
	AND avSubscriber.subscriberID <cfif Arguments.subscriberProcessAllQuantitiesEntered is 0> NOT </cfif> IN (SELECT subscriberID FROM avSubscriberProcess WHERE subscriberProcessCurrent = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#"> AND subscriberProcessAllQuantitiesEntered = <cfqueryparam value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
</cfif>
<cfif StructKeyExists(Arguments, "subscriberIsExported") and (Arguments.subscriberIsExported is "" or ListFind("0,1", Arguments.subscriberIsExported))>AND avSubscriber.subscriberIsExported <cfif Arguments.subscriberIsExported is "">IS NULL<cfelse>= <cfqueryparam value="#Arguments.subscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
</cfoutput>
