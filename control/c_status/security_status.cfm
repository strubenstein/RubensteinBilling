<cfif Not Application.fn_IsIntegerNonNegative(URL.statusID)>
	<cflocation url="index.cfm?method=status.listStatuses&error_status=noStatus" AddToken="No">
<cfelseif URL.statusID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Status" Method="checkStatusPermission" ReturnVariable="isStatusPermission">
		<cfinvokeargument Name="statusID" Value="#URL.statusID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isStatusPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatus" ReturnVariable="qry_selectStatus">
			<cfinvokeargument Name="statusID" Value="#URL.statusID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=status.listStatuses&error_status=invalidStatus" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listStatuses,insertStatus,updateStatusTarget", Variables.doAction)>
	<cflocation url="index.cfm?method=status.listStatuses&error_status=noStatus" AddToken="No">
</cfif>

<cfif Not ListFind(Variables.statusTargetList_id, URL.primaryTargetID)>
	<cflocation url="index.cfm?method=status.listStatuses&error_status=invalidPrimaryTargetID" AddToken="No">
</cfif>

