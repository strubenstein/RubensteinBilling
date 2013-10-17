<cfinclude template="wslang_affiliate.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listAffiliates", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_affiliate.listAffiliates>
<cfelse>
	<cfif StructKeyExists(Arguments, "affiliateNameIsCompanyName") and ListFind("0,1", Arguments.affiliateNameIsCompanyName)>
		<cfset Arguments.returnCompanyFields = True>
	</cfif>

	<cfinclude template="wsact_selectAffiliateList_qryParam.cfm">

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
		<cfcase value="affiliateName,affiliateName_d"><cfset queryFirstLetter_field = "avAffiliate.affiliateName"></cfcase>
		<cfcase value="affiliateCode,affiliateCode_d"><cfset queryFirstLetter_field = "avAffiliate.affiliateCode"></cfcase>
		<cfcase value="affiliateID_custom,affiliateID_custom_d"><cfset queryFirstLetter_field = "avAffiliate.affiliateID_custom"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset queryFirstLetter_field = "avCompany.companyName"><cfset Arguments.returnCompanyFields = True></cfcase>
		<cfcase value="lastName,lastName_d"><cfset queryFirstLetter_field = "avUser.lastName"><cfset Arguments.returnUserFields = True></cfcase>
		<cfdefaultcase><cfset Arguments.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList" argumentCollection="#qryParamStruct#">
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

	<cfset returnValue = qry_selectAffiliateList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

