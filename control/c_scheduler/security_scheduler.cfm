<cfif Not Application.fn_IsIntegerNonNegative(URL.schedulerID)>
	<cflocation url="index.cfm?method=scheduler.listSchedulers&error_scheduler=invalidScheduler" AddToken="No">
<cfelseif URL.schedulerID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Scheduler" Method="selectScheduler" ReturnVariable="qry_selectScheduler">
		<cfinvokeargument Name="schedulerID" Value="#URL.schedulerID#">
	</cfinvoke>

	<cfif qry_selectScheduler.RecordCount is not 1>
		<cflocation url="index.cfm?method=scheduler.listSchedulers&error_scheduler=invalidScheduler" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listSchedulers,insertScheduler", Variables.doAction)>
	<cflocation url="index.cfm?method=scheduler.listSchedulers&error_scheduler=noScheduler" AddToken="No">
</cfif>
