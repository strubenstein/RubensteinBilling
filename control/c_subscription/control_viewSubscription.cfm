<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfinvokeargument Name="subscriptionID_trend" Value="#qry_selectSubscription.subscriptionID_trend#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.SubscriptionUser" Method="selectSubscriptionUser" ReturnVariable="qry_selectSubscriptionUser">
	<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
	<cfinvokeargument Name="returnUserFields" Value="True">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="selectSubscriptionParameterList" ReturnVariable="qry_selectSubscriptionParameterList">
	<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionList.subscriptionID)#">
</cfinvoke>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,viewCustomFieldValuesAll,listStatusHistory,listSalesCommissions,viewUser")>

<!--- category --->
<cfif qry_selectSubscription.categoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategory" ReturnVariable="qry_selectCategory">
		<cfinvokeargument Name="categoryID" Value="#qry_selectSubscription.categoryID#">
	</cfinvoke>

	<cfif qry_selectCategory.categoryID_parentList is not "">
		<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategory" ReturnVariable="qry_selectCategoryList">
			<cfinvokeargument Name="categoryID" Value="#qry_selectCategory.categoryID_parentList#">
		</cfinvoke>
	</cfif>
</cfif>

<!--- product parameter --->
<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="selectSubscriptionParameterList" ReturnVariable="qry_selectSubscriptionParameterList">
	<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionList.subscriptionID)#">
</cfinvoke>

<cfif qry_selectSubscriptionParameterList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOption" ReturnVariable="qry_selectProductParameterOption">
		<cfinvokeargument Name="productParameterOptionID" Value="#ValueList(qry_selectSubscriptionParameterList.productParameterOptionID)#">
	</cfinvoke>
</cfif>

<!--- product parameter exception --->
<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.productParameterExceptionID))>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterException" ReturnVariable="qry_selectProductParameterException">
		<cfinvokeargument Name="productParameterExceptionID" Value="#ValueList(qry_selectSubscriptionList.productParameterExceptionID)#">
	</cfinvoke>
</cfif>

<!--- custom price --->
<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.priceID))>
	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPrice">
		<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectSubscriptionList.priceID)#">
	</cfinvoke>

	<cfset Variables.displayCustomPriceVolumeDiscount = False>
	<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectPrice.priceStageVolumeDiscount))>
		<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
			<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPrice.priceStageID)#">
		</cfinvoke>

		<cfif qry_selectPriceVolumeDiscount.RecordCount is not 0>
			<cfset Variables.displayCustomPriceVolumeDiscount = True>
		</cfif>
	</cfif>
</cfif>

<!--- vendor --->
<cfif Application.fn_IsIntegerPositive(qry_selectSubscriptionList.vendorID[1])>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
		<cfinvokeargument Name="vendorID" Value="#qry_selectSubscriptionList.vendorID[1]#">
	</cfinvoke>
</cfif>

<cfif qry_selectSubscription.subscriptionID_rollup is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscription_rollup">
		<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscription.subscriptionID_rollup#">
	</cfinvoke>
<cfelseif qry_selectSubscription.subscriptionIsRollup is 1>
	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList_rollup">
		<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		<cfinvokeargument Name="subscriptionStatus" Value="1">
		<cfinvokeargument Name="subscriptionID_rollup" Value="#URL.subscriptionID#">
	</cfinvoke>
</cfif>

<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
<cfinclude template="../../view/v_subscription/var_subscriptionIntervalTypeList.cfm">
<cfinclude template="../../view/v_subscription/dsp_selectSubscription.cfm">
