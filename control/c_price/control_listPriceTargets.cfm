<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_price/lang_listPriceTargets.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updatePriceTargetStatus0,updatePriceTargetStatus1,viewCompany,viewUser,viewGroup")>

<cfset Variables.priceColumnList = Variables.lang_listPriceTargets_title.priceTargetType
		& "^" &  Variables.lang_listPriceTargets_title.priceTargetName
		& "^" &  Variables.lang_listPriceTargets_title.priceTargetStatus
		& "^" &  Variables.lang_listPriceTargets_title.priceTargetDateCreated
		& "^" &  Variables.lang_listPriceTargets_title.priceTargetDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updatePriceTargetStatus0") or ListFind(Variables.permissionActionList, "updatePriceTargetStatus1")>
	<cfset Variables.priceColumnList = Variables.priceColumnList & "^" & Variables.lang_listPriceTargets_title.updatePriceTargetStatus>
</cfif>

<cfset Variables.priceColumnCount = DecrementValue(2 * ListLen(priceColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_price/dsp_selectPriceTargetList.cfm">
