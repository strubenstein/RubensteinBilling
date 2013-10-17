<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistory" ReturnVariable="qry_selectStatusHistory">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
</cfinvoke>

<cfif Not IsDefined("fn_DisplayOrderByButtons") or Not IsCustomFunction(fn_DisplayOrderByButtons)>
	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
</cfif>

<cfinclude template="formParam_insertStatusHistory.cfm">
<cfinclude template="../../view/v_status/lang_listStatusHistory.cfm">

<cfset Variables.columnHeaderList = Variables.lang_listStatusHistory_title.statusID
		& "^" & Variables.lang_listStatusHistory_title.statusOrder
		& "^" & Variables.lang_listStatusHistory_title.statusTitle
		& "^" & Variables.lang_listStatusHistory_title.statusDescription>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfset Variables.columnHeaderList = Variables.lang_listStatusHistory_title.statusHistoryVersion
		& "^" & Variables.lang_listStatusHistory_title.statusTitle
		& "^" & Variables.lang_listStatusHistory_title.lastName
		& "^" & Variables.lang_listStatusHistory_title.statusHistoryDateCreated
		& "^" & Variables.lang_listStatusHistory_title.statusHistoryManual
		& "^" & Variables.lang_listStatusHistory_title.statusHistoryComment>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../view/v_status/dsp_selectStatusHistoryList.cfm">
