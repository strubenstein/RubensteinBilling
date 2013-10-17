<cfinvoke Component="#Application.billingMapping#data.Scheduler" Method="selectSchedulerList" ReturnVariable="qry_selectSchedulerList">
</cfinvoke>

<cfinclude template="../../view/v_scheduler/lang_listSchedulers.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateScheduler")>

<cfset Variables.columnHeaderList = Variables.lang_listSchedulers_title.schedulerName
		& "^" & Variables.lang_listSchedulers_title.schedulerStatus
		& "^" & Variables.lang_listSchedulers_title.schedulerDateBegin
		& "^" & Variables.lang_listSchedulers_title.schedulerDateEnd
		& "^" & Variables.lang_listSchedulers_title.schedulerInterval
		& "^" & Variables.lang_listSchedulers_title.schedulerTimeout
		& "^" & Variables.lang_listSchedulers_title.lastName
		& "^" & Variables.lang_listSchedulers_title.schedulerDateCreated
		& "^" & Variables.lang_listSchedulers_title.schedulerDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateScheduler")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listSchedulers_title.updateScheduler>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_scheduler/dsp_selectSchedulerList.cfm">
