<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="selectShippingList" ReturnVariable="qry_selectShippingList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
</cfinvoke>

<cfinclude template="../../view/v_shipping/lang_listShipping.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateShipping")>

<cfset Variables.shippingColumnList = Variables.lang_listShipping_title.shippingCarrier
		& "^" & Variables.lang_listShipping_title.shippingOption
		& "^" & Variables.lang_listShipping_title.shippingWeight
		& "^" & Variables.lang_listShipping_title.shippingTrackingNumber
		& "^" & Variables.lang_listShipping_title.shippingInstructions
		& "^" & Variables.lang_listShipping_title.shippingDateSent
		& "^" & Variables.lang_listShipping_title.shippingDateReceived
		& "^" & Variables.lang_listShipping_title.shippingStatus
		& "^" & Variables.lang_listShipping_title.shippingDateCreated>

<cfif ListFind(Variables.permissionActionList, "updateStatus")>
	<cfset Variables.shippingColumnList = Variables.shippingColumnList & "^" & Variables.lang_listShipping_title.updateStatus>
</cfif>

<cfset Variables.shippingColumnCount = DecrementValue(2 * ListLen(Variables.shippingColumnList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_shipping/dsp_selectShippingList.cfm">
