<cfinclude template="wslang_salesCommission.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listSalesCommissions", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_salesCommission.listSalesCommissions>
<cfelse>
	<cfinclude template="wsact_selectSalesCommissionList_qryParam.cfm">

	<cfif Arguments.queryFirstLetter is not "" and Not REFindNoCase("[A-Za-z]", Arguments.queryFirstLetter)>
		<cfif Arguments.queryFirstLetter is 0>
			<cfset Arguments.queryFirstLetter = "0-9">
		<cfelse>
			<cfset Arguments.queryFirstLetter = "">
		</cfif>
	</cfif>

	<cfif ListFind("targetName,targetName_d", Arguments.queryOrderBy)>
		<cfset Arguments.returnTargetName = True>
	</cfif>

	<!--- <cfset queryFirstLetter_field = ""> --->
	<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "">
		<cfswitch expression="#Arguments.queryOrderBy#">
		<cfcase value="targetName,targetName_d"><cfset queryFirstLetter_field = "targetName"></cfcase>
		<cfcase value="lastName,lastName_d"><cfset queryFirstLetter_field = "avUser.lastName"></cfcase>
		<cfcase value="commissionName,commissionName_d"><cfset queryFirstLetter_field = "avCommission.commissionName"></cfcase>
		<cfcase value="commissionID_custom,commissionID_custom_d"><cfset queryFirstLetter_field = "avCommission.commissionID_custom"></cfcase>
		<cfdefaultcase><cfset Arguments.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommissionList" ReturnVariable="qry_selectSalesCommissionList" argumentCollection="#qryParamStruct#">
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
		<cfif StructKeyExists(Arguments, "returnTargetName") and Arguments.returnTargetName is True>
			<cfinvokeargument Name="returnTargetName" Value="True">
		</cfif>
		<cfif StructKeyExists(Arguments, "returnSalesCommissionSum") and Arguments.returnSalesCommissionSum is True>
			<cfinvokeargument Name="returnSalesCommissionSum" Value="True">
		</cfif>
	</cfinvoke>

	<!--- <cfset primaryTargetKeyArray = ArrayNew(1)> --->
	<cfloop Query="qry_selectSalesCommissionList">
		<cfset primaryTargetKeyArray[qry_selectSalesCommissionList.CurrentRow] = Application.fn_GetPrimaryTargetKey(qry_selectSalesCommissionList.primaryTargetID)>
	</cfloop>
	<cfset temp = QueryAddColumn(qry_selectSalesCommissionList, "primaryTargetKey", primaryTargetKeyArray)>

	<cfset returnValue = qry_selectSalesCommissionList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

