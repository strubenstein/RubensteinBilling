<cfif Application.fn_IsIntegerPositive(Session.userID) and Application.billingTrackLoginSessions is True>
	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="updateLoginSessionDateEnd" returnVariable="isLogoutSessionEnded">
		<cfinvokeargument name="userID" value="#Session.userID#">
		<cfinvokeargument name="loginSessionTimeout" value="0">
		<cfif StructKeyExists(Session, "loginSessionID") and Session.loginSessionID is not 0>
			<cfinvokeargument name="loginSessionID" value="#Session.loginSessionID#">
		</cfif>
	</cfinvoke>
</cfif>

<cflock Scope="Session" Timeout="5">
	<cfset Session.userID = 0>
	<cfset Session.companyID = 0>
	<cfset Session.companyID_author = 0>
	<cfset Session.cobrandID = 0>
	<cfset Session.cobrandID_list = 0>
	<cfset Session.affiliateID = 0>
	<cfset Session.affiliateID_list = 0>
	<cfset Session.groupID = 0>
</cflock>

<!--- <cflocation url="index.cfm?method=admin.main&confirm=logout" AddToken="No"> --->
<cflocation url="#Application.billingUrl#/admin/index.cfm?confirm=logout" AddToken="No">