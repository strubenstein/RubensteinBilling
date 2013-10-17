<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listProducts", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_product.listProducts>
<cfelse>
	<cfinclude template="wsact_selectProductList_qryParam.cfm">

	<cfif Arguments.queryFirstLetter is not "" and Not REFindNoCase("[A-Za-z]", Arguments.queryFirstLetter)>
		<cfif Arguments.queryFirstLetter is 0>
			<cfset Arguments.queryFirstLetter = "0-9">
		<cfelse>
			<cfset Arguments.queryFirstLetter = "">
		</cfif>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Arguments.queryOrderBy#">
		<cfif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryDisplayPerPage" Value="#Arguments.queryDisplayPerPage#">
		</cfif>
		<cfif StructKeyExists(Arguments, "queryPage") and Application.fn_IsIntegerPositive(Arguments.queryPage)>
			<cfinvokeargument Name="queryPage" Value="#Arguments.queryPage#">
		<cfelseif StructKeyExists(Arguments, "queryDisplayPerPage") and Application.fn_IsIntegerPositive(Arguments.queryDisplayPerPage)>
			<cfinvokeargument Name="queryPage" Value="1">
		</cfif>
		<cfif StructKeyExists(Arguments, "queryFirstLetter") and Len(Arguments.queryFirstLetter) is 1 and Not REFindNoCase("[^A-Za-z]", Arguments.queryFirstLetter)>
			<cfinvokeargument Name="queryFirstLetter" Value="#Arguments.queryFirstLetter#">
		</cfif>
		<cfinvokeargument Name="displayProductCategoryOrder" Value="False">
	</cfinvoke>

	<cfset returnValue = qry_selectProductList>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

