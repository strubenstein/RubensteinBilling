<cfif URL.companyID is not Session.companyID and URL.control is "user">
	<cflocation url="index.cfm?method=#URL.control#.listUsers&error_user=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID)>
	<cflocation url="index.cfm?method=#URL.control#.listUsers&error_user=noUser" AddToken="No">
<cfelseif URL.userID is not 0>
	<cfif Not Application.fn_IsIntegerNonNegative(URL.companyID)>
		<cflocation url="index.cfm?method=#URL.control#.listUsers&error_user=invalidUser" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="checkUserPermission" ReturnVariable="isUserPermission">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfif Not ListFind("0,#Session.companyID#", URL.companyID)>
				<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			</cfif>
			<cfif Session.companyID is not Session.companyID_author>
				<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
				<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
			</cfif>
		</cfinvoke>

		<cfif isUserPermission is False and Session.companyID_author is not Application.billingSuperuserCompanyID>
			<cflocation url="index.cfm?method=#URL.control#.listUsers&error_user=invalidUser" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
				<cfinvokeargument Name="userID" Value="#URL.userID#">
			</cfinvoke>
		</cfif>
	</cfif>
<cfelseif Not ListFind("listUsers,insertUser,listLoginSessions", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listUsers&error_user=noUser" AddToken="No">
</cfif>
