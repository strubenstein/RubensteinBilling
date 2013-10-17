<cfif Not Application.fn_IsIntegerNonNegative(URL.taskID)>
	<cflocation url="index.cfm?method=#URL.control#.listTasks#Arguments.urlParameters#&error_task=invalidTask" AddToken="No">
<cfelseif URL.taskID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Task" Method="selectTask" ReturnVariable="qry_selectTask">
		<cfinvokeargument Name="taskID" Value="#URL.taskID#">
	</cfinvoke>

	<cfif qry_selectTask.RecordCount is 0 or (qry_selectTask.userID_agent is not Session.userID and Not Application.fn_IsUserAuthorized("listTasksForOthers"))>
		<cflocation url="index.cfm?method=#Arguments.doControl#.listTasks#Arguments.urlParameters#&error_task=invalidTask" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listTasks,insertTask", Arguments.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listTasks#Arguments.urlParameters#&error_task=noTask" AddToken="No">
</cfif>
