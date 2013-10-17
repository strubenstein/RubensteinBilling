<cfif Not Application.fn_IsIntegerNonNegative(URL.groupID)>
	<cflocation url="index.cfm?method=group.listGroups&error_group=noGroup" AddToken="No">
<cfelseif URL.groupID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="checkGroupPermission" ReturnVariable="isGroupPermission">
		<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isGroupPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroup" ReturnVariable="qry_selectGroup">
			<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=group.listGroups&error_group=invalidGroup" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listGroups,insertGroup", Variables.doAction)>
	<cflocation url="index.cfm?method=group.listGroups&error_group=noGroup" AddToken="No">
</cfif>
