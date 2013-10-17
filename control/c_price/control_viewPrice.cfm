<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
	<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPrice.priceStageID)#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectSubscriptionPriceCount" ReturnVariable="subscriptionCount">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="subscriptionStatus" Value="1">
	<cfinvokeargument Name="subscriberStatus" Value="1">
</cfinvoke>

<cfif subscriptionCount gt 0>
	<cfset Variables.priceHasActiveSubscriptions = True>
<cfelse>
	<cfset Variables.priceHasActiveSubscriptions = False>
</cfif>

<cfinclude template="../../view/v_price/var_priceStageIntervalTypeList.cfm">
<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
<cfinclude template="../../view/v_price/dsp_selectPrice.cfm">

