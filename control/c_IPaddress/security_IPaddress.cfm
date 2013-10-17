<cfif Not Application.fn_IsIntegerNonNegative(URL.IPaddressID)>
	<cflocation url="index.cfm?method=IPaddress.listIPaddresses&error_IPaddress=noIPaddress" AddToken="No">
<cfelseif URL.IPaddressID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="checkIPaddressPermission" ReturnVariable="isIPaddressPermission">
		<cfinvokeargument Name="IPaddressID" Value="#URL.IPaddressID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isIPaddressPermission is True>
		<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="selectIPaddress" ReturnVariable="qry_selectIPaddress">
			<cfinvokeargument Name="IPaddressID" Value="#URL.IPaddressID#">
		</cfinvoke>
	<cfelse>
		<cflocation url="index.cfm?method=IPaddress.listIPaddresses&error_IPaddress=invalidIPaddress" AddToken="No">
	</cfif>
<cfelseif Not ListFind("listIPaddresses,insertIPaddress", Variables.doAction)>
	<cflocation url="index.cfm?method=IPaddress.listIPaddresses&error_IPaddress=noIPaddress" AddToken="No">
</cfif>
