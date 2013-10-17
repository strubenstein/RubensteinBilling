<cfif URL.taskID is not 0 and IsDefined("qry_selectTask")>
	<cfparam Name="Form.taskMessage" Default="#qry_selectTask.taskMessage#">
	<cfparam Name="Form.taskStatus" Default="#qry_selectTask.taskStatus#">
	<cfparam Name="Form.taskCompleted" Default="#qry_selectTask.taskCompleted#">
	<cfparam Name="Form.userID_agent" Default="#qry_selectTask.userID_agent#">

	<cfparam Name="Form.taskDateScheduled_date" Default="#DateFormat(qry_selectTask.taskDateScheduled, 'mm/dd/yyyy')#">
	<cfparam Name="Form.taskDateScheduled_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectTask.taskDateScheduled)), '|')#">
	<cfparam Name="Form.taskDateScheduled_mm" Default="#Minute(qry_selectTask.taskDateScheduled)#">
	<cfparam Name="Form.taskDateScheduled_tt" Default="#TimeFormat(qry_selectTask.taskDateScheduled, 'tt')#">
</cfif>

<cfparam Name="Form.taskMessage" Default="">
<cfparam Name="Form.taskStatus" Default="1">
<cfparam Name="Form.taskCompleted" Default="0">
<cfparam Name="Form.userID_agent" Default="#Session.userID#">

<cfset taskStruct.nowDateTimeIn5 = DateAdd("n", 5, fn_NowDateTimeIn5MinuteInterval())>
<cfset taskStruct.nowDateTimeIn5HourTT = fn_ConvertFrom24HourFormat(Hour(taskStruct.nowDateTimeIn5))>
<cfparam Name="Form.taskDateScheduled_date" Default="#DateFormat(Now(), 'mm/dd/yyyy')#">
<cfparam Name="Form.taskDateScheduled_hh" Default="#ListFirst(taskStruct.nowDateTimeIn5HourTT, "|")#">
<cfparam Name="Form.taskDateScheduled_mm" Default="#Minute(taskStruct.nowDateTimeIn5)#">
<cfparam Name="Form.taskDateScheduled_tt" Default="#ListLast(taskStruct.nowDateTimeIn5HourTT, "|")#">

