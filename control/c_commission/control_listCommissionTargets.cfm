<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
	<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
	<cfinvokeargument Name="commissionTargetWithTargetInfo" Value="True">
</cfinvoke>

<cfinclude template="../../view/v_commission/lang_listCommissionTargets.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateCommissionTargetStatus0,updateCommissionTargetStatus1,viewCompany,viewUser,viewGroup")>
<cfset Variables.columnHeaderList = Variables.lang_listCommissionTargets_title.commissionTargetName
		& "^" & Variables.lang_listCommissionTargets_title.commissionTargetStatus
		& "^" & Variables.lang_listCommissionTargets_title.commissionTargetDateCreated
		& "^" & Variables.lang_listCommissionTargets_title.commissionTargetDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateCommissionTargetStatus0") or ListFind(Variables.permissionActionList, "updateCommissionTargetStatus1")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCommissionTargets_title.updateCommissionTargetStatus>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_commission/dsp_selectCommissionTargetList.cfm">
