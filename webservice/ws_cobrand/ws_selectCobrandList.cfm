<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listCobrands", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_cobrand.listCobrands>
<cfelse>
	<cfif StructKeyExists(Arguments, "cobrandNameIsCompanyName") and ListFind("0,1", Arguments.cobrandNameIsCompanyName)>
		<cfset Arguments.returnCompanyFields = True>
	</cfif>

	<cfinclude template="wsact_selectCobrandList_qryParam.cfm">

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
		<cfcase value="cobrandName,cobrandName_d"><cfset queryFirstLetter_field = "avCobrand.cobrandName"></cfcase>
		<cfcase value="cobrandCode,cobrandCode_d"><cfset queryFirstLetter_field = "avCobrand.cobrandCode"></cfcase>
		<cfcase value="cobrandID_custom,cobrandID_custom_d"><cfset queryFirstLetter_field = "avCobrand.cobrandID_custom"></cfcase>
		<cfcase value="cobrandTitle,cobrandTitle_d"><cfset queryFirstLetter_field = "avCobrand.cobrandTitle"></cfcase>
		<cfcase value="cobrandDomain,cobrandDomain_d"><cfset queryFirstLetter_field = "avCobrand.cobrandDomain"></cfcase>
		<cfcase value="cobrandDirectory,cobrandDirectory_d"><cfset queryFirstLetter_field = "avCobrand.cobrandDirectory"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset queryFirstLetter_field = "avCompany.companyName"><cfset Arguments.returnCompanyFields = True></cfcase>
		<cfcase value="lastName,lastName_d"><cfset queryFirstLetter_field = "avUser.lastName"><cfset Arguments.returnUserFields = True></cfcase>
		<cfdefaultcase><cfset Arguments.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList" argumentCollection="#qryParamStruct#">
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
		<cfinvokeargument Name="returnCompanyFields" Value="#Arguments.returnCompanyFields#">
		<cfinvokeargument Name="returnUserFields" Value="#Arguments.returnUserFields#">
	</cfinvoke>

	<cfset returnValue = qry_selectCobrandList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

