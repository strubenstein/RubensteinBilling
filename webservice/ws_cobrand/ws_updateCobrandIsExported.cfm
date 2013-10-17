<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportCobrands", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_cobrand.exportCobrands>
<cfelse>
	<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.cobrandID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_cobrand.invalidCobrand>
	<cfelseif Arguments.cobrandIsExported is not "" and Not ListFind("0,1", Arguments.cobrandIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_cobrand.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="updateCobrandIsExported" ReturnVariable="isCobrandExported">
			<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
			<cfinvokeargument Name="cobrandIsExported" Value="#Arguments.cobrandIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

