<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfif Variables.doAction is "viewSubscriptionsAll">
		<cfinvokeargument Name="subscriptionID_parent" Value="-1">
	<cfelse><!--- Variables.doAction is "viewSubscriptions" --->
		<cfinvokeargument Name="subscriptionStatus" Value="1">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_subscription/lang_viewSubscriptions.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,insertSubscription,updateSubscription,moveSubscriptionUp,moveSubscriptionDown,viewCustomFieldValuesAll,listStatusHistory,insertContact,insertNote,insertTask,listSalesCommissions,viewSubscription")>
<cfset Variables.subscriptionColumnList = Variables.lang_viewSubscriptions_title.subscriptionOrder>
<cfset Variables.totalColspan = 4>

<cfset Variables.displaySubscriptionID_custom = False>
<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectSubscriptionList.subscriptionID_custom))>
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.subscriptionID_custom>
	<cfset Variables.displaySubscriptionID_custom = True>
	<cfset Variables.totalColspan = Variables.totalColspan + 2>
</cfif>

<!--- 
<cfset Variables.displayProductID_custom = False>
<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectSubscriptionList.subscriptionProductID_custom))>
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.subscriptionProductID_custom>
	<cfset Variables.displayProductID_custom = True>
	<cfset Variables.totalColspan = Variables.totalColspan + 2>
</cfif>
--->

<!--- get vendor information, if necessary --->
<cfset Variables.displayVendor = False>
<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.vendorID))>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectSubscriptionList.vendorID)#">
	</cfinvoke>

	<cfif qry_selectVendorList.RecordCount is not 0>
		<cfset Variables.displayVendor = True>
		<!--- 
		<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.vendorName>
		<cfset Variables.totalColspan = Variables.totalColspan + 2>
		--->
	</cfif>
</cfif>

<!--- <cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.productName> --->

<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionPriceUnit
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionQuantity
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionTotal>

<cfif Variables.doAction is "viewSubscriptionsAll" or ListFind(Variables.permissionActionList, "updateSubscription")>
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.subscriptionStatus>
</cfif>

<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.subscriptionDateCreated>
<cfif Variables.doAction is "viewSubscriptionsAll">
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.subscriptionDateUpdated>
</cfif>
<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionDateBeginEnd
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionMethodend
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionApplied
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionInterval
		& "^" & Variables.lang_viewSubscriptions_title.subscriptionDateProcessNextLast>

<cfif Variables.doAction is not "viewSubscriptionsAll" and ListFind(Variables.permissionActionList, "moveSubscriptionUp") and ListFind(Variables.permissionActionList, "moveSubscriptionDown")>
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.switchSubscriptionOrder>
</cfif>

<cfif ListFind(Variables.permissionActionList, "viewSubscription")>
	<cfset Variables.subscriptionColumnList = Variables.subscriptionColumnList & "^" & Variables.lang_viewSubscriptions_title.viewSubscription>
</cfif>

<!--- subscriptionProRate --->
<cfset Variables.subscriptionColumnCount = DecrementValue(2 * ListLen(Variables.subscriptionColumnList, "^"))>

<!--- include productParameterExceptionID, parameters --->
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_subscription/var_subscriptionIntervalTypeList.cfm">
<cfinclude template="../../view/v_subscription/dsp_selectSubscriptionList.cfm">

