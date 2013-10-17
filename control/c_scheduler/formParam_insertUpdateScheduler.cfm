<cfif Variables.doAction is "updateScheduler">
	<cfparam Name="Form.companyID" Default="#qry_selectScheduler.companyID#">
	<cfparam Name="Form.schedulerStatus" Default="#qry_selectScheduler.schedulerStatus#">
	<cfparam Name="Form.schedulerName" Default="#qry_selectScheduler.schedulerName#">
	<cfparam Name="Form.schedulerDescription" Default="#qry_selectScheduler.schedulerDescription#">
	<cfparam Name="Form.schedulerURL" Default="#qry_selectScheduler.schedulerURL#">
	<cfparam Name="Form.schedulerRequestTimeOut" Default="#qry_selectScheduler.schedulerRequestTimeOut#">

	<cfif Not IsNumeric(qry_selectScheduler.schedulerInterval)>
		<cfparam Name="Form.schedulerInterval_method" Default="#qry_selectScheduler.schedulerInterval#">
	<cfelse>
		<cfset Variables.intervalList = fn_convertSecondsToHMS(qry_selectScheduler.schedulerInterval)>
		<cfif ListFirst(Variables.intervalList) is not 0>
			<cfparam Name="Form.schedulerInterval_hours" Default="#ListFirst(Variables.intervalList)#">
		</cfif>

		<cfif ListGetAt(Variables.intervalList, 2) is not 0>
			<cfparam Name="Form.schedulerInterval_minutes" Default="#ListGetAt(Variables.intervalList, 2)#">
		<cfelse>
			<cfparam Name="Form.schedulerInterval_minutes" Default="">
		</cfif>

		<cfif ListLast(Variables.intervalList) is not 0>
			<cfparam Name="Form.schedulerInterval_seconds" Default="#ListLast(Variables.intervalList)#">
		</cfif>
	</cfif>

	<cfif IsDate(qry_selectScheduler.schedulerDateBegin)>
		<cfparam Name="Form.schedulerDateBegin_date" Default="#DateFormat(qry_selectScheduler.schedulerDateBegin, 'mm/dd/yyyy')#">
		<cfparam Name="Form.schedulerDateBegin_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectScheduler.schedulerDateBegin)), '|')#">
		<cfparam Name="Form.schedulerDateBegin_mm" Default="#Minute(qry_selectScheduler.schedulerDateBegin)#">
		<cfparam Name="Form.schedulerDateBegin_tt" Default="#TimeFormat(qry_selectScheduler.schedulerDateBegin, 'tt')#">
	</cfif>

	<cfif IsDate(qry_selectScheduler.schedulerDateEnd)>
		<cfparam Name="Form.schedulerDateEnd_date" Default="#DateFormat(qry_selectScheduler.schedulerDateEnd, 'mm/dd/yyyy')#">
		<cfparam Name="Form.schedulerDateEnd_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectScheduler.schedulerDateEnd)), '|')#">
		<cfparam Name="Form.schedulerDateEnd_mm" Default="#Minute(qry_selectScheduler.schedulerDateEnd)#">
		<cfparam Name="Form.schedulerDateEnd_tt" Default="#TimeFormat(qry_selectScheduler.schedulerDateEnd, 'tt')#">
	</cfif>
</cfif>

<cfparam Name="Form.companyID" Default="0">
<cfparam Name="Form.schedulerStatus" Default="1">
<cfparam Name="Form.schedulerName" Default="">
<cfparam Name="Form.schedulerDescription" Default="">
<cfparam Name="Form.schedulerURL" Default="#Application.billingUrl#/scheduled/">
<cfparam Name="Form.schedulerRequestTimeOut" Default="500">

<cfparam Name="Form.schedulerInterval_method" Default="">
<cfparam Name="Form.schedulerInterval_hours" Default="">
<cfparam Name="Form.schedulerInterval_minutes" Default="5">
<cfparam Name="Form.schedulerInterval_seconds" Default="">

<cfparam Name="Form.schedulerDateBegin_date" Default="">
<cfparam Name="Form.schedulerDateBegin_hh" Default="12">
<cfparam Name="Form.schedulerDateBegin_mm" Default="00">
<cfparam Name="Form.schedulerDateBegin_tt" Default="am">
<cfparam Name="Form.schedulerDateEnd_date" Default="">
<cfparam Name="Form.schedulerDateEnd_hh" Default="12">
<cfparam Name="Form.schedulerDateEnd_mm" Default="00">
<cfparam Name="Form.schedulerDateEnd_tt" Default="am">

