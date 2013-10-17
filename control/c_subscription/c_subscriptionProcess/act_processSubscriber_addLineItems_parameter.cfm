<!--- determine whether subscription has any product parameters. if so, create list --->
<cfset Variables.productParameterOptionID_list = "">
<cfset Variables.subscriptionParameterRow = ListFind(ValueList(qry_selectSubscriptionParameterList.subscriptionID), qry_selectSubscriptionList.subscriptionID)>
<cfif Variables.subscriptionParameterRow is not 0>
	<cfloop Query="qry_selectSubscriptionParameterList" StartRow="#Variables.subscriptionParameterRow#">
		<cfif qry_selectSubscriptionParameterList.subscriptionID is not qry_selectSubscriptionList.subscriptionID[Variables.thisSubscriptionRow]><cfbreak></cfif>
		<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, qry_selectSubscriptionParameterList.productParameterOptionID)>
	</cfloop>
</cfif>

<!--- determine if there is a price premium because of a parameter exception --->
<cfset Variables.productParameterExceptionPricePremium = 0>
<cfif qry_selectSubscriptionList.productParameterExceptionID is not 0>
	<cfset Variables.exceptionRow = ListFind(ValueList(qry_selectProductParameterExceptionList.productParameterExceptionID), qry_selectSubscriptionList.productParameterExceptionID)>
	<cfif Variables.exceptionRow is not 0>
		<cfset Variables.productParameterExceptionPricePremium = qry_selectProductParameterExceptionList.productParameterExceptionPricePremium[Variables.exceptionRow]>
	</cfif>
</cfif>
