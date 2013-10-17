<cfcomponent DisplayName="WebServiceSession" Hint="Manage session information for a webservice session">

<cffunction Name="insertWebServiceSession" Access="public" Output="No" ReturnType="boolean" Hint="Inserts existing web services session.">
	<cfargument Name="webServiceSessionUUID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="webServiceSessionPermissionStruct" Type="string" Required="No" Default="">
	<cfargument Name="webServiceSessionIPaddress" Type="string" Required="No" Default="">
	<cfargument Name="webServiceSessionLastError" Type="string" Required="No" Default="">

	<cfinclude template="webserviceSession/qry_insertWebServiceSession.cfm">
	<cfreturn True>
</cffunction>

<cffunction Name="selectWebServiceSession" Access="public" Output="No" ReturnType="query" Hint="Inserts existing web services session.">
	<cfargument Name="webServiceSessionUUID" Type="string" Required="Yes">

	<cfset var qry_selectWebServiceSession = QueryNew("error")>

	<cfinclude template="webserviceSession/qry_selectWebServiceSession.cfm">
	<cfreturn qry_selectWebServiceSession>
</cffunction>

<cffunction Name="updateWebServiceSession" Access="public" Output="No" ReturnType="boolean" Hint="Inserts existing web services session.">
	<cfargument Name="webServiceSessionID" Type="numeric" Required="Yes">
	<cfargument Name="webServiceSessionLastError" Type="string" Required="No">

	<cfinclude template="webserviceSession/qry_updateWebServiceSession.cfm">
	<cfreturn True>
</cffunction>

<cffunction Name="checkWebServiceSession" Access="public" Output="No" ReturnType="boolean" Hint="Verifies that web services session is valid.">
	<cfargument Name="qry_selectWebServiceSession" Type="query" Required="Yes">

	<cfif Arguments.qry_selectWebServiceSession.RecordCount is 0
			or Arguments.qry_selectWebServiceSession.webServiceSessionIPaddress is not CGI.REMOTE_ADDR
			or DateDiff("n", Arguments.qry_selectWebServiceSession.webServiceSessionDateUpdated, Now()) gt 120>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="isUserAuthorizedWS" Access="public" Output="No" ReturnType="boolean" Hint="Check permissions for web services user. Return True/False.">
	<cfargument Name="permissionAction" Type="string" Required="Yes">
	<cfargument Name="webServiceSessionPermissionStruct" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No" Default="0">

	<cfset var catIndex = 0>

	<!--- if permission is blank or does not exist, user has permission by default --->
	<cfif Trim(Arguments.permissionAction) is "" or Not StructKeyExists(Application.permissionStruct, Arguments.permissionAction)>
		<cfreturn True>
	<!--- if permission requires being a primary company --->
	<cfelseif Application.permissionStruct[permissionAction].permissionSuperuserOnly is 1 and Arguments.companyID is not Application.billingSuperuserCompanyID>
		<cfreturn False>
	<cfelse>
		<cfloop Index="count" From="1" To="#ListLen(Arguments.webServiceSessionPermissionStruct)#">
			<cfif ListFirst(ListGetAt(Arguments.webServiceSessionPermissionStruct, count), "_") is "cat#Application.permissionStruct[permissionAction].permissionCategoryID#">
				<cfset catIndex = count>
				<cfbreak>
			</cfif>
		</cfloop>

		<!--- if user does not have permission for permission category that contains permission, return False --->
		<cfif catIndex is 0>
			<cfreturn False>
		<!---  if user has permission, return True --->
		<cfelseif BitAnd(ListLast(ListGetAt(Arguments.webServiceSessionPermissionStruct, catIndex), "_"), Application.permissionStruct[permissionAction].permissionBinaryNumber)>
			<cfreturn True>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="isUserAuthorizedListWS" Access="public" Output="No" ReturnType="string" Hint="Check multiple permissions for web services user. Return list of permissions.">
	<cfargument Name="permissionActionList" Type="string" Required="Yes">
	<cfargument Name="webServiceSessionPermissionStruct" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No" Default="0">

	<cfset var permissionActionList_yes = "">
	<cfset var count = 1>

	<cfloop Index="count" From="1" To="#ListLen(Arguments.permissionActionList)#">
		<cfinvoke component="#Application.billingMapping#webservice.WebServiceSession" Method="isUserAuthorizedWS" ReturnVariable="isWSUserAuthorized">
			<cfinvokeargument Name="permissionAction" Value="#ListGetAt(Arguments.permissionActionList, count)#">
			<cfinvokeargument Name="webServiceSessionPermissionStruct" Value="#Arguments.webServiceSessionPermissionStruct#">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfinvoke>

		<cfif isWSUserAuthorized is True>
			<cfset permissionActionList_yes = ListAppend(permissionActionList_yes, ListGetAt(Arguments.permissionActionList, count))>
		</cfif>
	</cfloop>

	<cfreturn permissionActionList_yes>
</cffunction>

</cfcomponent>

