<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
</cfinvoke>

<cfinclude template="../../view/v_status/lang_listStatuses.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveStatusDown,moveStatusUp,updateStatus")>

<cfset Variables.columnHeaderList = Variables.lang_listStatuses_title.statusOrder
		& "^" & Variables.lang_listStatuses_title.statusName
		& "^" & Variables.lang_listStatuses_title.statusTitle
		& "^" & Variables.lang_listStatuses_title.statusID_custom
		& "^" & Variables.lang_listStatuses_title.statusDescription
		& "^" & Variables.lang_listStatuses_title.statusStatus
		& "^" & Variables.lang_listStatuses_title.statusDateCreated
		& "^" & Variables.lang_listStatuses_title.statusDateUpdated>

<cfif ListFind(Variables.permissionActionList, "moveStatusDown") and ListFind(Variables.permissionActionList, "moveStatusUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listStatuses_title.switchStatusOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateStatus")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listStatuses_title.updateStatus>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_status/dsp_selectStatusList.cfm">
