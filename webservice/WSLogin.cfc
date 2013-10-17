<cfcomponent DisplayName="WSLogin" Hint="Manages web services login requests">

<!--- General Functions --->
<cffunction Name="login" Access="remote" Output="No" ReturnType="string" Hint="Returns error message or sessionID.">
	<cfargument Name="companyDirectory" Type="string">
	<cfargument Name="username" Type="string">
	<cfargument Name="password" Type="string">

	<cfset var returnValue = "">
	<cfset var sessionUUID = CreateUUID()>
	<cfset var permissionStructList = "">

	<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="processLogin" ReturnVariable="loginResult">
		<cfinvokeargument Name="username" Value="#Arguments.username#">
		<cfinvokeargument Name="password" Value="#Arguments.password#">
		<cfinvokeargument Name="companyID_author" Value="0">
		<cfinvokeargument Name="companyDirectory" Value="#Arguments.companyDirectory#">
		<cfinvokeargument Name="isWebServicesLogin" Value="True">
	</cfinvoke>

	<cfif loginResult is not "True">
		<cfset returnValue = loginResult>
	<cfelse>
		<cfloop Collection="#Session.permissionStruct#" Item="field">
			<cfset permissionStructList = ListAppend(permissionStructList, field & "_" & Session.permissionStruct[field])>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceSession" Method="insertWebServiceSession" ReturnVariable="isWebServiceSessionInserted">
			<cfinvokeargument Name="webServiceSessionUUID" Value="#sessionUUID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="webServiceSessionPermissionStruct" Value="#permissionStructList#">
			<cfinvokeargument Name="webServiceSessionIPaddress" Value="#CGI.REMOTE_ADDR#">
			<cfinvokeargument Name="webServiceSessionLastError" Value="">
		</cfinvoke>

		<cfset returnValue = sessionUUID>
	</cfif>

	<cfreturn returnValue>
</cffunction>

<cffunction Name="getServerTimestamp" Access="remote" Output="No" ReturnType="date" Hint="Returns current date/time of server.">
	<cfargument Name="sessionUUID" Type="UUID">

	<cfinclude template="webserviceSession/wsact_checkWebServiceSession.cfm">
	<cfif isWebServiceSessionActive is False>
		<cfreturn CreateDateTime(1970, 01, 01, 00, 00, 00)>
	<cfelse>
		<cfreturn CreateODBCDateTime(Now())>
	</cfif>
</cffunction>

<cffunction Name="getLastErrorMessage" Access="remote" Output="No" ReturnType="string" Hint="Returns most recent error message for this web services session.">
	<cfargument Name="sessionUUID" Type="UUID">

	<cfinclude template="webserviceSession/wsact_checkWebServiceSession.cfm">
	<cfif isWebServiceSessionActive is False>
		<cfreturn "">
	<cfelse>
		<cfreturn qry_selectWebServiceSession.webServiceSessionLastError>
	</cfif>
</cffunction>

<cffunction Name="isSessionActive" Access="remote" Output="No" ReturnType="boolean" Hint="Returns whether web services session is still active.">
	<cfargument Name="sessionUUID" Type="UUID">

	<cfinclude template="webserviceSession/wsact_checkWebServiceSession.cfm">
	<cfreturn isWebServiceSessionActive>
</cffunction>

</cfcomponent>
