<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listCobrands", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_cobrand.listCobrands>
<cfelse>
	<cfset Arguments.returnUserFields = False>
	<cfif StructKeyExists(Arguments, "cobrandNameIsCompanyName") and ListFind("0,1", Arguments.cobrandNameIsCompanyName)>
		<cfset Arguments.returnCompanyFields = True>
	<cfelse>
		<cfset Arguments.returnCompanyFields = False>
	</cfif>

	<cfinclude template="wsact_selectCobrandList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="returnCompanyFields" Value="#Arguments.returnCompanyFields#">
	</cfinvoke>

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

