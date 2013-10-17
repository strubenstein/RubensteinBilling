<cfinclude template="wslang_user.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listUsers", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_user.listUsers>
<cfelse>
	<cfinclude template="wsact_selectUserList_qryParam.cfm">

	<cfif Arguments.queryFirstLetter is not "" and Not REFindNoCase("[A-Za-z]", Arguments.queryFirstLetter)>
		<cfif Arguments.queryFirstLetter is 0>
			<cfset Arguments.queryFirstLetter = "0-9">
		<cfelse>
			<cfset Arguments.queryFirstLetter = "">
		</cfif>
	</cfif>

	<cfset queryFirstLetter_field = "">
	<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "">
		<cfswitch expression="#Arguments.queryOrderBy#">
		<cfcase value="username,username_d"><cfset queryFirstLetter_field = "avUser.username"></cfcase>
		<cfcase value="name,name_d"><cfset queryFirstLetter_field = "avUser.lastName"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset queryFirstLetter_field = "avCompany.companyName"></cfcase>
		<cfcase value="jobTitle,jobTitle_d"><cfset queryFirstLetter_field = "avUser.jobTitle"></cfcase>
		<cfcase value="jobDepartment,jobDepartment_d"><cfset queryFirstLetter_field = "avUser.jobDepartment"></cfcase>
		<cfcase value="jobDivision,jobDivision_d"><cfset queryFirstLetter_field = "avUser.jobDivision"></cfcase>
		<cfdefaultcase><cfset Arguments.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserList" ReturnVariable="qry_selectUserList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Arguments.queryOrderBy#">
		<cfif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryDisplayPerPage" Value="#Arguments.queryDisplayPerPage#">
		</cfif>
		<cfif StructKeyExists(Arguments, "queryPage") and Application.fn_IsIntegerPositive(Arguments.queryPage)>
			<cfinvokeargument Name="queryPage" Value="#Arguments.queryPage#">
		<cfelseif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryPage" Value="1">
		</cfif>
		<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Arguments.queryFirstLetter#">
			<cfinvokeargument Name="queryFirstLetter_field" Value="#queryFirstLetter_field#">
		</cfif>
	</cfinvoke>

	<cfset returnValue = qry_selectUserList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

