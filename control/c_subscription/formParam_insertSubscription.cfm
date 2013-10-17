<!--- subscriptionCompleted --->
<cfif URL.subscriptionID is not 0 and IsDefined("qry_selectSubscription")>
	<cfparam Name="Form.subscriptionName" Default="#qry_selectSubscription.subscriptionName#">
	<cfparam Name="Form.subscriptionID_custom" Default="#qry_selectSubscription.subscriptionID_custom#">
	<cfparam Name="Form.subscriptionDescription" Default="#qry_selectSubscription.subscriptionDescription#">
	<cfparam Name="Form.subscriptionDescriptionHtml" Default="#qry_selectSubscription.subscriptionDescriptionHtml#">
	<cfparam Name="Form.subscriptionQuantity" Default="#qry_selectSubscription.subscriptionQuantity#">
	<cfparam Name="Form.subscriptionPriceUnit" Default="#qry_selectSubscription.subscriptionPriceUnit#">
	<cfparam Name="Form.subscriptionPriceNormal" Default="#qry_selectSubscription.subscriptionPriceNormal#">
	<cfparam Name="Form.subscriptionDiscount" Default="#qry_selectSubscription.subscriptionDiscount#">
	<!--- <cfparam Name="Form.subscriptionTotalTax" Default="#qry_selectSubscription.subscriptionTotalTax#"> --->
	<cfparam Name="Form.subscriptionStatus" Default="#qry_selectSubscription.subscriptionStatus#">
	<cfparam Name="Form.subscriptionProductID_custom" Default="#qry_selectSubscription.subscriptionProductID_custom#">
	<cfparam Name="Form.productParameterExceptionID" Default="#qry_selectSubscription.productParameterExceptionID#">
	<cfparam Name="Form.regionID" Default="#qry_selectSubscription.regionID#">
	<cfparam Name="Form.priceID" Default="#qry_selectSubscription.priceID#">
	<cfparam Name="Form.categoryID" Default="#qry_selectSubscription.categoryID#">
	<cfparam Name="Form.subscriptionOrder" Default="#qry_selectSubscription.subscriptionOrder#">
	<cfparam Name="Form.subscriptionID_rollup" Default="#qry_selectSubscription.subscriptionID_rollup#">

	<cfparam Name="Form.subscriptionAppliedMaximum" Default="#qry_selectSubscription.subscriptionAppliedMaximum#">
	<cfparam Name="Form.subscriptionIntervalType" Default="#qry_selectSubscription.subscriptionIntervalType#">
	<cfparam Name="Form.subscriptionInterval" Default="#qry_selectSubscription.subscriptionInterval#">
	<cfparam Name="Form.subscriptionEndByDateOrAppliedMaximum" Default="#qry_selectSubscription.subscriptionEndByDateOrAppliedMaximum#">
	<cfparam Name="Form.subscriptionProRate" Default="#qry_selectSubscription.subscriptionProRate#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.subscriptionQuantityVaries" Default="#qry_selectSubscription.subscriptionQuantityVaries#">
	</cfif>

	<!--- if ends by maximum number of times applies and end date is for internal reference purposes only, display as blank --->
	<cfif qry_selectSubscription.subscriptionEndByDateOrAppliedMaximum is not 0>
		<cfparam Name="Form.subscriptionDateEnd_date" Default="">
	</cfif>

	<cfloop Index="dateField" List="#Variables.subscriptionDateFieldList#">
		<cfset Variables.thisDate = Evaluate("qry_selectSubscription.#dateField#")>
		<cfif IsDate(Variables.thisDate)>
			<cfset Variables.hour_ampm = fn_ConvertFrom24HourFormat(Hour(Variables.thisDate))>
			<cfparam Name="Form.#dateField#_date" Default="#DateFormat(Variables.thisDate, 'mm/dd/yyyy')#">
			<cfparam Name="Form.#dateField#_hh" Default="#ListFirst(Variables.hour_ampm, '|')#">
			<cfparam Name="Form.#dateField#_mm" Default="#Minute(Variables.thisDate)#">
			<cfparam Name="Form.#dateField#_tt" Default="#ListLast(Variables.hour_ampm, '|')#">
		</cfif>
	</cfloop>

	<cfif displayProductParameter is True>
		<cfloop Query="qry_selectSubscriptionParameterList">
			<cfset Variables.parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterOptionID), qry_selectSubscriptionParameterList.productParameterOptionID)>
			<cfif Variables.parameterOptionRow is not 0>
				<cfparam Name="Form.parameter#qry_selectProductParameterOptionList.productParameterID[Variables.parameterOptionRow]#" Default="#qry_selectSubscriptionParameterList.productParameterOptionID#">
			</cfif>
		</cfloop>
	</cfif>

	<cfparam Name="Form.userID" Default="#ValueList(qry_selectSubscriptionUser.userID)#">

<cfelseif Variables.doAction is "insertSubscription" and URL.productID gt 0 and Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.subscriptionName" Default="#qry_selectProductLanguage.productLanguageLineItemName#">
	<cfparam Name="Form.subscriptionDescription" Default="#qry_selectProductLanguage.productLanguageLineItemDescription#">
	<cfparam Name="Form.subscriptionDescriptionHtml" Default="#qry_selectProductLanguage.productLanguageLineItemDescriptionHtml#">
	<cfparam Name="Form.subscriptionPriceUnit" Default="#qry_selectProduct.productPrice#">
	<cfparam Name="Form.subscriptionPriceNormal" Default="#qry_selectProduct.productPrice#">
	<cfparam Name="Form.subscriptionProductID_custom" Default="#qry_selectProduct.productID_custom#">
</cfif>

<cfparam Name="Form.userID" Default="">
<cfparam Name="Form.subscriptionName" Default="">
<cfparam Name="Form.subscriptionID_custom" Default="">
<cfparam Name="Form.subscriptionDescription" Default="">
<cfparam Name="Form.subscriptionDescriptionHtml" Default="0">
<cfparam Name="Form.subscriptionQuantity" Default="1">
<cfparam Name="Form.subscriptionQuantityVaries" Default="0">
<cfparam Name="Form.subscriptionPriceUnit" Default="0">
<cfparam Name="Form.subscriptionPriceNormal" Default="0">
<cfparam Name="Form.subscriptionDiscount" Default="0">
<!--- <cfparam Name="Form.subscriptionTotalTax" Default="0"> --->
<cfparam Name="Form.subscriptionStatus" Default="1">
<cfparam Name="Form.subscriptionProductID_custom" Default="">
<cfparam Name="Form.productParameterExceptionID" Default="0">
<cfparam Name="Form.regionID" Default="0">
<cfparam Name="Form.priceID" Default="0">
<cfparam Name="Form.categoryID" Default="0">
<cfparam Name="Form.subscriptionOrder" Default="0">

<cfparam Name="Form.subscriptionAppliedMaximum" Default="">
<cfparam Name="Form.subscriptionProRate" Default="1">
<cfparam Name="Form.subscriptionIntervalType" Default="m">
<cfparam Name="Form.subscriptionInterval" Default="1">
<cfparam Name="Form.subscriptionEndByDateOrAppliedMaximum" Default="">
<cfparam Name="Form.subscriptionID_rollup" Default="0">

<cfloop Index="dateField" List="#Variables.subscriptionDateFieldList#">
	<cfswitch expression="#dateField#">
	<cfcase value="subscriptionDateBegin">
		<cfparam Name="Form.#dateField#_date" Default="#DateFormat(Now(), "mm/dd/yyyy")#">
	</cfcase>
	<cfcase value="subscriptionDateProcessNext">
		<cfif IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
			<cfparam Name="Form.#dateField#_date" Default="#DateFormat(qry_selectSubscriber.subscriberDateProcessNext, "mm/dd/yyyy")#">
		<cfelse>
			<cfparam Name="Form.#dateField#_date" Default="#DateFormat(DateAdd("m", 1, Now()), "mm/dd/yyyy")#">
		</cfif>
	</cfcase>
	<cfdefaultcase>
		<cfparam Name="Form.#dateField#_date" Default="">
	</cfdefaultcase>
	</cfswitch>

	<cfparam Name="Form.#dateField#_hh" Default="12">
	<cfparam Name="Form.#dateField#_mm" Default="00">
	<cfparam Name="Form.#dateField#_tt" Default="am">
</cfloop>

<cfif displayProductParameter is True>
	<cfloop Query="qry_selectProductParameterList">
		<cfparam Name="Form.parameter#qry_selectProductParameterList.productParameterID#" Default="">
	</cfloop>
</cfif>

